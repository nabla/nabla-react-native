package com.nabla.sdk.reactnative.messaging.core.models

import com.nabla.sdk.messaging.core.domain.entity.SendStatus

internal fun SendStatus.toMapValue() = when (this) {
    SendStatus.Sending -> "sending"
    SendStatus.Sent -> "sent"
    SendStatus.ErrorSending -> "failed"
}
