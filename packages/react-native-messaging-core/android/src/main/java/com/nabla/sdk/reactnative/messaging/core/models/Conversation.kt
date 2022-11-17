package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.messaging.core.domain.entity.Conversation

@JvmName("toConversationMapArray")
internal fun List<Conversation>.toMapArray(): ReadableArray = Arguments.createArray().apply {
    forEach { conversation ->
        pushMap(conversation.toMap())
    }
}

internal fun Conversation.toMap(): ReadableMap {
    return Arguments.createMap().apply {
        putMap("id", id.toMap())
        putString("title", title)
        putString("inboxPreviewTitle", inboxPreviewTitle)
        putString("lastMessagePreview", lastMessagePreview)
        putString("lastModified", lastModified.toString())
        putInt("patientUnreadMessageCount", patientUnreadMessageCount)
        pictureUrl?.url?.toString()?.let { putString("pictureURL", it) }
        putArray("providers", providersInConversation.toMapArray())
        putBoolean("isLocked", isLocked)
    }
}

