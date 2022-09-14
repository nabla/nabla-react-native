package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.LivekitRoomStatus
import com.nabla.sdk.messaging.core.domain.entity.*

@JvmName("toConversationItemMapArray")
internal fun List<ConversationItem>.toMapArray(): ReadableArray {
    return Arguments.createArray().apply {
        forEach { item ->
            pushMap(item.toMap())
        }
    }
}

private fun ConversationItem.toMap(): ReadableMap {
    return Arguments.createMap().also {
        it.putString("createdAt", createdAt.toString())
        when (this) {
            is ConversationActivity -> {
                it.putString("type", "ConversationActivity")
                it.putString("id", id.value.toString())
                it.putMap("activity", content.toMap())
            }
            is Message.LivekitRoom -> {
                id.remoteId?.let { id -> it.putString("id", id.toString()) }
                it.putString("type", "VideoCallActionRequest")
                it.putMap("sender", author.toMap())
                it.putMap("videoCallActionRequest", Arguments.createMap().also { videoCallActionRequestMap ->
                when (livekitRoom.status) {
                    LivekitRoomStatus.Closed -> {
                        videoCallActionRequestMap.putString("status", "closed")
                    }
                    is LivekitRoomStatus.Open -> {
                        videoCallActionRequestMap.putString("status", "open")
                        videoCallActionRequestMap.putMap("room", Arguments.createMap().also { roomMap ->
                            roomMap.putString("id", livekitRoom.id.toString())
                            roomMap.putString("token", (livekitRoom.status as LivekitRoomStatus.Open).token)
                            roomMap.putString("url", (livekitRoom.status as LivekitRoomStatus.Open).url)
                        })
                    }
                }
                })
            }
            is Message -> {
                it.putString("type", "ConversationMessage")
                it.putMap("id", id.toMap())
                it.putMap("sender", author.toMap())
                it.putString("sendingState", sendStatus.toMapValue())
                replyTo?.let { replyTo -> it.putMap("replyTo", replyTo.toMap()) }
                it.putMap("content", Arguments.createMap().also { contentMap ->
                    when (this) {
                        is Message.Deleted ->
                            contentMap.putString("type", "DeletedMessageItem")
                        is Message.Text -> {
                            contentMap.putString("type", "TextMessageItem")
                            contentMap.putString("text", text)
                        }
                        is Message.Media<*, *> -> {
                            val mediaMap = Arguments.createMap()
                            mediaMap.putString("fileName", fileName)
                            mediaMap.putString("fileURL", stableUri.toString())
                            mediaMap.putString("mimeType", mimeType.stringRepresentation)
                            when (this) {
                                is Message.Media.Image -> {
                                    contentMap.putString("type", "ImageMessageItem")
                                    contentMap.putMap("image", mediaMap)
                                }
                                is Message.Media.Video -> {
                                    contentMap.putString("type", "VideoMessageItem")
                                    contentMap.putMap("video", mediaMap)
                                }
                                is Message.Media.Document -> {
                                    contentMap.putString("type", "DocumentMessageItem")
                                    mediaMap.putString("thumbnailURL", thumbnailUri.toString())
                                    contentMap.putMap("document", mediaMap)
                                }
                                is Message.Media.Audio -> {
                                    contentMap.putString("type", "AudioMessageItem")
                                    durationMs?.toDouble()?.let { durationMs ->
                                        mediaMap.putDouble("durationMs", durationMs)
                                    }
                                    contentMap.putMap("audio", mediaMap)
                                }
                            }
                        }
                    }
                })
            }
        }
    }
}

private fun ConversationActivityContent.toMap(): ReadableMap {
    return Arguments.createMap().also {
        when (this) {
            is ConversationActivityContent.ProviderJoinedConversation -> {
                it.putString("type", "ProviderJoined")
                it.putMap("maybeProvider", maybeProvider.toMap())
            }
        }
    }
}
