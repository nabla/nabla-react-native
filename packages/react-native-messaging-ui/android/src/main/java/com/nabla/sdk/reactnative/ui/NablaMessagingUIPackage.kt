package com.nabla.sdk.reactnative.ui

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import com.nabla.sdk.reactnative.ui.nablaconversationlistview.NablaConversationListViewManager
import com.nabla.sdk.reactnative.ui.nablamessaginguiclient.NablaMessagingUIModule

class NablaMessagingUIPackage : ReactPackage {

    override fun createViewManagers(reactContext: ReactApplicationContext): MutableList<ViewManager<*, *>>
        = mutableListOf(
            NablaConversationListViewManager()
        )

    override fun createNativeModules(reactContext: ReactApplicationContext): MutableList<NativeModule>
        = mutableListOf(
            NablaMessagingUIModule(reactContext)
        )
}
