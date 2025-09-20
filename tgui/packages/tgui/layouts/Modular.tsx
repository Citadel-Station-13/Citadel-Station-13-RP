/**
 * @file
 * @license MIT
 */

import { ReactNode, useContext } from "react";
import { Section } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { SectionProps } from "../components";
import { LegacyModuleContext } from "../components/LegacyModule";
import { Window, WindowProps } from "./Window";

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
export const Modular = (props: ModularProps) => {
  const { isModule, moduleSection } = useContext(LegacyModuleContext);
  let sectionProps = {
    ...props.section,
    ...moduleSection,
  };
  return (
    !isModule ? (
      <Window {...props.window}>
        {props.direct}
        <Window.Content scrollable={!!props.scrollable}>
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
