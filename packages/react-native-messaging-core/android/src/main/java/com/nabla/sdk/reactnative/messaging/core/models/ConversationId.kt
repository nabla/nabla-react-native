package com.nabla.sdk.reactnative.messaging.core.models

import com.benasher44.uuid.Uuid
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.messaging.core.domain.entity.ConversationId

fun ConversationId.toMap(): ReadableMap {
    return Arguments.createMap().also {
        when (this) {
            is ConversationId.Local -> {
                it.putString("type", "Local")
                it.putString("clientId", clientId.toString())
            }
            is ConversationId.Remote -> {
                it.putString("type", "Remote")
                it.putString("remoteId", remoteId.toString())
                clientId?.let { clientId -> it.putString("clientId", clientId.toString()) }
            }
        }
    }
}

fun ReadableMap.toConversationId(): ConversationId {
    return when (getString("type")) {
        "Local" -> {
            val clientId = Uuid.fromString(getString("clientId"))
            ConversationId.Local(clientId)
        }
        "Remote" -> {
            val clientId = getString("clientId")?.let { Uuid.fromString(it) }
            val remoteId = Uuid.fromString(getString("remoteId"))
            ConversationId.Remote(clientId, remoteId)
        }
        else -> throw IllegalArgumentException("Unknown conversation id type")
    }
}
