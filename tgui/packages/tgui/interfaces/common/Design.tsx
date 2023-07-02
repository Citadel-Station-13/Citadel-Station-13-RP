import { IngredientsNeeded } from "./Ingredients";

export interface Design {
  name: string;
  desc: string;
  category: string;
  materials?: Record<string, number>;
  material_parts?: Record<string, number>;
  reagents?: Record<string, number>;
  ingredients?: IngredientsNeeded;
  resultItem: DesignItem;
  id: string;
}

export interface DesignItem {
  name?: string;
  desc?: string;
  iconSheet?: string;
  iconPath?: string; // direct access if sheet not provided, if sheet provided we use the spritesheet
}

