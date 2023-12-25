import { BooleanLike } from "common/react";
import { Section } from "../../components";
import { RigPieceFlags, RigPieceSealStatus } from "./common";

export interface RigsuitPieceData {
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
