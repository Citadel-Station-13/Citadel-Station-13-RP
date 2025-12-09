/**
 * @file
 * @license MIT
 */

import { Box, Button, Dropdown, Input, NumberInput, Section, Stack, Tabs } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { useBackend, useLocalState } from "../../backend";
import { DM_TurfSpawnFlags } from "../../bindings/game";
import { Game_MapLevelAttribute } from "../../bindings/game/Game_MapLevelAttribute";
import { Json_MapSystem, JsonMappings } from "../../bindings/json";
import { VSplitTooltipList, WorldTypepathDropdown } from "../../components";
import { JsonAssetLoader } from "../../components/JsonAssetLoader";
import { Window } from "../../layouts";
import { LoadingScreen } from "../common/LoadingScreen";

enum LoadMapSectorStatus {
  Waiting = "waiting",
  Ready = "ready",
  Loading = "loading",
  Finished = "finished",
}

interface ModalData {
  status: LoadMapSectorStatus;
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
  traits: string[] | null;
  attributes: Record<string, string | number> | null;
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
  x: number | null;
  y: number | null;
  forcePos: BooleanLike;
  enabled: BooleanLike;
}

// TODO: atmosphere modification system
// TODO: procedural generation support

export const LoadMapSector = (props) => {
  const { act, data, nestedData } = useBackend<ModalData>();
  const [currentTab, setCurrentTab] = useLocalState<string>('currentTab', 'map');

  return (
    <Window width={575} height={700} title="Upload Map Sector">
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item grow={1}>
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
                        <Stack>
                          <Stack.Item grow={1}>
                            <Button
                              fluid color="transparent"
                              selected={currentTab === `level-${i + 1}`}
                              onClick={() => setCurrentTab(`level-${i + 1}`)}
                              content={`Level ${i + 1}`} />
                          </Stack.Item>
                          <Stack.Item >
                            <Button.Confirm icon="trash"
                              color="transparent"
                              confirmIcon="trash"
                              onClick={() => act('delLevel', { levelIndex: i + 1 })}
                              confirmContent={null} />
                          </Stack.Item>
                        </Stack>
                      </Stack.Item>
                    ))}
                    <Stack.Item grow={1} />
                    <Stack.Item>
                      <Button.Confirm icon="plus" confirmIcon="plus"
                        color="transparent"
                        fluid onClick={() => act('newLevel')}>Add Level
                      </Button.Confirm>
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
          </Stack.Item>
          <Stack.Item>
            <Section>
              <Stack fill>
                <Stack.Item grow={1}>
                  <Button.Confirm fluid
                    textAlign="center"
                    tooltip="Run validation checks on the map."
                    onClick={() => act('ready')}>
                    Validate
                  </Button.Confirm>
                </Stack.Item>
                <Stack.Item grow={1}>
                  <Button.Confirm fluid
                    textAlign="center"
                    disabled={data.status !== LoadMapSectorStatus.Ready}
                    tooltip={data.status === LoadMapSectorStatus.Ready ? "Load the map." : "You must validate the map first!"}
                    onClick={() => act('load')}>
                    {data.status === LoadMapSectorStatus.Loading ? "Loading..." : "Load"}
                  </Button.Confirm>
                </Stack.Item>
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};

const MapOptions = (props: {}) => {
  const { act, data, nestedData } = useBackend<ModalData>();
  const mapData: ModalMapData = nestedData['map'];
  return (
    <Section fill title="Map Options" overflow="wrap">
      <VSplitTooltipList leftSideWidthPercent={33}>
        <VSplitTooltipList.Entry label="Name" tooltip="Name of the map.">
          <Input width="100%" value={mapData.name} onChange={(val) => act('mapName', { 'setTo': val })} />
        </VSplitTooltipList.Entry>
        <VSplitTooltipList.Entry label="Orientation" tooltip='Load orientation for the levels on this map.'>
          <Stack>
            <Stack.Item grow={1}>
              <Button width="100%" content="(CW 0°)" icon="arrow-down"
                color="transparent" onClick={() => act('mapOrientation', { 'setTo': 2 })}
                selected={mapData.orientation === 2} />
            </Stack.Item>
            <Stack.Item grow={1}>
              <Button width="100%" content="(CW 90°)" icon="arrow-left"
                color="transparent" onClick={() => act('mapOrientation', { 'setTo': 8 })}
                selected={mapData.orientation === 8} />
            </Stack.Item>
          </Stack>
          <Stack>
            <Stack.Item grow={1}>
              <Button width="100%" content="(CW 180)" icon="arrow-up"
                color="transparent" onClick={() => act('mapOrientation', { 'setTo': 1 })}
                selected={mapData.orientation === 1} />
            </Stack.Item>
            <Stack.Item grow={1}>
              <Button width="100%" content="(CW 270°)" icon="arrow-right"
                color="transparent" onClick={() => act('mapOrientation', { 'setTo': 4 })}
                selected={mapData.orientation === 4} />
            </Stack.Item>
          </Stack>
        </VSplitTooltipList.Entry>
        <VSplitTooltipList.Entry label="Center" tooltip='Center the levels on this map. This should usually be on.'>
          <Stack>
            <Stack.Item grow={1}>
              <Button width="100%" color="transparent" selected={!!mapData.center} content="Yes" onClick={() => act('mapCenter', { setTo: true })} />
            </Stack.Item>
            <Stack.Item grow={1}>
              <Button width="100%" color="transparent" selected={!mapData.center} content="No" onClick={() => act('mapCenter', { setTo: false })} />
            </Stack.Item>
          </Stack>
        </VSplitTooltipList.Entry>
      </VSplitTooltipList>
    </Section>
  );
};

const MapLevelOptions = (props: {
  levelIndex: number;
}) => {
  const [levelTab, setLevelTab] = useLocalState<string>('levelTab', 'level');
  let innerFrag;
  switch (levelTab) {
    case 'level':
      innerFrag = (<MapLevelProperties levelIndex={props.levelIndex} />);
      break;
    case 'trait':
      innerFrag = (<MapLevelTraits levelIndex={props.levelIndex} />);
      break;
    case 'attr':
      innerFrag = (<MapLevelAttributes levelIndex={props.levelIndex} />);
      break;
  }
  return (
    <Section fill title="Level Options">
      <Stack vertical fill>
        <Stack.Item>
          <Tabs textAlign="center">
            <Tabs.Tab selected={levelTab === "level"} onClick={() => setLevelTab("level")}>Level</Tabs.Tab>
            <Tabs.Tab selected={levelTab === "trait"} onClick={() => setLevelTab("trait")}>Traits</Tabs.Tab>
            <Tabs.Tab selected={levelTab === "attr"} onClick={() => setLevelTab("attr")}>Attributes</Tabs.Tab>
          </Tabs>
        </Stack.Item>
        <Stack.Item grow={1}>
          {innerFrag}
        </Stack.Item>
      </Stack>
    </Section>
  );
};

const MapLevelProperties = (props: {
  levelIndex: number;
}) => {
  const { act, data, nestedData } = useBackend<ModalData>();
  const levelData: ModalLevelData = nestedData[`level-${props.levelIndex}`];
  const levelAct = (action: string, params?: Object) => act(action, { levelIndex: props.levelIndex, ...params });

  return (
    <VSplitTooltipList leftSideWidthPercent={25}>
      <VSplitTooltipList.Entry label="DMM" tooltip="The map file to load. If there is none, the level will be an empty plane.">
        <Stack>
          <Stack.Item grow={1}>
            <Box textAlign="center">
              {levelData.fileName?.length === 0 ? "--- empty level ---" : levelData.fileName}
            </Box>
          </Stack.Item>
          <Stack.Item>
            <Button icon="upload" onClick={() => levelAct('levelDmmUpload')} />
          </Stack.Item>
          <Stack.Item>
            <Button.Confirm confirmContent="" confirmColor="red" icon="trash" color={levelData.fileName?.length ? null : "transparent"} onClick={() => levelAct('levelDmmClear')} />
          </Stack.Item>
        </Stack>
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry
        label="Position"
        tooltip="The position on the map's structure. Adjacent levels will automatically join their edges (as well as up/down).">
        <Stack width="100%">
          <Stack.Item>
            X: <NumberInput value={levelData.structX || 0} minValue={-1000} maxValue={1000} step={1} onChange={(val) => levelAct('levelStructX', { val: val })} />
          </Stack.Item>
          <Stack.Item>
            Y: <NumberInput value={levelData.structY || 0} minValue={-1000} maxValue={1000} step={1} onChange={(val) => levelAct('levelStructY', { val: val })} />
          </Stack.Item>
          <Stack.Item>
            Z: <NumberInput value={levelData.structZ || 0} minValue={-1000} maxValue={1000} step={1} onChange={(val) => levelAct('levelStructZ', { val: val })} />
          </Stack.Item>
        </Stack>
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Name"
        tooltip="Internal name used by admin panels and debug tooling.">
        <Input onChange={(val) => levelAct('levelName', { setTo: val })} width="100%" value={levelData.name} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="ID"
        tooltip="Internal name used by the code for linkage. This must be unique.">
        <Input onChange={(val) => levelAct('levelId', { setTo: val })} width="100%" value={levelData.id} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Display Name (IC)"
        tooltip="Long name used for GPS, suit sensors, and other IC systems.">
        <Input onChange={(val) => levelAct('levelDisplayName', { setTo: val })} width="100%" value={levelData.displayName} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Display ID (IC)"
        tooltip="Short identifier used for GPS, suit sensors, and other IC systems. This must be unique.">
        <Input onChange={(val) => levelAct('levelDisplayId', { setTo: val })} width="100%" value={levelData.displayId} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Base Turf"
        tooltip="The base turf of the level.">
        <WorldTypepathDropdown
          selectedPath={levelData.baseTurf}
          onSelectPath={(path) => {
            levelAct('levelBaseTurf', { type: path });
          }}
          filter={{
            turfs: {
              enabled: true,
              spawnFlags: DM_TurfSpawnFlags.AllowLevelBaseturf,
            },
          }} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Base Area"
        tooltip="The base area of the level.">
        <WorldTypepathDropdown
          selectedPath={levelData.baseArea}
          onSelectPath={(path) => {
            levelAct('levelBaseArea', { type: path });
          }}
          filter={{
            areas: {
              enabled: true,
              allowUnique: true,
            },
          }} />
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Air - Indoors" tooltip="The default gas string to use for indoors air.">
        <Stack>
          <Stack.Item>
            <Input onChange={(val) => levelAct('levelAirIndoors', { air: val })}
              width="100%"
              value={levelData.airIndoors} />
          </Stack.Item>
          <Stack.Item>
            <Button icon="earth-americas" onClick={() => levelAct('levelAirIndoors', { air: data.const_airHabitable })}
              tooltip="Set to standard station air." />
          </Stack.Item>
          <Stack.Item>
            <Button icon="minus" onClick={() => levelAct('levelAirIndoors', { air: data.const_airVacuum })}
              tooltip="Set to vacuum." />
          </Stack.Item>
        </Stack>
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Air - Outdoors" tooltip="The default gas string to use for outdoors air.">
        <Stack>
          <Stack.Item>
            <Input onChange={(val) => levelAct('levelAirOutdoors', { air: val })}
              width="100%"
              value={levelData.airOutdoors} />
          </Stack.Item>
          <Stack.Item>
            <Button icon="earth-americas" onClick={() => levelAct('levelAirOutdoors', { air: data.const_airHabitable })}
              tooltip="Set to standard station air." />
          </Stack.Item>
          <Stack.Item>
            <Button icon="minus" onClick={() => levelAct('levelAirOutdoors', { air: data.const_airVacuum })}
              tooltip="Set to vacuum." />
          </Stack.Item>
        </Stack>
      </VSplitTooltipList.Entry>
      <VSplitTooltipList.Entry label="Ceiling Height">
        <NumberInput value={levelData.ceilingHeight || 5} minValue={1} maxValue={100000} step={1} onChange={(val) => { levelAct('levelCeilingHeight', { height: val }); }} width="100%" />
      </VSplitTooltipList.Entry>
    </VSplitTooltipList>
  );
};

const MapLevelTraits = (props: {
  levelIndex: number;
}) => {
  const { act, data, nestedData } = useBackend<ModalData>();
  const levelData: ModalLevelData = nestedData[`level-${props.levelIndex}`];
  const [stagedTraitId, setStagedTraitId] = useLocalState<string | null>('stagedTrait', null);
  const levelAct = (action: string, params?: Object) => act(action, { levelIndex: props.levelIndex, ...params });

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
              <Stack.Item>
                <Box className="LoadMapSector__TraitOrAttributePicker">
                  <Stack fill>
                    <Stack.Item grow={1}>
                      <Dropdown color="transparent" width="100%" options={
                        Object.keys(mapSystemData.keyedLevelTraits)
                          .filter((k) => !levelData.traits?.includes(k))
                          .filter((k) => mapSystemData.keyedLevelTraits[k]?.allowEdit)
                      } selected={stagedTraitId} onSelected={(val) => setStagedTraitId(val)} />
                    </Stack.Item>
                    <Stack.Item>
                      <Button icon="question" color={stagedTraitId ? "" : "transparent"} tooltip={maybeStagedTraitDesc} />
                    </Stack.Item>
                    <Stack.Item>
                      <Button icon="plus" onClick={() => levelAct('levelAddTrait', { trait: stagedTraitId })} />
                    </Stack.Item>
                  </Stack>
                </Box>
              </Stack.Item>
              {levelData.traits?.map((traitId) => {
                const maybeTraitDesc: string | null = traitId ? mapSystemData.keyedLevelTraits[traitId]?.desc : "Unknown trait; is this a legacy trait that is now removed from the code?";
                return (
                  <Stack.Item key={traitId}>
                    <Box className="LoadMapSector__TraitOrAttributeEntry">
                      <Stack fill>
                        <Stack.Item grow={1}>
                          {traitId}
                        </Stack.Item>
                        <Stack.Item>
                          <Button icon="question" tooltip={maybeTraitDesc} />
                        </Stack.Item>
                        <Stack.Item>
                          <Button.Confirm icon="minus" confirmIcon="minus" confirmContent={null}
                            onClick={() => levelAct('levelDelTrait', { trait: traitId })} />
                        </Stack.Item>
                      </Stack>
                    </Box>
                  </Stack.Item>
                );
              })}
            </Stack>
          );
        }}
      />
    </Box>
  );
};

const MapLevelAttributes = (props: {
  levelIndex: number;
}) => {
  const { act, data, nestedData } = useBackend<ModalData>();
  const levelData: ModalLevelData = nestedData[`level-${props.levelIndex}`];
  const [stagedAttributeId, setStagedAttributeId] = useLocalState<string | null>('stagedAttribute', null);
  const [stagedAttributeVal, setStagedAttributeVal] = useLocalState<string | number | null>('stagedAttributeVal', null);
  const levelAct = (action: string, params?: Object) => act(action, { levelIndex: props.levelIndex, ...params });

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
              <Stack.Item>
                <Stack fill>
                  <Stack.Item grow={1}>
                    <Dropdown color="transparent" width="100%" options={
                      Object.keys(mapSystemData.keyedLevelAttributes)
                        .filter((k) => levelData.attributes?.[k] === null)
                        .filter((k) => mapSystemData.keyedLevelAttributes[k]?.allowEdit)
                    } selected={stagedAttributeId} onSelected={(val) => setStagedAttributeId(val)} />
                  </Stack.Item>
                  <Stack.Item grow={1}>
                    {!!maybeStagedAttribute?.allowEdit && (
                      maybeStagedAttribute.numeric ? (
                        <NumberInput value={stagedAttributeVal || ""} minValue={-Infinity} maxValue={Infinity} step={1} onChange={(val) => setStagedAttributeVal(val)} />
                      ) : (
                        <Input value={`${stagedAttributeVal}`} onChange={(val) => setStagedAttributeVal(val)} />
                      )
                    )}
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="question" color={stagedAttributeId ? "" : "transparent"} tooltip={maybeStagedAttribute?.desc} />
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="plus" onClick={() => levelAct('levelSetAttribute', { attribute: stagedAttributeId, value: stagedAttributeVal })} />
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              {Object.entries(levelData.attributes || {}).map((e) => {
                const attributeId = e[0];
                const value = e[1];
                const maybeAttribute: Game_MapLevelAttribute | null = mapSystemData.keyedLevelAttributes[attributeId];
                return (
                  <Stack.Item key={attributeId}>
                    <Box className="LoadMapSector__TraitOrAttributeEntry">
                      <Stack fill>
                        <Stack.Item grow={1}>
                          {attributeId}
                        </Stack.Item>
                        <Stack.Item grow={1}>
                          {!!maybeAttribute.allowEdit && (
                            maybeAttribute.numeric ? (
                              <NumberInput value={value} minValue={-Infinity} maxValue={Infinity} step={1} onChange={(val) => levelAct('levelSetAttribute', { attribute: attributeId, value: val })} />
                            ) : (
                              <Input value={`${value}`} onChange={(val) => levelAct('levelSetAttribute', { attribute: attributeId, value: val })} />
                            )
                          )}
                        </Stack.Item>
                        <Stack.Item>
                          <Button icon="question" tooltip={maybeAttribute?.desc || "Unknown attribute. Was this removed from the game?"} />
                        </Stack.Item>
                        <Stack.Item>
                          <Button.Confirm icon="minus" confirmIcon="minus" confirmContent={null}
                            onClick={() => levelAct('levelDelAttribute', { attribute: attributeId })} />
                        </Stack.Item>
                      </Stack>
                    </Box>
                  </Stack.Item>
                );
              })}
            </Stack>
          );
        }}
      />
    </Box>
  );
};

const OvermapOptions = (props: {}) => {
  const { act, data, nestedData } = useBackend<ModalData>();
  const mapData: ModalMapData = nestedData['map'];
  let manualPositioningActive = mapData.overmap.x !== null && mapData.overmap.y !== null;
  return (
    <Section fill title="Overmap Binding">
      <VSplitTooltipList leftSideWidthPercent={40}>
        <VSplitTooltipList.Entry label="Load Into Overmap" tooltip="Whether or not this level should be loaded into the overmap. This usually should be on.">
          <Stack>
            <Stack.Item grow={1}>
              <Button width="100%" color="transparent" selected={mapData.overmap.enabled} content="Yes" onClick={() => act('overmapActive', { setTo: true })} />
            </Stack.Item>
            <Stack.Item grow={1}>
              <Button width="100%" color="transparent" selected={!mapData.overmap.enabled} content="No" onClick={() => act('overmapActive', { setTo: false })} />
            </Stack.Item>
          </Stack>
        </VSplitTooltipList.Entry>
        <VSplitTooltipList.Entry label="Manual Positioning" tooltip="Place the sector at a specific coordinate spot?">
          <Stack>
            <Stack.Item grow={1}>
              <Button width="100%" color="transparent" selected={manualPositioningActive} content="On" onClick={() => act('overmapPosToggle', { setTo: true })} />
            </Stack.Item>
            <Stack.Item grow={1}>
              <Button width="100%" color="transparent" selected={!manualPositioningActive} content="Off" onClick={() => act('overmapPosToggle', { setTo: false })} />
            </Stack.Item>
          </Stack>
        </VSplitTooltipList.Entry>
        {manualPositioningActive && (
          <>
            <VSplitTooltipList.Entry label="X" tooltip="If set, try to set the sector at this X on the overmap.">
              <NumberInput width="100%" minValue={-Infinity} maxValue={Infinity} step={1} value={mapData.overmap.x || 0} onChange={(val) => act('overmapX', { setTo: val })} />
            </VSplitTooltipList.Entry>
            <VSplitTooltipList.Entry label="Y" tooltip="If set, try to set the sector at this Y on the overmap.">
              <NumberInput width="100%" minValue={-Infinity} maxValue={Infinity} step={1} value={mapData.overmap.y || 0} onChange={(val) => act('overmapY', { setTo: val })} />
            </VSplitTooltipList.Entry>
            <VSplitTooltipList.Entry label="Force Position" tooltip="If enabled, override overmap placement safety checks.">
              <Stack>
                <Stack.Item grow={1}>
                  <Button width="100%" color="transparent" selected={!!mapData.overmap.forcePos} content="Yes" onClick={() => act('overmapForcePosition', { setTo: true })} />
                </Stack.Item>
                <Stack.Item grow={1}>
                  <Button width="100%" color="transparent" selected={!mapData.overmap.forcePos} content="No" onClick={() => act('overmapForcePosition', { setTo: false })} />
                </Stack.Item>
              </Stack>
            </VSplitTooltipList.Entry>
          </>
        )}
      </VSplitTooltipList>
    </Section>
  );
};
