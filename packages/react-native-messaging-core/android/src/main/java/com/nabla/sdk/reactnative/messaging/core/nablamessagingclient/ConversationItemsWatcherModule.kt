package com.nabla.sdk.reactnative.messaging.core.nablamessagingclient

import com.facebook.react.bridge.*
import com.facebook.react.modules.core.DeviceEventManagerModule
import com.nabla.sdk.core.NablaClient
import com.nabla.sdk.core.annotation.NablaInternal
import com.nabla.sdk.core.domain.entity.InternalException.Companion.asNablaInternal
import com.nabla.sdk.core.domain.entity.NablaException
import com.nabla.sdk.messaging.core.domain.entity.ConversationId
import com.nabla.sdk.messaging.core.messagingClient
import com.nabla.sdk.reactnative.messaging.core.models.toConversationId
import com.nabla.sdk.reactnative.messaging.core.models.toMap
import com.nabla.sdk.reactnative.messaging.core.models.toMapArray
import kotlinx.coroutines.*
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.flow.launchIn
import kotlinx.coroutines.flow.onEach

@OptIn(NablaInternal::class)
internal class ConversationItemsWatcherModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext),
    CoroutineScope by CoroutineScope(SupervisorJob() + Dispatchers.Default) {

    private var conversationItemsWatchersJobs: MutableMap<ConversationId, Pair<Job, ToUnitResult>> =
        mutableMapOf()

    override fun getName() = "ConversationItemsWatcherModule"

    override fun invalidate() {
        cancel() // Cancel coroutine scope on destroy
        super.invalidate()
    }

    @ReactMethod
    fun watchConversationItems(conversationIdMap: ReadableMap, callback: Callback) {
        val conversationId = try {
            conversationIdMap.toConversationId()
        } catch (e: Exception) {
            callback(e.asNablaInternal().toMap())
            return
        }
        var loadMoreItemsCallback: ToUnitResult = null
        val watchItemsJob =
            NablaClient.getInstance().messagingClient.watchConversationItems(conversationId)
                .onEach {
                    loadMoreItemsCallback = it.loadMore
                    sendUpdate(
                        Arguments.createMap().apply {
                            putMap("id", conversationId.toMap())
                            putArray("items", it.content.toMapArray())
                            putBoolean("hasMore", it.loadMore != null)
                        }
                    )
                }
                .catch { exception: Throwable ->
                    sendError(
                        (exception as NablaException)
                            .toMap()
                            .apply { putMap("id", conversationId.toMap()) }
                    )
                }
                .launchIn(this)
        conversationItemsWatchersJobs[conversationId] = watchItemsJob to loadMoreItemsCallback
        callback(null)
    }

    @ReactMethod
    fun loadMoreItemsInConversation(conversationIdMap: ReadableMap, callback: Callback) {
        val conversationId = try {
            conversationIdMap.toConversationId()
        } catch (e: Exception) {
            callback(e.asNablaInternal().toMap())
            return
        }

        if (conversationItemsWatchersJobs[conversationId] == null) {
            callback(
                IllegalStateException("`$conversationIdMap` items are not watched. Need to watch conversation items before loading more items")
                    .asNablaInternal()
                    .toMap()
            )
            return
        }
        val loadMore = conversationItemsWatchersJobs[conversationId]?.second ?: return
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
    fun unsubscribeFromConversationItems(conversationIdMap: ReadableMap) {
        val conversationId = try {
            conversationIdMap.toConversationId()
        } catch (e: Exception) {
            // This an internal method, so we can ignore exception
            // If we have a bad conversationId, the watchConversationItems
            // will fail before we get here
            return
        }
        conversationItemsWatchersJobs[conversationId]?.first?.cancel()
        conversationItemsWatchersJobs.remove(conversationId)
    }

    @ReactMethod
    fun addListener(eventName: String) {
        // This method is required even if empty
    }

    @ReactMethod
    fun removeListeners(count: Int) {
        if (count == 0) {
            conversationItemsWatchersJobs.forEach {
                it.value.first.cancel()
            }
            conversationItemsWatchersJobs.clear()
        }
    }

    private fun sendUpdate(params: ReadableMap?) {
        sendEvent(reactApplicationContext, WATCH_CONVERSATION_ITEMS_UPDATED, params)
    }

    private fun sendError(params: ReadableMap?) {
        sendEvent(reactApplicationContext, WATCH_CONVERSATION_ITEMS_ERROR, params)
    }

    private fun sendEvent(reactContext: ReactContext, eventName: String, params: ReadableMap?) {
        reactContext
            .getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter::class.java)
            .emit(eventName, params)
    }

    companion object {
        private const val WATCH_CONVERSATION_ITEMS_UPDATED = "watchConversationItemsUpdated"
        private const val WATCH_CONVERSATION_ITEMS_ERROR = "watchConversationItemsError"
    }
}
