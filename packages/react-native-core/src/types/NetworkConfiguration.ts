export class NetworkConfiguration {
  scheme: string;
  domain: string;
  port?: number;
  path: string;

  constructor(scheme: string, domain: string, path: string, port?: number) {
    this.scheme = scheme;
    this.domain = domain;
    this.port = port;
    this.path = path;
  }
}
