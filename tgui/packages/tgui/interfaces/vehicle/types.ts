/**
 * @file
 * @license MIT
 */

import { ReactNode } from "react";

import { useBackend } from "../../backend";

export type VehicleModuleRef = string;
export type VehicleComponentRef = string;

export interface VehicleData {
  name: string;
  componentRefs: VehicleComponentRef[];
  moduleRefs: VehicleModuleRef[];
  integrity: number | null;
  integrityMax: number | null;
}

export interface VehicleComponentData {
  name: string;
  desc: string;
  integrity: number;
  integrityMax: number;
  integrityUsed: boolean;
  [rest: string]: any;
}

export interface VehicleModuleData {
  name: string;
  desc: string;
  integrity: number;
  integrityMax: number;
  integrityUsed: boolean;
  [rest: string]: any;
}

export function useVehicleComponent<D, T = ReactNode>(ref: VehicleModuleRef | null, func: (data: D | null) => T): T {
  let { nestedData } = useBackend();
  // TODO: better error handling
  if (ref === null) {
    return func(null);
  }
  return func(nestedData[ref] as D | null);
}
