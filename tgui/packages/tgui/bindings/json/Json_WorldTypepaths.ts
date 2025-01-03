/**
 * @file
 * @license MIT
 */

import { DM_AtomSpawnFlags } from "../types";

export interface Json_WorldTypepaths {
  turfs: typepathDescriptorList;
  objs: typepathDescriptorList;
  mobs: typepathDescriptorList;
}

type typepathDescriptorList = typepathDescriptor[];
type typepathDescriptor = {
  name: string;
  path: string;
  flags: DM_AtomSpawnFlags;
}
