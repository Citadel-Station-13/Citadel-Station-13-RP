/**
 * @file
 * @license MIT
 */

import { Component } from "inferno";
import { BooleanLike } from "../../../common/react";
import { useBackend } from "../../backend";
import { Button, Section, Stack, TextArea } from "../../components";
import { Window } from "../../layouts";
import { ByondColorString } from "../common/Color";

interface AdminNarrateData {
  visualColor: ByondColorString;
  mode: AdminNarrateMode;
  rawHtml: string;
  target: AdminNarrateTarget | null;
  useLos: BooleanLike;
  useRange: BooleanLike;
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
    name: string;
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
    this.timeoutRef = setTimeout(() => {
      if (this.state.edited) {
        this.setState((old) => ({ ...old, edited: false }));
        const { act } = useBackend<AdminNarrateData>(this.context);
        act("setOutput", { target: this.state.emitHtml });
      }
    }, 2500);
  }

  componentWillUnmount(): void {
    clearTimeout(this.timeoutRef);
  }

  render() {
    const { act, data } = useBackend<AdminNarrateData>(this.context);

    return (
      <Window>
        <Window.Content>
          <Stack fill vertical>
            <Stack.Item grow={1}>
              <Stack fill>
                <Stack.Item grow={1}>
                  <Section title="Content">
                    <TextArea width="100%" height="100%"
                      value={this.state.emitHtml}
                      onChange={(e, val) =>
                        this.setState((old) =>
                          ({ ...old, edited: true, emitHtml: val }))} />
                  </Section>
                </Stack.Item>
                <Stack.Item>
                    <Stack vertical fill>
                      <Stack.Item>
                        <Section title="Mode">
                          Test
                        </Section>
                      </Stack.Item>
                      <Stack.Item>
                        <Section title="Settings">
                          Test
                        </Section>
                      </Stack.Item>
                      <Stack.Item>
                        <Section title="Target">
                          Test
                        </Section>
                      </Stack.Item>
                    </Stack>
                </Stack.Item>
              </Stack>
            </Stack.Item>
            <Stack.Item>
              <Stack fill>
                <Stack.Item grow={1}>
                  <Button.Confirm onClick={() => act("cancel")}>Cancel</Button.Confirm>
                </Stack.Item>
                <Stack.Item grow={1}>
                  <Button.Confirm onClick={() => act("preview", { html: this.state.emitHtml })}>Preview</Button.Confirm>
                </Stack.Item>
                <Stack.Item grow={1}>
                  <Button.Confirm onClick={() => act("narrate", { html: this.state.emitHtml })}>Send</Button.Confirm>
                </Stack.Item>
              </Stack>
            </Stack.Item>
          </Stack>
        </Window.Content>
      </Window>
    );
  }
}
