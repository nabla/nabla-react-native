import { Response, RefreshingState } from '../../types';
import { NablaError } from '@nabla/react-native-core';
import { NativeError } from '@nabla/react-native-core/lib/internal';
import { mapError } from './errorMapper';

function mapRefreshingState(
  refreshingState: RefreshingState<NativeError>,
): RefreshingState<NablaError> {
  switch (refreshingState.type) {
    case 'Refreshing':
    case 'Refreshed':
      return refreshingState;
    case 'ErrorWhileRefreshing':
      return {
        type: refreshingState.type,
        error: mapError(refreshingState.error),
      };
  }
}

export function mapResponse<NativeT, T>(
  nativeResponse: Response<NativeT, NativeError>,
  transform: (native: NativeT) => T,
): Response<T, NablaError> {
  return {
    isDataFresh: nativeResponse.isDataFresh,
    refreshingState: mapRefreshingState(nativeResponse.refreshingState),
    data: transform(nativeResponse.data),
  };
}
