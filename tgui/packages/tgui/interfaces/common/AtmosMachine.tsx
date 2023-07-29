import { BooleanLike } from "../../../common/react";
import { useBackend } from "../../backend";
import { Section, Stack } from "../../components";
import { ComponentProps } from "../../components/Component";
import { Window } from "../../layouts";

export enum AtmosComponentUIFlags {
  None = 0,
  TogglePower = (1<<0),
  SetPowerLimit = (1<<1),
}

export interface AtmosComponentControlProps extends ComponentProps {
  // data
  data: AtmosComponentData;
  // power toggle
  togglePowerAct?: () => void;
  // set target maximum power draw
  setPowerLimitAct?: (watts: number) => void;
}

export const AtmosComponentControl = (props, context) => {

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
}

export interface AtmosComponentProps extends ComponentProps {
  extraHeight: number;
}

export const AtmosComponent = (props: AtmosComponentProps, context) => {
  const { data, act } = useBackend<AtmosComponentData>(context);
  return (
    <Window>
      <Window.Content>
        <Section fill>
          <Stack vertical fill>
            <Stack.Item>
              <AtmosComponentControl
                data={data}
                togglePowerAct={() => act('togglePower')}
                setPowerLimitAct={(watts) => act('setPowerDraw', { target: watts })} />
            </Stack.Item>
          </Stack>
        </Section>
      </Window.Content>
    </Window>
  );
};
