/**
 * @file
 * @license MIT
 */

import { Json_AssetPackBase } from ".";
import { DM_AtomSpawnFlags } from "../game";

export interface Json_WorldTypepaths extends Json_AssetPackBase {
  turfs: typepathDescriptorList;
  objs: typepathDescriptorList;
  mobs: typepathDescriptorList;
}

type typepathDescriptorList = typepathDescriptor[];
type typepathDescriptor = {
  name: string;
  path: string;
  iconRef: string;
  iconState: string;
  spawnFlags: DM_AtomSpawnFlags;
}
