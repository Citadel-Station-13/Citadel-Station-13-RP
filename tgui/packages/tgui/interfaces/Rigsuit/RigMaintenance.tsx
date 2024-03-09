/**
 * This is a top level UI.
 *
 * todo: why is this a top level UI? why not embedded? huh?? huh??
 *
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { useBackend, useLocalState } from "../../backend";
import { Icon, NoticeBox, Section, Stack, Tabs, Tooltip } from "../../components";
import { Window } from "../../layouts";
import { RigActivationStatus, RigPieceID, RigPieceSealStatus, RigHardwareZoneSelection } from "./common";
import { RigConsole, RigConsoleData } from "./RigConsole";

interface RigMaintenanceData {
  console: RigConsoleData;
  pieceIDs: RigPieceID[];
  activation: RigActivationStatus;
  panelLock: BooleanLike;
  panelOpen: BooleanLike;
  panelBroken: BooleanLike;
  panelIntegrityRatio: number;
  theme: string;
  sprite64: string;
}

interface RigMaintenancePiece {
  id: string;
  sealed: RigPieceSealStatus;
  deployed: BooleanLike;
}

export const RigMaintenance = (props, context) => {
  const { act, data } = useBackend<RigMaintenanceData>(context);
  const [systemTab, setSystemTab] = useLocalState<number>(context, 'rigsuitSystemTab', 1);
  const [suitSection, setSuitSection] = useLocalState<string>(context, "rigsuitSectionTab", "All");
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
            <Section fill>
              <Stack vertical fill>
                <Stack.Item>
                  <Tabs fluid>
                    {RigHardwareZoneSelection.map((zone) => (
                      <Tabs.Tab onClick={() => setModuleSection(zone.key)}
                        selected={moduleSection === zone.key} key={zone.key}>
                        <Tooltip content={zone.name}>
                          <Icon name={zone.icon} size={2.5} />
                        </Tooltip>
                      </Tabs.Tab>
                    ))}
                  </Tabs>
                </Stack.Item>
                <Stack.Item grow={1}>
                  <NoticeBox warning>OS-WIP-FRAGMENT-101</NoticeBox>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Stack vertical fill>
              <Stack.Item>
                <RigConsole consoleData={data.console}
                  consoleInput={(raw) => act('consoleInput', { command: raw })} />
              </Stack.Item>
              {/* <Stack.Item>
                <Tabs fluid>
                  <Tabs.Tab
                    color="transparent"
                    onClick={() => setSuitSection('All')}
                    selected={suitSection === "All"}>
                    <Stack>
                      <Stack.Item>
                        <img src={`data:image/png;base64, ${data.sprite64}`}
                          style={{ transform: `scale(1.75)`, "margin": "0.25em 0.125em" }} />
                      </Stack.Item>
                      <Stack.Item>
                        <Flex height="100%" direction="column" justify="space-around">
                          <Flex.Item>
                            Test
                          </Flex.Item>
                        </Flex>
                      </Stack.Item>
                    </Stack>
                  </Tabs.Tab>
                  {data.pieceIDs.map((ref) => {
                    let pieceData = getModuleData<RigPieceData>(context, ref);
                    let pieceSealButton: InfernoNode | undefined;
                    switch (pieceData.sealed) {
                      case RigPieceSealStatus.Sealed:
                        pieceSealButton = (
                          <Button.Confirm
                            selected
                            icon="lock"
                            confirmColor="average"
                            confirmContent={null}
                            confirmIcon="unlock"
                            onClick={() => act('seal', { piece: pieceData.id, on: false })} />
                        );
                        break;
                      case RigPieceSealStatus.Unsealed:
                        pieceSealButton = (
                          <Button
                            icon="unlock"
                            color="transparent"
                            onClick={() => act('seal', { piece: pieceData.id, on: true })} />
                        );
                        break;
                      case RigPieceSealStatus.Sealing:
                        pieceSealButton = (
                          <Button
                            color="average"
                            icon="lock"
                            onClick={() => act('seal', { piece: pieceData.id, on: false })} />
                        );
                        break;
                      case RigPieceSealStatus.Unsealing:
                        pieceSealButton = (
                          <Button
                            icon="unlock"
                            color="average"
                            onClick={() => act('seal', { piece: pieceData.id, on: true })} />
                        );
                        break;
                    }
                    return (
                      <Tabs.Tab
                        key={ref}
                        color="transparent"
                        onClick={() => setSuitSection(ref)}
                        selected={suitSection === ref}
                        innerStyle={{ height: "100%", width: "100%" }}>
                        <Stack>
                          <Stack.Item align="center" justify="space-around">
                            <img src={`data:image/png;base64, ${pieceData.sprite64}`}
                              style={{ transform: `scale(1.75)`, "margin": "0.25em 0.125em" }} />
                          </Stack.Item>
                          <Stack.Item>
                            <Flex direction="column" fill justify="space-around">
                              <Flex.Item>
                                {pieceSealButton}
                              </Flex.Item>
                              <Flex.Item>
                                {pieceData.deployed? (
                                  <Button.Confirm
                                    selected
                                    icon="circle"
                                    confirmColor="red"
                                    confirmContent={null}
                                    confirmIcon="circle-o"
                                    onClick={() => act('deploy', { piece: pieceData.id, on: false })} />
                                ) : (
                                  <Button
                                    color="transparent"
                                    icon="circle-o"
                                    onClick={() => act('deploy', { piece: pieceData.id, on: true })} />
                                )}
                              </Flex.Item>
                            </Flex>
                          </Stack.Item>
                        </Stack>
                      </Tabs.Tab>
                    );
                  })}
                </Tabs>
              </Stack.Item>
              <Stack.Item grow={1}>
                <Section fill>
                  <NoticeBox warning>OS-WIP-FRAGMENT-102</NoticeBox>
                </Section>
              </Stack.Item> */}
            </Stack>
          </Stack.Item>
        </Stack>
      </Window.Content>
    );
  }
  return (
    <Window title={`${data.theme} controller internals`} width={700} height={600}>
      {rendered}
    </Window>
  );
};
