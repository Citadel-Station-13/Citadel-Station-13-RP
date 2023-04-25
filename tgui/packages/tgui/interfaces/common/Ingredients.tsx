import { BooleanLike } from "common/react";
import { Section } from "../../components";

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
  ingredients: IngredientsAvailable;
  lazy: BooleanLike;
  title?: string;
}

export const IngredientsDisplay = (props: IngredientsDisplayProps, context) => {
  return (
    <Section title={props.title || "Ingredients"}>
      test
    </Section>
  );
};

interface IngredientsProps {
  need: IngredientsNeeded;
  available: IngredientsAvailable;
  selection: BooleanLike;
  selected?: IngredientsSelected;
  select: (number, string) => void; // called with (index, data).
}

export const Ingredients = (props: IngredientsProps, context) => {
  return (
    <Section>
      test
    </Section>
  );
};
