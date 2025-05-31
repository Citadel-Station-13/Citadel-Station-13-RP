import { BooleanLike } from "common/react";
import { MaterialsContext } from "../common/Materials";

export interface HolofabricatorTemplate {
  // name
  name: string;
  // category name
  category: string;
  // priority in list
  priority: number;
  // list of material keys a user can pick materials for
  materialParts: string[];
  // todo
  patterns: any;
  // todo
  options: any;
}

export interface HolofabricatorPattern {
  id: string;
  name: string;
}

export interface HolofabricatorData {
  // material context
  materialContext: MaterialsContext;
  // only specified if we run off battery
  batteryCapacity: null | number;
  // only specified if we run off battery
  batteryCharge: null | number;
  // string
  selectedTemplateID: string;
  // k-v key-material id
  selectedMaterialIDs: Record<string, string>;
  // k-v key-arbitrary
  selectedOptions: Record<string, any>;
  // k-v id-template struct
  templates: Record<string, HolofabricatorTemplate>;
  // in deconstruction mode
  deconstructionMode: BooleanLike;
}

export const Holofabricator = (props, context) => {

};
