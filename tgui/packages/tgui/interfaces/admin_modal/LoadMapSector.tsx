/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { useBackend, useLocalState } from "tgui/backend";
import { Box, Button, Dropdown, Flex, Input, LabeledList, NumberInput, Section, Stack, Tabs } from "tgui/components";
import { Window } from "tgui/layouts";
import { VSplitTooltipList } from "../../components/VSplitTooltipList";
import { WorldTypepathDropdown } from "../../components/WorldTypepathDropdown";
import { JsonAssetLoader } from "../../components/JsonAssetLoader";
import { Json_MapSystem, JsonMappings } from "../../bindings/json";
import { LoadingScreen } from "../../components/LoadingScreen";
import { DM_TurfSpawnFlags } from "../../bindings/game";
import { Game_MapLevelAttribute } from "../../bindings/game/Game_MapLevelAttribute";

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
  overmap: ModalOvermapData;
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
  enabled: BooleanLike;
}

// TODO: atmosphere modification system
// TODO: procedural generation support

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
                      selected={currentTab === `level-${i + 1}`}
                      onClick={() => setCurrentTab(`level-${i + 1}`)}
                      content={`Level ${i + 1}`} />
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
              <MapLevelOptions levelIndex={Number.parseInt(currentTab.substring(6), 10)} />
            )}
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MapOptions = (props: {}, context) => {
  const { act, data, nestedData } = useBackend<ModalData>(context);
  const mapData: ModalMapData = nestedData['map'];
  return (
    <Section fill title="Map Options">
      {JSON.stringify(data)}
      {JSON.stringify(nestedData)}
      <VSplitTooltipList leftSideWidthPercent={33}>
        <VSplitTooltipList.Entry label="Name" tooltip="Name of the map.">
          <Input />
        </VSplitTooltipList.Entry>
        <VSplitTooltipList.Entry label="Orientation" tooltip='Load orientation for the levels on this map.'>
          <Stack>
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
          </Stack>
        </VSplitTooltipList.Entry>
        <VSplitTooltipList.Entry label="Center" tooltip='Center the levels on this map. This should usually be on.'>
          <Input />
        </VSplitTooltipList.Entry>
      </VSplitTooltipList>
    </Section>
  );
};

const MapLevelOptions = (props: {
  levelIndex: number;
}, context) => {
  const [levelTab, setLevelTab] = useLocalState<string>(context, 'levelTab', 'level');
  return (
    <Section fill title="Level Options">
      <Tabs textAlign="center">
        <Tabs.Tab selected={levelTab === "level"} onClick={() => setLevelTab("level")}>Level</Tabs.Tab>
        <Tabs.Tab selected={levelTab === "trait"} onClick={() => setLevelTab("trait")}>Traits</Tabs.Tab>
        <Tabs.Tab selected={levelTab === "attr"} onClick={() => setLevelTab("attr")}>Attributes</Tabs.Tab>
      </Tabs>
      {levelTab === 'level' && (<MapLevelProperties levelIndex={props.levelIndex} />)}
      {levelTab === 'trait' && (<MapLevelTraits levelIndex={props.levelIndex} />)}
      {levelTab === 'attr' && (<MapLevelAttributes levelIndex={props.levelIndex} />)}
    </Section>
  );
};

const MapLevelProperties = (props: {
  levelIndex: number;
}, context) => {
  const { act, data, nestedData } = useBackend<ModalData>(context);
  const levelData: ModalLevelData = nestedData[`level-${props.levelIndex}`];
  const levelAct = (action: string, params?: Object) => act(action, { levelIndex: props.levelIndex, ...params });

  return (
    <VSplitTooltipList leftSideWidthPercent={25}>
      <VSplitTooltipList.Entry label="DMM" tooltip="The map file to load. If there is none, the level will be an empty plane.">
        <Stack>
          <Stack.Item>
            <Box textAlign="center">
              {levelData.fileName?.length === 0 ? "----------" : levelData.fileName}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Button icon="upload" onClick={() => levelAct('levelDmmUpload')} />
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm confirmContent="" confirmColor="red" icon="trash" color="transparent" onClick={() => levelAct('levelDmmClear')} />
          </Stack.Item>
        </Stack>
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry
        label="Position"
        tooltip="The position on the map's structure. Adjacent levels will automatically join their edges (as well as up/down).">
        <Flex width="100%">
          <Flex.Item>
            X: <NumberInput value={levelData.structX} onChange={(e, val) => levelAct('levelStructX', { val: val })} />
          </Flex.Item>
          <Flex.Item>
            Y: <NumberInput value={levelData.structY} onChange={(e, val) => levelAct('levelStructY', { val: val })} />
          </Flex.Item>
          <Flex.Item>
            Z: <NumberInput value={levelData.structZ} onChange={(e, val) => levelAct('levelStructZ', { val: val })} />
          </Flex.Item>
        </Flex>
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Name">
        <Input onChange={(e, val) => levelAct('levelName', { setTo: val })} width="100%" value={levelData.name} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="ID">
        <Input onChange={(e, val) => levelAct('levelId', { setTo: val })} width="100%" value={levelData.id} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Display Name (IC)">
        <Input onChange={(e, val) => levelAct('levelDisplayName', { setTo: val })} width="100%" value={levelData.displayName} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Display ID (IC)">
        <Input onChange={(e, val) => levelAct('levelDisplayId', { setTo: val })} width="100%" value={levelData.displayId} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Base Turf">
        <WorldTypepathDropdown
          selectedPath={levelData.baseTurf}
          onSelectPath={(path) => levelAct('levelBaseTurf', { type: path })}
          filter={{
            turfs: {
              enabled: true,
              spawnFlags: DM_TurfSpawnFlags.AllowLevelBaseturf,
            },
          }} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Base Area">
        <WorldTypepathDropdown
          selectedPath={levelData.baseTurf}
          onSelectPath={(path) => levelAct('levelBaseArea', { type: path })}
          filter={{
            areas: {
              enabled: true,
              allowUnique: true,
            },
          }} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Air - Indoors">
        <Stack>
          <Stack.Item>
            <Input onChange={(e, val) => levelAct('levelAirIndoors', { air: val })}
              width="100%"
              value={levelData.airIndoors} />
          </Stack.Item>
          <Stack.Item>
            <Button icon="earth-americas" onClick={() => act('levelAirIndoors', { air: data.const_airHabitable })} />
          </Stack.Item>
          <Stack.Item>
            <Button icon="minus" onClick={() => act('levelAirIndoors', { air: data.const_airVacuum })} />
          </Stack.Item>
        </Stack>
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Air - Outdoors">
        <Stack>
          <Stack.Item>
            <Input onChange={(e, val) => levelAct('levelAirOutdoors', { air: val })}
              width="100%"
              value={levelData.airOutdoors} />
          </Stack.Item>
          <Stack.Item>
            <Button icon="earth-americas" onClick={() => act('levelAirOutdoors', { air: data.const_airHabitable })} />
          </Stack.Item>
          <Stack.Item>
            <Button icon="minus" onClick={() => act('levelAirOutdoors', { air: data.const_airVacuum })} />
          </Stack.Item>
        </Stack>
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Ceiling Height">
        <NumberInput value={levelData.ceilingHeight} minValue={1} onChange={(e, val) => { levelAct('levelCeilingHeight', { height: val }); }} width="100%" />
      </VSplitTooltipList.Entry>
    </VSplitTooltipList>
  );
};

const MapLevelTraits = (props: {
  levelIndex: number;
}, context) => {
  const { act, data, nestedData } = useBackend<ModalData>(context);
  const levelData: ModalLevelData = nestedData[`level-${props.levelIndex}`];
  const [stagedTraitId, setStagedTraitId] = useLocalState<string | null>(context, 'stagedTrait', null);

  return (
    <Box width="100%" height="100%">
      <JsonAssetLoader assets={[JsonMappings.MapSystem]}
        loading={() => (
          <LoadingScreen />
        )}
        loaded={(json) => {
          const mapSystemData: Json_MapSystem = json[JsonMappings.MapSystem] as Json_MapSystem;
          const maybeStagedTraitDesc: string | null = stagedTraitId ? mapSystemData.keyedLevelTraits[stagedTraitId]?.desc : null;
          return (
            <Stack fill vertical>
              {levelData.traits.map((traitId) => {
                const maybeTraitDesc: string | null = traitId ? mapSystemData.keyedLevelTraits[traitId]?.desc : "Unknown trait; is this a legacy trait that is now removed from the code?";
                return (
                  <Stack.Item key={traitId}>
                    <Stack fill>
                      <Stack.Item grow={1}>
                        {traitId}
                      </Stack.Item>
                      <Stack.Item>
                        <Button icon="question" tooltip={maybeTraitDesc} />
                      </Stack.Item>
                      <Stack.Item>
                        <Button icon="minus" onClick={() => act('levelDelTrait', { trait: traitId })} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                );
              })}
              <Stack.Item>
                <Stack fill>
                  <Stack.Item grow={1}>
                    <Dropdown options={
                      Object.keys(mapSystemData.keyedLevelTraits)
                        .filter((k) => !levelData.traits.includes(k))
                        .filter((k) => mapSystemData.keyedLevelTraits[k]?.allowEdit)
                    } selected={stagedTraitId} onSelect={(val) => setStagedTraitId(val)} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="question" color={stagedTraitId ? "" : "transparent"} tooltip={maybeStagedTraitDesc} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="plus" onClick={() => act('levelAddTrait', { trait: stagedTraitId })} />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          );
        }}
      />
    </Box>
  );
};

const MapLevelAttributes = (props: {
  levelIndex: number;
}, context) => {
  const { act, data, nestedData } = useBackend<ModalData>(context);
  const levelData: ModalLevelData = nestedData[`level-${props.levelIndex}`];
  const [stagedAttributeId, setStagedAttributeId] = useLocalState<string | null>(context, 'stagedAttribute', null);
  const [stagedAttributeVal, setStagedAttributeVal] = useLocalState<string | number | null>(context, 'stagedAttributeVal', null);

  return (
    <Box width="100%" height="100%">
      <JsonAssetLoader assets={[JsonMappings.MapSystem]}
        loading={() => (
          <LoadingScreen />
        )}
        loaded={(json) => {
          const mapSystemData: Json_MapSystem = json[JsonMappings.MapSystem] as Json_MapSystem;
          const maybeStagedAttribute: Game_MapLevelAttribute | null = stagedAttributeId && json[stagedAttributeId];
          return (
            <Stack fill vertical>
              {Object.entries(levelData.attributes).map((e) => {
                const attributeId = e[0];
                const value = e[1];
                const maybeAttribute: Game_MapLevelAttribute | null = mapSystemData.keyedLevelAttributes[attributeId];
                return (
                  <Stack.Item key={attributeId}>
                    <Stack fill>
                      <Stack.Item grow={1}>
                        {attributeId}
                      </Stack.Item>
                      <Stack.Item grow={1}>
                        {!!maybeAttribute.allowEdit && (
                          maybeAttribute.numeric ? (
                            <NumberInput value={value} onChange={(e, val) => act('levelSetAttribute', { attribute: attributeId, value: val })} />
                          ) : (
                            <Input value={value} onChange={(e, val) => act('levelSetAttribute', { attribute: attributeId, value: val })} />
                          )
                        )}
                      </Stack.Item>
                      <Stack.Item>
                        <Button icon="question" tooltip={maybeAttribute?.desc || "Unknown attribute. Was this removed from the game?"} />
                      </Stack.Item>
                      <Stack.Item>
                        <Button icon="minus" onClick={() => act('levelDelAttribute', { attribute: attributeId })} />
                      </Stack.Item>
                    </Stack>
                  </Stack.Item>
                );
              })}
              <Stack.Item>
                <Stack fill>
                  <Stack.Item grow={1}>
                    <Dropdown options={
                      Object.keys(mapSystemData.keyedLevelAttributes)
                        .filter((k) => levelData.attributes[k] === null)
                        .filter((k) => mapSystemData.keyedLevelAttributes[k]?.allowEdit)
                    } selected={stagedAttributeId} onSelect={(val) => setStagedAttributeId(val)} />
                  </Stack.Item>
                  <Stack.Item grow={1}>
                    {!!maybeStagedAttribute?.allowEdit && (
                      maybeStagedAttribute.numeric ? (
                        <NumberInput value={stagedAttributeVal} onChange={(e, val) => setStagedAttributeVal(val)} />
                      ) : (
                        <Input value={stagedAttributeVal} onChange={(e, val) => setStagedAttributeVal(val)} />
                      )
                    )}
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="question" color={stagedAttributeId ? "" : "transparent"} tooltip={maybeStagedAttribute?.desc} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="plus" onClick={() => act('levelSetAttribute', { attribute: stagedAttributeId, value: stagedAttributeVal })} />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          );
        }}
      />
    </Box>
  );
};

const OvermapOptions = (props: {}, context) => {
  const { act, data, nestedData } = useBackend<ModalData>(context);
  const mapData: ModalMapData = nestedData['map'];
  return (
    <Section fill title="Overmap Binding">
      <LabeledList>
        <VSplitTooltipList.Entry label="Load Into Overmap" tooltip="Whether or not this level should be loaded into the overmap. This usually should be on.">
          <Stack>
            <Stack.Item grow={1}>
              <Button color="transparent" selected={mapData.overmap.enabled} content="Yes" onClick={() => act('overmapActive', { setTo: true })} />
            </Stack.Item>
            <Stack.Item grow={1}>
              <Button color="transparent" selected={!mapData.overmap.enabled} content="No" onClick={() => act('overmapActive', { setTo: false })} />
            </Stack.Item>
          </Stack>
        </VSplitTooltipList.Entry>
        <VSplitTooltipList.Entry label="X" tooltip="If set, try to set the sector at this X on the overmap.">
          <NumberInput value={mapData.overmap.x} onChange={(e, val) => act('overmapX', { setTo: val })} />
        </VSplitTooltipList.Entry>
        <VSplitTooltipList.Entry label="Y" tooltip="If set, try to set the sector at this Y on the overmap.">
          <NumberInput value={mapData.overmap.y} onChange={(e, val) => act('overmapY', { setTo: val })} />
        </VSplitTooltipList.Entry>
        <VSplitTooltipList.Entry label="Force Position" tooltip="If enabled, override overmap placement safety checks.">
          <Stack>
            <Stack.Item grow={1}>
              <Button color="transparent" selected={!!mapData.overmap} content="Yes" onClick={() => act('overmapForcePosition', { setTo: true })} />
            </Stack.Item>
            <Stack.Item grow={1}>
              <Button color="transparent" selected={!mapData.overmap} content="No" onClick={() => act('overmapForcePosition', { setTo: false })} />
            </Stack.Item>
          </Stack>
        </VSplitTooltipList.Entry>
      </LabeledList>
    </Section>
  );
};
