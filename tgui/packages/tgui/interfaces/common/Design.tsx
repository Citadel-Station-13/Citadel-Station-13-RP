/**
 * @file
 * @license MIT
 */
import { IngredientsNeeded } from "./Ingredients";

/**
 * The Design interface. This is a class to facilitate the definition of static functions.
 */
export abstract class Design {
  name: string;
  desc: string;
  category: string;
  materials: Record<string, number> | null;
  material_parts: Record<string, number> | null;
  reagents: Record<string, number> | null;
  ingredients: IngredientsNeeded | null;
  resultItem: DesignItem;
  id: string;
}

export interface DesignItem {
  name?: string;
  desc?: string;
  iconSheet?: string;
  iconPath?: string; // direct access if sheet not provided, if sheet provided we use the spritesheet
}

