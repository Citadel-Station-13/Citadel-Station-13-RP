import { useBackend } from '../backend';
import {
  Button,
  LabeledList,
  ProgressBar,
  Section,
  AnimatedNumber,
} from '../components';
import { formatPower, formatSiUnit } from '../format';
import { Fragment } from 'inferno';
import { Window } from '../layouts';

export const MassiveHeatPump = (props, context) => {
  const { act, data } = useBackend(context);

  const {
    power_level,
    target_temp,
    current_temp,
    sink_temp,
    on,
    lowest_temp,
    efficiency,
    highest_temp,
    last_power_draw,
    max_power_draw,
  } = data;

  return (
    <Window width={470} height={270} resizable>
      <Window.Content>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Efficiency">
              <AnimatedNumber value={efficiency * 100} /> %
            </LabeledList.Item>
            <LabeledList.Item label="Current Temperaute">
              <AnimatedNumber value={current_temp} /> K
            </LabeledList.Item>
            <LabeledList.Item label="Sink Temperature">
              <AnimatedNumber value={sink_temp} /> K
            </LabeledList.Item>
            <LabeledList.Item label="Load">
              <ProgressBar
                value={last_power_draw}
                minValue={0}
                maxValue={power_level}
                color={last_power_draw < power_level - 5 ? 'good' : 'average'}
              >
                {formatPower(last_power_draw)}
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section
          title="Controls"
          buttons={
            <Button
              icon="power-off"
              content={on ? 'On' : 'Off'}
              selected={on}
              onClick={() => act('power')}
            />
          }
        >
          <LabeledList>
            <LabeledList.Item
              label="Target Temperature"
              buttons={
                <Fragment>
                  <Button
                    icon="compress-arrows-alt"
                    content="MIN"
                    onClick={() => act('set_temp', { temp: 'min' })}
                  />
                  <Button
                    icon="expand-arrows-alt"
                    content="MAX"
                    onClick={() => act('set_temp', { temp: 'max' })}
                  />
                  <Button
                    icon="wrench"
                    content="SET"
                    onClick={() => act('set_temp', { temp: 'set' })}
                  />
                </Fragment>
              }
            >
              {formatSiUnit(target_temp, 0, 'K')}
            </LabeledList.Item>
            <LabeledList.Item
              label="Power Level"
              buttons={
                <Fragment>
                  <Button
                    icon="compress-arrows-alt"
                    content="MIN"
                    onClick={() => act('set_pow', { pow: 'min' })}
                  />
                  <Button
                    icon="expand-arrows-alt"
                    content="MAX"
                    onClick={() => act('set_pow', { pow: 'max' })}
                  />
                  <Button
                    icon="wrench"
                    content="SET"
                    onClick={() => act('set_pow', { pow: 'set' })}
                  />
                </Fragment>
              }
            >
              {formatPower(power_level)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
