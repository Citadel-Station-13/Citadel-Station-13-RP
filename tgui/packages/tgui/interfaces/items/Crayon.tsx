/**
 * @file
 * @license MIT
 */
import { useState } from "react";
import { Box, Button, Dimmer, Flex, Icon, LabeledList, Modal, NumberInput, Section, Stack } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { useBackend } from "../../backend";
import { Sprite } from "../../components";
import { Window } from "../../layouts";
import { ByondColorString, ColorPicker } from "../common/Color";

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
  colorList: null | ByondColorString[];
  graffitiPickedIcon: string | null;
  graffitiPickedState: string | null;
  graffitiPickedAngle: number;
  graffitiPickedColor: ByondColorString;
}

const sizeKeyForCrayonDatapack = (pack: CrayonDatapack) => {
  return `${pack.width}x${pack.height}`;
};

export const Crayon = (props) => {
  const { data, act } = useBackend<CrayonUIData>();
  const [pickingColor, setPickingColor] = useState<boolean>(false);

  return (
    <Window width={500} height={800} title={data.canonicalName}>
      {pickingColor && (
        <Dimmer>
          <Modal>
            <Section title="Color" backgroundColor="transparent" buttons={
              <Button icon="times" onClick={() => setPickingColor(false)} />
            }>
              <ColorPicker
                currentColor={data.graffitiPickedColor}
                setColor={(what) => act('color', { color: what })} />
            </Section>
          </Modal>
        </Dimmer>
      )}
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item>
            <Section title="Basic">
              <LabeledList>
                {!!data.cappable && (
                  <LabeledList.Item label="Cap">
                    <Button content={data.capped ? "Capped" : "Uncapped"}
                      selected={!data.capped} onClick={() => act('cap')} />
                  </LabeledList.Item>
                )}
                {(data.anyColor || data.colorList) && (
                  <LabeledList.Item label="Color">
                    {data.anyColor ? (
                      <Stack>
                        <Stack.Item>
                          <Box style={{ position: "relative", top: "5px", marginTop: "-3px" }}
                            backgroundColor={data.graffitiPickedColor} width="13.5px" height="13.5px" />
                        </Stack.Item>
                        <Stack.Item>
                          <Button content="Change" onClick={() => setPickingColor(true)} />
                        </Stack.Item>
                      </Stack>
                    ) : (
                      <Stack>
                        {data.colorList?.map((color) => (
                          <Stack.Item key={color}>
                            <Button content={
                              <Box style={{ position: "relative", top: "5px", marginTop: "-3px" }}
                                backgroundColor={data.graffitiPickedColor} width="13.5px" height="13.5px" />
                            } onClick={() => act('color', { color: color })} />
                          </Stack.Item>
                        ))}
                      </Stack>
                    )}
                  </LabeledList.Item>
                )}
                <LabeledList.Item label="Angle">
                  <>
                    <Icon
                      mr={1}
                      size={1.2}
                      name="arrow-up"
                      rotation={
                        Math.round(data.graffitiPickedAngle)
                      } />
                    <NumberInput
                      value={data.graffitiPickedAngle}
                      unit="deg"
                      minValue={0}
                      maxValue={359}
                      step={1}
                      onChange={(val) => act('angle', { angle: val })} />
                  </>
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
