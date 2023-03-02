import { BooleanLike } from "common/react";

export interface Design {
  name: string;
  desc: string;
  materials: Record<string, number>;
  reagents: Record<string, number>;
  requiredItem: BooleanLike;
  requiredItemName?: string;
  requiredItemDesc?: string;
  requiredItemIconSheet?: string;
  requiredItemIconPath?: string; // direct access if sheet not provided, if sheet provided we use the spritesheet
  id: string;
}

export interface LatheDesignEntryProps {
  design: Design;
  minimal?: BooleanLike;
  printButtonAct?: Function;
  printButtonText?: string;
}

export const LatheDesignEntry = (props: LatheDesignEntryProps, context) => {

  return (
    <>
      test
    </>
  );
};
