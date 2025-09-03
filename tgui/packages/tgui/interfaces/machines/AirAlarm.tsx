import { Fragment } from 'react';
import { Box, Button, LabeledList, NumberInput, Section, Stack } from 'tgui-core/components';
import { round } from 'tgui-core/math';
import { BooleanLike } from 'tgui-core/react';

import { useBackend, useLocalState } from '../../backend';
import { Window } from '../../layouts';
import { AtmosAnalyzerResults, AtmosGasGroupFlags, AtmosGasID, GasContext } from '../common/Atmos';
import { InterfaceLockNoticeBox } from '../common/InterfaceLockNoticeBox';
import { AtmosVentPumpControl, AtmosVentPumpState } from './AtmosVentPump';
import { AtmosVentScrubberControl, AtmosVentScrubberState } from './AtmosVentScrubber';

enum AirAlarmMode {
  Off = "off",
  Scrub = "scrub",
  Replace = "replace",
  Siphon = "siphon",
  Cycle = "cycle",
  Panic = "panic",
  Contaminated = "contaminated",
  Fill = "fill",
}

const AirAlarmModes: [AirAlarmMode, string, string | undefined][] = [
  [AirAlarmMode.Scrub, "Filtering - Maintain area atmospheric integrity", undefined],
  [AirAlarmMode.Contaminated, "Contaminated - Rapidly scrub out contaminants", undefined],
  [AirAlarmMode.Replace, "Replace - Siphons air while replacing", undefined],
  [AirAlarmMode.Cycle, "Cycle - Fully siphon before replacing", "danger"],
  [AirAlarmMode.Fill, "Fill - Fill without scrubbing.", undefined],
  [AirAlarmMode.Siphon, "Siphon - Drain air from room", "danger"],
  [AirAlarmMode.Panic, "Panic Siphon - Quickly drain air from room", "danger"],
];

enum AirAlarmRaise {
  Okay = 0,
  Warning = 1,
  Danger = 2,
}

const AirAlarmRaiseLookup: {
  color: string;
  status: string;
}[] = [
    {
      color: 'good',
      status: 'Okay',
    },
    {
      color: 'average',
      status: 'Warning',
    },
    {
      color: 'bad',
      status: 'Danger',
    },
  ];

type AirAlarmTLV = [number, number, number, number];

const TLVCheck = (val: number, tlv: AirAlarmTLV | null | undefined) => tlv ? (val < tlv[0] || val > tlv[3]
  ? AirAlarmRaise.Danger : val < tlv[1] || val > tlv[2]
    ? AirAlarmRaise.Warning
    : AirAlarmRaise.Okay) : AirAlarmRaise.Okay;

interface ExtendedVentPumpState extends AtmosVentPumpState {
  name: string;
}

interface ExtendedVentScrubberState extends AtmosVentScrubberState {
  name: string;
}

interface AirAlarmData {
  gasTLV: Record<string, AirAlarmTLV>;
  groupTLV: Record<string, AirAlarmTLV>;
  pressureTLV: AirAlarmTLV;
  temperatureTLV: AirAlarmTLV;
  environment: AtmosAnalyzerResults;
  vents: Record<string, ExtendedVentPumpState>;
  scrubbers: Record<string, ExtendedVentScrubberState>;
  mode: AirAlarmMode;
  gasContext: GasContext;
  // legacy below
  locked: BooleanLike;
  siliconUser: BooleanLike;
  remoteUser: BooleanLike;
  danger_level: number;
  target_temperature: number;
  rcon: number;
  atmos_alarm: BooleanLike;
  fire_alarm: BooleanLike;
  emagged: BooleanLike;
}

export const AirAlarm = (props) => {
  const { act, data } = useBackend<AirAlarmData>();
  const locked = data.locked && !data.siliconUser && !data.remoteUser;
  const localRaised = AirAlarmRaiseLookup[data.danger_level];
  const pressureRaised = AirAlarmRaiseLookup[TLVCheck(data.environment.pressure, data.pressureTLV)];
  const temperatureRaised = AirAlarmRaiseLookup[TLVCheck(data.environment.temperature, data.temperatureTLV)];
  const temperatureRounded = round(data.environment.temperature, 2);
  return (
    <Window
      width={440}
      height={800}>
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item>
            <InterfaceLockNoticeBox />
          </Stack.Item>
          <Stack.Item>
            <Section title="Environment">
              <LabeledList>
                <LabeledList.Item label="Pressure" color={pressureRaised.color}>
                  {round(data.environment.pressure, 2)} kPa
                </LabeledList.Item>
                <LabeledList.Item label="Temperature" color={temperatureRaised.color}>
                  {temperatureRounded}K ({round(temperatureRounded - 273.15, 2)}°C)
                </LabeledList.Item>
                {
                  Object.entries(data.environment.gases).map(([k, v]) => {
                    const percent = v / data.environment.moles * 100;
                    const gasRaised = AirAlarmRaiseLookup[TLVCheck(v, data.gasTLV[k])];
                    return (
                      <LabeledList.Item key={k}
                        label={data.environment.names[k] || k} color={gasRaised.color}>
                        {round(percent, 2)}%
                      </LabeledList.Item>
                    );
                  })
                }
                <LabeledList.Item label="Local Status" color={localRaised.color}>
                  {localRaised.status}
                </LabeledList.Item>
                <LabeledList.Item label="Area Status" color={data.atmos_alarm || data.fire_alarm ? 'bad' : 'good'}>
                  {data.atmos_alarm ? "Atmosphere Alarm" : data.fire_alarm ? "Fire Alarm" : "Nominal"}
                </LabeledList.Item>
                {!!data.emagged && (
                  <LabeledList.Item
                    label="Warning"
                    color="bad">
                    Safety measures offline. Device may exhibit abnormal behavior.
                  </LabeledList.Item>
                )}
              </LabeledList>
            </Section>
          </Stack.Item>
          <Stack.Item>
            <AirAlarmUnlockedControl />
          </Stack.Item>
          <Stack.Item grow>
            {!locked && (
              <AirAlarmControl />
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const AirAlarmUnlockedControl = (props) => {
  const { act, data } = useBackend<AirAlarmData>();
  const {
    target_temperature,
    rcon,
  } = data;
  return (
    <Section
      title="Comfort Settings">
      <LabeledList>
        <LabeledList.Item label="Remote Control">
          <Button
            selected={rcon === 1}
            content="Off"
            onClick={() => act('rcon', { 'rcon': 1 })} />
          <Button
            selected={rcon === 2}
            content="Auto"
            onClick={() => act('rcon', { 'rcon': 2 })} />
          <Button
            selected={rcon === 3}
            content="On"
            onClick={() => act('rcon', { 'rcon': 3 })} />
        </LabeledList.Item>
        <LabeledList.Item label="Thermostat">
          <Button
            content={target_temperature}
            onClick={() => act('temperature')} />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const AIR_ALARM_ROUTES = {
  home: {
    title: 'Air Controls',
    component: () => AirAlarmControlHome,
  },
  vents: {
    title: 'Vent Controls',
    component: () => AirAlarmVentScreenWrapped,
  },
  scrubbers: {
    title: 'Scrubber Controls',
    component: () => AirAlarmScrubberScreenWrapped,
  },
  modes: {
    title: 'Operating Mode',
    component: () => AirAlarmModeScreenWrapped,
  },
  thresholds: {
    title: 'Alarm Thresholds',
    component: () => AirAlarmThresholdScreenWrapped,
  },
};

const AirAlarmControl = (props) => {
  const [screen, setScreen] = useLocalState<string>('screen', 'home');
  const route = AIR_ALARM_ROUTES[screen] || AIR_ALARM_ROUTES.home;
  const Component = route.component();
  return (
    <Section
      scrollable
      fill
      title={route.title}
      buttons={screen && (
        <Button
          icon="arrow-left"
          content="Back"
          onClick={() => setScreen('home')} />
      )}>
      <Component />
    </Section>
  );
};


//  Home screen
// --------------------------------------------------------

const AirAlarmControlHome = (props) => {
  const { act, data } = useBackend<AirAlarmData>();
  const [screen, setScreen] = useLocalState<string>('screen', '');
  const {
    mode,
    atmos_alarm,
  } = data;
  return (
    <>
      <Button
        icon={atmos_alarm
          ? 'exclamation-triangle'
          : 'exclamation'}
        color={!!atmos_alarm && 'caution'}
        content="Area Atmosphere Alarm"
        onClick={() => act(atmos_alarm ? 'reset' : 'alarm')} />
      <Box mt={1} />
      <Button
        icon={mode === AirAlarmMode.Panic
          ? 'exclamation-triangle'
          : 'exclamation'}
        color={mode === AirAlarmMode.Panic && 'danger'}
        content="Panic Siphon"
        onClick={() => act('mode', {
          mode: mode === AirAlarmMode.Panic ? AirAlarmMode.Scrub : AirAlarmMode.Panic,
        })} />
      <Box mt={2} />
      <Button
        icon="sign-out-alt"
        content="Vent Controls"
        onClick={() => setScreen('vents')} />
      <Box mt={1} />
      <Button
        icon="filter"
        content="Scrubber Controls"
        onClick={() => setScreen('scrubbers')} />
      <Box mt={1} />
      <Button
        icon="cog"
        content="Operating Mode"
        onClick={() => setScreen('modes')} />
      <Box mt={1} />
      <Button
        icon="chart-bar"
        content="Alarm Thresholds"
        onClick={() => setScreen('thresholds')} />
    </>
  );
};

//* Vents *//

const AirAlarmVentScreenWrapped = (props) => {
  const { data, act } = useBackend<AirAlarmData>();
  return (
    <AirAlarmVentScreen
      vents={data.vents}
      dirToggle={(id) => act('vent', { id: id, command: 'direction' })}
      powerToggle={(id) => act('vent', { id: id, command: 'power' })}
      internalToggle={(id) => act('vent', { id: id, command: 'internalToggle' })}
      internalSet={(id, amt) => act('vent', { id: id, command: 'internalPressure', target: amt })}
      externalToggle={(id) => act('vent', { id: id, command: 'externalToggle' })}
      externalSet={(id, amt) => act('vent', { id: id, command: 'externalPressure', target: amt })} />
  );
};

interface AirAlarmVentScreenProps {
  readonly powerToggle: (id: string, on?: boolean) => void;
  readonly internalToggle: (id: string, on?: boolean) => void;
  readonly externalToggle: (id: string, on?: boolean) => void;
  readonly internalSet: (id: string, kpa: number | 'default') => void;
  readonly externalSet: (id: string, kpa: number | 'default') => void;
  readonly dirToggle: (id: string, siphon?: boolean) => void;
  readonly vents: Record<string, ExtendedVentPumpState>;
}

const AirAlarmVentScreen = (props: AirAlarmVentScreenProps) => {
  return (
    <Stack vertical>
      {Object.entries(props.vents).map(([idTag, vent]) => (
        <Stack.Item key={idTag}>
          <AtmosVentPumpControl
            state={vent}
            title={vent.name}
            powerToggle={(on) => props.powerToggle(idTag, on)}
            dirToggle={(siphon) => props.dirToggle(idTag, siphon)}
            internalSet={(val) => props.internalSet(idTag, val)}
            externalSet={(val) => props.externalSet(idTag, val)}
            internalToggle={(on) => props.internalToggle(idTag, on)}
            externalToggle={(on) => props.externalToggle(idTag, on)} />
        </Stack.Item>
      ))}
    </Stack>
  );
};

//* Scrubbers *//

const AirAlarmScrubberScreenWrapped = (props) => {
  const { data, act } = useBackend<AirAlarmData>();
  return (
    <AirAlarmScrubberScreen
      gasContext={data.gasContext}
      scrubbers={data.scrubbers}
      powerToggle={(id) => act('scrubber', { id: id, command: 'power' })}
      siphonToggle={(id) => act('scrubber', { id: id, command: 'siphon' })}
      expandToggle={(id) => act('scrubber', { id: id, command: 'highPower' })}
      gasToggle={(id, gas) => act('scrubber', { id: id, command: 'gasID', target: gas })}
      groupToggle={(id, flags) => act('scrubber', { id: id, command: 'gasGroup', target: flags })} />
  );
};

interface AirAlarmScrubberScreenProps {
  readonly powerToggle: (id: string, on?: boolean) => void;
  readonly siphonToggle: (id: string, on?: boolean) => void;
  readonly expandToggle: (id: string, on?: boolean) => void;
  readonly gasToggle: (id: string, gas: AtmosGasID, on?: boolean) => void;
  readonly groupToggle: (id: string, group: AtmosGasGroupFlags, on?: boolean) => void;
  readonly scrubbers: Record<string, ExtendedVentScrubberState>;
  readonly gasContext: GasContext;
}

const AirAlarmScrubberScreen = (props: AirAlarmScrubberScreenProps) => {
  return (
    <Stack vertical>
      {Object.entries(props.scrubbers).map(([idTag, scrubber]) => (
        <Stack.Item key={idTag}>
          <AtmosVentScrubberControl
            state={scrubber}
            context={props.gasContext}
            title={scrubber.name}
            powerToggle={(on) => props.powerToggle(idTag, on)}
            siphonToggle={(on) => props.siphonToggle(idTag, on)}
            expandToggle={(on) => props.expandToggle(idTag, on)}
            idToggle={(id, on) => props.gasToggle(idTag, id, on)}
            groupToggle={(group, on) => props.groupToggle(idTag, group, on)} />
        </Stack.Item>
      ))}
    </Stack>
  );
};

//* Modes *//

// todo: legacy, remove
const AirAlarmModeScreenWrapped = (props) => {
  const { data, act } = useBackend<AirAlarmData>();
  return (
    <AirAlarmModeScreen
      selected={data.mode}
      setAct={(mode) => act('mode', { mode: mode })} />
  );
};

interface AirAlarmModeScreenProps {
  readonly selected: AirAlarmMode;
  readonly setAct: (AirAlarmMode) => void;
}

const AirAlarmModeScreen = (props: AirAlarmModeScreenProps) => {
  return (
    <Stack vertical>
      {AirAlarmModes.map(([mode, desc, color]) => (
        <AirAlarmModeButton
          key={mode}
          desc={desc}
          color={color}
          selected={props.selected === mode}
          setAct={() => props.setAct(mode)} />
      ))}
    </Stack>
  );
};

interface AirAlarmModeButtonProps {
  readonly desc: string;
  readonly selected: boolean;
  readonly setAct?: () => void;
  readonly color?: string;
}

const AirAlarmModeButton = (props: AirAlarmModeButtonProps) => {
  return (
    <Button
      icon={props.selected ? 'check-square-o' : 'square-o'}
      content={props.desc}
      onClick={() => props.setAct?.()}
      selected={props.selected}
      color={props.selected && props.color} />
  );
};

//* Thresholds / TLVs *//

const AirAlarmThresholdScreenWrapped = (props) => {
  const { data, act } = useBackend<AirAlarmData>();
  return (
    <table
      className="LabeledList"
      style={{ width: '100%', marginLeft: "2.5px", marginRight: "2.5px" }}>
      <thead>
        <tr>
          <td />
          <td className="color-bad">min2</td>
          <td className="color-average">min1</td>
          <td className="color-average">max1</td>
          <td className="color-bad">max2</td>
        </tr>
      </thead>
      <tbody>
        {(
          <>
            <AirAlarmTLVEntry name="Pressure" entry={data.pressureTLV}
              setEntry={(val, index) => act('tlv', { entry: 'pressure', index: index, val: val })} />
            <AirAlarmTLVEntry name="Temperature" entry={data.temperatureTLV}
              setEntry={(val, index) => act('tlv', { entry: 'temperature', index: index, val: val })} />
          </>
        )}
        {Object.entries(data.gasTLV).map(([id, tlv]) => (
          <AirAlarmTLVEntry name={id} entry={tlv} key={id}
            setEntry={(v, i) => act('tlv', { entry: id, index: i, val: v })} />
        ))}
        {Object.entries(data.groupTLV).map(([name, tlv]) => (
          <AirAlarmTLVEntry name={name} entry={tlv} key={name}
            setEntry={(v, i) => act('tlv', { entry: name, index: i, val: v })} />
        ))}
      </tbody>
    </table>
  );
};


interface AirAlarmTLVEntryProps {
  readonly name: string;
  readonly entry: AirAlarmTLV;
  readonly setEntry: (val: number, index: number) => void;
}

const AirAlarmTLVEntry = (props: AirAlarmTLVEntryProps) => {
  return (
    <tr>
      <td className="LabeledList__label">
        <span>
          {props.name}
        </span>
      </td>
      {props.entry.map((val, i) => (
        <td key={`${i}`}>
          <NumberInput
            step={0.001}
            value={round(val, 2)}
            width="60px"
            minValue={0}
            maxValue={1000000}
            onChange={(v) => props.setEntry(v, i)} />
        </td>
      ))}
    </tr>
  );
};
