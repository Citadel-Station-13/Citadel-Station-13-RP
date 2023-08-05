//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { useBackend } from "../../backend";
import { SectionProps } from "../../components/Section";
import { GasContext } from "../common/Atmos";

export interface AtmosVentScrubberState {
  // are we on siphon mode
  siphon: boolean;
  // are we on high power mode
  overclock: boolean;
}

interface AtmosVentScrubberControlProps extends SectionProps {
  context: GasContext;
  state: AtmosVentScrubberState;
}

export const AtmosVentScrubberControl = (props: AtmosVentScrubberControlProps) => {

};

interface AtmosVentScrubberData {

}

export const AtmosVentScrubber = (props, context) => {
  let { act, data } = useBackend<AtmosVentScrubberData>(context);

};
