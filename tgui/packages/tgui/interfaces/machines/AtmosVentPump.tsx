//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

import { round } from "common/math";
import { BooleanLike } from "common/react";
import { useBackend } from "../../backend";
import { Button, LabeledList, NumberInput } from "../../components";
import { Section, SectionProps } from "../../components/Section";
import { Window } from "../../layouts";

export enum AtmosVentPumpPressureChecks {
  None = 0,
  External = (1<<0),
  Internal = (1<<1),
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
  powerToggle?: (enabled?: boolean) => void;
  // act() for toggling pumping out; if this isn't provided, the button is disabled.
  dirToggle?: (siphon?: boolean) => void;
  // set internal pressure check
  internalSet?: (target: AtmosVentPressureTarget) => void;
  // set external pressure check
  externalSet?: (target: AtmosVentPressureTarget) => void;
  // act() for toggling internal checks
  internalToggle?: (enabled?: boolean) => void;
  // act() for toggling external checks
  externalToggle?: (enabled?: boolean) => void;
  // vent data
  state: AtmosVentPumpState;
}

/**
 * Embeddable atmos vent control.
 */
export const AtmosVentPumpControl = (props: AtmosVentPumpControlProps) => {
  return (
    <Section {...props} buttons={(
      <Button icon={props.state.power? 'power-off' : 'times'}
        selected={props.state.power} content={props.state.power? 'On' : 'Off'}
        onClick={() => props.powerToggle?.(!props.state.power)} />
    )}>
      <LabeledList>
        <LabeledList.Item label="Mode">
          <Button icon="sign-in-alt"
            content={props.state.siphon? 'Siphoning' : 'Pressurizing'}
            color={props.state.siphon? 'danger' : undefined}
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
        <LabeledList.Item label="Internal Target">
          <NumberInput
            value={round(props.state.internalPressure, 2)}
            unit="kPa"
            width="75px"
            minValue={0}
            step={10}
            maxValue={101.325 * 500}
            onChange={(e, val) => props.internalSet?.(val)} />
          <Button.Confirm
            content="Reset"
            icon="undo"
            onClick={() => props.internalSet?.('default')} />
        </LabeledList.Item>
        <LabeledList.Item label="External Target">
          <NumberInput
            value={round(props.state.externalPressure, 2)}
            unit="kPa"
            width="75px"
            minValue={0}
            step={10}
            maxValue={101.325 * 500}
            onChange={(e, val) => props.externalSet?.(val)} />
          <Button.Confirm
            content="Reset"
            icon="undo"
            onClick={() => props.externalSet?.('default')} />
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

export const AtmosVentPump = (props, context) => {
  let { data, act } = useBackend<AtmosVentPumpData>(context);

  return (
    <Window width={300} height={500} title={data.name}>
      <Window.Content>
        <AtmosVentPumpControl
          state={data.state}
          powerToggle={(on) => act('toggle')}
          dirToggle={(siphon) => act('siphon')}
          internalToggle={(on) => act('intCheck')}
          externalToggle={(on) => act('extCheck')}
          internalSet={(kpa) => act('intPressure', { target: kpa })}
          externalSet={(kpa) => act('extPressure', { target: kpa })} />
      </Window.Content>
    </Window>
  );
};
