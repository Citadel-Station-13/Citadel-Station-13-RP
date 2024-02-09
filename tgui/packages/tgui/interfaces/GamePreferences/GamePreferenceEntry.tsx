import { BooleanLike } from "common/react";

interface GamePreferenceEntryProps {
  schema: GamePreferenceEntrySchema;
  value: any;
  setValue: (v: any) => void;
}

export type GamePreferenceEntrySchema = 
  PreferenceNumberEntrySchema | 
  PreferenceStringEntrySchema | 
  PreferenceToggleEntrySchema | 
  PreferenceDropdownEntrySchema | 
  PreferenceSimpleColorEntrySchema;

interface PreferenceBaseEntrySchema {
  key: string;
  category: string;
  subcategory: string;
  name: string;
  desc: string;
  priority: number;
  defaultValue: any;
}

interface PreferenceNumberEntrySchema extends PreferenceBaseEntrySchema {
  type: "number";
  minValue: number | null;
  maxValue: number | null;
  roundTo: number | null;
  defaultValue: number;
}

interface PreferenceStringEntrySchema extends PreferenceBaseEntrySchema {
  type: "string";
  minLength: number;
  maxLength: number;
  defaultValue: string;
}

interface PreferenceToggleEntrySchema extends PreferenceBaseEntrySchema {
  type: "toggle";
  enabledName: string;
  disabledName: string;
  defaultValue: BooleanLike
}

interface PreferenceDropdownEntrySchema extends PreferenceBaseEntrySchema {
  type: "dropdown";
  options: string[];
  defaultValue: string;
}

interface PreferenceSimpleColorEntrySchema extends PreferenceBaseEntrySchema {
  type: "simpleColor";
}

export const GamePreferenceEntry = (props: GamePreferenceEntryProps, context) => {
  
};
