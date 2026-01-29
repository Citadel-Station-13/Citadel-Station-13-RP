/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react"
import { ResleevingMirrorData } from "../common/Resleeving"
import { Window } from "../../layouts";

interface MirrortoolContext {
  mirror: ResleevingMirrorData;
};

export const Mirrortool = (props) => {
  return (
    <Window>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  )
}
