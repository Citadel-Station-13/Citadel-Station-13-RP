
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
 *
 * @file
 * @license MIT
 */

import { Component } from "inferno";
import { useBackend } from "../backend";
import { directlyRouteComponent } from "../routes";

export interface ModuleProps {
  id: string, // module id, this lets it autoload from context
}

export interface ModuleData {
  $tgui: string, // module interface
  $ref: string, // byond ref to self
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
    return (
      <Component />
    );
  }
}
