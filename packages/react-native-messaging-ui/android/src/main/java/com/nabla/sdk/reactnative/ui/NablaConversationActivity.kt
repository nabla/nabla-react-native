package com.nabla.sdk.reactnative.ui

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.benasher44.uuid.Uuid
import com.nabla.sdk.messaging.core.domain.entity.toConversationId
import com.nabla.sdk.messaging.ui.scene.messages.ConversationFragment
import androidx.fragment.app.commit

class NablaConversationActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_nabla_conversation)

        if (savedInstanceState == null) {
            val conversationId =
                (intent.getSerializableExtra(CONVERSATION_ID_EXTRA) as Uuid).toConversationId()
            val showComposer =
                (intent.getSerializableExtra(SHOW_COMPOSER_EXTRA) as Boolean)

            supportFragmentManager.commit {
                val conversationFragment = ConversationFragment.newInstance(conversationId) {
                    setShowComposer(showComposer)
                }

                add(R.id.fragmentContainer, conversationFragment, "tag")
            }
        }
    }

    companion object {
        const val CONVERSATION_ID_EXTRA = "conversationId"
        const val SHOW_COMPOSER_EXTRA = "showComposer"
    }
}