import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { RigControlFlags, RigPieceReflist } from "./common";

export interface RigsuitData {
  controlFlags: RigControlFlags;
  pieceRefs: RigPieceReflist;
}

export const Rigsuit = (props, context) => {
  const { act, data } = useBackend<RigsuitData>(context);

  return (
    <Window width={400} height={400}>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};
