package com.nabla.sdk.reactnative.videocall.nablavideocallclient

import com.facebook.react.bridge.*
import com.nabla.sdk.core.NablaClient
import com.nabla.sdk.core.domain.entity.InternalException
import com.nabla.sdk.reactnative.core.models.toCoreMap
import com.nabla.sdk.reactnative.core.nablaclient.NablaClientModule
import com.nabla.sdk.videocall.NablaVideoCallModule
import com.nabla.sdk.videocall.videoCallModule

class NablaVideoCallClientModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext) {

    override fun getName() = "NablaVideoCallClientModule"

    @ReactMethod
    fun initializeVideoCallModule(promise: Promise) {
        NablaClientModule.addModule(NablaVideoCallModule())
        promise.resolve(null)
    }

    @ReactMethod
    fun joinVideoCall(roomMap: ReadableMap, callback: Callback) {
        val roomId = roomMap.getString("id") ?: kotlin.run {
            callback(InternalException(IllegalArgumentException("Missing room id")).toCoreMap())
            return
        }
        val url = roomMap.getString("url") ?: kotlin.run {
            callback(InternalException(IllegalArgumentException("Missing room url")).toCoreMap())
            return
        }
        val token = roomMap.getString("token") ?: kotlin.run {
            callback(InternalException(IllegalArgumentException("Missing room token")).toCoreMap())
            return
        }
        currentActivity?.let {
            NablaClient
                .getInstance()
                .videoCallModule
                .openVideoCall(
                    it,
                    url,
                    roomId,
                    token
                )
        }
    }
}
