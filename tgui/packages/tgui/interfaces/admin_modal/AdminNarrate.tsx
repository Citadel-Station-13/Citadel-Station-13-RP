/**
 * @file
 * @license MIT
 */

import { Component, Fragment } from "react";
import { Button, LabeledList, NumberInput, Section, Stack, TextArea } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { useBackend } from "../../backend";
import { Window } from "../../layouts";
import { ByondColorString } from "../common/Color";

interface AdminNarrateData {
  visualColor: ByondColorString;
  possibleModes: AdminNarrateMode[];
  mode: AdminNarrateMode;
  rawHtml: string;
  target: AdminNarrateTarget | null;
  useLos: BooleanLike;
  useRange: number;
  maxRangeLos: number;
  maxRangeAny: number;
}

interface AdminNarrateTarget {
  coords: [number, number, number] | null;
  level: {
    index: number;
    name: string;
  } | null;
  sector: {
    name: string;
  } | null;
  overmap: {
    name: string | null;
    x: number;
    y: number;
    map: string;
  } | null;
}

enum AdminNarrateMode {
  Global = "global",
  Sector = "sector",
  Overmap = "overmap",
  Level = "level",
  Range = "range",
  Direct = "direct",
  Lobby = "lobby",
}

const MODES_REQUIRING_TARGET: AdminNarrateMode[] = [
  AdminNarrateMode.Direct,
  AdminNarrateMode.Range,
  AdminNarrateMode.Overmap,
  AdminNarrateMode.Sector,
  AdminNarrateMode.Level,
];

const MODES_REQUIRING_RANGE: AdminNarrateMode[] = [
  AdminNarrateMode.Range,
  AdminNarrateMode.Overmap,
];

const ADMIN_NARRATE_MODE_NAMES: Record<AdminNarrateMode, string> = {
  [AdminNarrateMode.Global]: "Global",
  [AdminNarrateMode.Sector]: "Sector",
  [AdminNarrateMode.Overmap]: "Overmap",
  [AdminNarrateMode.Level]: "Level",
  [AdminNarrateMode.Range]: "Range",
  [AdminNarrateMode.Direct]: "Direct",
  [AdminNarrateMode.Lobby]: "Lobby",
};

const ADMIN_NARRATE_MODE_DESCS: Record<AdminNarrateMode, string> = {
  [AdminNarrateMode.Global]: "Send to everyone in the server, including those sitting in the lobby.",
  [AdminNarrateMode.Sector]: "Send to everyone in the logical map, whether that map may be a planet or a ship. This includes anyone sitting in its z-levels but not on the map, e.g. visiting shuttles.",
  [AdminNarrateMode.Overmap]: "Send to target and nearby overmap entities. Range is measured in <b>tiles</b>, not in overmap distance!",
  [AdminNarrateMode.Level]: "Send to everyone in the z-level, regardless of line of sight.",
  [AdminNarrateMode.Range]: "Send to everyone within range. If 'LoS' is enabled, this will check for viewers. Viewer check is done via BYOND 'viewers()', entirely ignoring things like blindness, darksight, etc.",
  [AdminNarrateMode.Direct]: "Send directly to an entity. What this does depends on the entity; it generally will target the mob itself if it's a mob, everyone inside a vehicle, the overmap level if it's an overmap entity, etc. This is a logical 'contains'. Note: Vore bellies are excluded from this (I hate that I have to specify it).",
  [AdminNarrateMode.Lobby]: "Send to everyone in the lobby.",
};

interface AdminNarrateState {
  emitHtml: string | null;
  edited: boolean;
}

export class AdminNarrate extends Component<{}, AdminNarrateState> {
  timeoutRef: any;
  state: AdminNarrateState = {
    emitHtml: null,
    edited: false,
  };

  componentDidMount(): void {
    this.timeoutRef = setInterval(() => {
      if (this.state.edited) {
        this.setState((old) => ({ ...old, edited: false }));
        const { act } = useBackend<AdminNarrateData>();
        act("setOutput", { target: this.state.emitHtml });
      }
    }, 2500);
  }

  componentWillUnmount(): void {
    clearTimeout(this.timeoutRef);
  }

  render() {
    const { act, data } = useBackend<AdminNarrateData>();

    return (
      <Window width={900} height={500} title="Narrate">
        <Window.Content>
          <Stack fill vertical>
            <Stack.Item grow={1}>
              <Stack fill>
                <Stack.Item width="70%">
                  <Section title={(
                    // eslint-disable-next-line react/no-danger
                    <div dangerouslySetInnerHTML={{ __html: "Content - <b>Shift-Enter</b> to insert a Line-Break!" }} />
                  )} fill>
                    <TextArea width="100%" height="100%"
                      value={this.state.emitHtml || ""}
                      onChange={(val) =>
                        this.setState((old) =>
                          ({ ...old, edited: true, emitHtml: val }))} />
                  </Section>
                </Stack.Item>
                <Stack.Item width="30%">
                  <Stack vertical fill>
                    <Stack.Item grow={1}>
                      <Section title="Mode" fill>
                        <Stack fill vertical>
                          {data.possibleModes.map((mode) => {
                            let selected = mode === data.mode;
                            return (
                              <Stack.Item key={mode}>
                                <Stack>
                                  <Stack.Item>
                                    <Button icon="question" tooltip={ADMIN_NARRATE_MODE_DESCS[mode]} />
                                  </Stack.Item>
                                  <Stack.Item grow>
                                    <Button
                                      style={{ textAlign: "left" }}
                                      fluid color={selected ? "" : "transparent"} selected={selected}
                                      onClick={() => act('setMode', { mode: mode })}>
                                      {ADMIN_NARRATE_MODE_NAMES[mode]}
                                    </Button>
                                  </Stack.Item>
                                </Stack>
                              </Stack.Item>
                            );
                          })}
                        </Stack>
                      </Section>
                    </Stack.Item>
                    <Stack.Item grow={1}>
                      <Section title="Settings" fill>
                        <Stack vertical fill>
                          {MODES_REQUIRING_RANGE.includes(data.mode) && (
                            <>
                              <Stack.Item>
                                <Stack>
                                  <Stack.Item grow={1}>
                                    Use LoS
                                  </Stack.Item>
                                  <Stack.Item>
                                    <Button icon="question" tooltip="Whether the narrate will check line of sight. If enabled, only people who can see the entity can view it; otherwise everyone in Chebyshev (square-radius) distance can." />
                                  </Stack.Item>
                                  <Stack.Item grow={1}>
                                    <Stack fill>
                                      <Stack.Item grow={1}>
                                        <Button fluid selected={data.useLos} onClick={() => act('setLos', { target: true })}>Yes</Button>
                                      </Stack.Item>
                                      <Stack.Item grow={1}>
                                        <Button fluid selected={!data.useLos} onClick={() => act('setLos', { target: false })}>No</Button>
                                      </Stack.Item>
                                    </Stack>
                                  </Stack.Item>
                                </Stack>
                              </Stack.Item>
                              <Stack.Item>
                                <Stack>
                                  <Stack.Item grow={1}>
                                    Range
                                  </Stack.Item>
                                  <Stack.Item>
                                    <Button icon="question" tooltip="Distance, in tiles, to broadcast. Fractional tiles are allowed in overmaps mode." />
                                  </Stack.Item>
                                  <Stack.Item grow={1}>
                                    <NumberInput width="100%"
                                      step={data.mode === AdminNarrateMode.Overmap ? 0.01 : 1}
                                      value={data.useRange}
                                      minValue={0}
                                      maxValue={data.maxRangeAny}
                                      onChange={(val) => act('setRange', { target: val })} />
                                  </Stack.Item>
                                </Stack>
                              </Stack.Item>
                            </>
                          )}
                        </Stack>
                      </Section>
                    </Stack.Item>
                    <Stack.Item grow={1}>
                      <Section title="Target" fill>
                        <LabeledList>
                          {data.target?.coords && (
                            <LabeledList.Item label="Coords">{data.target.coords[0]}, {data.target.coords[1]}, {data.target.coords[2]}</LabeledList.Item>
                          )}
                          {data.target?.level && (
                            <LabeledList.Item label="Level">{data.target.level.name} - Z{data.target.level.index}</LabeledList.Item>
                          )}
                          {data.target?.sector && (
                            <LabeledList.Item label="Sector">{data.target.sector.name}</LabeledList.Item>
                          )}
                          {data.target?.overmap && (
                            <LabeledList.Item label="Overmap">{data.target.overmap.name} @ {data.target.overmap.x} - {data.target.overmap.y} ({data.target.overmap.map})</LabeledList.Item>
                          )}
                        </LabeledList>
                      </Section>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Section fill>
                <Stack fill>
                  <Stack.Item grow={1}>
                    <Button.Confirm fluid
                      style={{ textAlign: "center" }}
                      color="transparent"
                      onClick={() => act("cancel")}>
                      Cancel
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item grow={1}>
                    <Button.Confirm fluid
                      style={{ textAlign: "center" }}
                      color="transparent"
                      onClick={() => act("preview", { html: this.state.emitHtml })}>
                      Preview
                    </Button.Confirm>
                  </Stack.Item>
                  <Stack.Item grow={1}>
                    <Button.Confirm fluid
                      style={{ textAlign: "center" }}
                      color="transparent"
                      onClick={() => act("narrate", { html: this.state.emitHtml })}>
                      Send
                    </Button.Confirm>
                  </Stack.Item>
                </Stack>
              </Section>
            </Stack.Item>
          </Stack>
        </Window.Content >
      </Window >
    );
  }
}
