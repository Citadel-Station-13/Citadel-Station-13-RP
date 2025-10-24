/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react";

import { useVehicleModule } from "../helpers";
import { VehicleModuleData } from "../types";
import { ModuleBase } from "./ModuleBase";

interface LazyModuleData extends VehicleModuleData {
  uiSchema: LUiSchemaEntry[];
}

type LUiSchemaEntry = LUiSchemaEntryBase | LUiHtml | LUiSelect | LUiMultiselect | LUiButton;

type LUiSchemaEntryBase = {
  type: string;
};

type LUiHtml = LUiSchemaEntryBase & {
  type: "html";
  content: string;
}

type LUiButton = LUiSchemaEntryBase & {
  type: "button";
  key: string
  name: string;
  active: BooleanLike;
  disabled: BooleanLike;
  confirm: BooleanLike;
}

type LUiSelect = LUiSchemaEntryBase & {
  type: "select";
  key: string
  names: Record<string, "disabled" | unknown>;
  selected: string | null;
  confirm: BooleanLike;
}

type LUiMultiselect = LUiSchemaEntryBase & {
  type: "multiselect"
  key: string
  names: Record<string, "disabled" | "active" | unknown>;
  confirm: BooleanLike;
}

export const Lazy = () => {
  const { act, data } = useVehicleModule<LazyModuleData>();
  return (
    <ModuleBase>
      Test
    </ModuleBase>
  );
};
