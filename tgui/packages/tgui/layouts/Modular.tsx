/**
 * @file
 * @license MIT
 */

import { InfernoNode } from "inferno";
import { actFunctionType, useBackend } from "../backend";
import { Section } from "../components";
import { ModuleData } from "../components/Module";
import { logger } from "../logging";
import { Window, WindowProps } from "./Window";

export interface ModularProps extends WindowProps{
  direct?: InfernoNode,
}

/**
 * A modular window.
 * Automatically becomes a Window or just renders directly
 * depending on if it's loaded directly, or included using a
 * <Module>.
 *
 * If not rendering directly, it will act like a <Box>.
 */
export const Modular = (props: ModularProps, context: any) => {
  return (
    props.tgui_root? (
      <Window {...props}>
        {props.direct}
        <Window.Content>
          {props.children}
        </Window.Content>
      </Window>
    ) : (
      <Section {...props}>
        {props.direct}
        {props.children}
      </Section>
    )
  );
};

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
  let backend = useBackend<TData>(context);
  let { modules } = backend;
  return {
    backend: backend,
    data: (modules && modules[context.m_id]) || {},
    act: constructModuleAct(context.m_id, context.m_ref),
  };
};

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
