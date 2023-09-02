import { round } from "common/math";
import { InfernoNode } from "inferno";
import { BooleanLike } from "../../../common/react";
import { useBackend } from "../../backend";
import { AnimatedNumber, Button, LabeledList, NumberInput, ProgressBar, Section, Stack } from "../../components";
import { ComponentProps } from "../../components/Component";
import { Window } from "../../layouts";
import { AtmosTank, AtmosTankSlot } from "./Atmos";

enum AtmosPortableUIFlags {
  None = (0),
  ViewFlow = (1<<0),
  TogglePower = (1<<1),
  SetFlow = (1<<2),
  SetPower = (1<<3),
  SeePower = (1<<4),
}

interface AtmosPortableControlProps {
  // portable data
  data: AtmosPortableData;
  // toggle on/off act
  toggleAct?: () => void;
  // set flow act
  setFlowAct?: (amt: number) => void;
  // any additional list items
  additionalListItems?: InfernoNode;
}

export const AtmosPortableControl = (props: AtmosPortableControlProps, context) => {
  return (
    <>
      <Section title="Status"
        buttons={props.data.controlFlags & AtmosPortableUIFlags.TogglePower && (
          <Button content={props.data.on? "On" : "Off"}
            onClick={() => props.toggleAct?.()}
            selected={props.data.on}
            icon={props.data.on? 'power-off' : 'times'} />
        )}>
        <LabeledList>
          <LabeledList.Item label="Pressure">
            <AnimatedNumber value={props.data.pressure} />{` kPa`}
          </LabeledList.Item>
          <LabeledList.Item label="Temperature">
            <AnimatedNumber value={props.data.temperature} />{` kPa`}
          </LabeledList.Item>
          <LabeledList.Item label="Port" color={props.data.portConnected? "good" : "average"}>
            {props.data.portConnected? "Connected" : "Not Connected"}
          </LabeledList.Item>
        </LabeledList>
      </Section>
      <Section title="Flow">
        <LabeledList>
          {props.data.controlFlags & AtmosPortableUIFlags.SetFlow? (
            <LabeledList.Item label="Flow Limit">
              <NumberInput value={props.data.flowSetting}
                maxValue={props.data.flowMax} onChange={(e, val) => props.setFlowAct?.(val)}
                unit="L/s" />
            </LabeledList.Item>
          ) : (!!(props.data.controlFlags & AtmosPortableUIFlags.ViewFlow) && (
            <LabeledList.Item label="Flow Status">
              {props.data.flow} L/s
            </LabeledList.Item>
          ))}
          {props.additionalListItems}
        </LabeledList>
      </Section>
      {props.data.useCell && (
        <Section title="Power">
          <LabeledList>
            <LabeledList.Item label="Cell">
              <ProgressBar value={props.data.maxCharge? (props.data.charge / props.data.maxCharge) : 0}>
                {props.data.charge? (round(props.data.charge / props.data.maxCharge, 1) * 100) : 0}%
              </ProgressBar>
            </LabeledList.Item>
            {!!(props.data.controlFlags & AtmosPortableUIFlags.SetPower) && (
              <LabeledList.Item label="Power Limit">
                WIP! Contact a dev.
              </LabeledList.Item>
            )}
            {!!(props.data.controlFlags & AtmosPortableUIFlags.SeePower) && (
              <LabeledList.Item label="Power Usage">
                {props.data.powerCurrent} W
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      )}
    </>
  );
};



export interface AtmosPortableData {
  // UI control flgas
  controlFlags: AtmosPortableUIFlags;
  // on
  on: BooleanLike;
  // uses charge
  useCharge: BooleanLike;
  // cell maxcharge
  maxCharge: number;
  // cell charge
  charge: number;
  // cell inserted
  hasCell: BooleanLike;
  // uses cells at all
  useCell: BooleanLike;
  // flow rate
  flow: number;
  // flow max
  flowMax: number;
  // flow setting
  flowSetting: number;
  // power max
  powerRating: number;
  // power setting
  powerSetting: number;
  // power used
  powerCurrent: number;
  // held tank
  tank: AtmosTank | null;
  // internal pressure
  pressure: number;
  // internal temperature
  temperature: number;
  // is port connected?
  portConnected: BooleanLike;
}

interface AtmosPortableProps extends ComponentProps{
  minimumHeight?: number;
  minimumWidth?: number;
  name: string;
  additionalListItems?: InfernoNode;
}

export const AtmosPortable = (props: AtmosPortableProps, context) => {
  const { data, act } = useBackend<AtmosPortableData>(context);
  let extraHeight = 0;
  if (data.useCell) {
    extraHeight += 100;
  }
  let width = Math.max(400, props.minimumWidth || 0);
  let height = Math.max(400 + extraHeight, props.minimumHeight || 0);
  return (
    <Window title={props.name} width={width} height={height}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <AtmosPortableControl
              additionalListItems={props.additionalListItems}
              data={data}
              toggleAct={() => act('togglePower')}
              setFlowAct={(amt) => act('setFlow', { value: amt })} />
          </Stack.Item>
          <Stack.Item>
            <AtmosTankSlot tank={data.tank} ejectAct={() => act('eject')} />
          </Stack.Item>
          {props.children && (
            <Stack.Item grow>
              {props.children}
            </Stack.Item>
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};
