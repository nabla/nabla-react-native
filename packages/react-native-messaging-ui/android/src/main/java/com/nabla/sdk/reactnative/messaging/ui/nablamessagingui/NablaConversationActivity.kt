package com.nabla.sdk.reactnative.messaging.ui.nablamessagingui

import android.content.Context
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import androidx.fragment.app.commit
import com.nabla.sdk.messaging.core.domain.entity.ConversationId
import com.nabla.sdk.messaging.ui.scene.messages.ConversationFragment
import com.nabla.sdk.reactnative.messaging.ui.R

internal class NablaConversationActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_nabla_conversation)

        if (savedInstanceState == null) {

            val conversationId = intent.getParcelableExtra<ConversationId>(CONVERSATION_ID_EXTRA)

            supportFragmentManager.commit {
                val conversationFragment = ConversationFragment.newInstance(conversationId!!)
                add(R.id.fragmentContainer, conversationFragment, "conversationFragmentTag")
            }
        }
    }

    companion object {
        private const val CONVERSATION_ID_EXTRA = "conversationId"

        fun newIntent(
            context: Context,
            conversationId: ConversationId
        ): Intent = Intent(context, NablaConversationActivity::class.java).apply {
            putExtra(CONVERSATION_ID_EXTRA, conversationId)
        }
    }
}
