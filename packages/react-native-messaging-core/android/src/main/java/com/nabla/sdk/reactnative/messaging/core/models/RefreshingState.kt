package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.RefreshingState

internal fun RefreshingState.toMap(): ReadableMap =
    Arguments.createMap().also {
        when (this) {
            is RefreshingState.ErrorWhileRefreshing -> {
                it.putString("type", "ErrorWhileRefreshing")
                it.putMap("error", error.toMap())
            }
            RefreshingState.Refreshed ->
                it.putString("type", "Refreshed")
            RefreshingState.Refreshing ->
                it.putString("type", "Refreshing")
        }
    }
