export enum RigControlFlags {
  None = 0,
  Movement = (1<<0),
  Hands = (1<<1),
  UseBinds = (1<<2),
  ModifyBinds = (1<<3),
  Activation = (1<<4),
  Pieces = (1<<5),
  Modules = (1<<6),
  ViewModules = (1<<7),
  ViewPieces = (1<<8),
  Permissions = (1<<9),
  Maintenance = (1<<10),
  Console = (1<<11),
}

export enum RigActivationStatus {
  Offline = (1<<0),
  Activating = (1<<1),
  Deactivating = (1<<2),
  Online = (1<<3),
}

export enum RigPieceSealStatus {
  Unsealed = (1<<0),
  Sealing = (1<<1),
  Unsealing = (1<<2),
  Sealed = (1<<3),
}

export enum RigPieceFlags {
  ApplyArmor = (1<<0),
  ApplyEnvironmentals = (1<<1),
}
