import { BooleanLike } from "common/react";
import { RigModuleData } from "../RigModule";

export interface RigModuleDynamicData extends RigModuleData {
  $tgui: 'dynamic';
  schema: RigModuleDynamicSchema;
}

interface RigModuleDynamicSchema {
  fragments: RigModuleDynamicFragment[];
  config: RigModuleDynamicConfig[];
}

type RigModuleDynamicFragment = (
  RigModuleDynamicFragmentAction |
  RigModuleDynamicFragmentActionSection
);

type RigModuleDynamicFragmentBase = {
  id: string;
}
type RigModuleDynamicFragmentAction = RigModuleDynamicFragmentBase & {
  type: "action";
  name: string;
  icon: string | null | undefined;
  confirm: BooleanLike;
  bindable: BooleanLike;
  confirmText: string | null | undefined;
  confirmIcon: string | null | undefined;
}

type RigModuleDynamicFragmentActionSection = {
  type: "section";
  actions: RigModuleDynamicFragmentAction[]
};

type RigModuleDynamicConfig = (
  RigModuleDynamicConfigNumber |
  RigModuleDynamicConfigString |
  RigModuleDynamicConfigToggle
);

type RigModuleDynamicConfigBase = {
  name: string;
  key: string;
}
type RigModuleDynamicConfigToggle = RigModuleDynamicConfigBase & {
  type: "toggle";
};
type RigModuleDynamicConfigNumber = RigModuleDynamicConfigBase & {
  type: "number";
  min: number;
  max: number;
  round: number | null | undefined;
};
type RigModuleDynamicConfigString = RigModuleDynamicConfigBase & {
  type: "string";
  maxLength: number;
  alphanumeric: BooleanLike;
}

export const RigModuleDynamic = (props, context) => {

};
