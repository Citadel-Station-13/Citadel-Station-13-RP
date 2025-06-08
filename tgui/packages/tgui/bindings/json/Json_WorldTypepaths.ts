/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { Json_AssetPackBase } from ".";
import { DM_TurfSpawnFlags } from "../game";

export interface Json_WorldTypepaths extends Json_AssetPackBase {
  areas: areaDescriptorList;
  turfs: turfDescriptorList;
}

type turfDescriptorList = turfDescriptor[];
type turfDescriptor = {
  name: string;
  path: string;
  iconRef: string;
  iconState: string;
  spawnFlags: DM_TurfSpawnFlags;
}

type areaDescriptorList = areaDescriptor[];
type areaDescriptor = {
  name: string;
  path: string;
  unique: BooleanLike;
  special: BooleanLike;
}
