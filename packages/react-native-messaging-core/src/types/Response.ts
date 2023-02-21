export type RefreshingState<Error> =
  | { type: 'Refreshing' }
  | { type: 'Refreshed' }
  | { type: 'ErrorWhileRefreshing'; error: Error };

export type Response<Data, Error> = {
  isDataFresh: boolean;
  refreshingState: RefreshingState<Error>;
  data: Data;
};
