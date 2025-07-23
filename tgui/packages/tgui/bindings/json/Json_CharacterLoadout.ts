/**
 * @file
 * @license MIT
 */

import { Game_LoadoutItem } from "../datum/Game_LoadoutItem";

export interface Json_CharacterLoadout {
  keyedItems: Record<string, Game_LoadoutItem>;
}
