import { BooleanLike } from "common/react";

interface PreferenceEntryProps {
  schema: PreferenceEntrySchema;
  value: any;
  setValue: (v: any) => void;
}

export type PreferenceEntrySchema = 
  PreferenceNumberEntrySchema | 
  PreferenceStringEntrySchema | 
  PreferenceToggleEntrySchema | 
  PreferenceDropdownEntrySchema;

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

export const PreferenceEntry = (props: PreferenceEntryProps, context) => {
  
};
