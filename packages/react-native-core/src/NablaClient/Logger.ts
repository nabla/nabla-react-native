import { NablaError } from '../types';

export interface Logger {
  debug(tag: string, message: string, error: NablaError | undefined): void;
  info(tag: string, message: string, error: NablaError | undefined): void;
  warn(tag: string, message: string, error: NablaError | undefined): void;
  error(tag: string, message: string, error: NablaError | undefined): void;
}
