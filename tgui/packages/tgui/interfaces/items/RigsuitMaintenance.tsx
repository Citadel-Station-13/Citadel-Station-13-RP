/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
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
  return (
    <Window width={800} height={550}>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};
