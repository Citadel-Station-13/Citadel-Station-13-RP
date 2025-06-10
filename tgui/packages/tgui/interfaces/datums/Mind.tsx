/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { Window } from "../../layouts";
import { useBackend } from "../../backend";

interface MindData {
  realName: string;
  memories: MemoryData[],
  memoryMaxUserLength: number;
  memoryMaxUserLinebreaks: number;
  legacyObjectives: string[];
  legacyAmbitions: string[];
  // below: admin-only
  admin?: BooleanLike;
  rHolderEldritchPresent?: BooleanLike;
}

interface MemoryData {
  key: string;
  priority: number;
  canDelete: BooleanLike;
  contentType: MemoryType;
  content: any;
}

enum MemoryType {
  Text = "text",
  UnsafeRawHtml = "html",
}

export const Mind = (props, context) => {
  const { act, data } = useBackend<MindData>(context);

  return (
    <Window title={`Recollection - ${data.realName}`}>
      <Window.Content>
        test
      </Window.Content>
    </Window>
  );
};

const MemoryRender = (props: {
  memory: MemoryData;
}, context) => {

};
