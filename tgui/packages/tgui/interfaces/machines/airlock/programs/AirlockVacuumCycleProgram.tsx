/**
 * @file
 * @license MIT
 */

import { Section, Stack } from 'tgui-core/components';
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
    <Section fill title="Program">
      <Stack>Test</Stack>
    </Section>
  );
};
