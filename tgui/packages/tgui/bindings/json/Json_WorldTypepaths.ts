/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { Json_AssetPackBase } from ".";
import { DM_TurfSpawnFlags } from "../game";

export interface Json_WorldTypepaths extends Json_AssetPackBase {
  areas: Record<string, AreaDescriptor>;
  turfs: Record<string, TurfDescriptor>;
}

type TurfDescriptor = {
  name: string;
  path: string;
  iconRef: string;
  iconState: string;
  spawnFlags: DM_TurfSpawnFlags;
}

type AreaDescriptor = {
  name: string;
  path: string;
  unique: BooleanLike;
  special: BooleanLike;
}
