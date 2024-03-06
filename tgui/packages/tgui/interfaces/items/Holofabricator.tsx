
export interface HolofabricatorTemplate {

}

export interface HolofabricatorData {
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
}

export const Holofabricator = (props, context) => {

};
