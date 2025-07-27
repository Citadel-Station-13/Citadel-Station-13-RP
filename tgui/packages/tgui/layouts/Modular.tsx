/**
 * @file
 * @license MIT
 */

import { ReactNode } from "react";
import { Window, WindowProps } from "./Window";
import { BooleanLike } from "tgui-core/react";
import { SectionProps } from "../components";
import { Section } from "tgui-core/components";

export interface ModularProps {
  readonly direct?: ReactNode;
  readonly children?: ReactNode;
  readonly window?: WindowProps;
  readonly section?: SectionProps;
  readonly scrollable?: BooleanLike;
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
export const Modular = (props: ModularProps: any) => {
  const { is_module, m_section } = context;
  let sectionProps = {
    ...props.section,
    ...m_section,
  };
  return (
    !is_module ? (
      <Window {...props.window}>
        {props.direct}
        <Window.Content scrollable={props.scrollable}>
          {props.children}
        </Window.Content>
      </Window>
    ) : (
      <Section
        {...props.section}
        {...sectionProps}>
        {props.direct}
        {props.children}
      </Section>
    )
  );
};
