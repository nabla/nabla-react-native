package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.*
import com.nabla.sdk.messaging.core.domain.entity.*
import com.nabla.sdk.reactnative.core.models.coreCode

internal val NablaException.code: Int
    get() {
        return when (this) {
            is InvalidAppThemeException -> 4
            is InvalidMessageException -> 20
            is MessageNotFoundException -> 21
            is ProviderNotFoundException -> 23
            is ProviderMissingPermissionException -> 24
            is MissingConversationIdException -> 25
            else -> this.coreCode
        }
    }

 fun NablaException.toMap(): ReadableMap {
    return Arguments.createMap().apply {
        putInt("code", code)
        putString("message", message)
        putMap("extra", Arguments.createMap().apply { putString("cause", cause?.toString()) })
    }
}
