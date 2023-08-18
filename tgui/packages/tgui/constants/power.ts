export enum PowerChannelBits {
  None = 0,
  Equip = (1<<0),
  Light = (1<<1),
  Envir = (1<<2),
}

export enum PowerChannels {
  Equip = 1,
  Light = 2,
  Envir = 3,w
}

export const PowerChannelsTotal = 3;

export enum PowerBalancingTiers {
  Low = 3,
  Medium = 2,
  High = 1,
}

export const PowerBalancingTierNames = [
  "High",
  "Medium",
  "Low",
]

export const PowerBalancingTiersTotal = 3;

export type<T> PowerChannelList<T> = [
  T, T, T,
];
