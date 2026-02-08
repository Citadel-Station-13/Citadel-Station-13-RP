/**
 * @file
 * @license MIT
 */

import { createContext, ReactNode, useContext } from "react";

import { ActFunctionType, useBackend } from "../../backend";
import { VehicleComponentRef, VehicleModuleRef } from "./types";

const requireVehicleComponent = require.context("./components");
const requireVehicleModule = require.context("./modules");

export function withVehicleComponentData<D, T = ReactNode>(ref: VehicleComponentRef | null, func: (data: D | null) => T): T {
  let { nestedData } = useBackend();
  // TODO: better error handling
  if (ref === null) {
    return func(null);
  }
  return func(nestedData[ref] as D | null);
}

export function withVehicleModuleData<D, T = ReactNode>(ref: VehicleModuleRef | null, func: (data: D | null) => T): T {
  let { nestedData } = useBackend();
  // TODO: better error handling
  if (ref === null) {
    return func(null);
  }
  return func(nestedData[ref] as D | null);
}

export const VehicleModuleContext = createContext<{ ref: VehicleModuleRef | null }>({ ref: null });
export const VehicleComponentContext = createContext<{ ref: VehicleComponentRef | null }>({ ref: null });

/**
 * Gets an act function / data for a given vehicle part interface.
 */
export function useVehicleComponent<Data>(): { data: Data, act: ActFunctionType } {
  const ctx = useContext(VehicleComponentContext);
}

/**
 * Gets an act function / data for a given vehicle part interface.
 */
export function useVehicleModule<Data>(): { data: Data, act: ActFunctionType } {
  const ctx = useContext(VehicleModuleContext);

}

export const VehicleComponent = (props: {
  ref: VehicleComponentRef;
}) => {
  return withVehicleComponentData(props.ref, (d) => {
    return (
      <VehicleComponentContext value={{ ref: props.ref }}>
        Test
      </VehicleComponentContext>
    );
  });
};

export const VehicleModule = (props: {
  ref: VehicleModuleRef;
}) => {
  return withVehicleModuleData(props.ref, (d) => {
    return (
      <VehicleModuleContext value={{ ref: props.ref }}>
        Test
      </VehicleModuleContext>
    );
  });
};
