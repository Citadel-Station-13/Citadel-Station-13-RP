import { Section } from "../../components";
import { RigPieceFlags, RigPieceSealStatus } from "./common";

export interface RigsuitPieceData {
  name: string;
  sealed: RigPieceSealStatus;
  flags: RigPieceFlags;
}

export const RigsuitPiece = (props, context) => {
  return (
    <Section>
      Test
    </Section>
  );
};
