
// RIG data

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

// RIG Pieces

export enum RigPieceFlags {
  ApplyArmor = (1<<0),
  ApplyEnvironmentals = (1<<1),
}

export type RigPieceReference = string;
export type RigPieceReflist = RigPieceReference[];

export type RigPieceID = string;

// RIG Modules

export type RigModuleReference = string;
export type RigModuleReflist = RigModuleReference[];

export type RigModuleID = string;

export const RigModuleZoneSelection:
  {
    name: string;
    icon: string;
    key: string;
  }[] = [
    {
      name: "All",
      icon: "tg-s1-stack",
      key: "all",
    },
    {
      name: "Head",
      icon: "tg-s1-space-helmet",
      key: "head",
    },
    {
      name: "Torso",
      icon: "tg-s1-chestplate",
      key: "torso",
    },
    {
      name: "Arms",
      icon: "tg-s1-gloves",
      key: "arms",
    },
    {
      name: "Legs",
      icon: "tg-s1-boots",
      key: "legs",
    },
    {
      name: "Misc",
      icon: "tg-s1-cube",
      key: "misc",
    },
  ];

// RIG UI

export const RigHardwareZoneSelection:
  {
    name: string;
    icon: string;
    key: string;
  }[] = [
    {
      name: "Components",
      icon: "tg-s1-stack",
      key: "all",
    },
    {
      name: "Controller",
      icon: "tg-s1-cube",
      key: "misc",
    },
    {
      name: "Head",
      icon: "tg-s1-space-helmet",
      key: "head",
    },
    {
      name: "Torso",
      icon: "tg-s1-chestplate",
      key: "torso",
    },
    {
      name: "Left Arm",
      icon: "tg-s1-glove-left",
      key: "left",
    },
    {
      name: "Right Arm",
      icon: "tg-s1-glove-right",
      key: "right",
    },
    {
      name: "Legs",
      icon: "tg-s1-boots",
      key: "legs",
    },
  ];
