/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react";

interface StargazerMindnetContext {
  abilities: Record<string, StargazerMindnetAbility>;
}

interface StargazerMindnetAbility {
  id: string;
  name: string;
  desc: string;
  attCoopThres: number;
  attForceThres: number;
  cooperateUnconscious: BooleanLike;
}
