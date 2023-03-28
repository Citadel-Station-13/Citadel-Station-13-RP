/**
 * @file
 * @license MIT
 */

import { InfernoNode } from "inferno";
import { Section } from "../components";
import { SectionProps } from "../components/Section";
import { Window, WindowProps } from "./Window";

export interface ModularProps {
  direct?: InfernoNode;
  children?: InfernoNode;
  window?: WindowProps;
  section?: SectionProps;
}

/**
 * A modular window.
 * Automatically becomes a Window or just renders directly
 * depending on if it's loaded directly, or included using a
 * <Module>.
 *
 * If not rendering directly, it will act like a <Section>.
 */
export const Modular = (props: ModularProps, context: any) => {
  const { is_module } = context;
  return (
    !is_module? (
      <Window {...props.window}>
        {props.direct}
        <Window.Content>
          {props.children}
        </Window.Content>
      </Window>
    ) : (
      <Section {...props.section}>
        {props.direct}
        {props.children}
      </Section>
    )
  );
};
