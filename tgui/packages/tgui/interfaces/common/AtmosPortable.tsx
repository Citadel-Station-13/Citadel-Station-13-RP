import { InfernoNode } from "inferno";
import { BooleanLike } from "../../../common/react";
import { useBackend } from "../../backend";
import { Button, LabeledList, NumberInput, ProgressBar, Section, Stack } from "../../components";
import { ComponentProps } from "../../components/Component";
import { SectionProps } from "../../components/Section";
import { Window } from "../../layouts";
import { AtmosTank, AtmosTankSlot } from "./Atmos";

enum AtmosPortableUIFlags {
  None = (0),
  ViewFlow = (1<<0),
  TogglePower = (1<<1),
  SetFlow = (1<<2),
}

interface AtmosPortableControlProps extends SectionProps {
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
    <Section title="Flow" {...props}>
      <LabeledList>
        {props.data.controlFlags & AtmosPortableUIFlags.TogglePower && (
          <LabeledList.Item label="Power">
            <Button color="transparent" content={props.data.on? "On" : "Off"}
              onClick={() => props.toggleAct?.()} />
          </LabeledList.Item>
        )}
        {props.data.controlFlags & AtmosPortableUIFlags.SetFlow? (
          <LabeledList.Item label="Flow Limit">
            <NumberInput value={props.data.flowSetting}
              maxValue={props.data.flowMax} onChange={(e, val) => props.setFlowAct?.(val)} />
          </LabeledList.Item>
        ) : (!!(props.data.controlFlags & AtmosPortableUIFlags.ViewFlow) && (
          <LabeledList.Item label="Flow Status">
            {props.data.flow} L/s
          </LabeledList.Item>
        ))}
      </LabeledList>
    </Section>
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
  // held tank
  tank: AtmosTank | null;
}

interface AtmosPortableProps extends ComponentProps{
  extraHeight?: number;
  additionalListItems?: InfernoNode;
}

export const AtmosPortable = (props: AtmosPortableProps, context) => {
  const { data, act } = useBackend<AtmosPortableData>(context);
  let extraHeight = 0;
  if (data.useCell) {
    extraHeight += 300;
  }
  return (
    <Window width={500} height={300 + extraHeight + (props.extraHeight || 0)}>
      <Window.Content>
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <AtmosPortableControl
                additionalListItems={props.additionalListItems}
                data={data}
                toggleAct={() => act('togglePower')}
                setFlowAct={(amt) => act('setFlow', { value: amt })} />
            </Stack.Item>
            {data.useCell && (
              <Stack.Item>
                <Section title="Cell">
                  <ProgressBar value={data.charge / data.maxCharge} />
                </Section>
              </Stack.Item>
            )}
            <Stack.Item>
              <AtmosTankSlot tank={data.tank} ejectAct={() => act('eject')} />
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
