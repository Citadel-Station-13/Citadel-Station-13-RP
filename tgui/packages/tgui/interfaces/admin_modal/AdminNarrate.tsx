/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "../../../common/react";
import { Window } from "../../layouts";
import { ByondColorString } from "../common/Color";

interface AdminNarrateData {
  visualColor: ByondColorString;
  mode: AdminNarrateMode;
  rawHtml: string;
  target: AdminNarrateTarget | null;
  useLos: BooleanLike;
  useRange: BooleanLike;
  maxRangeLos: number;
  maxRangeAny: number;
}

interface AdminNarrateTarget {
  coords: [number, number, number] | null;
  level: {
    index: number;
    name: string;
  } | null;
  sector: {
    name: string;
  } | null;
  overmap: {
    name: string;
    x: number;
    y: number;
    map: string;
  } | null;
}

enum AdminNarrateMode {
  Global = "global",
  Sector = "sector",
  Overmap = "overmap",
  Level = "level",
  Range = "range",
  Direct = "direct",
  Lobby = "lobby",
}

const MODES_REQUIRING_TARGET: AdminNarrateMode[] = [
  AdminNarrateMode.Direct,
  AdminNarrateMode.Range,
  AdminNarrateMode.Overmap,
  AdminNarrateMode.Sector,
  AdminNarrateMode.Level,
];

export const AdminNarrate = (props, context) => {
  return (
    <Window>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};
