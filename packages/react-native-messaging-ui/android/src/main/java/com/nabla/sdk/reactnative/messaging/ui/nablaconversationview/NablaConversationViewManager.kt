package com.nabla.sdk.reactnative.messaging.ui.nablaconversationview

import androidx.fragment.app.FragmentActivity
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewGroupManager
import com.facebook.react.uimanager.annotations.ReactProp
import com.nabla.sdk.messaging.core.domain.entity.ConversationId
import com.nabla.sdk.messaging.ui.scene.messages.ConversationFragment
import com.nabla.sdk.reactnative.messaging.core.models.toConversationId
import com.nabla.sdk.reactnative.messaging.ui.utils.NativeViewWrapper

internal class NablaConversationViewManager(
    private val reactContext: ReactApplicationContext,
) : ViewGroupManager<NativeViewWrapper>() {

    private lateinit var conversationId: ConversationId

    override fun getName() = REACT_CLASS

    override fun createViewInstance(reactContext: ThemedReactContext): NativeViewWrapper {
        return NativeViewWrapper(reactContext)
    }

    @ReactProp(name = "conversationId")
    fun setConversationId(view: NativeViewWrapper, conversationId: ReadableMap) {
        this.conversationId = conversationId.toConversationId()
    }

    override fun getCommandsMap() = mapOf("create" to COMMAND_CREATE)

    override fun receiveCommand(
        root: NativeViewWrapper,
        commandId: String,
        args: ReadableArray?,
    ) {
        super.receiveCommand(root, commandId, args)

        val reactNativeViewId = requireNotNull(args).getInt(0)
        when (commandId.toInt()) {
            COMMAND_CREATE -> createFragment(reactNativeViewId)
        }
    }

    private fun createFragment(reactNativeViewId: Int) {
        val fragment = ConversationFragment.newInstance(conversationId) {
            setShowNavigation(false)
        }
        (reactContext.currentActivity as FragmentActivity).supportFragmentManager
            .beginTransaction()
            .replace(
                reactNativeViewId,
                fragment,
                reactNativeViewId.toString()
            )
            .commit()
    }

    companion object {
        private const val REACT_CLASS = "NablaConversationView"
        private const val COMMAND_CREATE = 1
    }
}
