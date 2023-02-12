/**
 * contains root stuff for /datum/tgui_module
 *
 * @license MIT
 */

import { BackendConfig, BackendState, selectBackend } from "./backend"

export interface TguiModuleProps {
  ref: string, // src ref
  tgui: string, // tgui interface id
}

export const sendModuleAct(action: string, payload: object = {}) => {

}

/**
 * Sends an action to `ui_act` on `src_object` that this tgui window
 * is associated with.
 */
export const sendAct = (action: string, payload: object = {}) => {
  // Validate that payload is an object
  const isObject = typeof payload === 'object'
    && payload !== null
    && !Array.isArray(payload);
  if (!isObject) {
    logger.error(`Payload for act() must be an object, got this:`, payload);
    return;
  }
  Byond.sendMessage('act/' + action, payload);
};

export const useModule = <TData>(context: any) =>{
  const { store } = context;
  return {
    ...selectBackend(context),
    act: sendModuleAct,
  }
}
