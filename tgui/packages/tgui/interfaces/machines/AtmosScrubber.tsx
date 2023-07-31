//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { useBackend } from "../../backend";
import { SectionProps } from "../../components/Section";
import { GasContext } from "../common/Atmos";

interface AtmosScrubberControlProps extends SectionProps {
  context: GasContext;
}

export const AtmosScrubberControl = (props: AtmosScrubberControlProps) => {

};

export interface AtmosScrubberState {
  // are we on siphon mode
  siphon: boolean;
  // are we on high power mode
  overclock: boolean;
}

interface AtmosScrubberData {

}

export const AtmosScrubber = (props, context) => {
  let { act, data } = useBackend<AtmosScrubberData>(context);

};
