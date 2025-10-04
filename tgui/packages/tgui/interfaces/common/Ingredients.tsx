/**
 * @file
 * @license MIT
 */

import { Section } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

type IngredientRef = string;
type IngredientPath = string;
type MaterialID = string;
type ReagentID = string

export interface IngredientsAvailable {
  materials: Record<MaterialID, number>; // id to sheets
  materialLookup: Record<MaterialID, string>; // id to name
  reagents: Record<ReagentID, number>; // id to units
  reagentLookup: Record<ReagentID, string>; // id to name
  stacks: Record<IngredientPath, number>; // type to amount
  stackLookup: Record<IngredientPath, string>; // name lookup
  items: IngredientItem[]; // structs
  massItems: Record<IngredientPath, number>; // type to amount
  massItemLookup: Record<IngredientPath, string>; // type to name
}

export interface IngredientItem {
  ref: IngredientRef;
  name: string;
  path: IngredientPath;
}

export type IngredientsNeeded = IngredientNeed[];

export type IngredientsSelected = any[];

export type IngredientType = "material" | "reagent" | "item" | "stack";

export interface IngredientNeed {
  type: IngredientType;
  amt: number;
  allow: any;
  name: string;
}

interface IngredientsDisplayProps {
  readonly ingredients: IngredientsAvailable;
  readonly lazy: BooleanLike;
  readonly title?: string;
  readonly vertical: boolean;
}

export const IngredientsDisplay = (props: IngredientsDisplayProps) => {
  // Just here to make ESlint not complain about unused variables
  let { ingredients, lazy, vertical } = props;
  // End
  return (
    <Section title={props.title || "Ingredients"}>
      Unimplemented
    </Section>
  );
};

interface IngredientsProps {
  readonly need: IngredientsNeeded;
  readonly available: IngredientsAvailable;
  readonly selection: BooleanLike;
  readonly selected?: IngredientsSelected;
  readonly vertical: boolean;
  readonly select: (number, string) => void; // called with (index, data).
}

export const Ingredients = (props: IngredientsProps) => {
  // Just here to make ESlint not complain about unused variables
  let { need, available, selection, selected, vertical, select } = props;
  // End
  return (
    <Section>
      Unimplemented
    </Section>
  );
};
