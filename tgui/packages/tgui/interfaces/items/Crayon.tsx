import { BooleanLike } from "common/react";
import { useBackend } from "../../backend";
import { Button, Flex, LabeledList, Section, Stack } from "../../components";
import { Sprite } from "../../components/Sprite";
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
  graffitiPickedIcon: string | null;
  graffitiPickedState: string | null;
  graffitiPickedAngle: number;
}

const sizeKeyForCrayonDatapack = (pack: CrayonDatapack) => {
  return `${pack.width}x${pack.height}`;
};

export const Crayon = (props, context) => {
  const { data, act } = useBackend<CrayonUIData>(context);

  return (
    <Window width={500} height={800} title={data.canonicalName}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Basic">
              <LabeledList>
                {data.cappable && (
                  <LabeledList.Item label="Cap">
                    <Button content={data.capped? "Capped" : "Uncapped"}
                      selected={!data.capped} onClick={() => act('cap')} />
                  </LabeledList.Item>
                )}
                <LabeledList.Item label="Color">
                  test
                </LabeledList.Item>
                <LabeledList.Item label="Angle">
                  Test
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Section title="Stencil" fill scrollable>
              <Flex direction="column">
                {data.datapacks.map((pack) => (
                  <Flex.Item key={pack.id}>
                    <Flex wrap>
                      {pack.states.sort((a, b) => a.localeCompare(b)).map((state) => (
                        <Flex.Item key={state}>
                          <Button selected={data.graffitiPickedState === state && data.graffitiPickedIcon === pack.id}
                            onClick={() => act('pick', { icon: pack.id, state: state })}
                            color="transparent">
                            <Sprite sheet="crayon-graffiti" sprite={state} prefix={pack.name}
                              sizeKey={sizeKeyForCrayonDatapack(pack)} key={state} />
                          </Button>
                        </Flex.Item>
                      ))}
                    </Flex>
                  </Flex.Item>
                ))}
              </Flex>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );

};
