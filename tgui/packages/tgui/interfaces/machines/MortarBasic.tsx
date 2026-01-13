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
  targetX: number;
  targetY: number;
  adjustX: number;
  adjustY: number;
  ourX: number;
  ourY: number;
  adjustMax: number;
  kineVel: number;
  kineGrav: number;
}

export const MortarBasic = (props) => {
  const { act, data } = useBackend<MortarBasicData>();
  // target x
  const [gTX, sTX] = useState(data.targetX);
  // target y
  const [gTY, sTY] = useState(data.targetY);
  // adjust X
  const [gAX, sAX] = useState(data.adjustX);
  // adjust Y
  const [gAY, sAY] = useState(data.adjustY);

  return (
    <Window width={300} height={500}>
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
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              title="Target"
              fill
              buttons={
                <Button onClick={() => act('setTarget', { x: gTX, y: gTY })}>
                  Apply
                </Button>
              }
            >
              <LabeledList>
                <LabeledList.Item label="X">
                  <NumberInput
                    onChange={(v) => sTX(v)}
                    value={gTX}
                    step={1}
                    minValue={-10000}
                    maxValue={10000}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Y">
                  <NumberInput
                    onChange={(v) => sTY(v)}
                    value={gTY}
                    step={1}
                    minValue={-10000}
                    maxValue={10000}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section
              title="Adjustment"
              fill
              buttons={
                <Button onClick={() => act('setTarget', { x: gAX, y: gAY })}>
                  Apply
                </Button>
              }
            >
              <LabeledList>
                <LabeledList.Item label="X">
                  <NumberInput
                    onChange={(v) => sAX(v)}
                    value={gAX}
                    step={1}
                    minValue={-data.adjustMax}
                    maxValue={data.adjustMax}
                  />
                </LabeledList.Item>
                <LabeledList.Item label="Y">
                  <NumberInput
                    onChange={(v) => sAY(v)}
                    value={gAY}
                    step={1}
                    minValue={-data.adjustMax}
                    maxValue={data.adjustMax}
                  />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
