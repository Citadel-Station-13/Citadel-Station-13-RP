/**
 * @file
 * @license MIT
 */

import { LabeledList, Section, Stack } from 'tgui-core/components';
import { capitalize } from 'tgui-core/string';

import { useBackend } from '../../../backend';
import { Window } from '../../../layouts';
import { AirlockVacuumCycleProgram } from './programs/AirlockVacuumCycleProgram';
import { AirlockCyclingData } from './types';

interface AirlockSystemData {
  cycling: AirlockCyclingData | null;
  programTgui: string | null;
  programData: null | any;
}

export const AirlockSystem = (props) => {
  const { act, data } = useBackend<AirlockSystemData>();
  return (
    <Window title="Airlock System" width={400} height={400}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow={1} shrink={1}>
            <Section title="System" scrollable>
              <LabeledList>
                {data.cycling ? (
                  <>
                    <LabeledList.Item label="Status">
                      {capitalize(data.cycling.cyclingDesc)}
                    </LabeledList.Item>
                    <LabeledList.Item label="Operation">
                      {capitalize(data.cycling.phaseVerb)}
                    </LabeledList.Item>
                    {data.cycling.tasks.map((t, i) => (
                      <LabeledList.Item
                        key={t.ref}
                        label={i === 0 ? 'Tasks' : ''}
                      >
                        {t.reason}
                      </LabeledList.Item>
                    ))}
                  </>
                ) : (
                  <LabeledList.Item label="Status">Idle</LabeledList.Item>
                )}
              </LabeledList>
            </Section>
          </Stack.Item>
          {!!data.programTgui && (
            <AirlockProgramRender
              programComp={data.programTgui}
              programData={data.programData}
            />
          )}
        </Stack>
      </Window.Content>
    </Window>
  );
};

/**
 * @details The enclosed program is responsible for wrapping itself in Stack.Item's as needed.
 * @param props
 * @returns
 */
const AirlockProgramRender = (props: {
  programComp: string;
  programData: any;
}) => {
  const { act } = useBackend();
  switch (props.programComp) {
    case 'VacuumCycle':
      return AirlockVacuumCycleProgram({
        data: props.programData,
        act: (a, p) => act('programAct', { action: a, params: p }),
      });
  }
};
