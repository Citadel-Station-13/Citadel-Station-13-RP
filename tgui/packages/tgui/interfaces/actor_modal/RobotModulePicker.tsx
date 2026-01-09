/**
 * @file
 * @license MIT
 */

import { useState } from 'react';
import { Section, Stack, Tabs } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Sprite } from '../../components';
import { Window } from '../../layouts';

export const ROBOT_MODULE_SPRITESHEET_NAME = 'robot-iconsets';

interface RobotModulePickerData {
  modules: Record<string, PickableModule>;
}

interface PickableModule {
  name: string;
  frames: Record<string, PickableFrame>;
}

interface PickableFrame {
  ref: string;
  name: string;
  spriteSizeKey: string;
  spriteId: string;
}

export const RobotModulePicker = (props) => {
  const { act, data } = useBackend<RobotModulePickerData>();
  const [selectedModuleRef, setSelectedModuleRef] = useState<null | string>(
    null,
  );
  const [selectedFrameRef, setSelectedFrameRef] = useState<null | string>(null);

  let selectedFrame: PickableFrame | null =
    (selectedModuleRef &&
      selectedFrameRef &&
      data.modules?.[selectedModuleRef]?.frames?.[selectedFrameRef]) ||
    null;

  return (
    <Window width={650} height={450} title="Module Specialization">
      <Window.Content>
        <Stack fill>
          <Stack.Item width="25%">
            <Section title="Module" fill>
              <Tabs vertical fill>
                {Object.entries(data.modules).map(([id, module]) => {
                  return (
                    <Tabs.Tab
                      key={id}
                      onClick={() => setSelectedModuleRef(id)}
                      selected={id === selectedModuleRef}
                    >
                      {module.name}
                    </Tabs.Tab>
                  );
                })}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item width="25%">
            <Section title="Frame" fill>
              <Tabs vertical fill>
                {selectedModuleRef &&
                  !!data.modules[selectedModuleRef] &&
                  Object.entries(data.modules[selectedModuleRef].frames).map(
                    ([id, frame]) => {
                      return (
                        <Tabs.Tab
                          key={id}
                          onClick={() => setSelectedFrameRef(id)}
                          selected={id === selectedFrameRef}
                        >
                          {frame.name}
                        </Tabs.Tab>
                      );
                    },
                  )}
              </Tabs>
            </Section>
          </Stack.Item>
          <Stack.Item grow>
            <Section title="Preview" fill>
              {selectedFrame && (
                <>
                  {ROBOT_MODULE_SPRITESHEET_NAME}
                  <br />
                  {selectedFrame.spriteSizeKey}
                  <br />
                  {selectedFrame.spriteId}
                  <br />
                  <Sprite
                    width="100%"
                    height="100%"
                    sheet={ROBOT_MODULE_SPRITESHEET_NAME}
                    sizeKey={selectedFrame.spriteSizeKey}
                    sprite={selectedFrame.spriteId}
                  />
                </>
              )}
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
