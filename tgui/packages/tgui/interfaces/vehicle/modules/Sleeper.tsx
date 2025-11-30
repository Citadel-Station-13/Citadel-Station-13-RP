/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react";

import { useVehicleModule } from "../helpers";
import { VehicleModuleData } from "../types";
import { ModuleBase } from "./ModuleBase";

interface SleeperModuleData extends VehicleModuleData {
  filteringStomach: BooleanLike;
  filteringBlood: BooleanLike;
  occupant: {
    damBrute: number;
    damBurn: number;
    damTox: number;
    damOxy: number;
    stat: "conscious" | "unconscious" | "dead";
    health: number;
    maxHealth: number;
    pulse: number;
  } | null;
}

export const Sleeper = () => {
  const { act, data } = useVehicleModule<SleeperModuleData>();
  return (
    <ModuleBase>
      Test
    </ModuleBase>
  );
};
