/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { ModuleData } from "../../backend";
import { Section } from "../../components";
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

  return (
    <Section>
      Test
    </Section>
  );
};
