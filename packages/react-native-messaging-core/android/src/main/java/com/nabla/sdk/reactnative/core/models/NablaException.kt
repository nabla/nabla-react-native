package com.nabla.sdk.reactnative.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.*
import com.nabla.sdk.messaging.core.domain.entity.*

internal val NablaException.code: Int
    get() {
        return when (this) {
            is NetworkException -> 0
            is ServerException -> 1
            is InternalException -> 2
            is UnknownException -> 3
            is InvalidAppThemeException -> 4
            is AuthenticationException.NotAuthenticated -> 10
            is AuthenticationException.AuthorizationDenied -> 13
            is AuthenticationException.UnableToGetFreshSessionToken -> 14
            is InvalidMessageException -> 20
            is MessageNotFoundException -> 21
            is ProviderNotFoundException -> 23
            is ProviderMissingPermissionException -> 24
            is MissingConversationIdException -> 25
            is ConfigurationException.MissingApiKey -> 30
            is ConfigurationException.MissingContext -> 31
            is ConfigurationException.MissingInitialize -> 32
            else -> 3
        }
    }

internal fun NablaException.toMap(): ReadableMap {
    return Arguments.createMap().apply {
        putInt("code", code)
        putString("message", message)
        putMap("extra", Arguments.createMap().apply { putString("cause", cause?.toString()) })
    }
}
