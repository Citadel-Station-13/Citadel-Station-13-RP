/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { useBackend, useLocalState } from "tgui/backend";
import { Button, Flex, Input, LabeledList, NumberInput, Section, Stack, Tabs } from "tgui/components";
import { Window } from "tgui/layouts";
import { VSplitTooltipList } from "../../components/TwoColumnConfigurationList";

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
  const [currentTab, setCurrentTab] = useLocalState<string>(context, 'currentTab', 'map');

  const mapData: ModalMapData = nestedData["map"];
  const overmapData: ModalOvermapData = nestedData['overmap'];

  return (
    <Window width={700} height={800} title="Upload Map Sector">
      <Window.Content>
        <Stack fill>
          <Stack.Item>
            <Section fill title="Components" minWidth="12em">
              <Stack vertical fill>
                <Stack.Item>
                  <Button selected={currentTab === 'map'}
                    fluid
                    onClick={() => setCurrentTab('map')}
                    color="transparent" content="Map" />
                </Stack.Item>
                <Stack.Item>
                  <Button selected={currentTab === 'overmap'}
                    fluid
                    onClick={() => setCurrentTab('overmap')}
                    color="transparent" content="Overmap" />
                </Stack.Item>
                {new Array(data.levels).fill(0).map((v, i) => (
                  <Stack.Item key={i}>
                    <Button
                      fluid color="transparent"
                      selected={currentTab === `level=$[i]`}
                      onClick={() => setCurrentTab(`level-${i}`)}
                      content={`Level ${i}`} />
                  </Stack.Item>
                ))}
                <Stack.Item grow={1} />
                <Stack.Item>
                  <Button.Confirm content="Add Level" icon="plus"
                    color="transparent"
                    fluid onClick={() => act('newLevel')} />
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
          <Stack.Item grow={1}>
            {currentTab === 'map' && (
              <MapOptions />
            )}
            {currentTab === 'overmap' && (
              <OvermapOptions />
            )}
            {currentTab.startsWith("level-") && (
              <MapLevelOptions />
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MapOptions = (props: {

}, context) => {
  const { act, data, nestedData } = useBackend<ModalData>(context);
  // const mapData: ModalMapData = nestedData['map'];
  return (
    <Section fill title="Map Options">
      {JSON.stringify(data)}
      {JSON.stringify(nestedData)}
      <VSplitTooltipList leftSideWidthPercent={33}>
        <VSplitTooltipList.Entry label="Name" tooltip="Name of the map.">
            <Input />
        </VSplitTooltipList.Entry>
        <VSplitTooltipList.Entry label="Orientation" tooltip='Load orientation for the levels on this map.'>
          {/* <Stack>
            <Stack.Item>
              <Button content="(CW 0°)" icon="arrow-down"
              color="transparent" onClick={() => act('mapOrientation', { 'setTo': 2 })}
              selected={mapData.orientation === 2} />
            </Stack.Item>
            <Stack.Item>
              <Button content="(CW 90°)" icon="arrow-left"
              color="transparent" onClick={() => act('mapOrientation', { 'setTo': 8 })}
              selected={mapData.orientation === 8} />
            </Stack.Item>
            <Stack.Item>
              <Button content="(CW 180)" icon="arrow-up"
              color="transparent" onClick={() => act('mapOrientation', { 'setTo': 1 })}
              selected={mapData.orientation === 1} />
            </Stack.Item>
            <Stack.Item>
              <Button content="(CW 270°)" icon="arrow-right"
              color="transparent" onClick={() => act('mapOrientation', { 'setTo': 4 })}
              selected={mapData.orientation === 4} />
            </Stack.Item>
          </Stack> */}
        </VSplitTooltipList.Entry>
        <VSplitTooltipList.Entry label="Center" tooltip='Center the levels on this map. This should usually be on.'>
            <Input />
        </VSplitTooltipList.Entry>
      </VSplitTooltipList>
    </Section>
  );
};

const MapLevelOptions = (props: {

}, context) => {
  const { act, data, nestedData } = useBackend<ModalData>(context);
  const [levelTab, setLevelTab] = useLocalState<string>(context, 'levelTab', 'level');
  return (
    <Section fill title="Level Options">
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
              X: <NumberInput value={0} onChange={(e, val) => { }} />
            </Flex.Item>
            <Flex.Item>
              Y: <NumberInput value={0} onChange={(e, val) => { }} />
            </Flex.Item>
            <Flex.Item>
              Z: <NumberInput value={0} onChange={(e, val) => { }} />
            </Flex.Item>
          </Flex>
        </LabeledList.Item>
        <LabeledList.Item label="Name">
          <Input onChange={(e, val) => { }} width="100%" value={"test"} />
        </LabeledList.Item>
        <LabeledList.Item label="ID">
          <Input onChange={(e, val) => { }} width="100%" value={"test"} />
        </LabeledList.Item>
        <LabeledList.Item label="Display Name (IC)">
          <Input onChange={(e, val) => { }} width="100%" value={"test"} />
        </LabeledList.Item>
        <LabeledList.Item label="Display ID (IC)">
          <Input onChange={(e, val) => { }} width="100%" value={"test"} />
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
          <NumberInput value={0} minValue={0} onChange={(e, val) => { }} width="100%" />
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

const OvermapOptions = (props: {

}, context) => {
  const { act, data, nestedData } = useBackend<ModalData>(context);
  return (
    <Section fill title="Overmap Binding">
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
    </Section>
  );
};
