import { BooleanLike } from "../../../common/react";
import { ModuleData, useModule } from "../../backend";
import { Modular } from "../../layouts/Modular";

interface TelesciScannerData extends ModuleData {
  powerSetting: number;
  powerMax: number;
  powerOn: BooleanLike;
}

export const TelesciScanner = (props, context) => {
  let {act, data} = useModule<TelesciScannerData>(context);

  return (
    <Modular>
      Test
    </Modular>
  )
}
