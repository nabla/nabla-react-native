#!/bin/bash
set -euo pipefail

cd ../packages/react-native-messaging-core && yarn install

cd ../react-native-messaging-ui && yarn install

cd ../react-native-messaging-core && rm -rf node_modules android/build

cd ../react-native-messaging-ui && rm -rf node_modules android/build
