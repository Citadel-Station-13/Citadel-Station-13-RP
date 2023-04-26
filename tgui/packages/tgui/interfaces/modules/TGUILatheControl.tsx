import { BooleanLike } from "common/react";
import { ModuleData, useModule } from "../../backend";
import { Modular } from "../../layouts/Modular";
import { Design } from "../common/Design";
import { IngredientsAvailable } from "../common/Ingredients";
import { MaterialsContext } from "../common/Materials";
import { ReagentContentsData } from "../common/Reagents";

interface TGUILatheControlProps {

}

interface TGUILatheControlData extends ModuleData {
  designs: Record<string, Design>;
  queueActive: BooleanLike;
  queue: Array<LatheQueueEntry>;
  speedMultiplier: number;
  powerMultiplier: number;
  efficiencyMultiplier: number;
  materials: Record<string, number>;
  materialsContext: MaterialsContext;
  reagents: ReagentContentsData;
  printing: string;
  ingredients: IngredientsAvailable;
}

export const TGUILatheControl = (props: TGUILatheControlProps, context) => {
  const { data, act } = useModule<TGUILatheControlData>(context);

  return (
    <Modular>
      test
    </Modular>
  );
};

interface LatheQueueEntry {
  design: string; // design id
  amount: number; // how many
  materials?: Record<string, string>; // key to id
  ingredients?: any[]; // dataset from Ingredients.tsx
}

interface LatheQueuedProps {
  entry: LatheQueueEntry
}

const LatheQueued = (props: LatheQueuedProps, context) => {
  return (
    <>
      test
    </>
  );
};

interface LatheDesignProps {
  design: Design;
  materialsContext: MaterialsContext;
  printButtonAct?: Function;
  printButtonText?: string;
}

const LatheDesign = (props: LatheDesignProps, context) => {

  return (
    <>
      test
    </>
  );
};
