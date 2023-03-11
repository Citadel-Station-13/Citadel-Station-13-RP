import { arrayBucketFill } from "common/collections";
import { BooleanLike } from "common/react";
import { useBackend, useSharedState } from "../backend";
import { Button, LabeledList, NoticeBox, ProgressBar, Section, Slider, Stack } from "../components";
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
    if (macro === undefined) {
      return;
    }
    let appended = macro?.slice();
    if (appended.length && appended[appended.length - 1][0] === id) {
      appended[appended.length - 1][1] += amount;
    }
    else {
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
      width={565}
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
          </LabeledList>
        </Section>
        <Section title="Dispenser">
          <LabeledList>
            <LabeledList.Item label="Amount">
              <Slider step={1} stepPixelSize={8} value={data.amount} minValue={0} maxValue={data.amount_max} unit="u"
                onChange={(_, val) => act('amount', { set: val })} />
            </LabeledList.Item>
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
          <Stack vertical>
            {
              arrayBucketFill(data.macros.sort((a, b) => (a.name.localeCompare(b.name))), 4).map((arr) => (
                // yes, this is shitcode for key, but maybe it shouldn't be so damn PICKY
                <Stack.Item key={Math.random()}>
                  <Stack>
                    {arr.map((m) => (
                    // ditto
                      <Stack.Item grow={1} key={Math.random()}>
                        <Stack>
                          <Stack.Item grow={1}>
                            <Button
                              icon="forward"
                              fluid
                              key={m.name}
                              content={m.name}
                              onClick={() => act('macro', { index: m.index })} />
                          </Stack.Item>
                          <Stack.Item>
                            <Button.Confirm
                              key={m.name}
                              icon="trash"
                              onClick={() => act('del_macro', { index: m.index })} />
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    ))}
                  </Stack>
                </Stack.Item>
              ))
            }
          </Stack>
        </Section>
        <Section title="Synthesis">
          <Stack vertical>
            {arrayBucketFill(data.reagents.sort((a, b) => (a.name.localeCompare(b.name))), 4).map((reagentArray) => (
              <Stack.Item key={Math.random()}>
                <Stack>
                  {reagentArray.map((reagent) => (
                    <Stack.Item grow={1} key={reagent.id}>
                      <Button
                        fluid
                        icon="tint"
                        content={reagent.name}
                        onClick={() => {
                          act('reagent', { id: reagent.id });
                          recordReagent(reagent.id, data.amount);
                        }} />
                    </Stack.Item>
                  ))}
                </Stack>
              </Stack.Item>
            ))}
          </Stack>
        </Section>
        <Section title="Cartridges">
          {data.cartridges.sort((a, b) => (a.label.localeCompare(b.label))).map((cart) => (
            <Stack key={cart.label}>
              <Stack.Item>
                <Button
                  icon="tint"
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
            <ReagentContents
              reagents={data.beaker.data}
              reagentButtons={(id) => (
                <>
                  <Button
                    content="Isolate"
                    icon="compress-arrows-alt"
                    onClick={() => act('isolate', { id: id })} />
                  {
                    [1, 2, 3, 5].map((n) => (
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
