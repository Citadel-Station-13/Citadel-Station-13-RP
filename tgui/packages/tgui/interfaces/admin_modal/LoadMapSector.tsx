import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { actFunctionType, useBackend, useLocalState } from "tgui/backend";
import { Box, Button, Flex, Input, LabeledList, NumberInput, Section, Stack, Tabs } from "tgui/components";
import { Window } from "tgui/layouts";

enum LoadMapSectorStatus {
  Waiting = "waiting",
  Ready = "Ready",
  Loading = "loading",
  Finished = "Finsihed",
}


interface ModalData {
  status: LoadMapSectorStatus;
  ready: BooleanLike;
  levels: number;
  const_airVacuum: string;
  const_airHabitable: string;
}

interface ModalMapData {
  name: string;
  orientation: number;
  center: BooleanLike;
}

interface ModalLevelData {
  id: string;
  displayId: string;
  name: string;
  displayName: string;
  traits: string[];
  attributes: Record<string, string | number>;
  baseTurf: string;
  baseArea: string;
  structX: number | null;
  structY: number | null;
  structZ: number | null;
  airIndoors: string | undefined;
  airOutdoors: string | undefined;
  ceilingHeight: number | undefined;
  fileName: string | undefined;
}

interface ModalOvermapData {
  x: number;
  y: number;
  forcePos: BooleanLike;
}

export const LoadMapSector = (props, context) => {
  const { act, data, nestedData } = useBackend<ModalData>(context);

  const mapData: ModalMapData = nestedData["map"];
  const overmapData: ModalOvermapData = nestedData['overmap'];
  const renderedLevels: InfernoNode[] = [];

  for (let i = 1; i <= data.levels; i++) {
    const mapLevelData: ModalLevelData = nestedData[`level-${i}`];
    renderedLevels.push((
      <Stack.Item>
        <MapLevelPane data={mapLevelData} act={act} index={i} />
      </Stack.Item>
    ));
  }

  return (
    <Window width={600} height={800} title="Upload Map Sector">
      <Window.Content>
        <Stack vertical fill>
          <Stack.Item grow={1}>
            <Section title="Configuration" height="100%">
              <MapPane data={mapData} overmapData={overmapData} act={act} />
            </Section>
          </Stack.Item>
          <Stack.Item grow={2}>
            <Section title="Levels" fill overflow="auto"
              height="100%"
              buttons={(
                <Button
                  content="Add Level"
                  icon="plus"
                  onClick={() => act('newLevel')} />
              )}>
              <Stack vertical fill>
                {renderedLevels}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

interface MapPaneProps {
  readonly data: ModalMapData;
  readonly overmapData: ModalOvermapData;
  readonly act: actFunctionType;
}

const MapPane = (props: MapPaneProps, context) => {
  const [mapTab, setMapTab] = useLocalState(context, 'mapPaneTab', 'map');
  return (
    <Box width="100%" height="100%">
      <Tabs fluid>
        <Tabs.Tab
          style={{ "text-align": "center", "font-weight": "bold" }}
          selected={mapTab === 'map'}
          onClick={() => setMapTab('map')}>
          Map
        </Tabs.Tab>
        <Tabs.Tab
          style={{ "text-align": "center", "font-weight": "bold" }}
          selected={mapTab === 'overmap'}
          onClick={() => setMapTab('overmap')}>
          Overmap
        </Tabs.Tab>
      </Tabs>
      <Section>
        {mapTab === 'map' && (
          <LabeledList>
            <LabeledList.Item label="Name" labelDesc="Name of the map.">
              Test
            </LabeledList.Item>
            <LabeledList.Item label="Orientation" labelDesc="Load orientation for the levels on this map.">
              Test
            </LabeledList.Item>
            <LabeledList.Item label="Center" labelDesc="Center the levels on this map. This should usually be on.">
              Test
            </LabeledList.Item>
          </LabeledList>
        )}
        {mapTab === 'overmap' && (
          <LabeledList>
            <LabeledList.Item label="Load Into Overmap" labelDesc="Whether or not this level should be loaded into the overmap. This usually should be on.">
              Test
            </LabeledList.Item>
            <LabeledList.Item label="X" labelDesc="If set, try to set the sector at this X on the overmap.">
              Test
            </LabeledList.Item>
            <LabeledList.Item label="Y" labelDesc="If set, try to set the sector at this Y on the overmap.">
              Test
            </LabeledList.Item>
            <LabeledList.Item label="Force Position" labelDesc="If enabled, override overmap placement safety checks.">
              Test
            </LabeledList.Item>
          </LabeledList>
        )}
      </Section>
    </Box>
  );
};

interface MapLevelProps {
  readonly data: ModalLevelData;
  readonly act: actFunctionType;
  readonly index: number;
}

const MapLevelPane = (props: MapLevelProps, context) => {
  const [levelTab, setLevelTab] = useLocalState(context, 'levelPaneTab', `level-${props.data.index}`);
  return (
    <Box>
      <Box>
        <h1>Test</h1>
      </Box>
      <Tabs textAlign="center">
        <Tabs.Tab selected={levelTab === "level"} onClick={() => setLevelTab("level")}>Level</Tabs.Tab>
        <Tabs.Tab selected={levelTab === "trait"} onClick={() => setLevelTab("trait")}>Traits</Tabs.Tab>
        <Tabs.Tab selected={levelTab === "attr"} onClick={() => setLevelTab("attr")}>Attributes</Tabs.Tab>
      </Tabs>
      <LabeledList>
        <LabeledList.Item label="DMM">
          Test
        </LabeledList.Item>
        <LabeledList.Item label="Struct Position">
          <Flex width="100%">
            <Flex.Item>
              X: <NumberInput value={0} onChange={(e, val) => {}} />
            </Flex.Item>
            <Flex.Item>
              Y: <NumberInput value={0} onChange={(e, val) => {}} />
            </Flex.Item>
            <Flex.Item>
              Z: <NumberInput value={0} onChange={(e, val) => {}} />
            </Flex.Item>
          </Flex>
        </LabeledList.Item>
        <LabeledList.Item label="Name">
          <Input onChange={(e, val) => {}} width="100%" value={"test"} />
        </LabeledList.Item>
        <LabeledList.Item label="ID">
          <Input onChange={(e, val) => {}} width="100%" value={"test"} />
        </LabeledList.Item>
        <LabeledList.Item label="Display Name (IC)">
          <Input onChange={(e, val) => {}} width="100%" value={"test"} />
        </LabeledList.Item>
        <LabeledList.Item label="Display ID (IC)">
          <Input onChange={(e, val) => {}} width="100%" value={"test"} />
        </LabeledList.Item>
        <LabeledList.Item label="Base Turf">
          Test
        </LabeledList.Item>
        <LabeledList.Item label="Base Area">
          Test
        </LabeledList.Item>
        <LabeledList.Item label="Air - Indoors">
          Test
        </LabeledList.Item>
        <LabeledList.Item label="Air - Outdoors">
          Test
        </LabeledList.Item>
        <LabeledList.Item label="Ceiling Height">
          <NumberInput value={0} minValue={0} onChange={(e, val) => {}} width="100%" />
        </LabeledList.Item>
      </LabeledList>
    </Box>
  );
};
