/**
 * @file
 * @license MIT
 */

import { InfernoNode } from "inferno";
import { Section } from "../components";
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
