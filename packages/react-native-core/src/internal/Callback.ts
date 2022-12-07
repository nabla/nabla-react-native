import { NativeError } from './NativeError';

export type Callback<T> = (
  error: NativeError | undefined,
  result: T | undefined,
) => void;

export function mergeVoid<Error>(
  mapError: (error: NativeError) => Error,
  errorCallback: (error: Error) => void,
  successCallback: () => void,
): Callback<void> {
  return (error, result) => {
    if (error) {
      errorCallback(mapError(error));
    } else {
      successCallback();
    }
  };
}

export function merge<Success, Error>(
  mapError: (error: NativeError) => Error,
  errorCallback: (error: Error) => void,
  successCallback: (result: Success) => void,
): Callback<Success> {
  return (error, result) => {
    if (error) {
      errorCallback(mapError(error));
    } else if (result) {
      successCallback(result);
    }
  };
}
