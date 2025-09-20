import { AnimatedNumber, Divider, LabeledList, NoticeBox, ProgressBar, Section } from 'tgui-core/components';

import { useBackend } from '../../backend';
import { Window } from '../../layouts';

const damageTypes = [
  {
    label: 'Brute',
    type: 'bruteLoss',
  },
  {
    label: 'Burn',
    type: 'fireLoss',
  },
  {
    label: 'Toxin',
    type: 'toxLoss',
  },
  {
    label: 'Respiratory',
    type: 'oxyLoss',
  },
];

const patientStates = {
  0: {
    color: 'good',
    statText: 'Conscious',
  },
  1: {
    color: 'average',
    statText: 'Unconscious',
  },
  2: {
    color: 'bad',
    statText: 'Dead',
  },
  3: {
    color: 'light-gray',
    statText: 'Unknown',
  },
};

export const OperatingComputer = (props) => {
  return (
    <Window
      width={350}
      height={470}>
      <Window.Content scrollable>
        <PatientStateView />
      </Window.Content>
    </Window>
  );
};

const PatientStateView = (props) => {
  const { act, data } = useBackend<any>();
  const {
    table,
    hasOccupant,
    patient,
  } = data;
  const patientStat = patientStates[patient.stat] || patientStates[3];
  if (!table) {
    return (
      <NoticeBox>
        No Table Detected
      </NoticeBox>
    );
  }
  return (
    <>
      <Section title={patient.name || "Patient State"}>
        {hasOccupant && (
          <LabeledList>
            <LabeledList.Item
              label="State"
              color={patientStat.color}>
              {patientStat.statText}
            </LabeledList.Item>
            <LabeledList.Item label="Blood Type">
              {patient.bloodType}
            </LabeledList.Item>
            <LabeledList.Item label="Health">
              <ProgressBar
                value={patient.health}
                minValue={patient.minHealth}
                maxValue={patient.maxHealth}
                color={patient.health >= 0 ? 'good' : 'average'}>
                <AnimatedNumber value={patient.health} />
              </ProgressBar>
            </LabeledList.Item>
            {damageTypes.map(type => (
              <LabeledList.Item key={type.type} label={type.label}>
                <ProgressBar
                  value={patient[type.type] / patient.maxHealth}
                  color="bad">
                  <AnimatedNumber value={patient[type.type]} />
                </ProgressBar>
              </LabeledList.Item>
            ))}
          </LabeledList>
        ) || (
          'No Patient Detected'
        )}
      </Section>
      {(patient.procedures?.length === 0) && (
        <Section>
          No Active Procedures
        </Section>
      )}
      {patient.procedures?.map(procedure => (
        <Section
          key={procedure.name}
          title={procedure.name}>
          <i>{procedure.currentStage}</i>
          <Divider />
          <LabeledList>
            {Object.entries(procedure.nextSteps).map(([k, v]) => (
              <LabeledList.Item key={k} label={k}>
                {v as any}
              </LabeledList.Item>
            ))}
          </LabeledList>
        </Section>
      ))}
    </>
  );
};
