import { BooleanLike } from "../../../common/react";
import { ModuleData, useModule } from "../../backend";
import { Modular } from "../../layouts/Modular";

interface TGUIAbilityProps {

}

enum TGUIAbilityInteraction {
  NONE = "none",
  TRIGGER = "trigger",
  TOGGLE = "toggle",
}

interface TGUIAbilityData extends ModuleData {
  interact_type: TGUIAbilityInteraction;
  name: string;
  desc: string;
  bound: BooleanLike;
  can_bind: BooleanLike;
}

export const TGUIAbility = (props: TGUIAbilityProps, context) => {
  const { data, act } = useModule<TGUIAbilityData>(context);

  return (
    <Modular>
      Not Implemented
    </Modular>
  );
};
