package com.nabla.sdk.reactnative.messaging.ui.nablamessagingui

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.benasher44.uuid.Uuid
import com.nabla.sdk.messaging.core.domain.entity.toConversationId
import androidx.fragment.app.commit
import com.nabla.sdk.messaging.ui.scene.conversations.InboxFragment
import com.nabla.sdk.reactnative.messaging.ui.R

internal class NablaInboxActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_nabla_conversation)

        if (savedInstanceState == null) {
            supportFragmentManager.commit {
                val inboxFragment = InboxFragment()

                add(R.id.fragmentContainer, inboxFragment, "inboxFragmentTag")
            }
        }
    }
}
