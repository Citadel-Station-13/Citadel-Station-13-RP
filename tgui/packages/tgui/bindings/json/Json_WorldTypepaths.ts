/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react";

import { DM_TurfSpawnFlags } from "../game";
import { Json_AssetPackBase } from ".";

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
