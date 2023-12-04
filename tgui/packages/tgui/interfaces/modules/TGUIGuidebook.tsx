/**
 * @file
 * @license MIT
 */

import { ModuleData, useBackend, useLocalState } from "../../backend";
import { Window } from "../../layouts";

interface TGUIGuidebookContext {
  // module id to name
  sections: Record<string, string>;
}

export const TGUIGuidebook = (props, context) => {
  let { act, data } = useBackend<TGUIGuidebookContext>(context);
  const [activeSection, setActiveSection] = useLocalState<string | null>(context, 'activeSection', null);
  return (
    <Window width={800} height={800}>
      <Window.Content>
        {JSON.stringify(data)}
        Test
      </Window.Content>
    </Window>
  );
};

export interface TGUIGuidebookSectionData extends ModuleData {
  title: string;
}
