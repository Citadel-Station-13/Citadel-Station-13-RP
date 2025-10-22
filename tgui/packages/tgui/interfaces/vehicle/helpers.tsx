/**
 * @file
 * @license MIT
 */

import { ReactNode } from "react";

import { useBackend } from "../../backend";
import { VehicleComponentRef, VehicleModuleRef } from "./types";

const requireVehicleComponent = require.context("./components");
const requireVehicleModule = require.context("./modules");

export function useVehicleComponent<D, T = ReactNode>(ref: VehicleComponentRef | null, func: (data: D | null) => T): T {
  let { nestedData } = useBackend();
  // TODO: better error handling
  if (ref === null) {
    return func(null);
  }
  return func(nestedData[ref] as D | null);
}

export function useVehicleModule<D, T = ReactNode>(ref: VehicleModuleRef | null, func: (data: D | null) => T): T {
  let { nestedData } = useBackend();
  // TODO: better error handling
  if (ref === null) {
    return func(null);
  }
  return func(nestedData[ref] as D | null);
}

export const VehicleComponent = (props: {
  ref: VehicleComponentRef;
}) => {
  return useVehicleComponent(props.ref, (d) => {
    return (
      <>
        Test
      </>
    );
  });
};

export const VehicleModule = (props: {
  ref: VehicleModuleRef;
}) => {
  return useVehicleModule(props.ref, (d) => {
    return (
      <>
        Test
      </>
    );
  });
};
