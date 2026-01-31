/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react";
import { ResleevingBodyRecord, ResleevingMirrorData } from "../common/Resleeving"
import { Window } from "../../layouts";

interface ResleevingDiskData {
  valid: BooleanLike;
  name: string;

};

interface LinkedSleever {
  ref: string;
  name: string;
  occupied: null | {
    name: string;
    hasMind: BooleanLike;
    compatibleWithMirror: BooleanLike;
    stat: "conscious" | "dead" | "unconscious";
  };
  mirror: null | ResleevingMirrorData;
};

interface LinkedPrinter {
  ref: string;
  name: string;
  busy: null | {
    record: ResleevingBodyRecord;
    progressRatio: number;
  }
  allowOrganic: BooleanLike;
  allowSynthetic: BooleanLike;
};

interface ResleevingConsoleContext {
  insertedMirror: ResleevingMirrorData | null;
  insertedDisk: ResleevingDiskData | null;
  relinkOnCooldown: BooleanLike;
  sleevePods: LinkedSleever[];
  bodyPrinters: LinkedPrinter[];
};

export const ResleevingConsole = (props) => {
  return (
    <Window>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  )
}
