/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { useBackend, useLocalState } from "../../backend";
import { Icon, NoticeBox, Section, Stack, Tabs } from "../../components";
import { Window } from "../../layouts";
import { RigActivationStatus, RigPieceID, RigPieceSealStatus, RigHardwareZoneSelection } from "./RigsuitCommon";
import { RigsuitConsoleData } from "./RigsuitConsole";

interface RigsuitMaintenanceData {
  console: RigsuitConsoleData;
  pieceIDs: RigPieceID[];
  activation: RigActivationStatus;
  panelLock: BooleanLike;
  panelOpen: BooleanLike;
  panelBroken: BooleanLike;
  panelIntegrityRatio: number;
  theme: string;
}

interface RigsuitMaintenancePiece {
  id: string;
  sealed: RigPieceSealStatus;
  deployed: BooleanLike;
}

export const RigsuitMaintenance = (props, context) => {
  const { act, data } = useBackend<RigsuitMaintenanceData>(context);
  const [moduleSection, setModuleSection] = useLocalState<string>(context, "rigsuitModuleTab", RigHardwareZoneSelection[0].key);
  let rendered: InfernoNode;
  if (!data.panelOpen && false) {
    rendered = (
      <Window.Content>
        Test
      </Window.Content>
    );
  }
  else {
    rendered = (
      <Window.Content>
        <Stack fill>
          <Stack.Item grow={1}>
            <Section title="Modules" fill>
              <Stack vertical fill>
                <Stack.Item>
                  <Tabs fluid>
                    {RigHardwareZoneSelection.map((zone) => (
                      <Tabs.Tab onClick={() => setModuleSection(zone.key)}
                        selected={moduleSection === zone.key} key={zone.key}>
                        <Icon name={zone.icon} size={2.5} />
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Stack.Item>
                <Stack.Item grow={1}>
                  <NoticeBox warning>OS-WIP-FRAGMENT-7</NoticeBox>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Stack vertical fill>
              <Stack.Item>
                <Section title="Console" fill>
                  test
                </Section>
              </Stack.Item>
              <Stack.Item>
                <Section title="Controller">
                  test
                </Section>
              </Stack.Item>
              <Stack.Item grow={1}>
                <Section title="Pieces" fill>
                  test
                </Section>
              </Stack.Item>
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    );
  }
  return (
    <Window title={`${data.theme} controller internals`} width={600} height={800}>
      {rendered}
    </Window>
  );
};
