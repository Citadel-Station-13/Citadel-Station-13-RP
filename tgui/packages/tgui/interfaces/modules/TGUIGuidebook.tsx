/**
 * @file
 * @license MIT
 */

import { ModuleData, useBackend, useLocalState } from "../../backend";
import { Tabs } from "../../components";
import { Module } from "../../components/Module";
import { Window } from "../../layouts";

interface TGUIGuidebookContext {
  // module id to name
  sections: Record<string, string>;
}

export const TGUIGuidebook = (props, context) => {
  let { act, data } = useBackend<TGUIGuidebookContext>(context);
  const [activeSection, setActiveSection] = useLocalState<string | null>(context, 'activeSection', null);
  return (
    <Window width={800} height={800} title="Guidebook">
      <Window.Content>
        <Tabs>
          {Object.entries(data.sections).map(([id, name]) => (
            <Tabs.Tab selected={activeSection === id} onClick={
              () => setActiveSection(id)
            } key={id}>{name}
            </Tabs.Tab>
          ))}
        </Tabs>
        {activeSection !== null && (
          <Module id={activeSection} />
        )}
      </Window.Content>
    </Window>
  );
};

export interface TGUIGuidebookSectionData extends ModuleData {
  title: string;
}
