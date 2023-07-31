import { InfernoNode } from "inferno";
import { BooleanLike } from "../../../common/react";
import { useBackend } from "../../backend";
import { Button, LabeledList, NumberInput, ProgressBar, Section, Stack } from "../../components";
import { ComponentProps } from "../../components/Component";
import { SectionProps } from "../../components/Section";
import { Window } from "../../layouts";

export enum AtmosComponentUIFlags {
  None = 0,
  TogglePower = (1<<0),
  SetPowerLimit = (1<<1),
  SeePowerUsage = (1<<2),
}

export interface AtmosComponentControlProps extends SectionProps {
  // data
  data: AtmosComponentData;
  // power toggle
  togglePowerAct?: (on: boolean) => void;
  // set target maximum power draw
  setPowerLimitAct?: (watts: number) => void;
  // additional entries
  additionalListItems?: InfernoNode;
}

export const AtmosComponentControl = (props: AtmosComponentControlProps, context) => {
  return (
    <Section title="Flow" {...props}>
      <LabeledList>
        {(props.data.controlFlags & AtmosComponentUIFlags.TogglePower) && (
          <LabeledList.Item label="Enabled">
            <Button
              content={props.data.on? "On" : "Off"}
              selected={props.data.on}
              onClick={() => props.togglePowerAct?.(!props.data.on)} />
          </LabeledList.Item>
        )}
        {(props.data.controlFlags & AtmosComponentUIFlags.SetPowerLimit) && (
          <LabeledList.Item label="Power">
            <NumberInput minValue={0} maxValue={props.data.powerRating}
              value={props.data.powerSetting} onChange={(e, val) => props.setPowerLimitAct?.(val)} />
          </LabeledList.Item>
        )}
        {(props.data.controlFlags & AtmosComponentUIFlags.SeePowerUsage) && (
          <LabeledList.Item label="Draw">
            <ProgressBar minValue={0} maxValue={props.data.powerRating}
              value={props.data.powerUsage} color="default" />
          </LabeledList.Item>
        )}
        {props.additional}
      </LabeledList>
    </Section>
  );
};

export interface AtmosComponentData {
  // component UI flags
  controlFlags: AtmosComponentUIFlags;
  // on?
  on: BooleanLike;
  // power limit in W
  powerSetting: number;
  // max power limit in W
  powerRating: number;
  // power used
  powerUsage: number;
}

export interface AtmosComponentProps extends ComponentProps {
  extraHeight?: number;
  additionalListItems?: InfernoNode;
}

export const AtmosComponent = (props: AtmosComponentProps, context) => {
  const { data, act } = useBackend<AtmosComponentData>(context);
  return (
    <Window width={500} height={300 + (props.extraHeight || 0)}>
      <Window.Content>
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <AtmosComponentControl
                data={data}
                togglePowerAct={() => act('togglePower')}
                setPowerLimitAct={(watts) => act('setPowerDraw', { target: watts })}
                additionalListItems={props.additionalListItems} />
            </Stack.Item>
            {props.children && (
              <Stack.Item grow>
                {props.children}
              </Stack.Item>
            )}
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
