import { Platform } from 'react-native';
import {
  NablaClient,
  NablaMessagingClient,
  NetworkConfiguration,
} from '@nabla/react-native-messaging-core';
import { NablaMessagingUIClient } from '@nabla/react-native-messaging-ui';
// @ts-ignore
import { API_KEY, DOMAIN_IOS, DOMAIN_ANDROID } from 'react-native-dotenv';

export const nablaClient = NablaClient.getInstance();

const domain = Platform.OS === 'ios' ? DOMAIN_IOS : DOMAIN_ANDROID;
const apiKey = API_KEY;

nablaClient.initialize(
  apiKey,
  undefined !== domain
    ? new NetworkConfiguration('http', domain, '/', 8080)
    : undefined,
);

export const nablaMessagingClient = NablaMessagingClient.getInstance();
export const nablaMessagingUIClient = NablaMessagingUIClient.getInstance();
