package com.nabla.sdk.reactnative.scheduling

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.nabla.sdk.reactnative.scheduling.nablaapointmentlistview.NablaAppointmentListViewManager
import com.nabla.sdk.reactnative.scheduling.nablaschedulingclient.NablaSchedulingClientModule

class NablaSchedulingPackage : ReactPackage {

    override fun createViewManagers(reactContext: ReactApplicationContext):
            MutableList<ViewManager<*, *>> {
        return mutableListOf(
            NablaAppointmentListViewManager(reactContext)
        )
    }

    override fun createNativeModules(reactContext: ReactApplicationContext):
            MutableList<NativeModule> {
        return mutableListOf(
            NablaSchedulingClientModule(reactContext)
        )
    }
}
