/**
 * @file
 * @license MIT
 */

import { getModuleData, useLocalState } from "../../backend";
import { Button, Icon, LabeledList, NoticeBox, Section, Stack, Tabs } from "../../components";
import { RigsuitData } from "./Rigsuit";
import { RigUIZoneSelection } from "./RigsuitCommon";
import { RigsuitPieceData } from "./RigsuitPiece";

export interface RigControllerProps {
  readonly rig: RigsuitData;
}

export const RigController = (props: RigControllerProps, context) => {
  const [systemTab, setSystemTab] = useLocalState<number>(context, 'rigsuitSystemTab', 1);
  const [suitSection, setSuitSection] = useLocalState<string>(context, "rigsuitSectionTab", "All");
  const [moduleSection, setModuleSection] = useLocalState<string>(context, "rigsuitModuleTab", RigUIZoneSelection[0].key);
  return (
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
                    <img src={`data:image/png;base64, ${props.rig.sprite64}`}
                      style={{ transform: `scale(1.75)`, "margin": "0.25em 0.125em" }} />
                  </Stack.Item>
                  <Stack.Item>
                    <Stack vertical fill>
                      <Stack.Item>
                        <Button.Confirm
                          color="transparent"
                          icon={0? "lock" : "unlock"}
                          confirmColor="average"
                          confirmContent={null}
                          confirmIcon={0? "lock": "unlock"} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                </Stack>
              </Tabs.Tab>
              {props.rig.pieceRefs.map((ref) => {
                let pieceData = getModuleData<RigsuitPieceData>(context, ref);
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
                        <Stack vertical fill justify="space-around">
                          <Stack.Item align="center" justify="space-around">
                            <Button.Confirm
                              color="transparent"
                              icon={0? "lock" : "unlock"}
                              confirmColor="average"
                              confirmContent={null}
                              confirmIcon={0? "lock": "unlock"} />
                          </Stack.Item>
                          <Stack.Item align="center" justify="space-around">
                            <Button.Confirm
                              color="transparent"
                              icon={0? "circle" : "circle-o"}
                              confirmColor="average"
                              confirmContent={null}
                              confirmIcon={0? "circle": "circle-o"} />
                          </Stack.Item>
                        </Stack>
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
                    <Icon name={zone.icon} size={2.5} backgroundColor="#aa7700" height="50px" maxHeight="50px" />
                  </Tabs.Tab>
                ))}
                <Tabs.Tab selected={0}>
                  <Icon name="circle" size={2.5} backgroundColor="#aa7700" height="50px" />
                </Tabs.Tab>
                <Tabs.Tab selected={0}>
                  <Icon name="tg-non-binary" size={2.5} backgroundColor="#aa7700" />
                </Tabs.Tab>
              </Tabs>
            </Stack.Item>
            <Stack.Item grow={1}>
              <NoticeBox warning>OS-WIP-FRAGMENT-7</NoticeBox>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </Stack>
  );
};
