import { useBackend } from "../backend";
import { Button, LabeledList, Section, NumberInput, AnimatedNumber } from "../components";
import { Window } from "../layouts";

export const heat_pump = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    target_temp,
    current_temp,
    sink_temp,
    power_level,
    max_power_level,
    on,
    lowest_temp,
  } = data;

  return (
    <Window
      width={395}
      height={145}>
      <Window.Content>
        <Section>
          <LabeledList>
            <LabeledList.Item label="Power">
              <Button
                icon={on ? 'power-off' : 'times'}
                content={on ? 'On' : 'Off'}
                selected={on}
                onClick={() => act('power')} />
            </LabeledList.Item>
            <LabeledList.Item label="Current Temperature">
              <AnimatedNumber value={current_temp} /> Kelvin
            </LabeledList.Item>
            <LabeledList.Item label="Sink Temperature">
              <AnimatedNumber value={sink_temp} /> Kelvin
            </LabeledList.Item>
            <LabeledList.Item label="Target Temperature">
              <Button
                ml={1}
                icon="minus"
                content="min"
                disabled={target_temp === lowest_temp}
                onClick={() => act('target_temp', {
                  temperature: lowest_temp,
                })} />
              <NumberInput
                animated
                value={parseFloat(target_temp)}
                unit="K"
                width="75px"
                minValue={lowest_temp}
                step={10}
                onChange={(e, value) => act('target_temp', {
                  temperature: value,
                })} />
              <Button
                ml={1}
                icon="plus"
                content="Max"
                disabled={target_temp === 100000}
                onClick={() => act('target_temp', {
                  temperature: 100000,
                })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
