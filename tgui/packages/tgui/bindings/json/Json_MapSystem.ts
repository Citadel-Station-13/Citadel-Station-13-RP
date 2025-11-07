/**
 * @file
 * @license MIT
 */

import { Game_MapLevelAttribute } from "../game/Game_MapLevelAttribute";
import { Game_MapLevelTrait } from "../game/Game_MapLevelTrait";
import { Json_AssetPackBase } from ".";

export interface Json_MapSystem extends Json_AssetPackBase {
  keyedLevelTraits: Record<string, Game_MapLevelTrait>;
  keyedLevelAttributes: Record<string, Game_MapLevelAttribute>;
}
