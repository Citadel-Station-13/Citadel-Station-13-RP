/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react";

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
  ref: VehicleComponentRef;
  tguiRoute: string;
  name: string;
  desc: string;
  integrity: number;
  integrityMax: number;
  integrityUsed: boolean;
  [rest: string]: any;
}

export interface VehicleModuleData {
  ref: VehicleModuleRef;
  tguiRoute: string;
  name: string;
  desc: string;
  integrity: number;
  integrityMax: number;
  integrityUsed: boolean;
  potentiaActiveClickModule: BooleanLike;
  allowEject: BooleanLike;
  [rest: string]: any;
}
