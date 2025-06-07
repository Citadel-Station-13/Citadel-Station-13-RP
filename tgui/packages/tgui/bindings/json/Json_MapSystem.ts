/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { Json_AssetPackBase } from ".";

export interface Json_MapSystem extends Json_AssetPackBase {
  keyedLevelTraits: Record<string, {
    id: string,
    desc: string,
    allowEdit: BooleanLike,
  }>;
  keyedLevelAttributes: Record<string, {
    id: string,
    desc: string,
    allowEdit: BooleanLike,
    numeric: BooleanLike,
  }>;
}
