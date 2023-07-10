import { useBackend } from "../../backend";
import { SectionProps } from "../../components/Section";

interface AtmosScrubberControlProps extends SectionProps {

}

export const AtmosScrubberControl = (props: AtmosScrubberControlProps) => {

}

export interface AtmosScrubberState {
  // are we on siphon mode
  siphon: boolean;
  // are we on high power mode
  overclock: boolean;
}

interface AtmosScrubberData {

}

export const AtmosScrubber = (props, context) => {
  let {act, data} = useBackend<AtmosScrubberData>(context);

}
