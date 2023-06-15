import { BooleanLike } from "common/react";
import { ModuleData, useModule } from "../../backend";
import { SectionProps } from "../../components/Section";
import { Modular } from "../../layouts/Modular";
import { WindowProps } from "../../layouts/Window";
import { Design } from "../common/Design";
import { IngredientsAvailable, IngredientsSelected } from "../common/Ingredients";
import { MaterialsContext } from "../common/Materials";
import { ReagentContentsData } from "../common/Reagents";

interface TGUILatheControlProps {

}

interface TGUILatheControlData extends ModuleData {
  designs: Record<string, Design>;
  queueActive: BooleanLike;
  queue: Array<LatheQueueEntry>;
  latheName: string;
  speedMultiplier: number;
  powerMultiplier: number;
  dynamicButtons: Record<string, "off" | "on" | "disabled" | null>;
  efficiencyMultiplier: number;
  materials: Record<string, number>;
  materialsContext: MaterialsContext;
  reagents: ReagentContentsData;
  printing: string;
  ingredients: IngredientsAvailable;
}

export const TGUILatheControl = (props: TGUILatheControlProps, context) => {
  const { data, act } = useModule<TGUILatheControlData>(context);

  const windowProps: WindowProps = {
    title: data.latheName,
  };

  const sectionProps: SectionProps = {
    title: `${data.latheName} Control`,
  };

  return (
    <Modular window={windowProps}>
      test
    </Modular>
  );
};

interface LatheQueueEntry {
  design: string; // design id
  amount: number; // how many
  materials?: Record<string, string>; // key to id
  ingredients?: IngredientsSelected; // dataset from Ingredients.tsx
}

interface LatheQueuedProps {
  entry: LatheQueueEntry;
  design: Design;
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
  printButtonAct?: (string, number) => void; // id,
  printButtonText?: string;
}

const LatheDesign = (props: LatheDesignProps, context) => {

  return (
    <>
      test
    </>
  );
};
