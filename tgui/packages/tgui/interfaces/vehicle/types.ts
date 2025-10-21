/**
 * @file
 * @license MIT
 */

export type VehicleModuleRef = string;

export interface VehicleData {
  name: string;
  componentRefs: VehicleComponentData[];
  moduleRefs: VehicleModuleRef[];
}

export interface VehicleComponentData {
  name: string;
  desc: string;
}

export interface VehicleModuleData {
  name: string;
  desc: string;
}
