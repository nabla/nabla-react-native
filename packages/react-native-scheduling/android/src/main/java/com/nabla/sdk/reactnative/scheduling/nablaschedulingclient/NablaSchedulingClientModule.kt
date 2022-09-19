package com.nabla.sdk.reactnative.scheduling.nablaschedulingclient

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.nabla.sdk.reactnative.core.nablaclient.NablaClientModule
import com.nabla.sdk.scheduling.NablaSchedulingModule

class NablaSchedulingClientModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext) {

    override fun getName() = "NablaSchedulingClientModule"

    @ReactMethod
    fun initializeSchedulingModule(promise: Promise) {
        NablaClientModule.addModule(NablaSchedulingModule())
        promise.resolve(null)
    }
}
