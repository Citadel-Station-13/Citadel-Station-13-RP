//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { useBackend } from "../../backend";
import { Section, SectionProps } from "../../components/Section";

export enum AtmosVentPumpPressureChecks {
  None = 0,
  Internal = (1<<0),
  External = (1<<1),
}

export interface AtmosVentPumpState {
  pressureChecks: AtmosVentPumpPressureChecks;
  internalPressure: number;
  externalPressure: number;
  // on / off
  power: boolean;
  // true for in
  siphon: boolean;
}

interface AtmosVentPumpControlProps extends SectionProps {
  // act() for toggling vent; if this isn't provided, the button is disabled.
  powerAct: (boolean) => void;
  // act() for toggling pumping out; if this isn't provided, the button is disabled.
  siphonAct: (boolean) => void;
  // set internal pressure check
  internalAct: (number) => void;
  // set external pressure check
  externalAct: (number) => void;
  // vent data
  state: AtmosVentPumpState;
}

/**
 * Embeddable atmos vent control.
 */
export const AtmosVentPumpControl = (props: AtmosVentPumpControlProps) => {
  return (
    <Section {...props}>
      Unimplemented
    </Section>
  );
};

interface AtmosVentPumpData {
  // vent state
  state: AtmosVentPumpState;
}

export const AtmosVentPump = (props, context) => {
  let { data, act } = useBackend<AtmosVentPumpData>(context);

};
