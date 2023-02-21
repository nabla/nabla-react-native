package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.WritableMap
import com.nabla.sdk.core.domain.entity.PaginatedContent

internal fun <T> PaginatedContent<List<T>>.toMap(mapElement: (T) -> ReadableMap): WritableMap =
    Arguments.createMap().apply {
        putArray("elements", Arguments.createArray().apply {
            content.forEach { pushMap(mapElement(it)) }
        })
        putBoolean("hasMore", loadMore != null)
    }

