import { BooleanLike } from "common/react";
import { useBackend, useSharedState } from "../backend";
import { Button, LabeledList, NoticeBox, NumberInput, ProgressBar, Section, Stack } from "../components";
import { Window } from "../layouts";
import { ReagentContents, ReagentContentsData } from "./common/Reagents";

interface ReagentData {
  name: string;
  id: string;
}

interface CartridgeData {
  label: string;
  amount: number;
}

interface BeakerData {
  name: string;
  volume: number;
  capacity: BeakerData;
  data: ReagentContentsData;
}

interface ChemDispenserData {
  cell_charge: number;
  cell_capacity: number;
  has_cell: BooleanLike;
  cartridges: Array<CartridgeData>;
  reagents: Array<ReagentData>;
  has_beaker: BooleanLike;
  beaker: BeakerData;
  panel_open: BooleanLike;
  macros: Array<DispenserMacro>;
  amount: number;
  amount_max: number;
  recharging: BooleanLike;
  recharge_rate: number;
}

interface DispenserMacro {
  name: string;
  data: Array<[string, number]>;
  index: number;
}

export const ChemDispenser = (props, context) => {
  const { act, data } = useBackend<ChemDispenserData>(context);
  const [macro, setMacro] = useSharedState<Array<[string, number]> | undefined>(context, 'recording', undefined);
  const isRecording = () => (macro !== undefined);
  const sortedMacros = data.macros.sort((a, b) => a.name.localeCompare(b.name));
  const sortedReagents = data.reagents.sort((a, b) => a.name.localeCompare(b.name));
  const windowWidth = 575;
  const buttonWidth = (windowWidth - 50) / 4;
  const recordReagent = (id: string, amount: number) => {
    if (macro === undefined) {
      return;
    }
    let appended = macro?.slice();
    if (appended.length && appended[appended.length - 1][0] === id) {
      let remaining = Math.max(0, data.amount_max - appended[appended.length - 1][1]);
      let wanted = Math.min(remaining, amount);
      appended[appended.length - 1][1] += wanted;
      amount -= wanted;
    }
    if (amount > 0) {
      appended?.push([id, amount]);
    }
    setMacro(appended);
  };
  const finalizeMacro = (name?: string) => {
    if (macro?.length) {
      act("add_macro", { data: macro, name: name });
    }
    setMacro(undefined);
  };
  return (
    <Window
      width={windowWidth}
      height={720}>
      <Window.Content>
        <Section title="Power">
          <LabeledList>
            <LabeledList.Item label="Cell" buttons={
              <Button
                icon="eject"
                content="Eject"
                disabled={!data.panel_open || !data.has_cell}
                onClick={() => act('eject_cell')} />
            }>
              <ProgressBar
                minValue={0}
                maxValue={data.has_cell? data.cell_capacity : 100}
                value={data.has_cell? data.cell_charge : 0}>
                {data.has_cell ? (
                  `${Math.round(data.cell_charge / data.cell_capacity * 100)}%`
                ) : (
                  "No Cell"
                )}
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Charging" buttons={
              <Button
                content={data.recharging? "On" : "Off"}
                icon="power-off"
                color={data.recharging? "good" : "bad"}
                onClick={() => act('toggle_charge')} />
            }>
              {data.recharging? `Drawing ${data.recharge_rate}kW` : ``}
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Dispenser">
          <LabeledList>
            <LabeledList.Item label="Amount" buttons={
              <>
                {
                  [1, 5, 10, 15, 20, 30, 60].map((n) => (
                    <Button
                      icon="plus"
                      key={`${n}`}
                      content={`${n}`}
                      selected={data.amount === n}
                      onClick={() => act('amount', { set: n })} />
                  ))
                }
                <NumberInput
                  width="40px"
                  value={data.amount}
                  step={1}
                  minValue={1}
                  maxValue={data.amount_max}
                  onChange={(_, val) => act('amount', { set: val })} />
              </>
            } />
          </LabeledList>
        </Section>
        <Section title="Macros"
          buttons={
            <Button
              content={macro === undefined? "Record" : "Stop"}
              onClick={() => macro === undefined? setMacro(new Array<[string, number]>()) : finalizeMacro()}
              icon={macro === undefined? "circle" : "square"}
              color={macro === undefined? "good" : "bad"} />
          }>
          {
            sortedMacros.map((macro) => (
              <Stack mr="5px" inline width={`${buttonWidth}px`} key={`${macro.index} ${macro.name}`}>
                <Stack.Item grow={1}>
                  <Button
                    icon="forward"
                    fluid
                    content={macro.name}
                    onClick={() => act('macro', { index: macro.index })} />
                </Stack.Item>
                <Stack.Item>
                  <Button.Confirm
                    icon="trash"
                    onClick={() => act('del_macro', { index: macro.index })} />
                </Stack.Item>
              </Stack>
            ))
          }
        </Section>
        <Section title="Synthesis">
          {sortedReagents.map((reagent) => (
            <Button
              icon="tint"
              mr="5px"
              width={`${buttonWidth}px`}
              content={reagent.name}
              key={reagent.id}
              onClick={() => {
                act('reagent', { id: reagent.id });
                recordReagent(reagent.id, data.amount);
              }} />
          ))}
        </Section>
        <Section title="Cartridges">
          {data.cartridges.sort((a, b) => (a.label.localeCompare(b.label))).map((cart) => (
            <Stack mr="5px" inline key={cart.label} width={`${buttonWidth}px`}>
              <Stack.Item>
                <Button
                  icon="tint"
                  fluid
                  content={`${cart.label} (${cart.amount})`}
                  onClick={() => act('cartridge', { label: cart.label })} />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="eject"
                  disabled={!data.panel_open}
                  onClick={() => act('eject_cart', { label: cart.label })} />
              </Stack.Item>
            </Stack>
          ))}
        </Section>
        {macro !== undefined && (
          <Section title="Macro Recording">
            {
              macro.map((a) => `${a[0]}: ${a[1]}`).join(", ")
            }
          </Section>
        )}
        <Section
          title="Beaker"
          buttons={
            <Button
              icon="eject"
              content="Eject"
              disabled={!data.has_beaker}
              onClick={() => act('eject')} />
          }>
          {data.has_beaker? (
            <Section title={`${data.beaker.name} - ${data.beaker.volume} / ${data.beaker.capacity}`}>
              <ReagentContents
                reagents={data.beaker.data}
                reagentButtons={(id) => (
                  <>
                    <Button
                      content="Isolate"
                      icon="compress-arrows-alt"
                      onClick={() => act('isolate', { id: id })} />
                    {
                      [1, 5, 10, 15, 30].map((n) => (
                        <Button
                          key={n}
                          content={`-${n}`}
                          onClick={() => act('purge', { id: id, amount: n })} />
                      ))
                    }
                    <Button
                      content="Purge"
                      icon="trash"
                      onClick={() => act('purge', { id: id })} />
                  </>
                )} />
            </Section>
          ) : (
            <Section>
              <NoticeBox>
                No beaker inserted.
              </NoticeBox>
            </Section>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
