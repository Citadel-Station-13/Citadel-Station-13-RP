import { useBackend } from "../../backend";
import { Section, SectionProps } from "../../components/Section";

interface AtmosVentControlProps extends SectionProps {
  // act() for toggling vent; if this isn't provided, the button is disabled.
  powerAct: (boolean) => void;
  // act() for toggling pumping out; if this isn't provided, the button is disabled.
  siphonAct: (boolean) => void;
  // set internal pressure check
  internalAct: (number) => void;
  // set external pressure check
  externalAct: (number) => void;
  // vent data
  vent: AtmosVentState;
}

export enum AtmosVentPressureChecks {
  None = 0,
  Internal = (1<<0),
  External = (1<<1),
}

export interface AtmosVentState {
  pressureChecks: AtmosVentPressureChecks;
  internalPressure: number;
  externalPressure: number;
  // on / off
  power: boolean;
  // true for in
  siphon: boolean;
}

/**
 * Embeddable atmos vent control.
 */
export const AtmosVentControl = (props: AtmosVentControlProps) => {
  return (
    <Section {...props}>
      Unimplemented
    </Section>
  )
}

interface AtmosVentData {
  // vent state
  state: AtmosVentState;
}

export const AtmosVent = (props, context) => {
  let {data, act} = useBackend<AtmosVentData>(context);

}
