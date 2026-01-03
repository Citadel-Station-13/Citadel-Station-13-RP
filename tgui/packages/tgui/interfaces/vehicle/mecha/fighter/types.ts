/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react";

import { MechaData } from "../types";

export interface FighterData extends MechaData {
  flightMode: BooleanLike;
}
