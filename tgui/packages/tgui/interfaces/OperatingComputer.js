import { useBackend } from '../backend';
import { AnimatedNumber, LabeledList, NoticeBox, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

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

export const OperatingComputer = (props, context) => {
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

const PatientStateView = (props, context) => {
  const { act, data } = useBackend(context);
  const {
    table,
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
        {data.hasOccupant && (
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
          <LabeledList>
            {procedure.currentStage}
            <LabeledList.Item label="Next Step">
              {procedure.nextSteps}
              {procedure.chems_needed && (
                <>
                  <b>Required Chemicals:</b>
                  <br />
                  {procedure.chems_needed}
                </>
              )}
            </LabeledList.Item>
            {!!data.alternative_step && (
              <LabeledList.Item label="Alternative Step">
                {procedure.alternative_step}
                {procedure.alt_chems_needed && (
                  <>
                    <b>Required Chemicals:</b>
                    <br />
                    {procedure.alt_chems_needed}
                  </>
                )}
              </LabeledList.Item>
            )}
          </LabeledList>
        </Section>
      ))}
    </>
  );
};
