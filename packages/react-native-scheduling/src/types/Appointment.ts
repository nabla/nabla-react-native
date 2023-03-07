export type Location =
  | { type: 'Physical' }
  | { type: 'Remote' }
  | { type: 'Unknown' };

export type Provider = {
  id: string;
  prefix: string | undefined;
  firstName: string;
  lastName: string;
  title: string;
  avatarURL: string;
};

export type Price = {
  amount: number;
  currencyCode: string;
};

export type Appointment = {
  id: string;
  scheduledAt: string;
  provider: Provider;
  location: Location;
  price: Price | undefined;
};
