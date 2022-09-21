package com.nabla.sdk.reactnative.messaging.core.models

import com.facebook.react.bridge.ReadableMap
import com.nabla.sdk.core.domain.entity.MimeType
import com.nabla.sdk.core.domain.entity.Uri
import com.nabla.sdk.messaging.core.domain.entity.FileLocal
import com.nabla.sdk.messaging.core.domain.entity.FileSource
import com.nabla.sdk.messaging.core.domain.entity.MessageInput

internal fun ReadableMap.messageInputOrThrow(): MessageInput {
    val messageType = getString("type") ?: kotlin.run {
        throw IllegalStateException("Missing type of message")
    }

    return when (messageType) {
        "text" -> textMessageInputOrThrow()
        "image" -> imageMessageInputOrThrow()
        "video" -> videoMessageInputOrThrow()
        "document" -> documentMessageInputOrThrow()
        "audio" -> audioMessageInputOrThrow()
        else -> throw IllegalStateException("Unknown message type: $messageType")
    }
}

private fun ReadableMap.textMessageInputOrThrow(): MessageInput.Text {
    val text = getString("value") ?: throw IllegalStateException("Missing text value")

    return MessageInput.Text(text)
}

private fun ReadableMap.imageMessageInputOrThrow(): MessageInput.Media.Image {
    val valueMap = getMap("value") ?: throw IllegalStateException("Missing image value")

    val uri = valueMap.getString("uri") ?: throw IllegalStateException("Missing image uri")

    val mimeTypeString =
        valueMap.getString("mimetype") ?: throw IllegalStateException("Missing image mimetype")

    val mimetype = when (mimeTypeString) {
        "jpeg" -> MimeType.Image.Jpeg
        "png" -> MimeType.Image.Png
        else -> MimeType.Image.Other(mimeTypeString)
    }

    val filename =
        valueMap.getString("filename") ?: throw IllegalStateException("Missing image filename")

    return MessageInput.Media.Image(FileSource.Local(FileLocal.Image(Uri(uri), filename, mimetype)))
}

private fun ReadableMap.videoMessageInputOrThrow(): MessageInput.Media.Video {
    val valueMap = getMap("value") ?: throw IllegalStateException("Missing video value")

    val uri = valueMap.getString("uri") ?: throw IllegalStateException("Missing video uri")

    val mimeTypeString =
        valueMap.getString("mimetype") ?: throw IllegalStateException("Missing video mimetype")

    val mimetype = when (mimeTypeString) {
        "mp4" -> MimeType.Video.Mp4
        else -> MimeType.Video.Other(mimeTypeString)
    }

    val filename =
        valueMap.getString("filename") ?: throw IllegalStateException("Missing video filename")

    return MessageInput.Media.Video(FileSource.Local(FileLocal.Video(Uri(uri), filename, mimetype)))
}

private fun ReadableMap.documentMessageInputOrThrow(): MessageInput.Media.Document {
    val valueMap = getMap("value") ?: throw IllegalStateException("Missing document value")

    val uri = valueMap.getString("uri") ?: throw IllegalStateException("Missing document uri")

    val mimeTypeString =
        valueMap.getString("mimetype") ?: throw IllegalStateException("Missing document mimetype")

    val mimetype = when (mimeTypeString) {
        "pdf" -> MimeType.Application.Pdf
        else -> MimeType.Application.Other(mimeTypeString)
    }

    val filename =
        valueMap.getString("filename") ?: throw IllegalStateException("Missing document filename")

    return MessageInput.Media.Document(FileSource.Local(FileLocal.Document(Uri(uri),
        filename,
        mimetype)))
}

private fun ReadableMap.audioMessageInputOrThrow(): MessageInput.Media.Audio {
    val valueMap = getMap("value") ?: throw IllegalStateException("Missing audio value")

    val uri = valueMap.getString("uri") ?: throw IllegalStateException("Missing audio uri")

    val mimeTypeString =
        valueMap.getString("mimetype") ?: throw IllegalStateException("Missing audio mimetype")

    val mimetype = when (mimeTypeString) {
        "mp3" -> MimeType.Audio.Mp3
        else -> MimeType.Audio.Other(mimeTypeString)
    }

    val filename =
        valueMap.getString("filename") ?: throw IllegalStateException("Missing audio filename")

    val durationMs = valueMap.getInt("estimatedDurationMs")

    return MessageInput.Media.Audio(FileSource.Local(FileLocal.Audio(Uri(uri),
        filename,
        mimetype,
        durationMs.toLong())))
}
