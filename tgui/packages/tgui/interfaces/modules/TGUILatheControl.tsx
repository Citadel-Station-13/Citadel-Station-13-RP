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

interface LatheQueueEntry {
  id: string;
  material_parts: Record<string, string>;
}

export const TGUILatheControl = (props: TGUILatheControlProps, context) => {
  const { data, act } = useModule<TGUILatheControlData>(context);

  return (
    <Modular>
      test
    </Modular>
  );
};
