import { BooleanLike } from "common/react";
import { ModuleData, useModule } from "../../backend";
import { Modular } from "../../layouts/Modular";
import { Design } from "../common/Design";
import { MaterialsContext } from "../common/Materials";

interface TGUILatheControlProps {

}

interface TGUILatheControlData extends ModuleData {
  designs: Record<string, Design>;
  queue_active: BooleanLike;
  queue: Array<LatheQueueEntry>;
  speed_multiplier: number;
  power_multiplier: number;
  efficiency_multiplier: number;
  materials: Record<string, number>;
  materials_context: MaterialsContext;
  reagents: Record<string, number>;
  printing: string;
}

export const TGUILatheControl = (props: TGUILatheControlProps, context) => {
  const { data, act } = useModule<TGUILatheControlData>(context);

  return (
    <Modular>
      test
    </Modular>
  );
};

interface LatheQueueEntryProps {
  design: string; // design id
  amount: number; // how many
  materials?: Record<string, string>; // key to id
  ingredients?: any[]; // dataset from Ingredients.tsx
}

const LatheQueueEntry = (props: LatheQueueEntryProps, context) => {
  return (
    <>
      test
    </>
  );
};





interface LatheDesignEntryProps {
  design: Design;
  materialsContext: MaterialsContext;
  printButtonAct?: Function;
  printButtonText?: string;
}

const LatheDesignEntry = (props: LatheDesignEntryProps, context) => {

  return (
    <>
      test
    </>
  );
};
