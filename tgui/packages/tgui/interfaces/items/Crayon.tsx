import { BooleanLike } from "common/react";
import { useBackend } from "../../backend";
import { Section, Stack } from "../../components";
import { Window } from "../../layouts";
import { ByondAtomColor } from "../common/Color";

const CRAYON_SPRITESHEET_NAME = "crayon-graffiti";

interface CrayonDatapack {
  name: string;
  states: string[];
  width: number;
  height: number;
  id: string;
}

interface CrayonUIData {
  datapacks: CrayonDatapack[];
  canonicalName: string;
  capped: BooleanLike;
  cappable: BooleanLike;
  anyColor: BooleanLike;
  colorList: null | ByondAtomColor[];
  graffitiPickedItem: string | null;
  graffitiPickedState: string | null;
  graffitiPickedAngle: number;
}

const sizeKeyForCrayonDatapack = (pack: CrayonDatapack) => {
  return `${pack.width}x${pack.height}`;
};

export const Crayon = (props, context) => {
  const { data, act } = useBackend<CrayonUIData>(context);

  return (
    <Window width={800} height={800} title={data.canonicalName}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Basic">
              Test
            </Section>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Section title="Stencil" scrollable>
              Test
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );

};
