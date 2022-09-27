package com.nabla.sdk.reactnative.core.nablaclient

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.nabla.sdk.core.annotation.NablaInternal
import com.nabla.sdk.core.domain.entity.InternalException.Companion.asNablaInternal
import com.nabla.sdk.core.domain.entity.NablaException
import com.nabla.sdk.reactnative.core.models.toCoreMap
import kotlinx.coroutines.*

internal class LogWatcherModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext),
    CoroutineScope by CoroutineScope(SupervisorJob() + Dispatchers.Default) {


    private var logCollectJob: Job? = null

    override fun getName() = "LogWatcherModule"

    @ReactMethod
    fun setLogLevel(level: String) {
        CoreLogger.setLogLevel(level)
    }

    @ReactMethod
    fun addListener(eventName: String) {
        logCollectJob = this.launch {
            CoreLogger.logsFlow.collect {
                sendLogEvent(it.logLevel, it.message, it.domain, it.error)
            }
        }
    }

    @ReactMethod
    fun removeListeners(count: Int) {
        logCollectJob?.cancel()
    }


    private fun sendLogEvent(
        logLevel: CoreLogger.LogLevel,
        message: String,
        domain: String?,
        error: Throwable?,
    ) {
        sendEvent(
            Arguments.createMap().apply {
                putString("level", logLevel.name.lowercase())
                putString("message", message)
                putString("tag", asSdkTag(domain))
                error?.asNablaException()?.let {
                    putMap("error", it.toCoreMap())
                }
            }
        )
    }

    private fun sendEvent(params: ReadableMap?) {
        reactApplicationContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(LOG, params)
    }

    @OptIn(NablaInternal::class)
    private fun Throwable.asNablaException(): NablaException =
        if (this is NablaException) this else asNablaInternal()

    companion object {
        private const val LOG = "log"
        private const val DEFAULT_TAG = "Nabla-SDK"

        private fun asSdkTag(domain: String?): String {
            if (domain == null) {
                return DEFAULT_TAG
            }

            return "${DEFAULT_TAG}-${domain.replaceFirstChar { it.uppercaseChar() }}"
        }
    }
}
