/**
 * @file
 * @license MIT
 */

import {
  Button,
  LabeledList,
  ProgressBar,
  Section,
  Stack,
} from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { ActFunctionType } from '../../../../backend';
import {
  airlockSealedStateToName,
  AirlockSide,
  airlockSideToName,
} from '../types';

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
  const act = props.act;
  return (
    <>
      <Stack.Item grow={1}>
        <Section title="Information" fill>
          <LabeledList>
            <LabeledList.Item label="Pressure">
              {props.data.pressure !== null ? (
                <ProgressBar
                  value={props.data.pressure}
                  minValue={0}
                  maxValue={101}
                  color={
                    props.data.pressure < 66 || props.data.pressure > 130
                      ? 'bad'
                      : 'good'
                  }
                />
              ) : (
                'Unknown'
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Interior Doors">
              {airlockSealedStateToName(props.data.interiorSealed)}
            </LabeledList.Item>
            <LabeledList.Item label="Exterior Doors">
              {airlockSealedStateToName(props.data.exteriorSealed)}
            </LabeledList.Item>
            <LabeledList.Item label="Active Side">
              {airlockSideToName(props.data.side)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Stack.Item>
      <Stack.Item>
        <Section
          title="Operations"
          buttons={
            <>
              <Button.Confirm
                color="bad"
                textAlign="center"
                icon="exclamation-triangle"
                confirmIcon="exclamation-triangle"
                disabled={!props.data.cycling}
                onClick={() => act('abort')}
              >
                Abort
              </Button.Confirm>
              <Button
                textAlign="center"
                color="yellow"
                icon="stop"
                onClick={() => act('cancel')}
                disabled={!props.data.cycling || props.data.cancelling}
              >
                Cancel
              </Button>
            </>
          }
        >
          <Stack vertical>
            <Stack.Item>
              <Stack>
                <Stack.Item grow={1}>
                  <Button
                    disabled={!!props.data.cycling}
                    icon="arrow-left"
                    onClick={() => act('cycleToInterior')}
                    textAlign="center"
                    fluid
                  >
                    Cycle to Interior
                  </Button>
                </Stack.Item>
                <Stack.Item grow={1}>
                  <Button
                    disabled={!!props.data.cycling}
                    icon="arrow-right"
                    onClick={() => act('cycleToExterior')}
                    textAlign="center"
                    fluid
                  >
                    Cycle to Exterior
                  </Button>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack>
                <Stack.Item grow={1}>
                  <Button.Confirm
                    disabled={!!props.data.cycling}
                    color="bad"
                    icon="exclamation-triangle"
                    confirmIcon="exclamation-triangle"
                    onClick={() => act('forceInteriorDoors')}
                    textAlign="center"
                    fluid
                  >
                    Force Interior Door
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item grow={1}>
                  <Button.Confirm
                    disabled={!!props.data.cycling}
                    color="bad"
                    icon="exclamation-triangle"
                    confirmIcon="exclamation-triangle"
                    fluid
                    textAlign="center"
                    onClick={() => act('forceExteriorDoors')}
                  >
                    Force Exterior Door
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Section>
      </Stack.Item>
    </>
  );
};
