
/**
 * /datum/tgui_module stuff
 * Citadel in house
 * Suffer.
 *
 * Basically, how this works, is we inject the module's
 * id, ref, data, and act into context, fetched with useModule().
 *
 * id: The tgui's module id from props; obviously must be unique
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
import { ModuleProps, useBackend } from "../backend";
import { directlyRouteComponent } from "../routes";

export class Module<T extends ModuleProps> extends Component<T, {}> {
  getChildContext() {
    let { id } = this.props;
    let { modules } = useBackend(this.context);
    let data = modules[id];
    let ref = data['$src'];
    let ui_name = data['$tgui'];
    return {
      ...this.context,
      is_module: true,
      m_id: id,
      m_ref: ref,
      m_tgui: ui_name,
    };
  }

  render() {
    let { modules } = useBackend(this.context);
    let { id } = this.props;
    let ui_name = modules[id]['$tgui'];
    const Component = directlyRouteComponent(ui_name);
    return (
      <Component tgui_module={ui_name} />
    );
  }
}
