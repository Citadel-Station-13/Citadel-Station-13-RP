/**
 * @file
 * @license MIT
 */

import { Section } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

export interface AirlockVacuumCycleProgramData {
  interiorSealed: BooleanLike;
  exteriorSealed: BooleanLike;
}

export interface AirlockVacuumCycleProgramContext {
  data: AirlockVacuumCycleProgramData;
}

export const AirlockVacuumCycleProgram = (props: AirlockVacuumCycleProgramContext) => {
  return (
    <Section fill>
      Test
    </Section>
  );
};
