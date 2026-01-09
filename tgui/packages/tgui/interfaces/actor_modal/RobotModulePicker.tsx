/**
 * @file
 * @license MIT
 */

import { useState } from 'react';
import { Button, Section, Stack, Tabs } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { ByondIconRef } from '../../components/ByondIconRef';
import { Centered } from '../../components/Centered';
import { Direction } from '../../constants';
import { Window } from '../../layouts';

export const ROBOT_MODULE_SPRITESHEET_NAME = 'roboticonsets';

interface RobotModulePickerData {
  modules: Record<string, PickableModule>;
}

interface PickableModule {
  id: string;
  name: string;
  frames: Record<string, PickableFrame>;
}

interface PickableFrame {
  ref: string;
  name: string;
  spriteSizeKey: string;
  spriteId: string;
  iconRef: string;
  iconState: string;
}

export const RobotModulePicker = (props) => {
  const { act, data } = useBackend<RobotModulePickerData>();
  const [selectedModuleId, setSelectedModuleId] = useState<null | string>(null);
  const [selectedFrameRef, setSelectedFrameRef] = useState<null | string>(null);

  let selectedFrame: PickableFrame | null =
    (selectedModuleId &&
      selectedFrameRef &&
      data.modules?.[selectedModuleId]?.frames?.[selectedFrameRef]) ||
    null;

  return (
    <Window width={650} height={450} title="Module Specialization">
      <Window.Content>
        <Stack fill>
          <Stack.Item width="25%">
            <Section title="Module" fill scrollable>
              <Tabs vertical>
                {Object.entries(data.modules)
                  .sort(([a1, a2], [b1, b2]) => a2.name.localeCompare(b2.name))
                  .map(([id, module]) => {
                    return (
                      <Tabs.Tab
                        key={id}
                        onClick={() => setSelectedModuleId(id)}
                        selected={id === selectedModuleId}
                      >
                        {module.name}
                      </Tabs.Tab>
                    );
                  })}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item width="25%">
            <Section title="Frame" fill scrollable>
              <Tabs vertical>
                {selectedModuleId &&
                  !!data.modules[selectedModuleId] &&
                  Object.entries(data.modules[selectedModuleId].frames)
                    .sort(([a1, a2], [b1, b2]) =>
                      a2.name.localeCompare(b2.name),
                    )
                    .map(([id, frame]) => {
                      return (
                        <Tabs.Tab
                          key={id}
                          onClick={() => setSelectedFrameRef(id)}
                          selected={id === selectedFrameRef}
                        >
                          {frame.name}
                        </Tabs.Tab>
                      );
                    })}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section title="Preview" fill>
              <Stack vertical fill>
                <Stack.Item grow={1}>
                  {selectedFrame && (
                    <Stack fill>
                      <Stack.Item grow={1}>
                        <Stack fill vertical>
                          <Stack.Item grow={1}>
                            <Centered>
                              <ByondIconRef
                                width="100%"
                                height="auto"
                                iconRef={selectedFrame.iconRef}
                                iconState={selectedFrame.iconState}
                                direction={Direction.NORTH}
                              />
                            </Centered>
                          </Stack.Item>
                          <Stack.Item grow={1}>
                            <Centered>
                              <ByondIconRef
                                width="100%"
                                height="auto"
                                iconRef={selectedFrame.iconRef}
                                iconState={selectedFrame.iconState}
                                direction={Direction.SOUTH}
                              />
                            </Centered>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                      <Stack.Item grow={1}>
                        <Stack fill vertical>
                          <Stack.Item grow={1}>
                            <Centered>
                              <ByondIconRef
                                width="100%"
                                height="auto"
                                iconRef={selectedFrame.iconRef}
                                iconState={selectedFrame.iconState}
                                direction={Direction.EAST}
                              />
                            </Centered>
                          </Stack.Item>
                          <Stack.Item grow={1}>
                            <Centered>
                              <ByondIconRef
                                width="100%"
                                height="auto"
                                iconRef={selectedFrame.iconRef}
                                iconState={selectedFrame.iconState}
                                direction={Direction.WEST}
                              />
                            </Centered>
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    </Stack>
                  )}
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    fluid
                    disabled={!selectedFrameRef || !selectedModuleId}
                    onClick={() =>
                      act('pick', {
                        moduleId: selectedModuleId,
                        frameRef: selectedFrameRef,
                      })
                    }
                    textAlign="center"
                  >
                    Specialize
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
