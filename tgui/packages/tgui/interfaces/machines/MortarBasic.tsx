import { useState } from "react";
import { Section, Stack } from "tgui-core/components";

import { useBackend } from "../../backend";
import { Window } from "../../layouts";

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
  const [gTX, sTX] = useState();
  // target y
  const [gTY, sTY] = useState();
  // adjust X
  const [gAX, sAX] = useState();
  // adjust Y
  const [gAY, sAY] = useState();

  return (
    <Window width={300} height={500}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow>
            <Section title="Target">
              Test
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section title="Adjustment">
              Test
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
