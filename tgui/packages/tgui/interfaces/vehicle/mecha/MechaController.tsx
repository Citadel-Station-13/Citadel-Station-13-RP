/**
 * @file
 * @license MIT
 */

import { Section } from "tgui-core/components";

import { Window } from "../../../layouts";

export const MechaController = (props) => {
  return (
    <Window width={800} height={500}>
      <Window.Content>
        <Section>
          Test
        </Section>
      </Window.Content>
    </Window>
  );
};
