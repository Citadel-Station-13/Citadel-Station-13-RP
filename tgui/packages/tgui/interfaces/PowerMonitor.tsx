import { Fragment, useState } from 'react';
import { Box, Button, Chart, ColorBox, Flex, Icon, LabeledList, ProgressBar, Section, Table } from 'tgui-core/components';
import { toFixed } from 'tgui-core/math';

import { useBackend } from '../backend';
import { Window } from '../layouts';

const PEAK_DRAW = 500;

export const powerRank = str => {
  const unit = String(str.split(' ')[1]).toLowerCase();
  return ['w', 'kw', 'mw', 'gw'].indexOf(unit);
};

export const PowerMonitor = () => {
  return (
    <Window
      width={550}
      height={700}
    >
      <Window.Content scrollable>
        <PowerMonitorContent />
      </Window.Content>
    </Window>
  );
};

export const PowerMonitorContent = (props) => {
  const { act, data } = useBackend<any>();

  const {
    map_levels,
    all_sensors,
    focus,
  } = data;

  if (focus) {
    return <PowerMonitorFocus focus={focus} />;
  }

  let body = (
    <Box color="bad">No sensors detected</Box>
  );

  if (all_sensors) {
    body = (
      <Table>
        {all_sensors.map(sensor => (
          <Table.Row key={sensor.name}>
            <Table.Cell>
              <Button
                content={sensor.name}
                icon={sensor.alarm ? "bell" : "sign-in-alt"}
                onClick={() => act("setsensor", { id: sensor.name })} />
            </Table.Cell>
          </Table.Row>
        ))}
      </Table>
    );
  }

  return (
    <Section
      title="No active sensor. Listing all."
      buttons={
        <Button
          content="Scan For Sensors"
          icon="undo"
          onClick={() => act("refresh")} />
      }>
      {body}
    </Section>
  );
};

export const PowerMonitorFocus = (props) => {
  const { act, data } = useBackend<any>();
  const { focus } = props;
  const { history } = focus;
  const [
    sortByField,
    setSortByField,
  ] = useState<string>('name');
  const supply = history.supply[history.supply.length - 1] || 0;
  const demand = history.demand[history.demand.length - 1] || 0;
  const supplyData = history.supply.map((value, i) => [i, value]);
  const demandData = history.demand.map((value, i) => [i, value]);
  const maxValue = Math.max(
    PEAK_DRAW,
    ...history.supply,
    ...history.demand);
  // Process area data
  const areas = (focus.areas as any[])
    .map((area, i) => ({
      ...area,
      id: area.name + i,
    }))
    .sort((a, b) => {
      if (sortByField === 'name') {
        return a.name.localeCompare(b.name);
      } else if (sortByField === 'charge') {
        return a.charge - b.charge;
      } else if (sortByField === 'draw') {
        const rankA = powerRank(a.load);
        const rankB = powerRank(b.load);
        if (rankA !== rankB) {
          return rankA - rankB;
        }
        return parseFloat(a.load) - parseFloat(b.load);
      } else if (sortByField === 'problems') {
        if (a.eqp !== b.eqp) {
          return a.eqp - b.eqp;
        }
        if (a.lgt !== b.lgt) {
          return a.lgt - b.lgt;
        }
        if (a.env !== b.env) {
          return a.env - b.env;
        }
        if (a.charge !== b.charge) {
          return a.charge - b.charge;
        }
        return a.name.localeCompare(b.name);
      }
    });

  return (
    <>
      <Section
        title={focus.name}
        buttons={
          <Button
            icon="sign-out-alt"
            content="Back To Main"
            onClick={() => act("clear")} />
        } />
      <Flex mx={-0.5} mb={1}>
        <Flex.Item mx={0.5} width="200px">
          <Section>
            <LabeledList>
              <LabeledList.Item label="Supply">
                <ProgressBar
                  value={supply}
                  minValue={0}
                  maxValue={maxValue}
                  color="teal">
                  {toFixed(supply) + ' kW'}
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Draw">
                <ProgressBar
                  value={demand}
                  minValue={0}
                  maxValue={maxValue}
                  color="pink">
                  {toFixed(demand) + ' kW'}
                </ProgressBar>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        </Flex.Item>
        <Flex.Item mx={0.5} grow={1}>
          <Section position="relative" height="100%">
            <Chart.Line
              fillPositionedParent
              data={supplyData}
              rangeX={[0, supplyData.length - 1]}
              rangeY={[0, maxValue]}
              strokeColor="rgba(0, 181, 173, 1)"
              fillColor="rgba(0, 181, 173, 0.25)" />
            <Chart.Line
              fillPositionedParent
              data={demandData}
              rangeX={[0, demandData.length - 1]}
              rangeY={[0, maxValue]}
              strokeColor="rgba(224, 57, 151, 1)"
              fillColor="rgba(224, 57, 151, 0.25)" />
          </Section>
        </Flex.Item>
      </Flex>
      <Section>
        <Box mb={1}>
          <Box inline mr={2} color="label">
            Sort by:
          </Box>
          <Button.Checkbox
            checked={sortByField === 'name'}
            content="Name"
            onClick={() => setSortByField(
              'name'
            )} />
          <Button.Checkbox
            checked={sortByField === 'charge'}
            content="Charge"
            onClick={() => setSortByField(
              'charge'
            )} />
          <Button.Checkbox
            checked={sortByField === 'draw'}
            content="Draw"
            onClick={() => setSortByField(
              'draw'
            )} />
          <Button.Checkbox
            checked={sortByField === 'problems'}
            content="Problems"
            onClick={() => setSortByField(
              'problems'
            )} />
        </Box>
        <Table>
          <Table.Row header>
            <Table.Cell>
              Area
            </Table.Cell>
            <Table.Cell collapsing>
              Charge
            </Table.Cell>
            <Table.Cell textAlign="right">
              Draw
            </Table.Cell>
            <Table.Cell collapsing>
              Eqp
            </Table.Cell>
            <Table.Cell collapsing>
              Lgt
            </Table.Cell>
            <Table.Cell collapsing>
              Env
            </Table.Cell>
          </Table.Row>
          {areas.map((area, i) => (
            <tr
              key={area.id}
              className="Table__row candystripe">
              <td>
                {area.name}
              </td>
              <td className="Table__cell text-right text-nowrap">
                <AreaCharge
                  charging={area.charging}
                  charge={area.charge} />
              </td>
              <td className="Table__cell text-right text-nowrap">
                {area.load}
              </td>
              <td className="Table__cell text-center text-nowrap">
                <AreaStatusColorBox status={area.eqp} />
              </td>
              <td className="Table__cell text-center text-nowrap">
                <AreaStatusColorBox status={area.lgt} />
              </td>
              <td className="Table__cell text-center text-nowrap">
                <AreaStatusColorBox status={area.env} />
              </td>
            </tr>
          ))}
        </Table>
      </Section>
    </>
  );
};

export const AreaCharge = props => {
  const { charging, charge } = props;
  return (
    <>
      <Icon
        width="18px"
        textAlign="center"
        name={(
          charging === 0 && (
            charge > 50
              ? 'battery-half'
              : 'battery-quarter'
          )
          || charging === 1 && 'bolt'
          || charging === 2 && 'battery-full'
          || 'battery-half'
        )}
        color={(
          charging === 0 && (
            charge > 50
              ? 'yellow'
              : 'red'
          )
          || charging === 1 && 'yellow'
          || charging === 2 && 'green'
        )} />
      <Box
        inline
        width="36px"
        textAlign="right">
        {toFixed(charge) + '%'}
      </Box>
    </>
  );
};

const AreaStatusColorBox = props => {
  const { status } = props;
  const power = Boolean(status & 2);
  const mode = Boolean(status & 1);
  const tooltipText = (power ? 'On' : 'Off')
    + ` [${mode ? 'auto' : 'manual'}]`;
  return (
    <ColorBox
      color={power ? 'good' : 'bad'}
      content={mode ? undefined : 'M'}
    />
  );
};
