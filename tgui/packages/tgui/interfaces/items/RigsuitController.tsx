/**
 * @file
 * @license MIT
 */

import { getModuleData, useLocalState } from "../../backend";
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section, Stack, Tabs } from "../../components";
import { Module } from "../../components/Module";
import { Sprite } from "../../components/Sprite";
import { RigsuitData } from "./Rigsuit";
import { RigsuitPieceData } from "./RigsuitPiece";

export interface RigControllerProps {
  rig: RigsuitData;
}

export const RigController = (props: RigControllerProps, context) => {
  const [systemTab, setSystemTab] = useLocalState<number>(context, 'rigsuitSystemTab', 1);
  const [suitSection, setSuitSection] = useLocalState<string>(context, "rigsuitSectionTab", "All");
  return (
      <Stack fill vertical>
        <Stack.Item>
          <Section>
            <Stack vertical>
              <Stack.Item>
              <Tabs>
                <Tabs.Tab onClick={() => setSystemTab(1)} selected={systemTab === 1}>Systems</Tabs.Tab>
                <Tabs.Tab onClick={() => setSystemTab(3)} selected={systemTab === 3}>Wearer</Tabs.Tab>
                <Tabs.Tab onClick={() => setSystemTab(2)} selected={systemTab === 2}>Integrity</Tabs.Tab>
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
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
        <Stack.Item grow={1}>
          <Section fill title="Hardsuit">
            <Stack fill vertical>
              <Stack.Item>
                <Section overflowX="auto">
                  <Stack fill>
                    <Stack.Item>
                      <Button
                          color="transparent"
                          onClick={() => setSuitSection('All')}
                          selected={suitSection === "All"}>
                        <img src={`data:image/png;base64, ${props.rig.sprite64}`} />
                      </Button>
                    </Stack.Item>
                    {props.rig.pieceRefs.map((ref) => {
                      let pieceData = getModuleData<RigsuitPieceData>(context, ref);
                      return (
                        <Stack.Item>
                          <Button
                            color="transparent"
                            onClick={() => setSuitSection(ref)}
                            selected={suitSection === ref}>
                              <img src={`data:image/png;base64, ${pieceData.sprite64}`} />
                            </Button>
                        </Stack.Item>
                      )
                    })}
                  </Stack>
                </Section>
              </Stack.Item>
              <Stack.Item grow={1}>
                <Section fill>
                  Test
                </Section>
              </Stack.Item>
            </Stack>
          </Section>
        </Stack.Item>
      </Stack>
  );
};
