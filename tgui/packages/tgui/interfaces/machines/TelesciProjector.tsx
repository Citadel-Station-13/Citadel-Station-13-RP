import { ModuleData, useModule } from "../../backend";
import { Modular } from "../../layouts/Modular";

interface TelesciProjectorData extends ModuleData {

}

export const TelesciProjector = (props, context) => {
  let {act, data} = useModule<TelesciProjectorData>(context);

  return (
    <Modular>
      Test
    </Modular>
  )
}
