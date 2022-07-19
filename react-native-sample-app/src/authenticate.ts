import { nablaClient } from './nablaClients';
import { delay } from './delay';
import { AuthTokens } from '@nabla/react-native-messaging-core';
// @ts-ignore
import { USER_ID, REFRESH_TOKEN, ACCESS_TOKEN } from 'react-native-dotenv';

export const authenticate = () => {
  nablaClient.authenticate(USER_ID, async () => {
    await delay(500);
    return new AuthTokens(REFRESH_TOKEN, ACCESS_TOKEN);
  });
};
