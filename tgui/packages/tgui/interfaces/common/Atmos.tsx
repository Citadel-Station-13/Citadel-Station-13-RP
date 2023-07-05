export type AtmosGasID = string;
export type AtmosGasGroup = string;

export enum AtmosGasFlags {
  None = (0),
  Fuel = (1<<0),
  Oxidizer = (1<<1),
  Contaminent = (1<<2),
  FusionFuel = (1<<3),
  Unknown = (1<<4),
  Core = (1<<5),
  Listed = (1<<6),
  Dangerous = (1<<7),
}

interface BaseGasContext {
  coreGases: AtmosGasID[];
  groups: AtmosGasGroup[];
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
  groups: AtmosGasGroup[];
  specificHeat: number;
  molarMass: number;
}

export interface FullAtmosGas extends AtmosGas {

}
