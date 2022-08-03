/**
 * Representation of a message to give to ``NablaMessagingClient.sendMessage``
 */
export interface MessageInput {
  serialize(): any;
}

export interface MediaMessageInput extends MessageInput {
  uri: string;
  filename: string;
}

/**
 * Input for a text message, containing only the text to send.
 */
export class TextMessageInput implements MessageInput {
  text: string;

  constructor(text: string) {
    this.text = text;
  }

  serialize(): any {
    return {
      type: 'text',
      value: this.text,
    };
  }
}

export enum ImageMimeType {
  jpeg = 'jpeg',
  png = 'png',
  heic = 'heic',
  heif = 'heif',
  other = 'other',
}

/**
 * Input for an image message, containing the image uri to send.
 */
export class ImageMessageInput implements MediaMessageInput {
  uri: string;
  filename: string;
  mimetype: ImageMimeType;

  constructor(uri: string, mimetype: ImageMimeType, filename: string) {
    this.uri = uri;
    this.filename = filename;
    this.mimetype = mimetype;
  }

  serialize(): any {
    return {
      type: 'image',
      value: {
        uri: this.uri,
        mimetype: this.mimetype,
        filename: this.filename,
      },
    };
  }
}

export enum VideoMimeType {
  mp4 = 'mp4',
  mov = 'mov',
  other = 'other',
}

/**
 * Input for a video message, containing the video uri to send.
 */
export class VideoMessageInput implements MediaMessageInput {
  uri: string;
  filename: string;
  mimetype: VideoMimeType;

  constructor(uri: string, mimetype: VideoMimeType, filename: string) {
    this.uri = uri;
    this.filename = filename;
    this.mimetype = mimetype;
  }

  serialize(): any {
    return {
      type: 'video',
      value: {
        uri: this.uri,
        mimetype: this.mimetype,
        filename: this.filename,
      },
    };
  }
}

export enum DocumentMimeType {
  pdf = 'pdf',
  other = 'other',
}

/**
 * Input for a document message, containing the document uri to send.
 */
export class DocumentMessageInput implements MediaMessageInput {
  uri: string;
  filename: string;
  mimetype: DocumentMimeType;

  constructor(uri: string, mimetype: DocumentMimeType, filename: string) {
    this.uri = uri;
    this.filename = filename;
    this.mimetype = mimetype;
  }

  serialize(): any {
    return {
      type: 'document',
      value: {
        uri: this.uri,
        mimetype: this.mimetype,
        filename: this.filename,
      },
    };
  }
}

export enum AudioMimeType {
  mpeg = 'mpeg',
  other = 'other',
}

/**
 * Input for an audio message, containing the audio uri to send.
 */
export class AudioMessageInput implements MediaMessageInput {
  uri: string;
  filename: string;
  mimetype: AudioMimeType;
  estimatedDurationMs: number;

  constructor(
    uri: string,
    mimetype: AudioMimeType,
    estimatedDurationMs: number,
    filename: string,
  ) {
    this.uri = uri;
    this.filename = filename;
    this.mimetype = mimetype;
    this.estimatedDurationMs = estimatedDurationMs;
  }

  serialize(): any {
    return {
      type: 'audio',
      value: {
        uri: this.uri,
        mimetype: this.mimetype,
        filename: this.filename,
        estimatedDurationMs: this.estimatedDurationMs,
      },
    };
  }
}
