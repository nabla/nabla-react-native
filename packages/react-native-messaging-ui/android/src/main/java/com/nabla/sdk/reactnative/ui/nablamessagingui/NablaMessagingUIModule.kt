package com.nabla.sdk.reactnative.ui.nablamessagingui

import android.content.Intent
import com.benasher44.uuid.Uuid
import com.facebook.react.bridge.*

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
    fun navigateToConversation(conversationId: String, showComposer: Boolean) {
        currentActivity?.let {
            it.startActivity(
                Intent(it, NablaConversationActivity::class.java)
                    .apply {
                        putExtra(CONVERSATION_ID_EXTRA, Uuid.fromString(conversationId))
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
