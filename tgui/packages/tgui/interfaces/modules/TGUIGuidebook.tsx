/**
 * @file
 * @license MIT
 */

import { useState } from "react";
import { Stack, Tabs } from "tgui-core/components";

import { useBackend } from "../../backend";
import { LegacyModule } from "../../components/LegacyModule";
import { Window } from "../../layouts";
import { ModuleData } from "../../legacyModuleSystem";

interface TGUIGuidebookContext {
  // module id to name
  sections: Record<string, string>;
}

export const TGUIGuidebook = (props) => {
  let { act, data } = useBackend<TGUIGuidebookContext>();
  const [activeSection, setActiveSection] = useState<string | null>(null);
  const sections = Object.keys(data.sections);
  const oneSectionMode = sections.length === 1;
  return (
    <Window width={800} height={800} title="Guidebook">
      <Window.Content>
        {!!oneSectionMode && (
          <LegacyModule id={sections[0]} />
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
                <LegacyModule id={activeSection} />
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
