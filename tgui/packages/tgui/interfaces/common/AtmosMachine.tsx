import { BooleanLike } from "../../../common/react";

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

export const AtmosComponentControl = (props, context) => {

};
