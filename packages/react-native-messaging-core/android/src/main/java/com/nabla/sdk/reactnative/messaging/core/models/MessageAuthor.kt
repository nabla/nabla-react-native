package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.messaging.core.domain.entity.MessageAuthor

internal fun MessageAuthor.toMap(): ReadableMap? = Arguments.createMap().also {
    when (this) {
        is MessageAuthor.Provider -> {
            it.putString("type", "Provider")
            it.putMap("provider", provider.toMap())
        }
        is MessageAuthor.System -> {
            it.putString("type", "System")
            it.putMap("system", system.toMap())
        }
        MessageAuthor.DeletedProvider ->
            it.putString("type", "Deleted")
        MessageAuthor.Unknown ->
            it.putString("type", "Unknown")
        MessageAuthor.Patient.Current -> it.putString("type", "Me")
        is MessageAuthor.Patient.Other -> {
            it.putString("type", "Patient")
            it.putMap("patient", this.patient.toMap())
        }
    }
}
