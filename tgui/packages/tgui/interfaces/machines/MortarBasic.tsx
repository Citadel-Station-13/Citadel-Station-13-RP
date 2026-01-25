/* eslint-disable react/jsx-max-depth */
import { useState } from 'react';
import {
  Button,
  LabeledList,
  NumberInput,
  Section,
  Stack,
} from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Window } from '../../layouts';

interface MortarBasicData {
  targetX: number | null;
  targetY: number | null;
  adjustX: number | null;
  adjustY: number | null;
  ourX: number | null;
  ourY: number | null;
  adjustMax: number;
  maxDistance: number | null;
}

export const MortarBasic = (props) => {
  const { act, data } = useBackend<MortarBasicData>();
  // target x
  const [gTX, sTX] = useState(data.targetX || 0);
  // target y
  const [gTY, sTY] = useState(data.targetY || 0);
  // adjust X
  const [gAX, sAX] = useState(data.adjustX || 0);
  // adjust Y
  const [gAY, sAY] = useState(data.adjustY || 0);

  const inRange =
    Math.sqrt(
      Math.pow((data.ourX || 0) - (gTX + gAX), 2) +
        Math.pow((data.ourY || 0) - (gTY + gAY), 2),
    ) < (data.maxDistance || 0);

  return (
    <Window width={300} height={280} title="Mortar">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <Section title="Status">
              <LabeledList>
                <LabeledList.Item label="Mortar Pos X">
                  {data.ourX}
                </LabeledList.Item>
                <LabeledList.Item label="Mortar Pos Y">
                  {data.ourY}
                </LabeledList.Item>
                {data.maxDistance !== null && (
                  <LabeledList.Item
                    label="Maximum Range"
                    color={inRange ? undefined : 'red'}
                  >
                    {data.maxDistance}
                    {!inRange && ' (Exceeded)'}
                  </LabeledList.Item>
                )}
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Stack fill>
              <Stack.Item grow>
                <Section title="Target" fill>
                  <Stack vertical fill>
                    <Stack.Item grow>
                      <LabeledList>
                        <LabeledList.Item label={`X - ${data.targetX}`}>
                          <NumberInput
                            width="100%"
                            onChange={(v) => sTX(v)}
                            value={gTX}
                            step={1}
                            minValue={-10000}
                            maxValue={10000}
                          />
                        </LabeledList.Item>
                        <LabeledList.Item label={`Y - ${data.targetY}`}>
                          <NumberInput
                            width="100%"
                            onChange={(v) => sTY(v)}
                            value={gTY}
                            step={1}
                            minValue={-10000}
                            maxValue={10000}
                          />
                        </LabeledList.Item>
                      </LabeledList>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        fluid
                        textAlign="center"
                        onClick={() => act('setTarget', { x: gTX, y: gTY })}
                      >
                        Apply
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item grow>
                <Section title="Adjustment" fill>
                  <Stack vertical fill>
                    <Stack.Item grow>
                      <LabeledList>
                        <LabeledList.Item label={`X - ${data.adjustX}`}>
                          <NumberInput
                            width="100%"
                            onChange={(v) => sAX(v)}
                            value={gAX}
                            step={1}
                            minValue={-data.adjustMax}
                            maxValue={data.adjustMax}
                          />
                        </LabeledList.Item>
                        <LabeledList.Item label={`Y - ${data.adjustY}`}>
                          <NumberInput
                            width="100%"
                            onChange={(v) => sAY(v)}
                            value={gAY}
                            step={1}
                            minValue={-data.adjustMax}
                            maxValue={data.adjustMax}
                          />
                        </LabeledList.Item>
                      </LabeledList>
                    </Stack.Item>
                    <Stack.Item>
                      <Button
                        fluid
                        textAlign="center"
                        onClick={() => act('setAdjust', { x: gAX, y: gAY })}
                      >
                        Apply
                      </Button>
                    </Stack.Item>
                  </Stack>
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
