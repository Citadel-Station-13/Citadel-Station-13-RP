/**
 * @file
 * @license MIT
 */

import { VehicleModuleData } from "../types";
import { ModuleBase } from "./ModuleBase";

export const Trivial = (props: { data: VehicleModuleData }) => {
  return (
    <ModuleBase data={props.data} />
  );
};
