#!/bin/bash
set -euo pipefail

pushd ..
yarn install

pushd packages
rm -rf react-native-core/node_modules react-native-core/android/build
rm -rf react-native-messaging-core/node_modules react-native-messaging-core/android/build
rm -rf react-native-messaging-ui/node_modules react-native-messaging-ui/android/build

popd && popd
