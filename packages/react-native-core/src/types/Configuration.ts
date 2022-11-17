export class Configuration {
  constructor(apiKey: string, enableReporting: boolean = true) {
    this.apiKey = apiKey;
    this.enableReporting = enableReporting;
  }

  apiKey: string;
  enableReporting: boolean;
}
