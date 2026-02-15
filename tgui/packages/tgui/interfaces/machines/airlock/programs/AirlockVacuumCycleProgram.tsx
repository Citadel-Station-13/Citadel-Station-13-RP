/**
 * @file
 * @license MIT
 */

import { Button, LabeledList, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';
import { ActFunctionType } from '../../../../backend';
import { AirlockSide } from '../types';

export interface AirlockVacuumCycleProgramData {
  interiorSealed: BooleanLike;
  exteriorSealed: BooleanLike;
  side: AirlockSide;
  cycling: {
    fromSide: AirlockSide;
    toSide: AirlockSide;
  } | null;
  cancelling: BooleanLike;
  pressure: number | null;
}

export interface AirlockVacuumCycleProgramContext {
  data: AirlockVacuumCycleProgramData;
  act: ActFunctionType;
}

export const AirlockVacuumCycleProgram = (
  props: AirlockVacuumCycleProgramContext,
) => {
  return (
    <>
      <Stack.Item>
        <Section title="Information">
          <LabeledList>
            <LabeledList.Item label="Pressure">Test</LabeledList.Item>
            <LabeledList.Item label="Interior Doors">Test</LabeledList.Item>
            <LabeledList.Item label="Exterior Doors">Test</LabeledList.Item>
            <LabeledList.Item label="Active Side">Test</LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section title="Controls">
          <Stack vertical>
            <Stack.Item>
              <Stack>
                <Stack.Item grow={1}></Stack.Item>
                <Stack.Item grow={1}>Test</Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              {props.data.cancelling ? (
                <Button.Confirm fluid disabled={!props.data.cycling}>
                  Emergency Stop
                </Button.Confirm>
              ) : (
                <Button fluid disabled={!props.data.cycling}>
                  Cancel
                </Button>
              )}
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </>
  );
};
