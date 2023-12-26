/**
 * @file
 * @license MIT
 */

import { InfernoNode } from "inferno";
import { useBackend, useLocalState } from "../../backend";
import { Section, Stack, Tabs } from "../../components";
import { Window } from "../../layouts";
import { RigAuthorization } from "./RigsuitPermissions";
import { RigController } from "./RigsuitController";
import { RigMaintenance } from "./RigsuitMaintenance";

export enum RigControlFlags {
  None = 0,
  Movement = (1<<0),
  Hands = (1<<1),
  UseBinds = (1<<2),
  ModifyBinds = (1<<3),
  Activation = (1<<4),
  Pieces = (1<<5),
  Modules = (1<<6),
  ViewModules = (1<<7),
  ViewPieces = (1<<8),
  Permissions = (1<<9),
  Maintenance = (1<<10),
  Console = (1<<11),
}

export enum RigActivationStatus {
  Offline = (1<<0),
  Activating = (1<<1),
  Deactivating = (1<<2),
  Online = (1<<3),
}

export enum RigPieceSealStatus {
  Unsealed = (1<<0),
  Sealing = (1<<1),
  Unsealing = (1<<2),
  Sealed = (1<<3),
}

export enum RigPieceFlags {
  ApplyArmor = (1<<0),
  ApplyEnvironmentals = (1<<1),
}

export type RigPieceReference = string;
export type RigPieceReflist = RigPieceReference[];

export type RigModuleReference = string;
export type RigModuleReflist = RigModuleReference[];

export interface RigsuitData {
  controlFlags: RigControlFlags;
  pieceRefs: RigPieceReflist;
  moduleRefs: RigModuleReflist;
  theme: string;
}

export const Rigsuit = (props, context) => {
  const { act, data } = useBackend<RigsuitData>(context);
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
    <Window width={550} height={800} title={`${data.theme} hardsuit controller`}>
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
