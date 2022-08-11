package com.nabla.sdk.reactnative.messaging.core.models

import com.benasher44.uuid.Uuid
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.messaging.core.domain.entity.MessageId

internal fun MessageId.toMap(): ReadableMap {
    return Arguments.createMap().also {
        when (this) {
            is MessageId.Local -> {
                it.putString("type", "Local")
                it.putString("clientId", clientId.toString())
            }
            is MessageId.Remote -> {
                it.putString("type", "Remote")
                it.putString("remoteId", remoteId.toString())
                clientId?.let { clientId -> it.putString("clientId", clientId.toString()) }
            }
        }
    }
}

internal fun ReadableMap.toMessageId(): MessageId {
    return when (getString("type")) {
        "Local" -> {
            val clientId = Uuid.fromString(getString("clientId"))
            MessageId.Local(clientId)
        }
        "Remote" -> {
            val clientId = getString("clientId")?.let { Uuid.fromString(it) }
            val remoteId = Uuid.fromString(getString("remoteId"))
            MessageId.Remote(clientId, remoteId)
        }
        else -> throw IllegalArgumentException("Unknown message id type")
    }
}

internal fun ReadableMap.toRemoteMessageId(): MessageId.Remote {
    return when (val messageId = toMessageId()) {
        is MessageId.Remote -> messageId
        is MessageId.Local -> throw IllegalArgumentException("Incorrect message id type")
    }
}

