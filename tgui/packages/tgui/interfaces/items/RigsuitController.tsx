/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { getModuleData, useBackend, useLocalState } from "../../backend";
import { Button, Flex, Icon, LabeledList, NoticeBox, Section, Stack, Tabs } from "../../components";
import { Window } from "../../layouts";
import { RigActivationStatus, RigControlFlags, RigModuleReflist, RigPieceReflist, RigPieceSealStatus, RigUIZoneSelection } from "./RigsuitCommon";
import { RigsuitPieceData } from "./RigsuitPiece";

export interface RigsuitControllerData {
  controlFlags: RigControlFlags;
  activation: RigActivationStatus;
  pieceRefs: RigPieceReflist;
  moduleRefs: RigModuleReflist;
  sprite64: string;
  theme: string;
  wornCorrectly: BooleanLike;
}
export interface RigControllerProps {
  readonly rig: RigsuitControllerData;
}

export const RigsuitController = (props, context) => {
  const [systemTab, setSystemTab] = useLocalState<number>(context, 'rigsuitSystemTab', 1);
  const [suitSection, setSuitSection] = useLocalState<string>(context, "rigsuitSectionTab", "All");
  const [moduleSection, setModuleSection] = useLocalState<string>(context, "rigsuitModuleTab", RigUIZoneSelection[0].key);

  const { data, act } = useBackend<RigsuitControllerData>(context);
  const rig = data;

  let rigActivationButton: InfernoNode | null = null;

  switch (rig.activation) {
    case RigActivationStatus.Activating:
      rigActivationButton = (
        <Button
          color="average"
          icon="lock"
          onClick={() => act('activation', { on: false })} />
      );
      break;
    case RigActivationStatus.Deactivating:
      rigActivationButton = (
        <Button
          color="average"
          icon="unlock"
          onClick={() => act('activation', { on: true })} />
      );
      break;
    case RigActivationStatus.Offline:
      rigActivationButton = (
        <Button
          color="bad"
          icon="unlock"
          onClick={() => act('activation', { on: true })} />
      );
      break;
    case RigActivationStatus.Online:
      rigActivationButton = (
        <Button.Confirm
          color="good"
          icon="lock"
          confirmColor="bad"
          confirmContent={null}
          confirmIcon="unlock"
          onClick={() => act('activation', { on: false })} />
      );
      break;
  }

  return (
    <Window width={450} height={800} title={`${rig.theme} hardsuit controller`}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item maxHeight="40%">
            <Stack fill>
              {suitSection === "All" && (
                <Stack.Item grow={1}>
                  <Section fill>
                    <Stack vertical>
                      <Stack.Item>
                        <Tabs fluid>
                          <Tabs.Tab onClick={() => setSystemTab(1)} selected={systemTab === 1}>Systems</Tabs.Tab>
                          <Tabs.Tab onClick={() => setSystemTab(2)} selected={systemTab === 2}>Core</Tabs.Tab>
                          <Tabs.Tab onClick={() => setSystemTab(3)} selected={systemTab === 3}>Wearer</Tabs.Tab>
                          <Tabs.Tab onClick={() => setSystemTab(4)} selected={systemTab === 4}>Integrity</Tabs.Tab>
                          <Tabs.Tab onClick={() => setSystemTab(5)} selected={systemTab === 5}>Control</Tabs.Tab>
                        </Tabs>
                      </Stack.Item>
                      <Stack.Item>
                        {systemTab === 1 && (
                          <Section>
                            <LabeledList>
                              <LabeledList.Item label="Status">
                                OS-WIP-FRAGMENT-2
                              </LabeledList.Item>
                              <LabeledList.Item label="Energy">
                                OS-WIP-FRAGMENT-3
                              </LabeledList.Item>
                            </LabeledList>
                          </Section>
                        )}
                        {systemTab === 2 && (
                          <Section>
                            <NoticeBox warning>OS-WIP-FRAGMENT-4</NoticeBox>
                          </Section>
                        )}
                        {systemTab === 3 && (
                          <Section>
                            <NoticeBox warning>OS-WIP-FRAGMENT-5</NoticeBox>
                          </Section>
                        )}
                        {systemTab === 4 && (
                          <Section>
                            <NoticeBox warning>OS-WIP-FRAGMENT-6</NoticeBox>
                          </Section>
                        )}
                        {systemTab === 5 && (
                          <Section>
                            <NoticeBox warning>OS-WIP-FRAGMENT-14</NoticeBox>
                          </Section>
                        )}
                      </Stack.Item>
                    </Stack>
                  </Section>
                </Stack.Item>
              )}
              {suitSection !== "All" && (
                <Stack.Item grow={1}>
                  <Section fill>
                    <NoticeBox warning>
                      OS-WIP-FRAGMENT-13
                    </NoticeBox>
                  </Section>
                </Stack.Item>
              )}
              <Stack.Item>
                <Tabs vertical fluid>
                  <Tabs.Tab
                    color="transparent"
                    onClick={() => setSuitSection('All')}
                    selected={suitSection === "All"}>
                    <Stack>
                      <Stack.Item>
                        <img src={`data:image/png;base64, ${rig.sprite64}`}
                          style={{ transform: `scale(1.75)`, "margin": "0.25em 0.125em" }} />
                      </Stack.Item>
                      <Stack.Item>
                        <Flex height="100%" direction="column" justify="space-around">
                          <Flex.Item>
                            {rigActivationButton}
                          </Flex.Item>
                        </Flex>
                      </Stack.Item>
                    </Stack>
                  </Tabs.Tab>
                  {rig.pieceRefs.map((ref) => {
                    let pieceData = getModuleData<RigsuitPieceData>(context, ref);
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
            </Stack>
          </Stack.Item>
          <Stack.Item grow={1}>
            <Section fill title="Modules">
              <Stack vertical fill>
                <Stack.Item>
                  <Tabs fluid>
                    {RigUIZoneSelection.map((zone) => (
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
        </Stack>
      </Window.Content>
    </Window>
  );
};
