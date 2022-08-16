package com.nabla.sdk.reactnative.messaging.core.nablamessagingclient

import com.benasher44.uuid.Uuid
import com.facebook.react.bridge.*
import com.nabla.sdk.core.domain.entity.InternalException
import com.nabla.sdk.core.domain.entity.NablaException
import com.nabla.sdk.messaging.core.NablaMessagingClient
import com.nabla.sdk.reactnative.messaging.core.models.*
import com.nabla.sdk.reactnative.messaging.core.models.audioMessageInputOrThrow
import com.nabla.sdk.reactnative.messaging.core.models.documentMessageInputOrThrow
import com.nabla.sdk.reactnative.messaging.core.models.imageMessageInputOrThrow
import com.nabla.sdk.reactnative.messaging.core.models.toMap
import com.nabla.sdk.reactnative.messaging.core.models.videoMessageInputOrThrow
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.launch

internal class NablaMessagingClientModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext),
    CoroutineScope by CoroutineScope(SupervisorJob() + Dispatchers.Default) {

    override fun getName() = "NablaMessagingClientModule"

    override fun invalidate() {
        cancel() // Cancel coroutine scope on destroy
        super.invalidate()
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
                    callback(null, it.id.toMap())
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
        conversationIdMap: ReadableMap,
        replyToMap: ReadableMap?,
        callback: Callback,
    ) {
        val messageType = input.getString("type") ?: kotlin.run {
            callback(InternalException(IllegalStateException("Missing type of message")).toMap())
            return
        }

        val conversationId = try {
            conversationIdMap.toConversationId()
        } catch (e: Exception) {
            callback(InternalException(e).toMap())
            return
        }

        val replyToUuid = try {
            replyToMap?.toRemoteMessageId()
        } catch (e: Exception) {
            callback(InternalException(e).toMap())
            return
        }

        val messageInput = try {
            when (messageType) {
                "text" -> input.textMessageInputOrThrow()
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
                    conversationId,
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

    @ReactMethod
    fun deleteMessage(
        messageIdMap: ReadableMap,
        conversationIdMap: ReadableMap,
        callback: Callback,
    ) {
        val messageId = try {
            messageIdMap.toMessageId()
        } catch (e: Exception) {
            callback(InternalException(e).toMap())
            return
        }

        val conversationId = try {
            conversationIdMap.toConversationId()
        } catch (e: Exception) {
            callback(InternalException(e).toMap())
            return
        }

        launch {
            NablaMessagingClient.getInstance()
                .deleteMessage(conversationId, messageId)
                .onSuccess {
                    callback(null)
                }
                .onFailure {
                    callback((it as NablaException).toMap())
                }
        }
    }

    @ReactMethod
    fun markConversationAsSeen(
        conversationIdMap: ReadableMap,
        callback: Callback,
    ) {
        val conversationId = try {
            conversationIdMap.toConversationId()
        } catch (e: Exception) {
            callback(InternalException(e).toMap())
            return
        }
        launch {
            NablaMessagingClient.getInstance().markConversationAsRead(conversationId)
                .onSuccess {
                    callback(null)
                }
                .onFailure {
                    callback((it as NablaException).toMap())
                }
        }
    }
}
