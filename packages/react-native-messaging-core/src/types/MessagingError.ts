import { NablaError } from '@nabla/react-native-core';

export class MessagingError extends NablaError {}

export class InvalidMessageError extends MessagingError {}
export class MessageNotFoundError extends MessagingError {}
export class CannotReadFileDataError extends MessagingError {}
export class ProviderNotFoundError extends MessagingError {}
export class ProviderMissingPermissionError extends MessagingError {}
export class MissingConversationIdError extends MessagingError {}
