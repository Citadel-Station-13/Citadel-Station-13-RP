import { arrayBucketSplit } from "common/collections";
import { BooleanLike } from "common/react";
import { useBackend, useSharedState } from "../backend";
import { Button, Flex, LabeledList, NoticeBox, ProgressBar, Section, Slider, Stack } from "../components";
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
}

interface DispenserMacro {
  name: string;
  data: Array<Record<string, number>>;
  index: number;
}

export const ChemDispenser = (props, context) => {
  const { act, data } = useBackend<ChemDispenserData>(context);
  const [macro, setMacro] = useSharedState<Array<[string, number]> | undefined>(context, 'recording', undefined);
  const isRecording = () => (macro !== undefined);
  const recordReagent = (id: string, amount: number) => {
    macro?.push([id, amount]);
  };
  const finalizeMacro = (name: string) => {
    act("add_macro", { data: macro, name: name });
  };
  return (
    <Window
      width={565}
      height={720}>
      <Window.Content>
        <Section title="Power">
          <LabeledList>
            <LabeledList.Item label="Cell" buttons={
              <Button
                icon="eject"
                content="Eject"
                disabled={!data.panel_open}
                onClick={() => act('eject_cell')} />
            }>
              <ProgressBar minValue={0} maxValue={data.cell_capacity} value={data.cell_charge}>
                {Math.round(data.cell_charge / data.cell_capacity * 100)}%
              </ProgressBar>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Dispenser">
          <LabeledList>
            <LabeledList.Item label="Amount">
              <Slider value={data.amount} minValue={0} maxValue={data.amount_max} unit="u"
                onChange={(_, val) => act('amount', { set: val })} />
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Macros"
          buttons={
            <Button
              content={macro === undefined? "Record" : "Stop"}
              onClick={() => macro === undefined? setMacro(new Array<[string, number]>()) : finalizeMacro("ERROR")}
              icon={macro === undefined? "circle" : "square"}
              color={macro === undefined? "good" : "bad"} />
          }>
          <Stack direction="column">
            {
              arrayBucketSplit(data.macros.sort((a, b) => (a.name.localeCompare(b.name))), 4).map((arr) => (
                // yes, this is shitcode for key, but maybe it shouldn't be so damn PICKY
                <Stack.Item grow={1} key={Math.random()}>
                  {arr.map((m) => (
                    <Flex direction="column" key={m}>
                      <Flex.Item grow={1}>
                        <Button
                          icon="rewind"
                          key={m.name}
                          content={m.name}
                          onClick={() => act('macro', { index: m.index })} />
                      </Flex.Item>
                      <Flex.Item>
                        <Button.Confirm
                          key={m.name}
                          icon="trash"
                          onClick={() => act('del_macro', { index: m.index })} />
                      </Flex.Item>
                    </Flex>
                  ))}
                </Stack.Item>
              ))
            }
          </Stack>
        </Section>
        <Section title="Synthesis">
          <Stack>
            {arrayBucketSplit(data.reagents.sort((a, b) => (a.name.localeCompare(b.name))), 4).map((reagentArray) => (
              <Stack.Item grow={1} key={Math.random()}>
                {reagentArray.map((reagent) => (
                  <Button
                    fluid
                    icon="tint"
                    key={reagent.id}
                    content={reagent.name}
                    onClick={() => {
                      act('reagent', { id: reagent.id });
                      recordReagent(reagent.id, data.amount);
                    }} />
                ))}
              </Stack.Item>
            ))}
          </Stack>
        </Section>
        <Section title="Cartridges">
          {data.cartridges.sort((a, b) => (a.label.localeCompare(b.label))).map((cart) => (
            <Stack direction="column" key={cart.label}>
              <Stack.Item>
                <Button
                  icon="tint"
                  content={`${cart.label} (${cart.amount})`}
                  onClick={() => act('cartridge', { label: cart.label })} />
              </Stack.Item>
              <Stack.Item>
                <Button
                  icon="trash"
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
            <ReagentContents
              reagents={data.beaker.data}
              reagentButtons={(id) => (
                <>
                  <Button
                    content="Isolate"
                    onClick={() => act('isolate', { id: id })} />
                  {
                    [1, 2, 3, 5, 10, 20].map((n) => (
                      <Button
                        key={n}
                        content={`-${n}`}
                        onClick={() => act('purge', { id: id, amount: n })} />
                    ))
                  }
                  <Button
                    content="Purge"
                    onClick={() => act('purge', { id: id })} />
                </>
              )} />
          ) : (
            <NoticeBox>
              No beaker inserted.
            </NoticeBox>
          )}
        </Section>
      </Window.Content>
    </Window>
  );
};
