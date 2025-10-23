/**
 * @file
 * @license MIT
 */

import { VehicleComponentData } from "../types";
import { ComponentBase } from "./ComponentBase";

export const Trivial = (props: { data: VehicleComponentData }) => {
  return (
    <ComponentBase data={props.data} />
  );
};
