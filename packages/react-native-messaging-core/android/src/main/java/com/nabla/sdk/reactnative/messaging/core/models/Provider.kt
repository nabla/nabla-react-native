package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.Provider

internal fun Provider.toMap(): ReadableMap = Arguments.createMap().apply {
    putString("id", id.toString())
    putString("prefix", prefix)
    putString("firstName", firstName)
    putString("lastName", lastName)
    avatar?.let {  putString("avatarURL", it.url.toString())}
}
