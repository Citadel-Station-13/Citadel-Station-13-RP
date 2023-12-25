import { Section } from "../../components";
import { RigPieceFlags, RigPieceSealStatus } from "./common";

export interface RigsuitPieceData {
  name: string;
  sealed: RigPieceSealStatus;
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
