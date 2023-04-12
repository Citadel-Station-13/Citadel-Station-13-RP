import { BooleanLike } from "../../../common/react";
import { ModuleData, ModuleProps } from "../../backend";
import { Modular } from "../../layouts/Modular";

export interface RigModuleProps extends ModuleProps {

}

export interface RigModuleData extends ModuleData {
  bindable: BooleanLike;
}

export const RigModule = (props: RigModuleProps, context) => {
  return (
    <Modular>
      test
    </Modular>
  );
};
