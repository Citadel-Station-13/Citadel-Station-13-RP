import { ModuleData, useModule } from "../../backend";
import { Modular } from "../../layouts/Modular";


interface TelesciPadData extends ModuleData {

}

export const TelesciPad = (props, context) => {
  let {act, data} = useModule<TelesciPadData>(context);

  return (
    <Modular>
      Test
    </Modular>
  )
}
