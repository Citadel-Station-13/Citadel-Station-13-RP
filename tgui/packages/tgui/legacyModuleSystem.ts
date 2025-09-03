import { useContext } from "react";

import { useBackend } from "./backend";
import { LegacyModuleContext } from "./components/LegacyModule";

export interface ModuleData {
  "$tgui": string,
  "$ref": string,
}

/**
 * welcome to my shame
 * stop using this function
 * we're replacing this.
 */
export const useLegacyModule = <T extends ModuleData>(): {
  act: (action: string, params?: {}) => void,
  data: T,
  moduleID: string | null;
} => {
  let { act, data, nestedData } = useBackend();

  const { isModule, moduleId } = useContext(LegacyModuleContext);

  return {
    data: isModule ? nestedData?.[moduleId as string] || {} : data,
    moduleID: moduleId,
    act: isModule ? (action, params) => act(action, params, moduleId) : (action, params) => act(action, params),
  };
};
