
/**
 * /datum/tgui_module stuff
 * Citadel in house
 * Suffer.
 *
 * Basically, how this works, is we inject the module's
 * id, ref, data, and act into context.
 *
 * id: The tgui's module id from props
 * module: The tgui module's interface name
 * ref: The tgui_module's datum ref
 * data: The module's data passed into data.modules
 * act: A pre-built act function that automatically routes to the right datum procs.
 *
 * You should use the provided act instead of the one from useBackend().
 * useBackend() still works fine to grab the overall non-module context.
 */

import { Component } from "inferno";
import { actFunctionType, useBackend } from "./backend";
import { logger } from "./logging";
import { directlyRouteComponent } from "./routes";

export interface ModuleProps {
  id: string, // module id, this lets it autoload from context
}

export interface ModuleData {
  $tgui: string, // module interface
  $ref: string, // byond ref to self
}

export interface ModuleBackend<TData> {
  ref: string | undefined, // ref to our module
  id: string | undefined, // our id if we're not in standalone mode
  data: TData, // our data
}

export class Module<T extends ModuleProps> extends Component<T, {}> {
  getChildContext() {
    let { id } = this.props;
    let { modules } = useBackend(this.context);
    let ref = modules[id].$ref;
    let data = modules[id];
    let ui_name = modules[id].$tgui;
    return {
      ...this.context,
      m_id: id,
      m_ref: ref,
      m_tgui: ui_name,
    };

  }

  render(props: ModuleProps, context) {
    let ui_name = context.m_tgui;
    const Component = directlyRouteComponent(ui_name);
    return <Component />;
  }
}

/**
 * a hook for getting the module state
 *
 * id is not provided in returned object because it's in props.
 *
 * returns:
 * {
 *    backend - what useBackend usually sends; you usually don't want to use this.
 *    data - our module's id
 *    act - a pre-bound module act function that works the same from the UI side
 *        whether or not we're in a module, or being used as a root UI
 * }
 */
export const useModule = <TData extends ModuleData>(context) => {
  let backend = useBackend(context);
  let { modules } = backend;
  return {
    backend = useBackend(context),
    data: (modules && modules[context.m_id]) || {},
    act: constructModuleAct(context.m_id, context.m_ref),
  };
};

/**
 * Basically, grabs data & act for a module in a way that makes it work
 * whether or not it's standalone or embedded.
 */
// export const useModule = <TData>(props: any, context: any) => {
//   const { store } = context;
//   let state = selectBackend(context);
//   return {
//     ...state,
//     act: prepareSendModuleAct(config, state),
//   };
// };


export const constructModuleAct = (id: string, ref: string): actFunctionType => {
  return (action: string, payload: object = {}) => {
    let sent = {
      ...payload,
      $m_id: id,
      $m_ref: ref,
    };
    // Validate that payload is an object
    const isObject = typeof payload === 'object'
      && payload !== null
      && !Array.isArray(payload);
    if (!isObject) {
      logger.error(`Payload for module act() must be an object, got this:`, payload);
      return;
    }
    Byond.sendMessage('mod/' + action, payload);
  };
};
