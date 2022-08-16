package com.nabla.sdk.reactnative.messaging.core.nablamessagingclient

import com.benasher44.uuid.Uuid
import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.nabla.sdk.core.domain.entity.InternalException
import com.nabla.sdk.core.domain.entity.NablaException
import com.nabla.sdk.messaging.core.NablaMessagingClient
import com.nabla.sdk.messaging.core.domain.entity.ConversationId
import com.nabla.sdk.reactnative.messaging.core.models.toConversationId
import com.nabla.sdk.reactnative.messaging.core.models.toMap
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

internal class ConversationWatcherModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext),
    CoroutineScope by CoroutineScope(SupervisorJob() + Dispatchers.Default) {

    private var conversationWatchersJobs: MutableMap<ConversationId, Job> = mutableMapOf()

    override fun getName() = "ConversationWatcherModule"

    override fun invalidate() {
        cancel() // Cancel coroutine scope on destroy
        super.invalidate()
    }

    @ReactMethod
    fun watchConversation(conversationIdMap: ReadableMap, callback: Callback) {
        val conversationId = try {
            conversationIdMap.toConversationId()
        } catch (e: Exception) {
            callback(InternalException(e).toMap())
            return
        }
        val watchConversationJob =
            NablaMessagingClient.getInstance().watchConversation(conversationId)
                .onEach {
                    sendUpdate(it.toMap())
                }
                .catch { exception: Throwable ->
                    sendError(
                        (exception as NablaException)
                            .toMap()
                            .apply { putMap("id", conversationId.toMap()) }
                    )
                }
                .launchIn(this)
        conversationWatchersJobs[conversationId] = watchConversationJob
        callback(null)
    }

    @ReactMethod
    fun unsubscribeFromConversation(conversationIdMap: ReadableMap) {
        val conversationId = try {
            conversationIdMap.toConversationId()
        } catch (e: Exception) {
            // This an internal method, so we can ignore exception
            // If we have a bad conversationId, the watchConversationItems
            // will fail before we get here
            return
        }
        conversationWatchersJobs[conversationId]?.cancel()
        conversationWatchersJobs.remove(conversationId)
    }

    @ReactMethod
    fun addListener(eventName: String) {
        // This method is required even if empty
    }

    @ReactMethod
    fun removeListeners(count: Int) {
        if (count == 0) {
            conversationWatchersJobs.forEach {
                it.value.cancel()
            }
            conversationWatchersJobs.clear()
        }
    }

    private fun sendUpdate(params: ReadableMap) {
        sendEvent(
            reactApplicationContext,
            WATCH_CONVERSATION_UPDATED,
            params
        )
    }

    private fun sendError(params: WritableMap) {
        sendEvent(
            reactApplicationContext,
            WATCH_CONVERSATION_ERROR,
            params
        )
    }

    private fun sendEvent(reactContext: ReactContext, eventName: String, params: ReadableMap?) {
        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }

    companion object {
        private const val WATCH_CONVERSATION_UPDATED = "watchConversationUpdated"
        private const val WATCH_CONVERSATION_ERROR = "watchConversationError"
    }
}
