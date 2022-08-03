package com.nabla.sdk.reactnative.core.nablaclient

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.nabla.sdk.core.Configuration
import com.nabla.sdk.core.NablaClient
import com.nabla.sdk.core.NetworkConfiguration
import com.nabla.sdk.core.domain.boundary.SessionTokenProvider
import com.nabla.sdk.core.domain.entity.AuthTokens
import com.nabla.sdk.core.domain.entity.StringId
import kotlinx.coroutines.CancellableContinuation
import kotlinx.coroutines.ExperimentalCoroutinesApi
import kotlinx.coroutines.suspendCancellableCoroutine

class NablaClientModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext), SessionTokenProvider {

    override fun getName() = "NablaClientModule"
    private var provideAuthTokensContinuation: CancellableContinuation<Result<AuthTokens>>? = null
    private var currentUserId: String? = null

    @ReactMethod
    fun initialize(apiKey: String, networkConfiguration: ReadableMap?) {
        if (networkConfiguration != null) {
            val scheme = networkConfiguration.getString("scheme")
            val domain = networkConfiguration.getString("domain")
            val path = networkConfiguration.getString("path")
            val port = networkConfiguration.getInt("port")

            if (scheme != null && domain != null && path != null) {
                val baseUrl = if (port != 0) "$scheme://$domain:$port$path" else "$scheme://$domain$path"

                NablaClient.initialize(
                    Configuration(publicApiKey = apiKey),
                    NetworkConfiguration(baseUrl = baseUrl)
                )
            } else {
                NablaClient.initialize(
                    Configuration(publicApiKey = apiKey)
                )
            }
        } else {
            NablaClient.initialize(
                Configuration(publicApiKey = apiKey)
            )
        }
    }

    @ReactMethod
    fun willAuthenticateUser(
        userId: String,
    ) {
        currentUserId = userId
    }

    @ReactMethod
    fun addListener(eventName: String) {
        if (eventName == NEED_PROVIDE_TOKENS) {
            currentUserId?.let {
                NablaClient.getInstance().authenticate(it, this)
            }
        }
    }

    @ReactMethod
    fun removeListeners(count: Int) {
        if (count == 0) {
            currentUserId = null
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
            value = Result.success(AuthTokens(refreshToken, accessToken)),
            onCancellation = null
        )
        provideAuthTokensContinuation = null
    }

    override suspend fun fetchNewSessionAuthTokens(userId: StringId): Result<AuthTokens> {
        sendEvent(reactApplicationContext, NEED_PROVIDE_TOKENS, null)
        return suspendCancellableCoroutine { this.provideAuthTokensContinuation = it }
    }

    private fun sendEvent(reactContext: ReactContext, eventName: String, params: ReadableMap?) {
        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }

    companion object {
        private const val NEED_PROVIDE_TOKENS = "needProvideTokens"
    }
}
