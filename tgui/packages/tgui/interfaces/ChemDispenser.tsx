import { arrayBucketSplit } from "common/collections";
import { BooleanLike } from "common/react";
import { useBackend, useSharedState } from "../backend";
import { Button, Flex, LabeledList, NoticeBox, ProgressBar, Section, Slider } from "../components";
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
}

export const ChemDispenser = (props, context) => {
  const { act, data } = useBackend<ChemDispenserData>(context);
  const [macro, setMacro] = useSharedState<Array<Record<string, number>> | undefined>(context, 'recording', undefined);
  return (
    <Window
      width={400}
      height={600}>
      <Window.Content>
        <Section title="Dispenser">
          <LabeledList>
            <LabeledList.Item label="Cell">
              <ProgressBar minValue={0} maxValue={data.cell_capacity} value={data.cell_charge}>
                {Math.round(data.cell_charge / data.cell_capacity)}%
              </ProgressBar>
            </LabeledList.Item>
            <LabeledList.Item label="Amount">
              <Slider>
                test
              </Slider>
            </LabeledList.Item>
          </LabeledList>
        </Section>
        <Section title="Macros">
          <Flex direction="column">
            {
              arrayBucketSplit(data.macros.sort((a, b) => (b.name.localeCompare(a.name))), 4).map((arr) => (
                <Flex.Item key>
                  {arr.map((m) => (
                    <Button
                      key={m.name}
                      title={m.name}
                      onClick={} />
                  ))}
                </Flex.Item>
              ))
            }
          </Flex>
        </Section>
        <Section title="Synthesis">
          <Flex direction="column">
            {arrayBucketSplit(data.reagents.sort((a, b) => (b.name.localeCompare(a.name))), 4).map((reagentArray) => (
              <Flex.Item key={reagentArray}>
                {reagentArray.map((reagent) => (
                  <Button
                    key={reagent.id}
                    fluid
                    title={reagent.name}
                    onClick={} />
                ))}
              </Flex.Item>
            ))}
          </Flex>
        </Section>
        <Section title="Cartridges">
          {data.cartridges.sort((a, b) => (b.label.localeCompare(a.label))).map((cart) => (
            <Button
              title={`${cart.label} (${cart.amount})`}
              key={cart.label}
              onClick={} />
          ))}
        </Section>
        <Section title="Beaker">
          {data.has_beaker? (
            <ReagentContents
              reagents={data.beaker.data}
              reagentButtons={(id) => (
                <>
                  <Button
                    title="Isolate"
                    onClick={} />
                  {
                    [1, 2, 3, 5, 10, 20].map((n) => (
                      <Button
                        key={n}
                        title={`-${n}`}
                        onClick={} />
                    ))
                  }
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

/*
const dispenseAmounts = [5, 10, 20, 30, 40, 60];
const removeAmounts = [1, 5, 10];

export const ChemDispenser = (props, context) => {
  return (
    <Window
      width={390}
      height={655}
      resizable>
      <Window.Content className="Layout__content--flexColumn">
        <ChemDispenserSettings />
        <ChemDispenserChemicals />
        <ChemDispenserBeaker />
      </Window.Content>
    </Window>
  );
};

const ChemDispenserSettings = (properties, context) => {
  const { act, data } = useBackend(context);
  const {
    amount,
  } = data;
  return (
    <Section title="Settings" flex="content">
      <LabeledList>
        <LabeledList.Item label="Dispense" verticalAlign="middle">
          <Flex direction="row" wrap="wrap" spacing="1">
            {dispenseAmounts.map((a, i) => (
              <Flex.Item key={i} grow="1">
                <Button
                  textAlign="center"
                  selected={amount === a}
                  content={a + "u"}
                  m="0"
                  fluid
                  onClick={() => act('amount', {
                    amount: a,
                  })}
                />
              </Flex.Item>
            ))}
          </Flex>
        </LabeledList.Item>
        <LabeledList.Item label="Custom Amount">
          <Slider
            step={1}
            stepPixelSize={5}
            value={amount}
            minValue={1}
            maxValue={120}
            onDrag={(e, value) => act('amount', {
              amount: value,
            })} />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const ChemDispenserChemicals = (properties, context) => {
  const { act, data } = useBackend(context);
  const {
    chemicals = [],
  } = data;
  const flexFillers = [];
  for (let i = 0; i < (chemicals.length + 1) % 3; i++) {
    flexFillers.push(true);
  }
  return (
    <Section
      title={data.glass ? 'Drink Dispenser' : 'Chemical Dispenser'}
      flexGrow="1">
      <Flex
        direction="row"
        wrap="wrap"
        height="100%"
        align="flex-start">
        {chemicals.map((c, i) => (
          <Flex.Item key={i} grow="1" m={0.2} basis="40%" height="20px">
            <Button
              icon="arrow-circle-down"
              width="100%"
              height="100%"
              align="flex-start"
              content={c.title + " (" + c.amount + ")"}
              onClick={() => act('dispense', {
                reagent: c.id,
              })}
            />
          </Flex.Item>
        ))}
        {flexFillers.map((_, i) => (
          <Flex.Item key={i} grow="1" basis="25%" height="20px" />
        ))}
      </Flex>
    </Section>
  );
};

const ChemDispenserBeaker = (properties, context) => {
  const { act, data } = useBackend(context);
  const {
    isBeakerLoaded,
    beakerCurrentVolume,
    beakerMaxVolume,
    beakerContents = [],
  } = data;
  return (
    <Section
      title="Beaker"
      flex="content"
      minHeight="25%"
      buttons={(
        <Box>
          {!!isBeakerLoaded && (
            <Box inline color="label" mr={2}>
              {beakerCurrentVolume} / {beakerMaxVolume} units
            </Box>
          )}
          <Button
            icon="eject"
            content="Eject"
            disabled={!isBeakerLoaded}
            onClick={() => act('ejectBeaker')}
          />
        </Box>
      )}>
      <BeakerContents
        beakerLoaded={isBeakerLoaded}
        beakerContents={beakerContents}
        buttons={chemical => (
          <Fragment>
            <Button
              content="Isolate"
              icon="compress-arrows-alt"
              onClick={() => act('remove', {
                reagent: chemical.id,
                amount: -1,
              })}
            />
            {removeAmounts.map((a, i) => (
              <Button
                key={i}
                content={a}
                onClick={() => act('remove', {
                  reagent: chemical.id,
                  amount: a,
                })}
              />
            ))}
            <Button
              content="ALL"
              onClick={() => act('remove', {
                reagent: chemical.id,
                amount: chemical.volume,
              })}
            />
          </Fragment>
        )}
      />
    </Section>
  );
};
*/
