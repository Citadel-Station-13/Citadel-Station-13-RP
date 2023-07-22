import { useBackend } from '../backend';
import { Box, Button, LabeledList, NoticeBox, ProgressBar, Section } from '../components';
import { Window } from '../layouts';

export const PortableGenerator = (props, context) => {
  const { act, data } = useBackend(context);
  const stack_percent = data.fuel_stored / data.fuel_capacity;
  const stackPercentState = (
    stack_percent > 50 && 'good'
    || stack_percent > 15 && 'average'
    || 'bad'
  );
  return (
    <Window
      width={450}
      height={340}>
      <Window.Content scrollable>
        {!data.anchored && (
          <NoticeBox>Generator not anchored.</NoticeBox>
        )}
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Power switch">
              <Button
                icon={data.active ? 'power-off' : 'times'}
                onClick={() => act('toggle_power')}
                disabled={!data.ready_to_boot}>
                {data.active ? 'On' : 'Off'}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label={data.sheet_name}>
              <Box inline color={stackPercentState}>{Math.round(data.fuel_stored / 2000)}</Box>
              {data.fuel_stored >= 2000 && (
                <Button
                  ml={1}
                  icon="eject"
                  disabled={data.active}
                  onClick={() => act('eject')}>
                  Eject
                </Button>
              )}
            </LabeledList.Item>
            <LabeledList.Item label="Current sheet level">
              <ProgressBar
                value={stack_percent}
                ranges={{
                  good: [0.1, Infinity],
                  average: [0.01, 0.1],
                  bad: [-Infinity, 0.01],
                }} />
            </LabeledList.Item>
            <LabeledList.Item label="Heat level">
              {
                data.temperature_current < data.temperature_max / 2 ? (
                  <Box inline color="good">Nominal</Box>
                ) : (
                  (data.temperature_current < data.temperature_max) && !data.temperature_overheat ? (
                    <Box inline color="average">
                      Caution
                    </Box>
                  ) : (
                    <Box inline color="bad">DANGER</Box>
                  )
                )
              }
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Output">
          <LabeledList>
            <LabeledList.Item label="Current output" color={
              data.unsafe_output? "bad" : undefined
            }>
              {data.power_output}
            </LabeledList.Item>
            <LabeledList.Item label="Adjust output">
              <Button
                icon="minus"
                onClick={() => act('lower_power')}>
                {data.power_generated}
              </Button>
              <Button
                icon="plus"
                onClick={() => act('higher_power')}>
                {data.power_generated}
              </Button>
            </LabeledList.Item>
            <LabeledList.Item label="Power available">
              <Box inline color={!data.connected && 'bad'}>
                {data.connected ? data.power_available : "Unconnected"}
              </Box>
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
