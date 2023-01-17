import { Color } from '../../common/color';
import { useBackend, useSharedState } from '../backend';
import { AnimatedNumber, Box, Button, ColorBox, LabeledList, NumberInput, Section, Table } from '../components';
import { Window } from '../layouts';

type ChemMasterData = {
  // Generic Data
  mode: boolean;
  screen: string;
  condi: boolean;
  printing: boolean;

  // Beaker Data
  is_beaker_loaded: boolean;
  beaker_contents: ReagentData[];
  beaker_current_volume: number;
  beaker_max_volume: number;

  // Pill Bottle Data
  is_pill_bottle_loaded: boolean;
  pill_bottle_current_amount: number;
  pill_bottle_max_amount: number;

  // Buffer Data
  buffer_contents: ReagentData[];

  // Style Data
  pill_styles: StyleData[];
  bottle_styles: StyleData[];
  patch_styles: StyleData[];
  condi_styles: StyleData[];

  // Chosen Styl Data
  chosen_pill_style: number;
  chosen_bottle_style: number;
  chosen_patch_style: string;
  chosen_condi_style: string;
  auto_condi_style: string;

  // Screen Data
  analyzeVars: AnalyzeData;
};

type ReagentData = {
  name: string;
  id: string;
  description: string;
  volume: number;
};

type AnalyzeData = {
  name: string;
  state: string;
  color: Color;
  description: string;
  metaRate: number;
  overD: number;
};

// TODO: Universal type for assets. @Zandario
type StyleData = {
  id: number | string;
  className: string;
  title: string;
};

export const ChemMaster = (props, context) => {
  const { data } = useBackend<ChemMasterData>(context);
  const { screen } = data;
  return (
    <Window width={465} height={550}>
      <Window.Content scrollable>
        {(screen === 'analyze' && <AnalysisResults />) || <ChemMasterContent />}
      </Window.Content>
    </Window>
  );
};

const ChemMasterContent = (props, context) => {
  const { act, data } = useBackend<ChemMasterData>(context);
  const {
    screen,
    beaker_contents = [],
    buffer_contents = [],
    beaker_current_volume,
    beaker_max_volume,
    is_beaker_loaded,
    is_pill_bottle_loaded,
    pill_bottle_current_amount,
    pill_bottle_max_amount,
  } = data;
  if (screen === 'analyze') {
    return <AnalysisResults />;
  }
  return (
    <>
      <Section
        title="Beaker"
        buttons={
          !!data.is_beaker_loaded && (
            <>
              <Box inline color="label" mr={2}>
                <AnimatedNumber value={beaker_current_volume} initial={0} />
                {` / ${beaker_max_volume} units`}
              </Box>
              <Button
                icon="eject"
                content="Eject"
                onClick={() => act('eject')}
              />
            </>
          )
        }>
        {!is_beaker_loaded && (
          <Box color="label" mt="3px" mb="5px">
            No beaker loaded.
          </Box>
        )}
        {!!is_beaker_loaded && beaker_contents.length === 0 && (
          <Box color="label" mt="3px" mb="5px">
            Beaker is empty.
          </Box>
        )}
        <ChemicalBuffer>
          {beaker_contents.map((chemical) => (
            <ChemicalBufferEntry
              key={chemical.id}
              chemical={chemical}
              transferTo="buffer"
            />
          ))}
        </ChemicalBuffer>
      </Section>
      <Section
        title="Buffer"
        buttons={
          <>
            <Box inline color="label" mr={1}>
              Mode:
            </Box>
            <Button
              color={data.mode ? 'good' : 'bad'}
              icon={data.mode ? 'exchange-alt' : 'times'}
              content={data.mode ? 'Transfer' : 'Destroy'}
              onClick={() => act('toggleMode')}
            />
          </>
        }>
        {buffer_contents.length === 0 && (
          <Box color="label" mt="3px" mb="5px">
            Buffer is empty.
          </Box>
        )}
        <ChemicalBuffer>
          {buffer_contents.map((chemical) => (
            <ChemicalBufferEntry
              key={chemical.id}
              chemical={chemical}
              transferTo="beaker"
            />
          ))}
        </ChemicalBuffer>
      </Section>
      <Section title="Packaging">
        <PackagingControls />
      </Section>
      {!!is_pill_bottle_loaded && (
        <Section
          title="Pill Bottle"
          buttons={
            <>
              <Box inline color="label" mr={2}>
                {pill_bottle_current_amount} / {pill_bottle_max_amount} pills
              </Box>
              <Button
                icon="eject"
                content="Eject"
                onClick={() => act('ejectPillBottle')}
              />
            </>
          }
        />
      )}
    </>
  );
};

const ChemicalBuffer = Table;

const ChemicalBufferEntry = (props, context) => {
  const { act } = useBackend<ChemMasterData>(context);
  const { chemical, transferTo } = props;
  return (
    <Table.Row key={chemical.id}>
      <Table.Cell color="label">
        <AnimatedNumber value={chemical.volume} initial={0} />
        {` units of ${chemical.name}`}
      </Table.Cell>
      <Table.Cell collapsing>
        <Button
          content="1"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 1,
              to: transferTo,
            })
          }
        />
        <Button
          content="5"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 5,
              to: transferTo,
            })
          }
        />
        <Button
          content="10"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 10,
              to: transferTo,
            })
          }
        />
        <Button
          content="30"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 30,
              to: transferTo,
            })
          }
        />
        <Button
          content="60"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 60,
              to: transferTo,
            })
          }
        />
        <Button
          content="All"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 1000,
              to: transferTo,
            })
          }
        />
        <Button
          icon="ellipsis-h"
          title="Custom amount"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: -1,
              to: transferTo,
            })
          }
        />
        <Button
          icon="question"
          title="Analyze"
          onClick={() =>
            act('analyze', {
              id: chemical.id,
            })
          }
        />
      </Table.Cell>
    </Table.Row>
  );
};

const PackagingControlsItem = (props) => {
  const { label, amountUnit, amount, onChangeAmount, onCreate, sideNote } =
    props;
  return (
    <LabeledList.Item label={label}>
      <NumberInput
        width="84px"
        unit={amountUnit}
        step={1}
        stepPixelSize={15}
        value={amount}
        minValue={1}
        maxValue={10}
        onChange={onChangeAmount}
      />
      <Button ml={1} content="Create" onClick={onCreate} />
      <Box inline ml={1} color="label">
        {sideNote}
      </Box>
    </LabeledList.Item>
  );
};

const PackagingControls = (props, context) => {
  const { act, data } = useBackend<ChemMasterData>(context);
  const [pillAmount, setPillAmount] = useSharedState(context, 'pillAmount', 1);
  const [patchAmount, setPatchAmount] = useSharedState(
    context,
    'patchAmount',
    1
  );
  const [bottleAmount, setBottleAmount] = useSharedState(
    context,
    'bottleAmount',
    1
  );
  const [packAmount, setPackAmount] = useSharedState(context, 'packAmount', 1);
  const {
    condi,
    chosen_pill_style,
    chosen_bottle_style,
    chosen_condi_style,
    chosen_patch_style,
    auto_condi_style,
    pill_styles = [],
    bottle_styles = [],
    condi_styles = [],
    patch_styles = [],
  } = data;
  const auto_condi_style_chosen = auto_condi_style === chosen_condi_style;
  return (
    <LabeledList>
      {!condi && (
        <LabeledList.Item label="Pill type">
          {pill_styles.map((pill) => (
            <Button
              key={pill.id}
              width="30px"
              verticalAlignContent="middle"
              textAlign="center"
              selected={pill.id === chosen_pill_style}
              color="transparent"
              onClick={() => act('change_pill_style', { id: pill.id })}>
              <Box mx={-1} mb={0} mt={1} className={pill.className} />
            </Button>
          ))}
        </LabeledList.Item>
      )}
      {!condi && (
        <PackagingControlsItem
          label="Pills"
          amount={pillAmount}
          amountUnit="pills"
          sideNote="max 50u"
          onChangeAmount={(e, value) => setPillAmount(value)}
          onCreate={() =>
            act('create', {
              type: 'pill',
              amount: pillAmount,
              volume: 'auto',
            })
          }
        />
      )}
      {!condi && (
        <LabeledList.Item label="Patch type">
          {patch_styles.map((patch) => (
            <Button
              key={patch.id}
              selected={patch.id === chosen_patch_style}
              textAlign="center"
              color="transparent"
              onClick={() =>
                act('change_patch_style', { chosen_patch_style: patch.id })
              }>
              <Box mb={0} mt={1} className={patch.className} />
            </Button>
          ))}
        </LabeledList.Item>
      )}
      {!condi && (
        <PackagingControlsItem
          label="Patches"
          amount={patchAmount}
          amountUnit="patches"
          sideNote="max 40u"
          onChangeAmount={(e, value) => setPatchAmount(value)}
          onCreate={() =>
            act('create', {
              type: 'patch',
              amount: patchAmount,
              volume: 'auto',
            })
          }
        />
      )}
      {!condi && (
        <LabeledList.Item label="Bottle type">
          {bottle_styles.map((bottle) => (
            <Button
              key={bottle.id}
              width="30px"
              selected={bottle.id === chosen_bottle_style}
              textAlign="center"
              color="transparent"
              onClick={() => act('change_bottle_style', { id: bottle.id })}>
              <Box mx={-1} mb={0} mt={1} className={bottle.className} />
            </Button>
          ))}
        </LabeledList.Item>
      )}
      {!condi && (
        <PackagingControlsItem
          label="Bottles"
          amount={bottleAmount}
          amountUnit="bottles"
          sideNote="max 60u"
          onChangeAmount={(e, value) => setBottleAmount(value)}
          onCreate={() =>
            act('create', {
              type: 'bottle',
              amount: bottleAmount,
              volume: 'auto',
            })
          }
        />
      )}
      {!!condi && (
        <LabeledList.Item label="Bottle type">
          <Button.Checkbox
            onClick={() =>
              act('change_condi_style', {
                id: auto_condi_style_chosen
                  ? condi_styles[0].id
                  : auto_condi_style,
              })
            }
            checked={auto_condi_style_chosen}
            disabled={!condi_styles.length}>
            Guess from contents
          </Button.Checkbox>
        </LabeledList.Item>
      )}
      {!!condi && !auto_condi_style_chosen && (
        <LabeledList.Item label="">
          {condi_styles.map((style) => (
            <Button
              key={style.id}
              width="30px"
              selected={style.id === chosen_condi_style}
              textAlign="center"
              color="transparent"
              title={style.title}
              onClick={() => act('condiStyle', { id: style.id })}>
              <Box mx={-1} className={style.className} />
            </Button>
          ))}
        </LabeledList.Item>
      )}
      {!!condi && (
        <PackagingControlsItem
          label="Bottles"
          amount={bottleAmount}
          amountUnit="bottles"
          sideNote="max 50u"
          onChangeAmount={(e, value) => setBottleAmount(value)}
          onCreate={() =>
            act('create', {
              type: 'condiment_bottle',
              amount: bottleAmount,
              volume: 'auto',
            })
          }
        />
      )}
      {!!condi && (
        <PackagingControlsItem
          label="Packs"
          amount={packAmount}
          amountUnit="packs"
          sideNote="max 10u"
          onChangeAmount={(e, value) => setPackAmount(value)}
          onCreate={() =>
            act('create', {
              type: 'condiment_pack',
              amount: packAmount,
              volume: 'auto',
            })
          }
        />
      )}
    </LabeledList>
  );
};

const AnalysisResults = (props, context) => {
  const { act, data } = useBackend<ChemMasterData>(context);
  const { analyzeVars } = data;
  return (
    <Section
      title="Analysis Results"
      buttons={
        <Button
          icon="arrow-left"
          content="Back"
          onClick={() =>
            act('goScreen', {
              screen: 'home',
            })
          }
        />
      }>
      <LabeledList>
        <LabeledList.Item label="Name">{analyzeVars.name}</LabeledList.Item>
        <LabeledList.Item label="State">{analyzeVars.state}</LabeledList.Item>
        {/* <LabeledList.Item label="pH">{analyzeVars.ph}</LabeledList.Item> */}
        <LabeledList.Item label="Color">
          <ColorBox color={analyzeVars.color} mr={1} />
          {analyzeVars.color}
        </LabeledList.Item>
        <LabeledList.Item label="Description">
          {analyzeVars.description}
        </LabeledList.Item>
        <LabeledList.Item label="Metabolization Rate">
          {analyzeVars.metaRate}
        </LabeledList.Item>
        <LabeledList.Item label="Overdose Threshold">
          {analyzeVars.overD}
        </LabeledList.Item>
        {/* <LabeledList.Item label="Addiction Threshold">
          {analyzeVars.addicD}
        </LabeledList.Item> */}
      </LabeledList>
    </Section>
  );
};
