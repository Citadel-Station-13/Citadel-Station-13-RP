/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react"
import { ResleevingMirrorData } from "../common/Resleeving"
import { Window } from "../../layouts";
import { Section } from "tgui-core/components";
import { useBackend } from "../../backend";

interface MirrortoolContext {
  mirror: ResleevingMirrorData;
};

export const Mirrortool = (props) => {
  const {act, data} = useBackend<MirrortoolContext>();
  return (
    <Window title="Mirror Tool">
      <Window.Content>
        <Section title="Mirror">
          test
        </Section>
      </Window.Content>
    </Window>
  )
}
