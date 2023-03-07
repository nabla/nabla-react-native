package com.nabla.sdk.reactnative.scheduling.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.Provider

internal fun Provider.toMap(): ReadableMap = Arguments.createMap().apply {
    putString("id", id.toString())
    putString("firstName", firstName)
    putString("lastName", lastName)
    prefix?.let { putString("prefix", it) }
    title?.let { putString("title", it) }
    avatar?.let {  putString("avatarURL", it.url.toString())}
}
