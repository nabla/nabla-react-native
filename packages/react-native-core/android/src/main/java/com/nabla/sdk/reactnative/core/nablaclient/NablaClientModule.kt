package com.nabla.sdk.reactnative.core.nablaclient

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.nabla.sdk.core.Configuration
import com.nabla.sdk.core.NablaClient
import com.nabla.sdk.core.NetworkConfiguration
import com.nabla.sdk.core.annotation.NablaInternal
import com.nabla.sdk.core.domain.boundary.Module
import com.nabla.sdk.core.domain.boundary.SessionTokenProvider
import com.nabla.sdk.core.domain.entity.AccessToken
import com.nabla.sdk.core.domain.entity.AuthTokens
import com.nabla.sdk.core.domain.entity.AuthenticationException
import com.nabla.sdk.core.domain.entity.RefreshToken
import com.nabla.sdk.reactnative.core.models.coreCode
import com.nabla.sdk.reactnative.core.models.toCoreMap
import kotlinx.coroutines.*
import okhttp3.internal.http2.ErrorCode


class NablaClientModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext), SessionTokenProvider,
    CoroutineScope by CoroutineScope(SupervisorJob() + Dispatchers.Default) {

    override fun getName() = "NablaClientModule"
    private var provideAuthTokensContinuation: CancellableContinuation<Result<AuthTokens>>? = null

    @OptIn(NablaInternal::class)
    @ReactMethod
    fun initialize(
        apiKey: String,
        enableReporting: Boolean,
        networkConfiguration: ReadableMap?,
        promise: Promise,
    ) {
        val configuration = Configuration(
            publicApiKey = apiKey,
            logger = CoreLogger,
            enableReporting = enableReporting
        )
        if (networkConfiguration != null) {
            val scheme = networkConfiguration.getString("scheme")
            val domain = networkConfiguration.getString("domain")
            val path = networkConfiguration.getString("path")
            val port = networkConfiguration.getInt("port")

            if (scheme != null && domain != null && path != null) {
                val baseUrl =
                    if (port != 0) "$scheme://$domain:$port$path" else "$scheme://$domain$path"

                configuration.networkConfiguration = NetworkConfiguration(baseUrl = baseUrl)
            }
        }

        NablaClient.initialize(
            modules = MODULES,
            configuration = configuration,
            sessionTokenProvider = this
        )
        POST_INIT_ACTIONS.forEach { it() }
        POST_INIT_ACTIONS.clear()
        promise.resolve(null)
    }

    @ReactMethod
    fun setCurrentUser(
        userId: String,
        promise: Promise,
    ) {
        try {
            NablaClient.getInstance().setCurrentUserOrThrow(userId)
            promise.resolve(null)
        } catch (e: AuthenticationException.CurrentUserAlreadySet) {
            promise.reject(e.coreCode.toString(), e.message, e)
        }
    }

    @ReactMethod
    fun clearCurrentUser(promise: Promise) {
        this.launch {
            NablaClient.getInstance().clearCurrentUser()
            promise.resolve(null)
        }
    }

    @ReactMethod
    fun getCurrentUserId(promise: Promise) {
        promise.resolve(NablaClient.getInstance().currentUserId)
    }

    @ReactMethod
    fun addListener(eventName: String) {
        // This method is required even if empty
    }

    @ReactMethod
    fun removeListeners(count: Int) {
        if (count == 0) {
            provideAuthTokensContinuation?.cancel()
        }
    }

    @OptIn(ExperimentalCoroutinesApi::class)
    @ReactMethod
    fun provideTokens(
        refreshToken: String,
        accessToken: String,
    ) {
        provideAuthTokensContinuation?.resume(
            value = Result.success(AuthTokens(AccessToken(accessToken), RefreshToken(refreshToken))),
            onCancellation = null
        )
        provideAuthTokensContinuation = null
    }


    override suspend fun fetchNewSessionAuthTokens(userId: String): Result<AuthTokens> {
        sendEvent(
            reactApplicationContext,
            NEED_PROVIDE_TOKENS,
            Arguments.createMap().apply { putString("userId", userId) })
        return suspendCancellableCoroutine { this.provideAuthTokensContinuation = it }
    }

    private fun sendEvent(reactContext: ReactContext, eventName: String, params: ReadableMap?) {
        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }

    companion object {
        private const val NEED_PROVIDE_TOKENS = "needProvideTokens"
        private var MODULES: MutableList<Module.Factory<out Module<*>>> = mutableListOf()
        private val POST_INIT_ACTIONS = mutableListOf<() -> Unit>()

        fun addModule(module: Module.Factory<out Module<*>>) {
            MODULES.add(module)
        }

        fun addPostInitializeAction(action: () -> Unit) {
            POST_INIT_ACTIONS.add(action)
        }
    }
}
