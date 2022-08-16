package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.DeletedProvider
import com.nabla.sdk.core.domain.entity.MaybeProvider
import com.nabla.sdk.core.domain.entity.Provider

internal fun MaybeProvider.toMap(): ReadableMap = Arguments.createMap().also {
    when (this) {
        DeletedProvider ->
            it.putString("type", "DeletedProvider")
        is Provider -> {
            it.putString("type", "Provider")
            it.putMap("provider", toMap())
        }
    }
}
