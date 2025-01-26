import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";
import { actFunctionType, useBackend, useLocalState } from "tgui/backend";
import { Box, Button, Section, Stack, Tabs } from "tgui/components";
import { Window } from "tgui/layouts";

interface ModalData {
  primed: BooleanLike;
  ready: BooleanLike;
  levels: number;
  staged: StagingData | null;
  const_airVacuum: string;
  const_airHabitable: string;
}

interface StagingData {
  errors: string[];
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
  structPos: [number, number, number];
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
  const { act, data, nested_data } = useBackend<ModalData>(context);

  const mapData: ModalMapData = nested_data["map"];
  const overmapData: ModalOvermapData = nested_data['overmap'];
  const renderedLevels: InfernoNode[] = [];

  for (let i = 1; i <= data.levels; i++) {
    const mapLevelData: ModalLevelData = nested_data[`level-${i}`];
    renderedLevels.push((
      <MapLevelPane data={mapLevelData} act={act} />
    ));
  }

  return (
    <Window width={600} height={800} title="Upload Map Sector">
      <Window.Content>
        <Stack vertical>
          <Stack.Item height="33%">
            <Section title="Configuration">
              <MapPane data={mapData} overmapData={overmapData} act={act} />
            </Section>
          </Stack.Item>
          <Stack.Item height="66%">
            <Section title="Levels" fill overflow="auto"
              height="100%"
              buttons={(
                <Button
                  content="Add Level"
                  icon="plus"
                  onClick={() => act('newLevel')} />
              )}>
              {renderedLevels}
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
          <>
            {JSON.stringify(props.data)}
          </>
        )}
        {mapTab === 'overmap' && (
          <>
            {JSON.stringify(props.overmapData)}
          </>
        )}
      </Section>
    </Box>
  );
};

interface MapLevelProps {
  readonly data: ModalLevelData;
  readonly act: actFunctionType;
}

const MapLevelPane = (props: MapLevelProps, context) => {
  return (
    <>
      {JSON.stringify(props)}
    </>
  );
};
