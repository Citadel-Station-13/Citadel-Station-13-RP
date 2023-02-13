
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

import { Component } from "inferno"
import { directlyRouteComponent, getRoutedComponent } from "../../routes";

export interface TguiModuleProps {
  id: string, // module id, this lets it autoload from context
}

export class Module<T extends TguiModuleProps> extends Component<T, {}> {
  getChildContext() {
    let {id} = this.props;
    let ref = ;
    let data = ;
    let module = ;
    return {
      ...this.context,
      id: id,
      ref: ref,
      data: data,
      module: module,
      act: (action, payload) => {
        // todo: nope, need to generic it so we don't have to switch between this and useBackend.
      },
    }

  }

  render(props: TguiModuleProps, context) {
    let interface_id = context.module
    const Component = directlyRouteComponent(context.module);
    return <Component />;
  }
}

export const TguiModule = (props:)


export const sendModuleAct = <TData>(context: BackendState<TData>, action: string, payload: object = {}) => {
  // todo: dejank this shit
  const isObject = typeof payload === 'object'
    && payload !== null
    && !Array.isArray(payload);
  if (!isObject) {
    logger.error(`Payload for module act() must be an object, got instead: `, payload);
    return;
  }
  Byond.sendMessage('act/' + action, { ...payload, __module_ref: ref });
};

/**
 * Basically, grabs data & act for a module in a way that makes it work
 * whether or not it's standalone or embedded.
 */
export const useModule = <TData>(props: any, context: any) => {
  const { store } = context;
  let state = selectBackend(context);
  let config = selectConfig(context);
  return {
    ...state,
    act: prepareSendModuleAct(config, state),
  };
};
