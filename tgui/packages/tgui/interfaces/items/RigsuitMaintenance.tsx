/**
 * @file
 * @license MIT
 */

import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { RigsuitConsoleData } from "./RigsuitConsole";

interface RigsuitMaintenanceData {
  console: RigsuitConsoleData;
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
