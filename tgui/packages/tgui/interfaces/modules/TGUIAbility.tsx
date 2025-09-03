/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react";

import { Modular } from "../../layouts/Modular";
import { ModuleData, useLegacyModule } from "../../legacyModuleSystem";

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

export const TGUIAbility = (props: TGUIAbilityProps) => {
  const { data, act } = useLegacyModule<TGUIAbilityData>();

  return (
    <Modular>
      Not Implemented
    </Modular>
  );
};
