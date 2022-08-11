package com.nabla.sdk.reactnative.messaging.ui.nablamessagingui

import android.content.Intent
import com.facebook.react.bridge.*
import com.nabla.sdk.reactnative.messaging.core.models.toConversationId

class NablaMessagingUIModule(
    reactContext: ReactApplicationContext
) : ReactContextBaseJavaModule(reactContext){
    override fun getName() = "NablaMessagingUIModule"

    @ReactMethod
    fun navigateToInbox() {
        currentActivity?.let {
            it.startActivity(
                Intent(it, NablaInboxActivity::class.java)
            )
        }
    }

    @ReactMethod
    fun navigateToConversation(conversationIdMap: ReadableMap, showComposer: Boolean) {
        currentActivity?.let {
            it.startActivity(
                Intent(it, NablaConversationActivity::class.java)
                    .apply {
                        putExtra(CONVERSATION_ID_EXTRA, conversationIdMap.toConversationId())
                        putExtra(SHOW_COMPOSER_EXTRA, showComposer)
                    }
            )
        }
    }

    companion object {
        const val CONVERSATION_ID_EXTRA = "conversationId"
        const val SHOW_COMPOSER_EXTRA = "showComposer"
    }
}
