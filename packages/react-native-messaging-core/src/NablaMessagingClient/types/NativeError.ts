export interface NativeError {
  code: number;
  message: string;
  extra?: Map<string, any>;
}
