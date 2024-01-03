/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { RigActivationStatus, RigPieceID, RigPieceSealStatus } from "./RigsuitCommon";
import { RigsuitConsoleData } from "./RigsuitConsole";

interface RigsuitMaintenanceData {
  console: RigsuitConsoleData;
  pieceIDs: RigPieceID[];
  activation: RigActivationStatus;
  panelLock: BooleanLike;
  panelOpen: BooleanLike;
  panelBroken: BooleanLike;
  panelIntegrityRatio: number;
}

interface RigsuitMaintenancePiece {
  id: string;
  sealed: RigPieceSealStatus;
  deployed: BooleanLike;
}

export const RigsuitMaintenance = (props, context) => {
  const { act, data } = useBackend<RigsuitMaintenanceData>(context);
  let rendered: InfernoNode;
  if (!data.panelOpen) {
    rendered = (
      <Window.Content>
        Test
      </Window.Content>
    );
  }
  else {
    rendered = (
      <Window.Content>
        test
      </Window.Content>
    );
  }
  return (
    <Window width={800} height={550}>
      {rendered}
    </Window>
  );
};
