/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { ModuleData, useModule } from "../../backend";
import { NoticeBox, Section } from "../../components";
import { RigPieceFlags, RigPieceSealStatus } from "./RigsuitCommon";

export interface RigsuitPieceData extends ModuleData {
  name: string;
  id: string;
  sealed: RigPieceSealStatus;
  deployed: BooleanLike;
  flags: RigPieceFlags;
  sprite64: string;
}

export const RigsuitPiece = (props, context) => {
  const { act, data } = useModule<RigsuitPieceData>(context);
  return (
    <Section>
      <NoticeBox warning>
        OS-WIP-FRAGMENT-11
      </NoticeBox>
    </Section>
  );
};
