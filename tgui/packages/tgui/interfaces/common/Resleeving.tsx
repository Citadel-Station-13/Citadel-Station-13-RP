/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react"

export interface ResleevingBodyRecord{
  gender: string | null;
  speciesName: string | null;
  synthetic: BooleanLike;
};

export interface ResleevingMindRecord{
  recordedName: string | null;
};

export interface ResleevingMirrorData {
  activated: BooleanLike;
  bodyRecord: ResleevingBodyRecord | null;
  mindRecord: ResleevingMindRecord | null;
};

