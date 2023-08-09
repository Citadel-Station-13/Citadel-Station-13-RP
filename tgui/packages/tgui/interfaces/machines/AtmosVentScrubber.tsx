//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { BooleanLike } from "common/react";
import { useBackend } from "../../backend";
import { Button, LabeledList } from "../../components";
import { Section, SectionProps } from "../../components/Section";
import { Window } from "../../layouts";
import { AtmosFilterList, AtmosGasGroupFlags, AtmosGasID, AtmosGasIDs, GasContext } from "../common/Atmos";

export interface AtmosVentScrubberState {
  // are we on siphon mode
  siphon: boolean;
  // are we on high power mode
  expand: boolean;
  // scrubbed IDs
  scrubIDs: AtmosGasIDs;
  // scrubbed groups
  scrubGroups: AtmosGasGroupFlags;
  // are we on?
  power: BooleanLike;
}

interface AtmosVentScrubberControlProps extends SectionProps {
  context: GasContext;
  state: AtmosVentScrubberState;
  powerToggle?: (enabled?: boolean) => void;
  siphonToggle?: (enabled?: boolean) => void;
  expandToggle?: (enabled?: boolean) => void;
  idToggle?: (target: AtmosGasID, enabled?: boolean) => void;
  groupToggle?: (target: AtmosGasGroupFlags, enabled?: boolean) => void;
}

export const AtmosVentScrubberControl = (props: AtmosVentScrubberControlProps) => {
  return (
    <Section {...props}
      buttons={(
        <Button
          icon={props.state.power? 'power-off' : 'times'}
          content={props.state.power? 'On' : 'Off'}
          selected={props.state.power}
          onClick={() => props.powerToggle?.(!props.state.power)} />
      )}>
      <LabeledList>
        <LabeledList.Item label="Mode">
          <Button icon={props.state.siphon? 'sign-in-alt' : 'filter'}
            color={props.state.siphon? 'danger' : undefined}
            content={props.state.siphon? 'Siphoning' : 'Scrubbing'}
            onClick={() => props.siphonToggle?.(!props.state.siphon)} />
        </LabeledList.Item>
        <LabeledList.Item label="Range">
          <Button.Checkbox
            content={props.state.expand? 'Expanded' : 'Normal'}
            onClick={() => props.expandToggle?.(!props.state.expand)} />
        </LabeledList.Item>
        {!props.state.siphon && (
          <AtmosFilterList
            gasContext={props.context}
            selectedGroups={props.state.scrubGroups}
            selectedIds={props.state.scrubIDs}
            selectId={(id) => props.idToggle?.(id, !props.state.scrubIDs.includes(id))}
            selectGroup={(group) => props.groupToggle?.(group, !(props.state.scrubGroups & group))} />
        )}
      </LabeledList>
    </Section>
  );
};

interface AtmosVentScrubberData {
  state: AtmosVentScrubberState
  name: string;
  gasContext: GasContext;
}

export const AtmosVentScrubber = (props, context) => {
  let { act, data } = useBackend<AtmosVentScrubberData>(context);
  return (
    <Window width={500} height={500} title={data.name}>
      <Window.Content>
        <AtmosVentScrubberControl
          state={data.state}
          context={data.gasContext}
          idToggle={(id, on) => act('id', { target: id, on: on })}
          groupToggle={(group, on) => act('group', { target: group, on: on })}
          expandToggle={(on) => act('expand', { target: on })}
          siphonToggle={(on) => act('siphon', { target: on })}
          powerToggle={(on) => act('power', { target: on })} />
      </Window.Content>
    </Window>
  );
};
