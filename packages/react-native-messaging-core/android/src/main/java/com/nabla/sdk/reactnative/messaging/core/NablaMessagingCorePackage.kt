package com.nabla.sdk.reactnative.messaging.core

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.nabla.sdk.reactnative.messaging.core.nablamessagingclient.NablaMessagingClientModule

class NablaMessagingCorePackage : ReactPackage {

    override fun createViewManagers(reactContext: ReactApplicationContext):
            MutableList<ViewManager<*, *>> {
        return mutableListOf()
    }

    override fun createNativeModules(reactContext: ReactApplicationContext):
            MutableList<NativeModule> {
        return mutableListOf(
            NablaMessagingClientModule(reactContext),
        )
    }
}
