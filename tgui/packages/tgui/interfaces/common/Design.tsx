/**
 * @file
 * @license MIT
 */
import { IngredientsNeeded } from "./Ingredients";

/**
 * The Design interface. This is a class to facilitate the definition of static functions.
 */
export interface Design {
  name: string;
  desc: string;
  categories: string[];
  subcategories: string[];
  materials: Record<string, number> | null;
  material_parts: Record<string, number> | null;
  material_constraints: Record<string, number> | null;
  autodetect_tags: Record<string, string> | null;
  reagents: Record<string, number> | null;
  ingredients: IngredientsNeeded | null;
  resultItem: DesignItem;
  id: string;
  work: number;
}

export interface DesignItem {
  name?: string;
  desc?: string;
  iconSheet?: string;
  iconPath?: string; // direct access if sheet not provided, if sheet provided we use the spritesheet
}

