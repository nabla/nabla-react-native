package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.nabla.sdk.messaging.core.domain.entity.ConversationItems

internal fun ConversationItems.toMap(hasMore: Boolean): WritableMap = Arguments.createMap().apply {
    putBoolean("hasMore", hasMore)
    putArray("items", items.toMapArray())
}
