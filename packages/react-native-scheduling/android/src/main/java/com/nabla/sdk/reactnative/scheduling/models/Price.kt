package com.nabla.sdk.reactnative.scheduling.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.scheduling.domain.entity.Price

internal fun Price.toMap(): ReadableMap = Arguments.createMap().apply {
    putDouble("amount", amount.toDouble())
    putString("currencyCode", currencyCode)
}
