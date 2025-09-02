import { useContext } from "react";
import { useBackend } from "./backend"
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
  act: (action, params?) => void,
  data: T,
  moduleID: string | null;
} => {
  let { act, data, nestedData } = useBackend();

  const { isModule } = useContext(LegacyModuleContext)

  return {
    act: act,
    data: resolved,
  }
}

// export const useModule = <TData extends ModuleData>(context): ModuleBackend<TData> => {
//   let backend = useBackend<TData>(context);
//   if (!is_module) {
//     return { // not operating in module mode, just send normal backend
//       backend: backend,
//       data: backend.data,
//       act: backend.act,
//       moduleID: null,
//     };
//   }
//   let { modules } = backend;
//   return {
//     backend: backend,
//     data: (modules && modules[context.m_id]) || {},
//     act: constructModuleAct(context.m_id, context.m_ref),
//     moduleID: context.m_id,
//   };
// };

// export const constructModuleAct = (id: string, ref: string): actFunctionType => {
//   return (action: string, payload: object = {}) => {
//     let sent = {
//       ...payload,
//       "$m_id": id,
//       "$m_ref": ref,
//     };
//     // Validate that payload is an object
//     const isObject = typeof payload === 'object'
//       && payload !== null
//       && !Array.isArray(payload);
//     if (!isObject) {
//       logger.error(`Payload for module act() must be an object, got this:`, payload);
//       return;
//     }
//     Byond.sendMessage('mod/' + action, sent);
//   };
// };

// /**
//  * Extracts module data from context
//  */
// export const getModuleData = <TData>(context, id: string): TData => {
//   let backend = useBackend<TData>(context);
//   return backend.modules[id];
