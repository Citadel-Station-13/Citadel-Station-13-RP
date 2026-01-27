import { Fragment, useState } from 'react';
import { Box, Button, Icon, LabeledList, ProgressBar, Section, Slider, Stack, Tabs } from "tgui-core/components";
import { formatPower } from "tgui-core/format";
import { round } from 'tgui-core/math';
import { capitalize } from 'tgui-core/string';

import { useBackend } from "../backend";
import { Window } from "../layouts";

export const RCON = (props) => {
  return (
    <Window
      width={630}
      height={440}
    >
      <Window.Content scrollable>
        <RCONContent />
      </Window.Content>
    </Window>
  );
};

export const RCONContent = (props) => {
  const [tabIndex, setTabIndex] = useState(0);

  let body;
  if (tabIndex === 0) {
    body = <RCONSmesList />;
  } else if (tabIndex === 1) {
    body = <RCONBreakerList />;
  }

  return (
    <>
      <Tabs>
        <Tabs.Tab
          key="SMESs"
          selected={0 === tabIndex}
          onClick={() => setTabIndex(0)}>
          <Icon name="power-off" /> SMESs
        </Tabs.Tab>
        <Tabs.Tab
          key="Breakers"
          selected={1 === tabIndex}
          onClick={() => setTabIndex(1)}>
          <Icon name="bolt" /> Breakers
        </Tabs.Tab>
      </Tabs>
      <Box m={2}>
        {body}
      </Box>
    </>
  );
};

const RCONSmesList = (props) => {
  const { act, data } = useBackend<any>();

  const {
    smes_info,
  } = data;

  return (
    <Section title="SMESs">
      <Stack vertical>
        {smes_info.map(smes => (
          <Stack.Item key={smes.RCON_tag}>
            <SMESItem smes={smes} />
          </Stack.Item>
        ))}
      </Stack>
    </Section>
  );
};

const SMESItem = (props) => {
  const { act } = useBackend<any>();
  const {
    capacityPercent,
    capacity,
    charge,
    inputAttempt,
    inputting,
    inputLevel,
    inputLevelMax,
    inputAvailable,
    outputAttempt,
    outputting,
    outputLevel,
    outputLevelMax,
    outputUsed,
    RCON_tag,
  } = props.smes;

  return (
    <Stack vertical>
      <Stack.Item>
        <Stack fill justify="space-between">
          <Stack.Item fontSize={1.2}>
            {RCON_tag}
          </Stack.Item>
          <Stack.Item>
            <ProgressBar
              width={20}
              value={capacityPercent * 0.01}
              ranges={{
                good: [0.5, Infinity],
                average: [0.15, 0.5],
                bad: [-Infinity, 0.15],
              }}>
              {round(charge / 60, 0.1)} kWh / {round(capacity / 60, 0.1)} kWh
              ({capacityPercent}%)
            </ProgressBar>
          </Stack.Item>
        </Stack>
      </Stack.Item>
      <Stack.Item>
        <SMESControls smes={props.smes} way="input" />
      </Stack.Item>
      <Stack.Item>
        <SMESControls smes={props.smes} way="output" />
      </Stack.Item>
      <Stack.Divider />
    </Stack>
  );
};

const SMESControls = (props) => {
  const { act } = useBackend<any>();
  const {
    way,
    smes,
  } = props;
  const {
    capacityPercent,
    capacity,
    charge,
    inputAttempt,
    inputting,
    inputLevel,
    inputLevelMax,
    inputAvailable,
    outputAttempt,
    outputting,
    outputLevel,
    outputLevelMax,
    outputUsed,
    RCON_tag,
  } = smes;

  let level;
  let levelMax;
  let available;
  let direction;
  let changeStatusAct;
  let changeAmountAct;
  let enabled;
  let powerColor;
  let powerTooltip;

  switch (way) {
    case "input":
      level = inputLevel;
      levelMax = inputLevelMax;
      available = inputAvailable;
      direction = "IN";
      changeStatusAct = "smes_in_toggle";
      changeAmountAct = "smes_in_set";
      enabled = inputAttempt;
      powerColor = !inputAttempt ? null : (inputting ? "green" : "yellow");
      powerTooltip = !inputAttempt ? "The SMES input is off." : (inputting ? "The SMES is drawing power." : "The SMES lacks power.");
      break;
    case "output":
      level = outputLevel;
      levelMax = outputLevelMax;
      available = outputUsed;
      direction = "OUT";
      changeStatusAct = "smes_out_toggle";
      changeAmountAct = "smes_out_set";
      enabled = outputAttempt;
      powerColor = !outputAttempt ? null : (outputting ? "green" : "yellow");
      powerTooltip = !outputAttempt ? "The SMES output is off." : (outputting ? "The SMES is outputting power." : "The SMES lacks any draw.");
      break;
  }

  return (
    <Stack fill>
      <Stack.Item basis="20%">
        {capitalize(way)}
      </Stack.Item>
      <Stack.Item grow={1}>
        <Stack>
          <Stack.Item>
            <Button
              icon="power-off"
              color={powerColor}
              tooltip={powerTooltip}
              onClick={() => act(changeStatusAct, {
                smes: RCON_tag,
              })} />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="fast-backward"
              disabled={level === 0}
              onClick={() => act(changeAmountAct, {
                target: 'min',
                smes: RCON_tag,
              })} />
            <Button
              icon="backward"
              disabled={level === 0}
              onClick={() => act(changeAmountAct, {
                adjust: -10,
                smes: RCON_tag,
              })} />
          </Stack.Item>
          <Stack.Item grow={1}>
            <Slider
              value={level * 0.001}
              fillValue={available * 0.001}
              minValue={0}
              maxValue={levelMax * 0.001}
              step={5}
              stepPixelSize={4}
              format={value => formatPower(available * 1000, 1) + "/" + formatPower(value * 1000, 1)}
              onChange={(e, value) => act(changeAmountAct, {
                target: value,
                smes: RCON_tag,
              })} />
          </Stack.Item>
          <Stack.Item>
            <Button
              icon="forward"
              disabled={level === levelMax}
              onClick={() => act(changeAmountAct, {
                adjust: 10,
                smes: RCON_tag,
              })} />
            <Button
              icon="fast-forward"
              disabled={level === levelMax}
              onClick={() => act(changeAmountAct, {
                target: 'max',
                smes: RCON_tag,
              })} />
          </Stack.Item>
        </Stack>
      </Stack.Item>
    </Stack>
  );
};

const RCONBreakerList = (props) => {
  const { act, data } = useBackend<any>();

  const {
    breaker_info,
  } = data;

  return (
    <Section title="Breakers">
      <LabeledList>
        {breaker_info ? breaker_info.map(breaker => (
          <LabeledList.Item
            key={breaker.RCON_tag}
            label={breaker.RCON_tag}
            buttons={(
              <Button
                icon="power-off"
                content={breaker.enabled ? "Enabled" : "Disabled"}
                selected={breaker.enabled}
                color={breaker.enabled ? null : "bad"}
                onClick={() => act("toggle_breaker", {
                  breaker: breaker.RCON_tag,
                })} />
            )} />
        )) : (
          <LabeledList.Item color="bad">
            No breakers detected.
          </LabeledList.Item>
        )}
      </LabeledList>
    </Section>
  );
};
