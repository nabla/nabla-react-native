export class RemoteId {
  readonly type = 'Remote';
  readonly clientId: string | undefined;
  readonly remoteId: string;

  constructor(remoteId: string, clientId: string | undefined = undefined) {
    this.clientId = clientId;
    this.remoteId = remoteId;
  }
}

export class LocalId {
  readonly type = 'Local';
  readonly clientId: string;

  constructor(clientId: string) {
    this.clientId = clientId;
  }
}

export function getStableId(id: LocalId | RemoteId): string {
  switch (id.type) {
    case 'Remote':
      return id.remoteId;
    case 'Local':
      return id.clientId;
  }
}
