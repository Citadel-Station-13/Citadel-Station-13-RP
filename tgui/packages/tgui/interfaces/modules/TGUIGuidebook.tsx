/**
 * @file
 * @license MIT
 */

import { ModuleData, useBackend, useLocalState } from "../../backend";
import { Stack, Tabs } from "../../components";
import { Module } from "../../components/Module";
import { Window } from "../../layouts";

interface TGUIGuidebookContext {
  // module id to name
  sections: Record<string, string>;
}

export const TGUIGuidebook = (props, context) => {
  let { act, data } = useBackend<TGUIGuidebookContext>(context);
  const [activeSection, setActiveSection] = useLocalState<string | null>(context, 'masterGuidebookSection', null);
  const sections = Object.keys(data.sections);
  const oneSectionMode = sections.length === 1;
  return (
    <Window width={800} height={800} title="Guidebook">
      <Window.Content>
        {!!oneSectionMode && (
          <Module id={sections[0]} />
        )}
        {!oneSectionMode && (
          <Stack vertical>
            <Stack.Item>
              <Tabs>
                {Object.entries(data.sections).map(([id, name]) => (
                  <Tabs.Tab selected={activeSection === id} onClick={
                    () => setActiveSection(id)
                  } key={id}>{name}
                  </Tabs.Tab>
                ))}
              </Tabs>
            </Stack.Item>
            {activeSection !== null && (
              <Stack.Item grow={1}>
                <Module id={activeSection} />
              </Stack.Item>
            )}
            {activeSection === null && (
              <Stack.Item grow={1} />
            )}
          </Stack>
        )}
      </Window.Content>
    </Window>
  );
};

export interface TGUIGuidebookSectionData extends ModuleData {
  title: string;
}
