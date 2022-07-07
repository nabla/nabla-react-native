package com.nabla.sdk.reactnative.core.nablamessagingclient

import androidx.annotation.CheckResult
import com.benasher44.uuid.Uuid
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.nabla.sdk.core.domain.entity.NablaException
import com.nabla.sdk.messaging.core.NablaMessagingClient
import com.nabla.sdk.reactnative.core.models.toMap
import com.nabla.sdk.reactnative.core.models.toMapArray
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlin.coroutines.CoroutineContext

class NablaMessagingClientModule(
    reactContext: ReactApplicationContext
) : ReactContextBaseJavaModule(reactContext),
    CoroutineScope by CoroutineScope(SupervisorJob() + Dispatchers.Default) {
    override fun getName() = "NablaMessagingClientModule"


    @ReactMethod
    fun addListener(eventName: String) {

        if (eventName == WATCH_CONVERSATIONS_UPDATED || eventName == WATCH_CONVERSATIONS_ERROR) {
            job = NablaMessagingClient.getInstance().watchConversations()
                .onEach {
                    loadMoreConversations = it.loadMore
                    val params = Arguments.createMap().apply {
                        putArray("conversations", it.content.toMapArray())
                    }
                    sendEvent(reactApplicationContext, WATCH_CONVERSATIONS_UPDATED, params)
                }
                .catch { exception: Throwable ->
                    sendEvent(
                        reactApplicationContext,
                        WATCH_CONVERSATIONS_ERROR,
                        (exception as NablaException).toMap()
                    )
                }
                .launchIn(this)
        }
    }

    @ReactMethod
    fun removeListeners(count: Int) {
        if (count == 0) {
            job?.cancel()
        }
    }

    @ReactMethod
    fun loadMoreConversations(callback: Callback) {
        val loadMore = loadMoreConversations ?: return
        this.launch {
            loadMore()
                .onSuccess {
                    callback(null)
                }
                .onFailure {
                    callback((it as NablaException).toMap())
                }
        }
    }

    @ReactMethod
    fun createConversation(
        title: String?,
        providerIds: ReadableArray?,
        callback: Callback,
    ) {
        val providerUuids = providerIds?.let {
            (0 until it.size()).map { index -> Uuid.fromString(it.getString(index)) }
        }
        this.launch {
            NablaMessagingClient.getInstance()
                .createConversation(
                    title,
                    providerUuids
                )
                .onSuccess {
                    callback(null, it.id.value.toString())
                }
                .onFailure {
                    callback((it as NablaException).toMap())
                }
        }
    }

    private fun sendEvent(reactContext: ReactContext, eventName: String, params: ReadableMap?) {
        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }

    private var loadMoreConversations: (@CheckResult suspend () -> Result<Unit>)? = null
    private var job: Job? = null

    companion object {
        const val WATCH_CONVERSATIONS_UPDATED = "watchConversationsUpdated"
        const val WATCH_CONVERSATIONS_ERROR = "watchConversationsError"
    }
}
