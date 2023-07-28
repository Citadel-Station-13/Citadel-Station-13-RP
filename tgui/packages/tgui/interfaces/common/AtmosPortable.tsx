import { BooleanLike } from "../../../common/react";

export interface AtmosPortableData {
  // uses charge
  useCharge: BooleanLike;
  // cell maxcharge
  maxCharge: number;
  // cell charge
  charge: number;
}

interface AtmosPortableControlProps {
  // portable data
  data: AtmosPortableData;
  // toggle on/off act ; also determines if it's allowed to toggle
  toggleAct: () => void;
}

export const AtmosPortableControl = (props: AtmosPortableControlProps, context) => {

};
