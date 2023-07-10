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
  Unknown = (1<<1),
  Chemical = (1<<2),
  Other = (1<<3),
}

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
