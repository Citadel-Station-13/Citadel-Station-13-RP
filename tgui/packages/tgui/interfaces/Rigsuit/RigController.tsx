/**
 * This is a top level UI.
 *
 * todo: why is this a top level UI? why not embedded? huh?? huh??
 *
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { getModuleData, useBackend, useLocalState } from "../../backend";
import { Button, Flex, Icon, LabeledList, NoticeBox, Section, Stack, Tabs, Tooltip } from "../../components";
import { checkClickEventNoSwitchTab } from "../../components/Tabs";
import { Window } from "../../layouts";
import { WindowTheme } from "../../styles/themes/typedef";
import { RigActivationStatus, RigControlFlags, RigModuleReflist, RigModuleZoneSelection, RigPieceReflist, RigPieceSealStatus } from "./common";
import { RigPieceData } from "./RigPiece";

export interface RigControllerData {
  controlFlags: RigControlFlags;
  activation: RigActivationStatus;
  pieceRefs: RigPieceReflist;
  moduleRefs: RigModuleReflist;
  sprite64: string;
  // theme name
  theme: string;
  wornCorrectly: BooleanLike;
  windowTheme: WindowTheme | null;
}
export interface RigControllerProps {
  readonly rig: RigControllerData;
}

export const RigController = (props, context) => {
  const [systemTab, setSystemTab] = useLocalState<number>(context, 'rigsuitSystemTab', 1);
  const [suitSection, setSuitSection] = useLocalState<string>(context, "rigsuitSectionTab", "All");
  const [moduleSection, setModuleSection] = useLocalState<string>(context, "rigsuitModuleTab", RigModuleZoneSelection[0].key);

  const { data, act } = useBackend<RigControllerData>(context);
  const rig = data;

  return (
    <Window width={450} height={800} title={`${rig.theme} hardsuit controller`}
      theme={data.windowTheme}>
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
                          <Tabs.Tab onClick={(e) => setSystemTab(1)} selected={systemTab === 1}>Systems</Tabs.Tab>
                          <Tabs.Tab onClick={(e) => setSystemTab(2)} selected={systemTab === 2}>Core</Tabs.Tab>
                          <Tabs.Tab onClick={(e) => setSystemTab(3)} selected={systemTab === 3}>Wearer</Tabs.Tab>
                          <Tabs.Tab onClick={(e) => setSystemTab(4)} selected={systemTab === 4}>Integrity</Tabs.Tab>
                          <Tabs.Tab onClick={(e) => setSystemTab(5)} selected={systemTab === 5}>Control</Tabs.Tab>
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
                            <RigActivationButton activation={rig.activation} />
                          </Flex.Item>
                        </Flex>
                      </Stack.Item>
                    </Stack>
                  </Tabs.Tab>
                  {rig.pieceRefs.map((ref) => {
                    let pieceData = getModuleData<RigPieceData>(context, ref);
                    return (
                      <Tabs.Tab
                        key={ref}
                        color="transparent"
                        onClick={(e) => !checkClickEventNoSwitchTab(e) && setSuitSection(ref)}
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
                                <RigPieceSealButton id={pieceData.id}
                                  sealed={pieceData.sealed} />
                              </Flex.Item>
                              <Flex.Item>
                                {pieceData.deployed? (
                                  <Button.Confirm
                                    selected
                                    icon="circle"
                                    confirmColor="yellow"
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
                    {RigModuleZoneSelection.map((zone) => (
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

interface RigActivationButtonProps {
  readonly activation: RigActivationStatus;
}

const RigActivationButton = (props: RigActivationButtonProps, context) => {
  const { act } = useBackend(context);
  switch (props.activation) {
    case RigActivationStatus.Activating:
      return (
        <Button
          flashing
          color="average"
          icon="lock"
          onClick={() => act('activation', { on: false })} />
      );
    case RigActivationStatus.Deactivating:
      return (
        <Button
          flashing
          color="average"
          icon="unlock"
          onClick={() => act('activation', { on: true })} />
      );
    case RigActivationStatus.Offline:
      return (
        <Button
          color="bad"
          icon="unlock"
          onClick={() => act('activation', { on: true })} />
      );
    case RigActivationStatus.Online:
      return (
        <Button.Confirm
          color="good"
          icon="lock"
          confirmColor="average"
          confirmContent={null}
          confirmIcon="unlock"
          onClick={() => act('activation', { on: false })} />
      );
  }
  return (
    <Button color="bad" content="?" />
  );
};

interface RigPieceSealButtonProps {
  readonly sealed: RigPieceSealStatus;
  readonly id: string;
}

const RigPieceSealButton = (props: RigPieceSealButtonProps, context) => {
  const { act } = useBackend(context);

  switch (props.sealed) {
    case RigPieceSealStatus.Sealed:
      return (
        <Button.Confirm
          selected
          icon="lock"
          confirmColor="average"
          confirmContent={null}
          confirmIcon="unlock"
          onClick={() => act('seal', { piece: props.id, on: false })} />
      );
    case RigPieceSealStatus.Unsealed:
      return (
        <Button
          icon="unlock"
          color="transparent"
          onClick={() => act('seal', { piece: props.id, on: true })} />
      );
    case RigPieceSealStatus.Sealing:
      return (
        <Button
          flashing
          color="average"
          icon="lock"
          onClick={() => act('seal', { piece: props.id, on: false })} />
      );
    case RigPieceSealStatus.Unsealing:
      return (
        <Button
          flashing
          icon="unlock"
          color="average"
          onClick={() => act('seal', { piece: props.id, on: true })} />
      );
  }
  return (
    <Button color="bad" content="?" />
  );
};
