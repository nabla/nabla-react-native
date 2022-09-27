package com.nabla.sdk.reactnative.messaging.ui.nablamessagingui

import android.content.Intent
import com.facebook.react.bridge.*
import com.nabla.sdk.core.annotation.NablaInternal
import com.nabla.sdk.reactnative.core.nablaclient.CoreLogger
import com.nabla.sdk.core.domain.entity.InternalException.Companion.asNablaInternal
import com.nabla.sdk.reactnative.messaging.core.models.toConversationId
import com.nabla.sdk.reactnative.messaging.core.models.toMap

@OptIn(NablaInternal::class)
class NablaMessagingUIModule(
    reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext) {
    override fun getName() = "NablaMessagingUIModule"

    @ReactMethod
    fun navigateToInbox() {
        try {
            requireNotNull(currentActivity).let {
                it.startActivity(Intent(it, NablaInboxActivity::class.java))
            }
        } catch (e: Exception) {
            CoreLogger.error("Missing currentActivity in `NablaMessagingUIModule`")
            return
        }
    }

    @ReactMethod
    fun navigateToConversation(
        conversationIdMap: ReadableMap,
        showComposer: Boolean,
        callback: Callback,
    ) {
        val conversationId = try {
            conversationIdMap.toConversationId()
        } catch (e: Exception) {
            callback(e.asNablaInternal().toMap())
            return
        }
        try {
            requireNotNull(currentActivity).let {
                it.startActivity(
                    Intent(it, NablaConversationActivity::class.java)
                        .apply {
                            putExtra(CONVERSATION_ID_EXTRA, conversationId)
                            putExtra(SHOW_COMPOSER_EXTRA, showComposer)
                        }
                )
            }
        } catch (e: Exception) {
            CoreLogger.warn("Missing currentActivity in `NablaMessagingUIModule`")
            callback(e.asNablaInternal().toMap())
            return
        }
        callback(null)
    }

    companion object {
        const val CONVERSATION_ID_EXTRA = "conversationId"
        const val SHOW_COMPOSER_EXTRA = "showComposer"
    }
}
