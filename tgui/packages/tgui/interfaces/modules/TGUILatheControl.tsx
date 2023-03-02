import { ModuleData, useModule } from "../../backend";
import { Modular } from "../../layouts/Modular";

interface TGUILatheControlProps {

}

interface TGUILatheControlData extends ModuleData {

}

export const TGUILatheControl = (props: TGUILatheControlProps, context) => {
  const { data, act } = useModule<TGUILatheControlData>(context);

  return (
    <Modular>
      test
    </Modular>
  );
};
