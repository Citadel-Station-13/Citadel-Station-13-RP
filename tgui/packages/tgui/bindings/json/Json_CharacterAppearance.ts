/**
 * @file
 * @license MIT
 */

import { Game_Bodyset } from "../datum/Game_Bodyset";
import { Game_BodysetMarking } from "../datum/Game_BodysetMarking";
import { Game_SpriteAccessory } from "../datum/Game_SpriteAccessory";

export interface Json_CharacterAppearance {
  keyedSpriteAccessories: Record<string, Game_SpriteAccessory>;
  keyedBodysets: Record<string, Game_Bodyset>;
  keyedBodysetMarkings: Record<string, Game_BodysetMarking>;
}
