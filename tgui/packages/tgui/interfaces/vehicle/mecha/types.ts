/**
 * @file
 * @license MIT
 */

import { VehicleData } from "../types";

export type VehicleModuleRef = string;

export interface MechaData extends VehicleData {
  mCompHullRef: VehicleModuleRef | null;
  mCompArmorRef: VehicleModuleRef | null;
}
