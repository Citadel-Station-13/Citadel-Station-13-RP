import { useBackend } from "../../backend";
import { SectionProps } from "../../components/Section";

interface AtmosScrubberControlProps extends SectionProps {

}

export const AtmosScrubberControl = (props: AtmosScrubberControlProps) => {

}

interface AtmosScrubberData {

}

export const AtmosScrubber = (props, context) => {
  let {act, data} = useBackend<AtmosScrubberData>(context);

}
