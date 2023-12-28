/**
 * @file
 * @license MIT
 */

import { InfernoNode } from "inferno";
import { useBackend, useLocalState } from "../../backend";
import { Section, Stack } from "../../components";
import { Window } from "../../layouts";
import { RigAuthorization } from "./RigsuitPermissions";
import { RigController, RigsuitControllerData } from "./RigsuitController";
import { RigMaintenance } from "./RigsuitMaintenance";


export const Rigsuit = (props, context) => {
  const { act, data } = useBackend<RigsuitControllerData>(context);
  const [screen, setScreen] = useLocalState<number>(context, 'screen', 1);

  let screenRendered: InfernoNode;

  switch (screen) {
    case 1:
      screenRendered = RigController({ rig: data }, context);
      break;
    case 2:
      screenRendered = RigAuthorization({ rig: data }, context);
      break;
    case 3:
      screenRendered = RigMaintenance({ rig: data }, context);
      break;
    default:
      screenRendered = (<Section fill>Error: No Screen Routed</Section>);
  }

  return (
    <Window width={450} height={800} title={`${data.theme} hardsuit controller`}>
      <Window.Content>
        <Stack fill vertical>
          {/* <Stack.Item>
            <Tabs>
              <Tabs.Tab selected={screen === 1} onClick={() => setScreen(1)}>Controller</Tabs.Tab>
              <Tabs.Tab selected={screen === 2} onClick={() => setScreen(2)}>Authorization</Tabs.Tab>
              <Tabs.Tab selected={screen === 3} onClick={() => setScreen(3)}>Maintenance</Tabs.Tab>
            </Tabs>
          </Stack.Item> */}
          <Stack.Item grow={1}>
            {screenRendered}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
