package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.messaging.core.domain.entity.Conversation

internal fun Conversation.toMap(): ReadableMap {
    return Arguments.createMap().apply {
        putString("id", id.value.toString())
        putString("title", title)
        putString("inboxPreviewTitle", inboxPreviewTitle)
        putString("lastMessagePreview", lastMessagePreview)
        putString("lastModified", lastModified.toString())
        putInt("patientUnreadMessageCount", patientUnreadMessageCount)
        putArray("providers", providersInConversation.toMapArray())
    }
}

@JvmName("toConversationMapArray")
internal fun List<Conversation>.toMapArray(): ReadableArray {
    return Arguments.createArray().apply {
        forEach { conversation ->
            pushMap(conversation.toMap())
        }
    }
}

