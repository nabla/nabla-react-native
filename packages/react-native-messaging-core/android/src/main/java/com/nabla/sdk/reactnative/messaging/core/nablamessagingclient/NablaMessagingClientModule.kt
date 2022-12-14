package com.nabla.sdk.reactnative.messaging.core.nablamessagingclient

import com.benasher44.uuid.Uuid
import com.facebook.react.bridge.*
import com.nabla.sdk.core.NablaClient
import com.nabla.sdk.core.annotation.NablaInternal
import com.nabla.sdk.core.domain.entity.InternalException
import com.nabla.sdk.core.domain.entity.InternalException.Companion.asNablaInternal
import com.nabla.sdk.core.domain.entity.NablaException
import com.nabla.sdk.messaging.core.NablaMessagingModule
import com.nabla.sdk.messaging.core.domain.entity.ConversationId
import com.nabla.sdk.messaging.core.domain.entity.MessageId
import com.nabla.sdk.messaging.core.domain.entity.MessageInput
import com.nabla.sdk.messaging.core.messagingClient
import com.nabla.sdk.reactnative.core.nablaclient.NablaClientModule
import com.nabla.sdk.reactnative.messaging.core.models.*
import kotlinx.coroutines.*

@OptIn(NablaInternal::class)
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
    fun initializeMessagingModule(promise: Promise) {
        NablaClientModule.addModule(NablaMessagingModule())
        promise.resolve(null)
    }

    @ReactMethod
    fun createConversation(
        messageInput: ReadableMap,
        title: String?,
        providerIds: ReadableArray?,
        callback: Callback,
    ) {
        val providerUuids = providerIds?.let {
            (0 until it.size()).map { index -> Uuid.fromString(it.getString(index)) }
        }
        val initialMessage = try {
            messageInput.messageInputOrThrow()
        } catch (e: Exception) {
            callback(e.asNablaInternal().toMap())
            return
        }
        this.launch {
            NablaClient.getInstance().messagingClient
                .createConversationWithMessage(
                    initialMessage,
                    title,
                )
                .onSuccess {
                    callback(null, it.id.toMap())
                }
                .onFailure {
                    callback((it as NablaException).toMap())
                }
        }
    }

    @ReactMethod
    fun startConversation(
        title: String?,
        providerIds: ReadableArray?,
        callback: Callback,
    ) {
        val providerUuids = providerIds?.let {
            (0 until it.size()).map { index -> Uuid.fromString(it.getString(index)) }
        }
        val conversationId = NablaClient.getInstance().messagingClient
            .startConversation(
                title,
                providerUuids,
            )
        callback(null, conversationId.toMap())
    }

    @Suppress("ThrowableNotThrown")
    @ReactMethod
    fun sendMessage(
        input: ReadableMap,
        conversationIdMap: ReadableMap,
        replyToMap: ReadableMap?,
        callback: Callback,
    ) {
        val messageInput: MessageInput
        val conversationId: ConversationId
        val replyToUuid: MessageId.Remote?
        try {
            messageInput = input.messageInputOrThrow()
            conversationId = conversationIdMap.toConversationId()
            replyToUuid = replyToMap?.toRemoteMessageId()
        } catch (e: Exception) {
            callback(e.asNablaInternal().toMap())
            return
        }

        launch {
            NablaClient.getInstance().messagingClient
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

    @OptIn(NablaInternal::class)
    @ReactMethod
    fun retrySendingMessage(
        messageIdMap: ReadableMap,
        conversationIdMap: ReadableMap,
        callback: Callback,
    ) {
        val messageId: MessageId.Local
        val conversationId: ConversationId
        try {
            messageId = messageIdMap.toMessageId().requireLocal()
            conversationId = conversationIdMap.toConversationId()
        } catch (e: Exception) {
            callback(e.asNablaInternal().toMap())
            return
        }

        launch {
            NablaClient.getInstance().messagingClient
                .retrySendingMessage(messageId, conversationId)
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
        val messageId: MessageId
        val conversationId: ConversationId
        try {
            messageId = messageIdMap.toMessageId()
            conversationId = conversationIdMap.toConversationId()
        } catch (e: Exception) {
            callback(e.asNablaInternal().toMap())
            return
        }

        launch {
            NablaClient.getInstance().messagingClient
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
            callback(e.asNablaInternal().toMap())
            return
        }
        launch {
            NablaClient.getInstance().messagingClient
                .markConversationAsRead(conversationId)
                .onSuccess {
                    callback(null)
                }
                .onFailure {
                    callback((it as NablaException).toMap())
                }
        }
    }

    @ReactMethod
    fun setIsTyping(
        isTyping: Boolean,
        conversationIdMap: ReadableMap,
        callback: Callback,
    ) {
        val conversationId = try {
            conversationIdMap.toConversationId()
        } catch (e: Exception) {
            callback(e.asNablaInternal().toMap())
            return
        }

        launch {
            NablaClient.getInstance().messagingClient
                .setTyping(conversationId, isTyping)
                .onSuccess {
                    callback(null)
                }
                .onFailure {
                    callback((it as NablaException).toMap())
                }
        }
    }
}
