//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { LabeledList, Section } from "tgui-core/components";

import { useBackend } from "../../backend";
import { SectionProps } from "../../components";
import { AtmosFilterList, AtmosGasGroupFlags, AtmosGasIDs, GasContext } from "../common/Atmos";
import { AtmosPortable } from "../common/AtmosPortable";

interface AtmosPortableScrubberControlProps extends SectionProps {
  readonly atmosContext: GasContext;
  readonly scrubbingIds: AtmosGasIDs;
  readonly scrubbingGroups: AtmosGasGroupFlags;
  readonly toggleId?: (id) => void;
  readonly toggleGroup?: (group) => void;
}

export const AtmosPortableScrubberControl = (props: AtmosPortableScrubberControlProps) => {
  return (
    <Section title="Scrubbing" {...props}>
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
  moleRate: number;
}

export const AtmosPortableScrubber = (props) => {
  const { data, act } = useBackend<AtmosPortableScubberData>();
  return (
    <AtmosPortable
      minimumWidth={430}
      minimumHeight={600}
      name="Portable Air Scrubber"
      additionalListItems={(
        <LabeledList.Item label="Current Flow">
          {data.moleRate} mol/s
        </LabeledList.Item>
      )}>
      <AtmosPortableScrubberControl
        fill
        scrollable
        atmosContext={data.atmosContext}
        scrubbingIds={data.scrubbingIds}
        scrubbingGroups={data.scrubbingGroups}
        toggleId={(id) => act('scrubID', { target: id })}
        toggleGroup={(group) => act('scrubGroup', { target: group })} />
    </AtmosPortable>
  );
};
