/**
 * @file
 * @license MIT
 */

import { ByondAtomColor } from "tgui/interfaces/common/Color";

export interface Game_BodysetMarkingDescriptor {
  id: string;
  colors: ByondAtomColor[];
  // 0 to 255
  emissive: number;
  layer: number;
}
