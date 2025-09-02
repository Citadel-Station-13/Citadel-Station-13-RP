
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

import React, { Component, createContext, useContext } from "react";
import { SectionProps } from ".";
import { getComponentForRoute } from "../routes";
import { useBackend } from "../backend";

export const LegacyModuleContext = createContext<{
  isModule: boolean;
  moduleId: string | null;
  moduleRef: string | null;
  moduleTgui: string | null;
  moduleSection: SectionProps | null;
}>({
  isModule: false,
  moduleId: null,
  moduleRef: null,
  moduleTgui: null,
  moduleSection: null,
});

export interface ModuleProps {
  id: string;
  section?: SectionProps;
}

export class LegacyModule<T extends ModuleProps, S = {}> extends Component<T, S> {
  render() {
    const moduleData = useBackend().nestedData[this.props.id as string];
    const routedComponent: Component = getComponentForRoute(moduleData["$tgui"]);
    return (
      <LegacyModuleContext value={{
        isModule: true,
        moduleId: this.props.id,
      }}>
        {routedComponent.render()}
      </LegacyModuleContext>
    )
  }
}

// export class LegacyModule<T extends ModuleProps> extends Component<T, {}> {
//   getChildContext() {
//     let { id } = this.props;
//     let { nestedData } = useBackend();
//     let data = modules[id];
//     let ref = data['$src'];
//     let ui_name = data['$tgui'];
//     return {
//       ...this.context,
//       is_module: true,
//       m_section: this.props.section,
//       m_id: id,
//       m_ref: ref,
//       m_tgui: ui_name,
//     };
//   }

//   render() {
//     let { modules } = useBackend(this.context);
//     let { id } = this.props;
//     let ui_name = modules[id]['$tgui'];
//     const Component = directlyRouteComponent(ui_name);
//     return (
//       <Component tgui_module={ui_name} />
//     );
//   }
// }
