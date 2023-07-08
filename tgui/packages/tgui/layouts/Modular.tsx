/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { Section } from "../components";
import { SectionProps } from "../components/Section";
import { Window, WindowProps } from "./Window";

export interface ModularProps {
  direct?: InfernoNode;
  children?: InfernoNode;
  window?: WindowProps;
  section?: SectionProps;
  scrollable?: BooleanLike;
}

/**
 * A modular window.
 * Automatically becomes a Window or just renders directly
 * depending on if it's loaded directly, or included using a
 * <Module>.
 *
 * If not rendering directly, it will act like a <Section>.
 *
 * todo: scrolling is broken when embedded. there's no workaround; tgui components and their CSS just can't handle
 *       proper scrolling behavior when made to auto-fill as opposed to fixed height.
 */
export const Modular = (props: ModularProps, context: any) => {
  const { is_module } = context;
  return (
    !is_module? (
      <Window {...props.window}>
        {props.direct}
        <Window.Content scrollable={props.scrollable}>
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
