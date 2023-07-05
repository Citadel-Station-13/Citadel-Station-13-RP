import { useBackend } from "../../backend";
import { Section, SectionProps } from "../../components/Section";

interface AtmosVentControlProps extends SectionProps {
  // is the vent on
  powerState: boolean;
  // act() for toggling vent; if this isn't provided, the button is disabled.
  powerAct: (boolean) => void;
  // is the vent pressurizing or siphoning?
  pumpOut: boolean;
  // act() for toggling pumping out; if this isn't provided, the button is disabled.
  pumpAct: (boolean) => void;
  // vent pressure check internal
  internalCheck: boolean;
  // set internal pressure check
  internalAct: (number) => void;
  // vent pressure check external
  externalCheck: boolean;
  // set external pressure check
  externalAct: (number) => void;
}

export const AtmosVentControl = (props: AtmosVentControlProps) => {
  return (
    <Section {...props}>
      Unimplemented
    </Section>
  )
}

interface AtmosVentData {

}

export const AtmosVent = (props, context) => {
  let {data, act} = useBackend<AtmosVentData>(context);

}
