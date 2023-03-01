export enum AccessRegions {
  None = 0,
  All = ~0,
  Security = (1<<0),
  Medbay = (1<<1),
  Research = (1<<2),
  Engineering = (1<<3),
  Command = (1<<4),
  General = (1<<5),
  Supply = (1<<6),
}

export enum AccessTypes {
  None = 0,
  All = ~0,
  Centcom = (1<<0),
  Station = (1<<1),
  Syndicate = (1<<2),
  Private = (1<<3),
}
