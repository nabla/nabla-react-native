import { NativeError } from '@nabla/react-native-core/lib/internal';

export type Callback<T> = (
  error: NativeError | undefined,
  result: T | undefined,
) => void;
