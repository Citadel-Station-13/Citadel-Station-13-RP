/**
 * @file
 * @license MIT
 */

import { Window } from "../../../layouts";
import { AirlockVacuumCycleProgram } from "./programs/AirlockVacuumCycleProgram";

export const AirlockSystem = (props) => {
  return (
    <Window>
      <Window.Content>
        Test
      </Window.Content>
    </Window>
  );
};

const AirlockProgramRender = (props: {
  programComp: string;
  programData: any;
}) => {
  switch (props.programComp) {
    case 'VacuumCycle':
      return AirlockVacuumCycleProgram({ data: props.programData });
  }
};
