/**
 * @file
 * @license MIT
 */

import { ByondColorString } from "tgui/interfaces/common/Color";

export interface Game_SpriteAccessoryDescriptor {
  id: string;
  // 0 to 255
  emissive: number;
  colors: ByondColorString[];
}
