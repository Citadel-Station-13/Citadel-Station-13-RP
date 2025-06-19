import { actFunctionType, logger, ModuleBackend, ModuleData, useBackend } from "../backend";


export const constructModuleAct = (id: string, ref: string): actFunctionType => {
  return (action: string, payload: object = {}) => {
    let sent = {
      ...payload,
      "$m_id": id,
      "$m_ref": ref,
    };
    // Validate that payload is an object
    const isObject = typeof payload === 'object'
      && payload !== null
      && !Array.isArray(payload);
    if (!isObject) {
      logger.error(`Payload for module act() must be an object, got this:`, payload);
      return;
    }
    Byond.sendMessage('mod/' + action, sent);
  };
};

/**
 * a hook for getting the module state
 *
 * id is not provided in returned object because it's in props.
 *
 * returns:
 * {
 *    backend - what useBackend usually sends; you usually don't want to use this.
 *    data - our module's data, got from their id
 *    act - a pre-bound module act function that works the same from the UI side
 *        whether or not we're in a module, or being used as a root UI
 * }
 *
 * todo: bind useLocalState, useSharedState properly *somehow*
 *       maybe with a useModuleLocal, useModuleShared?
 */

export const useModule = <TData extends ModuleData>(context): ModuleBackend<TData> => {
  const { is_module } = context;
  let backend = useBackend<TData>(context);
  if (!is_module) {
    return {
      backend: backend,
      data: backend.data,
      act: backend.act,
      moduleID: null,
    };
  }
  let { nestedData } = backend;
  return {
    backend: backend,
    data: (nestedData && nestedData[context.m_id]) || {},
    act: constructModuleAct(context.m_id, context.m_ref),
    moduleID: context.m_id,
  };
};

