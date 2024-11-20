/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";

export interface Json_MapSystem {
  keyedLevelTraits: Record<string, {
    id: string,
    desc: string,
    allowEdit: BooleanLike,
  }>;
  keyedLevelAttributes: Record<string, {
    id: string,
    desc: string,
    allowEdit: BooleanLike,
  }>;
}
