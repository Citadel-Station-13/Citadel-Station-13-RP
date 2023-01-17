import { useBackend } from '../backend';
import { Button, LabeledList, ProgressBar, Section, AnimatedNumber } from '../components';
import { formatPower } from '../format';
import { Fragment } from 'inferno';
import { Window } from '../layouts';

export const MassiveGasPump = (props, context) => {
  const { act, data } = useBackend(context);

  const { on, pressure_set, last_flow_rate, last_power_draw, power_level } =
    data;

  return (
    <Window width={470} height={250} resizable>
      <Window.Content>
        <Section title="Status">
          <LabeledList>
            <LabeledList.Item label="Effic">
              <AnimatedNumber value={last_flow_rate / 10} /> L/s
            </LabeledList.Item>
            <LabeledList.Item label="Load">
              <ProgressBar
                value={last_power_draw}
                minValue={0}
                maxValue={power_level}
                color={last_power_draw < power_level - 5 ? 'good' : 'average'}>
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
          }>
          <LabeledList>
            <LabeledList.Item
              label="Output Pressure"
              buttons={
                <Fragment>
                  <Button
                    icon="compress-arrows-alt"
                    content="MIN"
                    onClick={() => act('set_press', { press: 'min' })}
                  />
                  <Button
                    icon="expand-arrows-alt"
                    content="MAX"
                    onClick={() => act('set_press', { press: 'max' })}
                  />
                  <Button
                    icon="wrench"
                    content="SET"
                    onClick={() => act('set_press', { press: 'set' })}
                  />
                </Fragment>
              }>
              {pressure_set / 100} kPa
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
              }>
              {formatPower(power_level)}
            </LabeledList.Item>
          </LabeledList>
        </Section>
      </Window.Content>
    </Window>
  );
};
