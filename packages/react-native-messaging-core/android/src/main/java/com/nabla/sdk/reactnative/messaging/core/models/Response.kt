package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.Response

internal fun <T> Response<T>.toMap(mapData: (T) -> ReadableMap): ReadableMap =
    Arguments.createMap().apply {
        putBoolean("isDataFresh", isDataFresh)
        putMap("refreshingState", refreshingState.toMap())
        putMap("data", mapData(data))
    }
