import { SectionProps } from "../../components/Section";

interface AtmosMachineControlProps extends SectionProps {
  // allow toggling on/off
  toggleControl?: boolean;
  // called to toggle on/off
  toggleAct?: (state: boolean) => void;
  // allow toggling power draw / usage; will render power use/max as part of this if toggled
  powerControl?: boolean;
  // called to change power
  powerAct?: (watts: number) => void;
  // if specified, we render power usage
  powerUsed?: number;
  // must be specified if powerUsed or powerControl is specified.
  powerMax?: number;
  // allow setting volume flow limit
  flowControl?: boolean;
  // called to change flow
  flowAct?: (liters: number) => void;
  // if specified, we render current flow rate
  flowUsed?: number;
  // must be specified if flowUsed or flowControl is specified.
  flowMax?: number;
  // allow changing max output pressure
  pressureControl?: boolean;
  // called to change max output pressure
  pressureAct?: (kpa: number) => void;
  // must be specified if pressureControl is specified.
  pressureMax?: number;
}

/**
 * generic atmos machinery control panel
 */
export const AtmosMachineControl = (props: AtmosMachineControlProps, context) => {

}
