import { NativeError } from '../../internal';
import { LogLevel } from '../../types';

export interface NativeLog {
  level: LogLevel;
  tag: string;
  message: string;
  error: NativeError | undefined;
}
