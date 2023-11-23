/**
 * @file
 * @license MIT
 */

import { useBackend } from "../../backend";
import { Window } from "../../layouts";

interface TGUIGuidebookContext {
  // module id to name
  sections: Record<string, string>;
}

export const TGUIGuidebook = (props, context) => {
  let { act, data } = useBackend<TGUIGuidebookContext>(context);
  return (
    <Window width={800} height={800}>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};
