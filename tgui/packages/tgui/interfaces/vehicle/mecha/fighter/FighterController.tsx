/**
 * @file
 * @license MIT
 */


import { useBackend } from "../../../../backend";
import { FighterData } from "./types";

export const MechaController = (props) => {
  const { act, data } = useBackend<FighterData>();

  return (
    <MechaController />
  );
};
