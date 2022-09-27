package com.nabla.sdk.reactnative.scheduling.nablaschedulingclient

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.nabla.sdk.core.NablaClient
import com.nabla.sdk.reactnative.core.nablaclient.CoreLogger
import com.nabla.sdk.reactnative.core.nablaclient.NablaClientModule
import com.nabla.sdk.scheduling.NablaSchedulingModule
import com.nabla.sdk.scheduling.schedulingModule

class NablaSchedulingClientModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext) {

    override fun getName() = "NablaSchedulingClientModule"

    @ReactMethod
    fun initializeSchedulingModule(promise: Promise) {
        NablaClientModule.addModule(NablaSchedulingModule())
        promise.resolve(null)
    }

    @ReactMethod
    fun openScheduleAppointmentScreen() {
        if (currentActivity == null) {
            CoreLogger.warn("Missing current activity in `NablaSchedulingClientModule`")
            return
        }
        NablaClient.getInstance().schedulingModule.openScheduleAppointmentActivity(currentActivity!!)
    }
}
