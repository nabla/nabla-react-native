package com.nabla.sdk.reactnative.messaging.ui.nablamessagingui

import android.app.Activity
import android.content.Intent
import android.util.SparseArray
import com.facebook.react.bridge.*
import com.nabla.sdk.core.annotation.NablaInternal
import com.nabla.sdk.core.domain.entity.InternalException.Companion.asNablaInternal
import com.nabla.sdk.reactnative.core.nablaclient.CoreLogger
import com.nabla.sdk.reactnative.messaging.core.models.toConversationId
import com.nabla.sdk.reactnative.messaging.core.models.toMap
import kotlin.random.Random

@OptIn(NablaInternal::class)
internal class NablaMessagingUIModule(
    private val reactContext: ReactApplicationContext,
) : ReactContextBaseJavaModule(reactContext), ActivityEventListener {
    override fun getName() = "NablaMessagingUIModule"

    private val resultCallbacks: SparseArray<Callback> = SparseArray()

    override fun initialize() {
        super.initialize()
        reactContext.addActivityEventListener(this)
    }

    override fun invalidate() {
        reactContext.removeActivityEventListener(this)
        super.invalidate()
    }

    @ReactMethod
    fun navigateToInbox(callback: Callback) {
        try {
            requireNotNull(currentActivity).let { currentActivity ->
                val requestCode = randomPositiveInt()
                resultCallbacks.put(requestCode, callback)
                currentActivity.startActivityForResult(Intent(currentActivity, NablaInboxActivity::class.java), requestCode)
            }
        } catch (e: Exception) {
            CoreLogger.warn("An error occurred while navigating to the InboxScreen", e)
            callback(e.asNablaInternal().toMap())
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
            requireNotNull(currentActivity).let { currentActivity ->
                val requestCode = randomPositiveInt()
                resultCallbacks.put(requestCode, callback)

                currentActivity.startActivityForResult(
                    Intent(currentActivity, NablaConversationActivity::class.java)
                        .apply {
                            putExtra(NablaConversationActivity.CONVERSATION_ID_EXTRA,
                                conversationId)
                            putExtra(NablaConversationActivity.SHOW_COMPOSER_EXTRA, showComposer)
                        },
                    requestCode,
                )
            }
        } catch (e: Exception) {
            CoreLogger.warn("An error occurred while navigating to the ConversationScreen", e)
            callback(e.asNablaInternal().toMap())
            return
        }
    }

    private fun randomPositiveInt(): Int = Random.nextInt(from = 0, until = Int.MAX_VALUE)

    override fun onActivityResult(
        activity: Activity,
        requestCode: Int,
        resultCode: Int,
        data: Intent?,
    ) {
        val callback = resultCallbacks.get(requestCode) ?: return

        resultCallbacks.remove(requestCode)
        callback.invoke(null)
    }

    override fun onNewIntent(intent: Intent?) {
        // No-op
    }
}
