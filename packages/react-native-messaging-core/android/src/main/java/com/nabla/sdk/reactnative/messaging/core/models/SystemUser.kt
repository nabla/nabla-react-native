package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.SystemUser

internal fun SystemUser.toMap(): ReadableMap? = Arguments.createMap().apply {
    putString("name", name)
    putString("avatarURL", avatar?.url.toString())
}
