package com.nabla.sdk.reactnative.scheduling.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.scheduling.domain.entity.AppointmentLocation
import com.nabla.sdk.scheduling.domain.entity.AppointmentLocationType

internal fun AppointmentLocation.toMap(): ReadableMap = Arguments.createMap().also {
    when (type) {
        AppointmentLocationType.REMOTE -> it.putString("type", "Remote")
        AppointmentLocationType.PHYSICAL -> it.putString("type", "Physical")
        null -> it.putString("type", "Unknown")
    }
}
