package com.nabla.sdk.reactnative.messaging.ui.nablaconversationlistview

import androidx.activity.ComponentActivity
import androidx.activity.viewModels
import com.facebook.react.bridge.Arguments
import com.facebook.react.common.MapBuilder
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.events.RCTEventEmitter
import com.nabla.sdk.messaging.ui.helper.ConversationListViewModelFactory
import com.nabla.sdk.messaging.ui.scene.conversations.ConversationListView
import com.nabla.sdk.messaging.ui.scene.conversations.ConversationListViewModel
import com.nabla.sdk.messaging.ui.scene.conversations.bindViewModel
import com.nabla.sdk.reactnative.messaging.core.models.toMap
import com.nabla.sdk.reactnative.messaging.ui.utils.NativeViewWrapper

internal class NablaConversationListViewManager : SimpleViewManager<NativeViewWrapper>() {

    override fun getName() = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): NativeViewWrapper {
        val currentActivity = reactContext.currentActivity as ComponentActivity

        val conversationListView = ConversationListView(reactContext)
        val conversationListViewWrapper = NativeViewWrapper(reactContext, conversationListView)

        val viewModel: ConversationListViewModel by currentActivity.viewModels {
            ConversationListViewModelFactory(owner = currentActivity)
        }

        conversationListView.bindViewModel(
            viewModel = viewModel,
            onConversationClicked = { conversationId ->
                val event = Arguments.createMap().apply {
                    putMap("conversationId", conversationId.toMap())
                }
                reactContext
                    .getJSModule(RCTEventEmitter::class.java)
                    .receiveEvent(
                        conversationListViewWrapper.id,
                        "onConversationClicked",
                        event)
            }
        )

        return conversationListViewWrapper
    }


    override fun getExportedCustomDirectEventTypeConstants(): MutableMap<String, Any>? {
        return MapBuilder.of(
            "onConversationClicked",
            MapBuilder.of(
                "registrationName",
                "onConversationSelected"
            )
        )
    }

    companion object {
        private const val REACT_CLASS = "NablaConversationListView"
    }
}
