package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.Patient

internal fun Patient.Other.toMap(): ReadableMap? = Arguments.createMap().also {
    it.putString("id", id.toString())
    it.putString("displayName", displayName)
}
