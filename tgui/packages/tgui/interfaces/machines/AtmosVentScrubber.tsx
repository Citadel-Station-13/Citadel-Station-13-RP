//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { Button, LabeledList, Section } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { useBackend } from "../../backend";
import { SectionProps } from "../../components";
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
  readonly context: GasContext;
  readonly state: AtmosVentScrubberState;
  readonly powerToggle?: (enabled?: boolean) => void;
  readonly siphonToggle?: (enabled?: boolean) => void;
  readonly expandToggle?: (enabled?: boolean) => void;
  readonly idToggle?: (target: AtmosGasID, enabled?: boolean) => void;
  readonly groupToggle?: (target: AtmosGasGroupFlags, enabled?: boolean) => void;
  // standalone window? will make button a list item instead of section item.
  readonly standalone?: boolean;
}

export const AtmosVentScrubberControl = (props: AtmosVentScrubberControlProps) => {
  return (
    <Section {...props}
      buttons={!props.standalone && (
        <Button
          icon={props.state.power ? 'power-off' : 'times'}
          content={props.state.power ? 'On' : 'Off'}
          selected={props.state.power}
          onClick={() => props.powerToggle?.(!props.state.power)} />
      )}>
      <LabeledList>
        {props.standalone && (
          <LabeledList.Item label="Power">
            <Button
              icon={props.state.power ? 'power-off' : 'times'}
              content={props.state.power ? 'On' : 'Off'}
              selected={props.state.power}
              onClick={() => props.powerToggle?.(!props.state.power)} />
          </LabeledList.Item>
        )}
        <LabeledList.Item label="Mode">
          <Button icon={props.state.siphon ? 'sign-in-alt' : 'filter'}
            color={props.state.siphon ? 'danger' : undefined}
            content={props.state.siphon ? 'Siphoning' : 'Scrubbing'}
            onClick={() => props.siphonToggle?.(!props.state.siphon)} />
        </LabeledList.Item>
        <LabeledList.Item label="Range">
          <Button.Checkbox
            content={props.state.expand ? 'Expanded' : 'Normal'}
            selected={props.state.expand}
            onClick={() => props.expandToggle?.(!props.state.expand)} />
        </LabeledList.Item>
      </LabeledList>
      {!props.state.siphon && (
        <AtmosFilterList
          width="100%"
          gasContext={props.context}
          selectedGroups={props.state.scrubGroups}
          selectedIds={props.state.scrubIDs}
          selectId={(id) => props.idToggle?.(id, !props.state.scrubIDs.includes(id))}
          selectGroup={(group) => props.groupToggle?.(group, !(props.state.scrubGroups & group))} />
      )}
    </Section>
  );
};

interface AtmosVentScrubberData {
  state: AtmosVentScrubberState
  name: string;
  gasContext: GasContext;
}

export const AtmosVentScrubber = (props) => {
  let { act, data } = useBackend<AtmosVentScrubberData>();
  return (
    <Window width={450} height={275} title={data.name}>
      <Window.Content>
        <AtmosVentScrubberControl
          scrollable
          fill
          state={data.state}
          context={data.gasContext}
          idToggle={(id, on) => act('id', { target: id, on: on })}
          groupToggle={(group, on) => act('group', { target: group, on: on })}
          expandToggle={(on) => act('expand', { target: on })}
          siphonToggle={(on) => act('siphon', { target: on })}
          powerToggle={(on) => act('power', { target: on })}
          standalone />
      </Window.Content>
    </Window>
  );
};
