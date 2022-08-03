import {
  mapCoreError,
  NativeError,
} from '@nabla/react-native-core/lib/internal';
import { NablaError } from '@nabla/react-native-core';
import {
  CannotReadFileDataError,
  InvalidMessageError,
  MessageNotFoundError,
  MissingConversationIdError,
  ProviderMissingPermissionError,
  ProviderNotFoundError,
} from '../../types';

export const mapError: (error: NativeError) => NablaError = (error) => {
  const { code, message, extra } = error;
  switch (code) {
    case 20:
      return new InvalidMessageError(message, extra);
    case 21:
      return new MessageNotFoundError(message, extra);
    case 22:
      return new CannotReadFileDataError(message, extra);
    case 23:
      return new ProviderNotFoundError(message, extra);
    case 24:
      return new ProviderMissingPermissionError(message, extra);
    case 25:
      return new MissingConversationIdError(message, extra);
    default:
      return mapCoreError(error);
  }
};
