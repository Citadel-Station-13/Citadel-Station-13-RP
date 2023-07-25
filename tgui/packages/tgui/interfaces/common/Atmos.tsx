import { BooleanLike } from "../../../common/react";

/**
 * @file
 * @license MIT
 */
export type AtmosGasID = string;
export type AtmosGasGroups = AtmosGroupFlags;

export enum AtmosGasFlags {
  None = (0),
  Fuel = (1<<0),
  Oxidizer = (1<<1),
  Contaminent = (1<<2),
  FusionFuel = (1<<3),
  Unknown = (1<<4),
  Core = (1<<5),
  Filterable = (1<<6),
  Dangerous = (1<<7),
}

export enum AtmosGroupFlags {
  None = (0),
  Core = (1<<0),
  Other = (1<<1),
  Unknown = (1<<2),
  Reagents = (1<<3),
}

export const AtmosGroupFlagNames = [
  "Core",
  "Other",
  "Unknown",
  "Reagents",
];

interface BaseGasContext {
  coreGases: AtmosGasID[];
  groupNames: string[];
}

export interface GasContext extends BaseGasContext {
  gases: Record<AtmosGasID, AtmosGas>;
}

export interface FullGasContext extends BaseGasContext {
  gases: Record<AtmosGasID, FullAtmosGas>;
}

export interface AtmosGas {
  id: AtmosGasID;
  name: string;
  flags: AtmosGasFlags;
  groups: AtmosGasGroups;
  specificHeat: number;
  molarMass: number;
}

export interface FullAtmosGas extends AtmosGas {

}

export enum AtmosComponentUIFlags {
  None = 0,
  TogglePower = (1<<0),
  SetPowerLimit = (1<<1),
}

export interface AtmosComponentData {
  // component UI flags
  controlFlags: AtmosComponentUIFlags;
  // on?
  on: BooleanLike;
  // power limit in W
  powerSetting: number;
  // max power limit in W
  powerRating: number;
}

export interface AtmosComponentProps {
  // forbid injecting default acts for non-specified acts
  forbidDefaultActs?: boolean;
  // power toggle
  togglePowerAct?: () => void;
  // set target maximum power draw
  setPowerLimitAct?: (watts: number) => void;

}
