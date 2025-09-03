//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { Button, LabeledList, NumberInput } from "tgui-core/components";
import { Section } from "tgui-core/components";
import { round } from "tgui-core/math";
import { BooleanLike } from "tgui-core/react";

import { useBackend } from "../../backend";
import { SectionProps } from "../../components";
import { Window } from "../../layouts";

export enum AtmosVentPumpPressureChecks {
  None = 0,
  External = (1 << 0),
  Internal = (1 << 1),
}

export interface AtmosVentPumpState {
  pressureChecks: AtmosVentPumpPressureChecks;
  internalPressure: number;
  externalPressure: number;
  // on / off
  power: BooleanLike;
  // true for in
  siphon: BooleanLike;
}

export type AtmosVentPressureTarget = number | 'default';

interface AtmosVentPumpControlProps extends SectionProps {
  // act() for toggling vent; if this isn't provided, the button is disabled.
  readonly powerToggle?: (enabled?: boolean) => void;
  // act() for toggling pumping out; if this isn't provided, the button is disabled.
  readonly dirToggle?: (siphon?: boolean) => void;
  // set internal pressure check
  readonly internalSet?: (target: AtmosVentPressureTarget) => void;
  // set external pressure check
  readonly externalSet?: (target: AtmosVentPressureTarget) => void;
  // act() for toggling internal checks
  readonly internalToggle?: (enabled?: boolean) => void;
  // act() for toggling external checks
  readonly externalToggle?: (enabled?: boolean) => void;
  // vent data
  readonly state: AtmosVentPumpState;
  // standalone window? will make button a list item instead of section item.
  readonly standalone?: boolean;
}

/**
 * Embeddable atmos vent control.
 */
export const AtmosVentPumpControl = (props: AtmosVentPumpControlProps) => {
  return (
    <Section {...props} buttons={!props.standalone && (
      <Button icon={props.state.power ? 'power-off' : 'times'}
        selected={props.state.power} content={props.state.power ? 'On' : 'Off'}
        onClick={() => props.powerToggle?.(!props.state.power)} />
    )}>
      <LabeledList>
        {props.standalone && (
          <LabeledList.Item label="Power">
            <Button
              icon={props.state.power ? 'power-off' : 'times'}
              selected={props.state.power} content={props.state.power ? 'On' : 'Off'}
              onClick={() => props.powerToggle?.(!props.state.power)} />
          </LabeledList.Item>
        )}
        <LabeledList.Item label="Mode">
          <Button icon="sign-in-alt"
            content={props.state.siphon ? 'Siphoning' : 'Pressurizing'}
            color={props.state.siphon ? 'danger' : undefined}
            onClick={() => props.dirToggle?.(!props.state.siphon)} />
        </LabeledList.Item>
        <LabeledList.Item label="Pressure Checks">
          <Button icon="sign-in-alt"
            content="Internal"
            selected={props.state.pressureChecks & AtmosVentPumpPressureChecks.Internal}
            onClick={() => props.internalToggle?.(
              !(props.state.pressureChecks & AtmosVentPumpPressureChecks.Internal)
            )} />
          <Button icon="sign-in-alt"
            content="External"
            selected={props.state.pressureChecks & AtmosVentPumpPressureChecks.External}
            onClick={() => props.externalToggle?.(
              !(props.state.pressureChecks & AtmosVentPumpPressureChecks.External)
            )} />
        </LabeledList.Item>
        <LabeledList.Item label="Internal Target"
          buttons={(
            <Button.Confirm
              content="Reset"
              icon="undo"
              onClick={() => props.internalSet?.('default')} />
          )}>
          <NumberInput
            value={round(props.state.internalPressure, 2)}
            unit="kPa"
            width="120px"
            minValue={0}
            step={10}
            maxValue={101.325 * 500}
            onChange={(val) => props.internalSet?.(val)} />
        </LabeledList.Item>
        <LabeledList.Item label="External Target"
          buttons={(
            <Button.Confirm
              content="Reset"
              icon="undo"
              onClick={() => props.externalSet?.('default')} />
          )}>
          <NumberInput
            value={round(props.state.externalPressure, 2)}
            unit="kPa"
            width="120px"
            minValue={0}
            step={10}
            maxValue={101.325 * 500}
            onChange={(val) => props.externalSet?.(val)} />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

interface AtmosVentPumpData {
  // vent state
  state: AtmosVentPumpState;
  // vent name
  name: string;
}

export const AtmosVentPump = (props) => {
  let { data, act } = useBackend<AtmosVentPumpData>();

  return (
    <Window width={350} height={185} title={data.name}>
      <Window.Content>
        <AtmosVentPumpControl
          scrollable
          fill
          state={data.state}
          powerToggle={(on) => act('toggle')}
          dirToggle={(siphon) => act('siphon')}
          internalToggle={(on) => act('intCheck')}
          externalToggle={(on) => act('extCheck')}
          internalSet={(kpa) => act('intPressure', { target: kpa })}
          externalSet={(kpa) => act('extPressure', { target: kpa })}
          standalone />
      </Window.Content>
    </Window>
  );
};
