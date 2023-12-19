import { BooleanLike } from "../../../common/react";
import { ModuleData, useModule } from "../../backend"
import { Modular } from "../../layouts/Modular";

interface TelesciCapacitorData extends ModuleData{
  stored: number;
  drawRate: number;
  drawMax: number;
  capacity: number;
  linkedProjector: BooleanLike;
}

export const TelesciCapactor = (props, context) => {
  let {act, data} = useModule<TelesciCapacitorData>(context);

  return (
    <Modular>
      Test
    </Modular>
  )
}
