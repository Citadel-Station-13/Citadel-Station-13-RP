//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { useBackend } from "../../backend";
import { Section } from "../../components";
import { AtmosFilterList, AtmosGasGroupFlags, AtmosGasIDs, GasContext } from "../common/Atmos";
import { AtmosPortable } from "../common/AtmosPortable";

interface AtmosPortableScrubberControlProps {
  atmosContext: GasContext;
  scrubbingIds: AtmosGasIDs;
  scrubbingGroups: AtmosGasGroupFlags;
  toggleId?: (id) => void;
  toggleGroup?: (group) => void;
}

export const AtmosPortableScrubberControl = (props: AtmosPortableScrubberControlProps, context) => {
  return (
    <Section title="Scrubbing">
      <AtmosFilterList
        gasContext={props.atmosContext}
        selectedGroups={props.scrubbingGroups}
        selectedIds={props.scrubbingIds}
        selectGroup={(group) => props.toggleGroup?.(group)}
        selectId={(id) => props.toggleId?.(id)} />
    </Section>
  );
};

export interface AtmosPortableScubberData {
  atmosContext: GasContext;
  scrubbingIds: AtmosGasIDs;
  scrubbingGroups: AtmosGasGroupFlags;
}

export const AtmosPortableScubber = (props, context) => {
  const { data, act } = useBackend<AtmosPortableScubberData>(context);
  return (
    <AtmosPortable>
      <AtmosPortableScrubberControl
        atmosContext={data.atmosContext}
        scrubbingIds={data.scrubbingIds}
        scrubbingGroups={data.scrubbingGroups}
        toggleId={(id) => act('scrubID', { target: id })}
        toggleGroup={(group) => act('scrubGroup', { target: group })} />
    </AtmosPortable>
  );
};
