import { Color } from '../../common/colorLegacy';
import { useBackend } from '../backend';
import { AnimatedNumber, Box, Button, Section, Table } from '../components';
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
}

// TODO: Universal type for assets. @Zandario
type StyleData = {
  id: number | string;
  className: string;
  title: string;
};


export const ChemPrimi = (props, context) => {
  const { data } = useBackend<ChemMasterData>(context);
  const { screen } = data;
  return (
    <Window width={465} height={550}>
      <Window.Content scrollable>
        {<ChemPrimiContent />}
      </Window.Content>
    </Window>
  );
};

const ChemPrimiContent = (props, context) => {
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
            </>)
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
            })}
        />
        <Button
          content="5"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 5,
              to: transferTo,
            })}
        />
        <Button
          content="10"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 10,
              to: transferTo,
            })}
        />
        <Button
          content="30"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 30,
              to: transferTo,
            })}
        />
        <Button
          content="60"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 60,
              to: transferTo,
            })}
        />
        <Button
          content="All"
          onClick={() =>
            act('transfer', {
              id: chemical.id,
              amount: 1000,
              to: transferTo,
            })}
        />
      </Table.Cell>
    </Table.Row>
  );
};

