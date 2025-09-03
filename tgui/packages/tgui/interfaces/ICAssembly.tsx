import { AnimatedNumber, Box, Button, Flex, LabeledList, ProgressBar, Section } from "tgui-core/components";
import { formatPower } from "tgui-core/format";
import { round } from 'tgui-core/math';

import { useBackend } from "../backend";
import { Window } from "../layouts";

export const ICAssembly = (props) => {
  const { act, data } = useBackend<any>();

  const {
    total_parts,
    max_components,
    total_complexity,
    max_complexity,
    opened,
    battery_charge,
    battery_max,
    net_power,
    circuit_props,
  } = data;

  return (
    <Window width={600} height={380}>
      <Window.Content scrollable>
        <ICTerminal circuits={circuit_props} />
        {opened ? (
          <Section title="Status">
            <LabeledList>
              <LabeledList.Item label="Space in Assembly">
                <ProgressBar
                  ranges={{
                    good: [0, 0.25],
                    average: [0.5, 0.75],
                    bad: [0.75, 1],
                  }}
                  value={total_parts / max_components}
                  maxValue={1}>
                  {total_parts} / {max_components}
                  ({round((total_parts / max_components) * 100, 1)}%)
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Complexity">
                <ProgressBar
                  ranges={{
                    good: [0, 0.25],
                    average: [0.5, 0.75],
                    bad: [0.75, 1],
                  }}
                  value={total_complexity / max_complexity}
                  maxValue={1}>
                  {total_complexity} / {max_complexity}
                  ({round((total_complexity / max_complexity) * 100, 1)}%)
                </ProgressBar>
              </LabeledList.Item>
              <LabeledList.Item label="Cell Charge">
                {battery_charge && (
                  <ProgressBar
                    ranges={{
                      bad: [0, 0.25],
                      average: [0.5, 0.75],
                      good: [0.75, 1],
                    }}
                    value={battery_charge / battery_max}
                    maxValue={1}>
                    {battery_charge} / {battery_max}
                    ({round((battery_charge / battery_max) * 100, 1)}%)
                  </ProgressBar>
                ) || <Box color="bad">No cell detected.</Box>}
              </LabeledList.Item>
              <LabeledList.Item label="Net Energy" >
                <Flex>
                  <Flex.Item grow={1}>
                    {net_power === 0 && "0 W" || (
                      <AnimatedNumber
                        value={net_power}
                        format={val => "-" + formatPower(Math.abs(val))} />)}
                  </Flex.Item>
                  <Button icon="eye" onClick={() => act("remove_cell")}>Remove</Button>
                </Flex>
              </LabeledList.Item>
            </LabeledList>
          </Section>
        )
          : <Box>The assembly is closed.</Box>}
        {opened && (
          <ICAssemblyCircuits title="Components" circuits={circuit_props} />
        ) || null}
      </Window.Content>
    </Window>
  );
};

const ICAssemblyCircuits = (props) => {
  const { act } = useBackend<any>();

  const {
    title,
    circuits,
  } = props;

  return (
    <Section title={title}>
      <LabeledList>
        {circuits.map((circuit, i) => (
          <LabeledList.Item key={circuit.ref} label={circuit.name} >
            <Button icon="eye" onClick={() => act("open_circuit", { ref: circuit.ref })}>View</Button>
            <Button icon="eye" onClick={() => act("rename_circuit", { ref: circuit.ref })}>Rename</Button>
            <Button icon="eye" onClick={() => act("scan_circuit", { ref: circuit.ref })}>Debugger Scan</Button>
            <Button icon="eye" disabled={!circuit.removable} onClick={() => act("remove_circuit", { ref: circuit.ref, index: ++i })}>Remove</Button>
            <Button icon="eye" onClick={() => act("bottom_circuit", { ref: circuit.ref, index: ++i })}>Move to Bottom</Button>
          </LabeledList.Item>)
        )}
      </LabeledList>
    </Section>
  );
};

export const ICTerminal = (props) => {
  const { act, data } = useBackend<any>();

  const {
    UI_settings,
    circuits,
  } = props;

  return (
    <Section title="Terminal">
      <Flex direction="row" wrap="wrap" justify="space-evenly" align="baseline">
        {circuits.map(circuit =>
        (circuit.input && (
          <Flex.Item key={circuit.ref} grow={1} wrap="wrap" maxwidth="33%" inline={1} color="label" verticalAlignContent={1} basis="30%" m={0.5} p={0.5} >
            <Button icon="eye" width="95%" align="center" verticalAlignContent="center" height={2.5} fluid style={{ textWrap: "wrap" }} ellipsis onClick={() => act("input_selection", { ref: circuit.ref })}>
              {circuit.name}
            </Button>
          </Flex.Item>
        ) || null)
        )}
      </Flex>
    </Section>
  );
};
