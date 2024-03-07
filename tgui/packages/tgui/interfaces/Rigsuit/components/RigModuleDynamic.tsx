import { BooleanLike } from "common/react";
import { RigModuleData } from "../RigModule";

export interface RigModuleDynamicData extends RigModuleData {
  $tgui: 'dynamic';
}

export type RigModuleDynamicSchema = (
  RigModuleDynamicSchemaAction |
  RigModuleDynamicSchemaActionSection
)[];

export type RigModuleDynamicSchemaBase = {
  id: string;
}
export type RigModuleDynamicSchemaAction = RigModuleDynamicSchemaBase & {
  type: "action";
  name: string;
  icon: string | null | undefined;
  confirm: BooleanLike;
  bindable: BooleanLike;
  confirmText: string | null | undefined;
  confirmIcon: string | null | undefined;
}

export type RigModuleDynamicSchemaActionSection = {
  type: "section";
  actions: RigModuleDynamicSchemaAction[]
};

export type RigModuleDynamicConfig = (
  RigModuleDynamicConfigNumber |
  RigModuleDynamicConfigString |
  RigModuleDynamicConfigToggle
)[];

export type RigModuleDynamicConfigBase = {
  name: string;
  key: string;
}
export type RigModuleDynamicConfigToggle = RigModuleDynamicConfigBase & {
  type: "toggle";
};
export type RigModuleDynamicConfigNumber = RigModuleDynamicConfigBase & {
  type: "number";
  min: number;
  max: number;
  round: number | null | undefined;
};
export type RigModuleDynamicConfigString = RigModuleDynamicConfigBase & {
  type: "string";
  maxLength: number;
  alphanumeric: BooleanLike;
}

export const RigModuleDynamic = (props, context) => {

};
