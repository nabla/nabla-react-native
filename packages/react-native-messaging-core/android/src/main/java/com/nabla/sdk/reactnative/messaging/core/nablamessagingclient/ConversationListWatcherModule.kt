package com.nabla.sdk.reactnative.messaging.core.nablamessagingclient

import androidx.annotation.CheckResult
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.nabla.sdk.core.NablaClient
import com.nabla.sdk.core.domain.entity.NablaException
import com.nabla.sdk.messaging.core.messagingClient
import com.nabla.sdk.reactnative.messaging.core.models.toMap
import com.nabla.sdk.reactnative.messaging.core.models.toMapArray
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach


internal class ConversationListWatcherModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext),
    CoroutineScope by CoroutineScope(SupervisorJob() + Dispatchers.Default) {

    private var loadMoreConversationsCallback: (@CheckResult suspend () -> Result<Unit>)? = null
    private var watchConversationJob: Job? = null

    override fun getName() = "ConversationListWatcherModule"

    override fun invalidate() {
        cancel() // Cancel coroutine scope on destroy
        super.invalidate()
    }

    @ReactMethod
    fun addListener(eventName: String) {
        if (eventName == WATCH_CONVERSATIONS_UPDATED || eventName == WATCH_CONVERSATIONS_ERROR) {
            watchConversationJob = NablaClient.getInstance().messagingClient.watchConversations()
                .onEach {
                    loadMoreConversationsCallback = it.loadMore
                    val params = Arguments.createMap().apply {
                        putArray("conversations", it.content.toMapArray(reactApplicationContext))
                    }
                    sendEvent(reactApplicationContext,
                        WATCH_CONVERSATIONS_UPDATED, params)
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
            watchConversationJob?.cancel()
        }
    }

    @ReactMethod
    fun loadMoreConversations(callback: Callback) {
        val loadMore = loadMoreConversationsCallback ?: return
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

    private fun sendEvent(reactContext: ReactContext, eventName: String, params: ReadableMap?) {
        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }

    companion object {
        private const val WATCH_CONVERSATIONS_UPDATED = "watchConversationsUpdated"
        private const val WATCH_CONVERSATIONS_ERROR = "watchConversationsError"
    }
}
