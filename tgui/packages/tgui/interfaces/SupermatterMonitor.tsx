import { Fragment } from 'react';
import { AnimatedNumber, Box, Button, Chart, ColorBox, Flex, LabeledList, ProgressBar, Section }
  from 'tgui-core/components';
import { round } from 'tgui-core/math';
import { toTitleCase } from 'tgui-core/string';

import { useBackend } from '../backend';
import { Window } from '../layouts';

//  As of 2020-08-06 this isn't actually ever used, but it needs to exist
//  because that's what tgui_modules expect
export const SupermatterMonitor = (props) => (
  <Window width={600} height={400}>
    <Window.Content scrollable>
      <SupermatterMonitorContent />
    </Window.Content>
  </Window>
);

export const SupermatterMonitorContent = (props) => {
  const { act, data } = useBackend<any>();

  const { active } = data;

  if (active) {
    return <SupermatterMonitorActive />;
  } else {
    return <SupermatterMonitorList />;
  }
};

const SupermatterMonitorList = (props) => {
  const { act, data } = useBackend<any>();

  const { supermatters } = data;

  return (
    <Section
      title="Supermatters Detected"
      buttons={<Button content="Refresh" icon="sync"
        onClick={() => act('refresh')} />}>
      <Flex wrap="wrap">
        {supermatters.map((sm, i) => (
          <Flex.Item basis="49%" grow={i % 2} key={i}>
            <Section title={sm.area_name + ' (#' + sm.uid + ')'}>
              <LabeledList>
                <LabeledList.Item label="Integrity">{sm.integrity} %
                </LabeledList.Item>
                <LabeledList.Item label="Options">
                  <Button icon="eye" content="View Details"
                    onClick={() => act('set', { set: sm.uid })} />
                </LabeledList.Item>
              </LabeledList>
            </Section>
          </Flex.Item>
        ))}
      </Flex>
    </Section>
  );
};

const SupermatterMonitorActive = (props) => {
  const { act, data } = useBackend<any>();
  const { SM_History } = data;

  const {
    SM_area,
    SM_integrity,
    SM_power,
    SM_ambienttemp,
    SM_ambientpressure,
    SM_EPR,
    SM_gas_O2,
    SM_gas_CO2,
    SM_gas_N2,
    SM_gas_PH,
    SM_gas_N2O,
  } = data;

  const IntegrityData = SM_History.integrity_history.map((value, i) => [i, value]);
  const EERData = SM_History.EER_history.map((value, i) => [i, value]);
  const TemperatureData = SM_History.temperature_history.map((value, i) => [i, value]);
  const PressureData = SM_History.pressure_history.map((value, i) => [i, value]);
  const EPRData = SM_History.EPR_history.map((value, i) => [i, value]);

  const EERSingleton = SM_History.EER_history[SM_History.EER_history.length - 1] || 0;
  const TemperatureSingleton = SM_History.temperature_history[SM_History.temperature_history.length - 1] || 0;
  const PressureSingleton = SM_History.pressure_history[SM_History.pressure_history.length - 1] || 0;
  const EPRSingleton = SM_History.EPR_history[SM_History.EPR_history.length - 1] || 0;

  const IntegrityMax = 100;
  const EERMax = Math.max(EERSingleton) + 200;
  const TemperatureMax = Math.max(TemperatureSingleton) + 200;
  const PressureMax = Math.max(PressureSingleton) + 200;
  const EPRMax = Math.max(EPRSingleton) + 2;

  return (
    <>
      <Section
        title={toTitleCase(SM_area)}
        buttons={<Button icon="arrow-left" content="Return to Menu"
          onClick={() => act('clear')} />} />
      <Flex mx={-0.5} mb={1}>
        <Flex.Item mx={0.5} width="125px">
          <Section>
            <LabeledList>
              <LabeledList.Item label="Integrity">
                <ColorBox color="#00d7ff" />
              </LabeledList.Item>
              <LabeledList.Item label="EER">
                <ColorBox color="#ff4200" />
              </LabeledList.Item>
              <LabeledList.Item label="Temperature">
                <ColorBox color="#e700ff" />
              </LabeledList.Item>
              <LabeledList.Item label="Pressure">
                <ColorBox color="#91ce94" />
              </LabeledList.Item>
              <LabeledList.Item label="EPR">
                <ColorBox color="#8f69b9" />
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Flex.Item>
        <Flex.Item mx={0.5} grow={1}>
          <Section position="relative" height="100%">
            <Chart.Line
              height="100px"
              data={IntegrityData}
              rangeX={[0, IntegrityData.length - 1]}
              rangeY={[0, IntegrityMax]}
              strokeColor="rgba(0, 215, 255, 0.8)"
              fillColor="rgba(0, 215, 255, 0)" />
            <Chart.Line
              fillPositionedParent
              data={EERData}
              rangeX={[0, EERData.length - 1]}
              rangeY={[0, EERMax]}
              strokeColor="rgba(255, 66, 0, 0.8)"
              fillColor="rgba(255, 66, 0, 0)" />
            <Chart.Line
              fillPositionedParent
              data={TemperatureData}
              rangeX={[0, TemperatureData.length - 1]}
              rangeY={[0, TemperatureMax]}
              strokeColor="rgba(231, 0, 255, 0.8)"
              fillColor="rgba(231, 0, 255, 0)" />
            <Chart.Line
              fillPositionedParent
              data={PressureData}
              rangeX={[0, PressureData.length - 1]}
              rangeY={[0, PressureMax]}
              strokeColor="rgba(145, 206, 148, 0.8)"
              fillColor="rgba(145, 206, 148, 0)" />
            <Chart.Line
              fillPositionedParent
              data={EPRData}
              rangeX={[0, EPRData.length - 1]}
              rangeY={[0, EPRMax]}
              strokeColor="rgba(143, 105, 185, 0.8)"
              fillColor="rgba(143, 105, 185, 0)" />
          </Section>
        </Flex.Item>
      </Flex>
      <LabeledList>
        <LabeledList.Item label="Core Integrity">
          <ProgressBar
            value={SM_integrity}
            minValue={0}
            maxValue={100}
            ranges={{
              good: [100, 100],
              average: [50, 100],
              bad: [-Infinity, 50],
            }}
          />
        </LabeledList.Item>
        <LabeledList.Item label="Relative EER">
          <Box color={(SM_power > 300 && 'bad')
            || (SM_power > 150 && 'average') || 'good'}>
            <AnimatedNumber format={(val) => round(val, 2) + ' MeV/cm³'}
              value={SM_power} />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Temperature">
          <Box color={(SM_ambienttemp > 5000 && 'bad')
            || (SM_ambienttemp > 4000 && 'average') || 'good'}>
            <AnimatedNumber format={(val) => round(val, 2) + ' K'}
              value={SM_ambienttemp} />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Pressure">
          <Box color={(SM_ambientpressure > 10000 && 'bad')
            || (SM_ambientpressure > 5000 && 'average') || 'good'}>
            <AnimatedNumber format={(val) => round(val, 2) + ' kPa'}
              value={SM_ambientpressure} />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Chamber EPR">
          <Box color={(SM_EPR > 4 && 'bad')
            || (SM_EPR > 1 && 'average') || 'good'}>
            <AnimatedNumber format={(val) => `${round(val, 2)}`}
              value={SM_EPR} />
          </Box>
        </LabeledList.Item>
        <LabeledList.Item label="Gas Composition">
          <LabeledList>
            <LabeledList.Item label="O²">
              <AnimatedNumber value={SM_gas_O2} />%
            </LabeledList.Item>
            <LabeledList.Item label="CO²">
              <AnimatedNumber value={SM_gas_CO2} />%
            </LabeledList.Item>
            <LabeledList.Item label="N²">
              <AnimatedNumber value={SM_gas_N2} />%
            </LabeledList.Item>
            <LabeledList.Item label="PH">
              <AnimatedNumber value={SM_gas_PH} />%
            </LabeledList.Item>
            <LabeledList.Item label="N²O">
              <AnimatedNumber value={SM_gas_N2O} />%
            </LabeledList.Item>
          </LabeledList>
        </LabeledList.Item>
      </LabeledList>
    </>
  );
};
