/**
 * @file
 * @license MIT
 */

import { VehicleData, VehicleModuleRef } from "../types";

export interface MechaData extends VehicleData {
  mCompHullRef: VehicleModuleRef | null;
  mCompArmorRef: VehicleModuleRef | null;
}
