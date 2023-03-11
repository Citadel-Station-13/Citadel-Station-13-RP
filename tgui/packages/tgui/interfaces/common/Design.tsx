import { BooleanLike } from "common/react";

export interface Design {
  full_name: string;
  name: string;
  desc: string;
  materials: Record<string, number>;
  material_parts: Record<string, number>;
  reagents: Record<string, number>;
  resultItem: DesignItem;
  id: string;
}

export interface DesignItem {
  name?: string;
  desc?: string;
  iconSheet?: string;
  iconPath?: string; // direct access if sheet not provided, if sheet provided we use the spritesheet
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
