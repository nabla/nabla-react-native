export class AuthTokens {
  refreshToken: string;
  accessToken: string;

  public constructor(refreshToken: string, accessToken: string) {
    this.refreshToken = refreshToken;
    this.accessToken = accessToken;
  }
}
