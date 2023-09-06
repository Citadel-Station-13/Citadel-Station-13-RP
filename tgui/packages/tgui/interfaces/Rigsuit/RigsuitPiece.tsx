import { RigPieceFlags, RigPieceSealStatus } from "./common";

export interface RigsuitPieceData {
  name: string;
  sealed: RigPieceSealStatus;
  flags: RigPieceFlags;
}
