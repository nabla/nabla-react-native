package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.messaging.core.domain.entity.ProviderInConversation

@JvmName("toProviderInConversationMapArray")
internal fun List<ProviderInConversation>.toMapArray(): ReadableArray {
    return Arguments.createArray().apply {
        forEach { providerInConversation ->
            pushMap(providerInConversation.toMap())
        }
    }
}

internal fun ProviderInConversation.toMap(): ReadableMap = Arguments.createMap().apply {
    putMap("provider", provider.toMap())
    putString("typingAt", typingAt?.toString())
    putString("seenUntil", seenUntil?.toString())
}
