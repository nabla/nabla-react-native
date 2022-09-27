import { Logger } from './Logger';
import { NablaError } from '../types';

export class ConsoleLogger implements Logger {
  debug(tag: string, message: string, error: NablaError | undefined): void {
    formatAndLog(tag, message, error, console.debug);
  }

  info(tag: string, message: string, error: NablaError | undefined): void {
    formatAndLog(tag, message, error, console.info);
  }

  warn(tag: string, message: string, error: NablaError | undefined): void {
    formatAndLog(tag, message, error, console.warn);
  }

  error(tag: string, message: string, error: NablaError | undefined): void {
    formatAndLog(tag, message, error, console.error);
  }
}

function formatAndLog(
  tag: string,
  message: string,
  error: NablaError | undefined,
  logFunction: { (message?: any): void },
) {
  let log = `[${tag}] ${message}`;
  if (error) {
    const errorDescription = JSON.stringify(error, null, 2);
    log += `\nerror: ${errorDescription}`;
  }
  logFunction(log);
}
