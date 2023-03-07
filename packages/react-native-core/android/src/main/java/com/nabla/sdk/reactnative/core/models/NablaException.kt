package com.nabla.sdk.reactnative.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.annotation.NablaInternal
import com.nabla.sdk.core.domain.entity.*

@OptIn(NablaInternal::class)
val NablaException.coreCode: Int
    get() {
        return when (this) {
            is NetworkException -> 0
            is ServerException -> 1
            is InternalException -> 2
            is UnknownException -> 3
            is AuthenticationException.UserIdNotSet -> 10
            is AuthenticationException.AuthorizationDenied -> 13
            is AuthenticationException.UnableToGetFreshSessionToken -> 14
            is AuthenticationException.CurrentUserAlreadySet -> 16
            is ConfigurationException.MissingApiKey -> 30
            is ConfigurationException.MissingContext -> 31
            is ConfigurationException.MissingInitialize -> 32
            else -> 3
        }
    }

fun NablaException.toCoreMap(): ReadableMap {
    return Arguments.createMap().apply {
        putInt("code", coreCode)
        putString("message", message)
        putMap("extra", Arguments.createMap().apply { putString("cause", cause?.toString()) })
    }
}
