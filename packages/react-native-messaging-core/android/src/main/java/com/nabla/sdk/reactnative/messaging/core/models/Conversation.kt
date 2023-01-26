package com.nabla.sdk.reactnative.messaging.core.models

import android.content.Context
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.annotation.NablaInternal
import com.nabla.sdk.core.domain.entity.evaluate
import com.nabla.sdk.messaging.core.domain.entity.Conversation

@JvmName("toConversationMapArray")
internal fun List<Conversation>.toMapArray(context: Context): ReadableArray = Arguments.createArray().apply {
    forEach { conversation ->
        pushMap(conversation.toMap(context))
    }
}

@OptIn(NablaInternal::class)
internal fun Conversation.toMap(context: Context): ReadableMap {
    return Arguments.createMap().apply {
        putMap("id", id.toMap())
        putString("title", title)
        putString("inboxPreviewTitle", inboxPreviewTitle.evaluate(context))
        putString("lastMessagePreview", lastMessagePreview)
        putString("lastModified", lastModified.toString())
        putInt("patientUnreadMessageCount", patientUnreadMessageCount)
        pictureUrl?.url?.toString()?.let { putString("pictureURL", it) }
        putArray("providers", providersInConversation.toMapArray())
        putBoolean("isLocked", isLocked)
    }
}

