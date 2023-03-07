package com.nabla.sdk.reactnative.scheduling.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.scheduling.domain.entity.PendingAppointment

internal fun PendingAppointment.toMap(): ReadableMap = Arguments.createMap().apply {
    putString("id", id.uuid.toString())
    putString("scheduledAt", scheduledAt.toString())
    putMap("provider", provider.toMap())
    putMap("location", location.toMap())
    price?.let { putMap("price", it.toMap()) }
}
