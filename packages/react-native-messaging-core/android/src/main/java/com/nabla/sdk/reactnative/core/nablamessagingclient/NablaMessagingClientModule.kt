package com.nabla.sdk.reactnative.core.nablamessagingclient

import androidx.annotation.CheckResult
import com.benasher44.uuid.Uuid
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.nabla.sdk.core.domain.entity.InternalException
import com.nabla.sdk.core.domain.entity.NablaException
import com.nabla.sdk.messaging.core.NablaMessagingClient
import com.nabla.sdk.messaging.core.domain.entity.ConversationId
import com.nabla.sdk.messaging.core.domain.entity.MessageId
import com.nabla.sdk.reactnative.core.models.audioMessageInputOrThrow
import com.nabla.sdk.reactnative.core.models.documentMessageInputOrThrow
import com.nabla.sdk.reactnative.core.models.imageMessageInputOrThrow
import com.nabla.sdk.reactnative.core.models.textMessageInpuOrThrow
import com.nabla.sdk.reactnative.core.models.toMap
import com.nabla.sdk.reactnative.core.models.toMapArray
import com.nabla.sdk.reactnative.core.models.videoMessageInputOrThrow
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach
import kotlinx.coroutines.launch

class NablaMessagingClientModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext), CoroutineScope by CoroutineScope(SupervisorJob() + Dispatchers.Default) {
    private var loadMoreConversationsCallback: (@CheckResult suspend () -> Result<Unit>)? = null
    private var watchConversationJob: Job? = null

    override fun getName() = "NablaMessagingClientModule"

    override fun invalidate() {
        cancel() // Cancel coroutine scope on destroy
        super.invalidate()
    }

    @ReactMethod
    fun addListener(eventName: String) {
        if (eventName == WATCH_CONVERSATIONS_UPDATED || eventName == WATCH_CONVERSATIONS_ERROR) {
            watchConversationJob = NablaMessagingClient.getInstance().watchConversations()
                .onEach {
                    loadMoreConversationsCallback = it.loadMore
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

    @Suppress("ThrowableNotThrown")
    @ReactMethod
    fun sendMessage(
        input: ReadableMap,
        conversationId: String,
        replyTo: String?,
        callback: Callback,
    ) {
        val messageType = input.getString("type") ?: kotlin.run {
            callback(InternalException(IllegalStateException("Missing type of message")).toMap())
            return
        }

        val conversationUuid = try {
            Uuid.fromString(conversationId)
        } catch (e: Exception) {
            callback(InternalException(e).toMap())
            return
        }

        val replyToUuid = try {
            replyTo?.let { MessageId.Remote(null, Uuid.fromString(it)) }
        } catch (e: Exception) {
            callback(InternalException(e).toMap())
            return
        }

        val messageInput = try {
            when(messageType) {
                "text" -> input.textMessageInpuOrThrow()
                "image" -> input.imageMessageInputOrThrow()
                "video" -> input.videoMessageInputOrThrow()
                "document" -> input.documentMessageInputOrThrow()
                "audio" -> input.audioMessageInputOrThrow()
                else -> throw IllegalStateException("Unknown message type: $messageType")
            }
        } catch (e: Exception) {
            callback(InternalException(e).toMap())
            return
        }

        launch {
            NablaMessagingClient.getInstance()
                .sendMessage(
                    messageInput,
                    ConversationId(conversationUuid),
                    replyToUuid,
                )
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
