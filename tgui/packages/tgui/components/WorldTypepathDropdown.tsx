/**
 * @file
 * @license MIT
 */

import { Component } from "react";
import { Box, Button, Icon, Input, Stack } from "tgui-core/components";
import { BooleanLike } from "tgui-core/react";

import { DM_TurfSpawnFlags } from "../bindings/game";
import { Json_WorldTypepaths, JsonMappings } from "../bindings/json";
import { BoxProps } from ".";
import { ByondIconRef } from "./ByondIconRef";
import { JsonAssetLoader } from "./JsonAssetLoader";
import { VStaticScrollingWindower, VStaticScrollingWindowerEntry } from "./VStaticScrollingWindower";

/**
 * WARNING: HERE BE DRAGONS
 *
 * Dropdown field capable of rendering with icons a searchable typepath/entity selector.
 * This is used for admin UIs like buildnode, maploader, and more.
 *
 * * Requries WorldTypepaths json asset pack to be sent.
 * * Will resolve icons directly from rsc.
 * * Only works with compile-time typepaths; do not try to use this with non-WorldTypepath paths.
 * * Expects WorldTypepaths to be sent.
 */
export class WorldTypepathDropdown extends Component<{
  selectedPath: string;
  onSelectPath: (path: string) => void;
  color?: string;
  disabled?: BooleanLike;
  filter?: {
    turfs?: {
      enabled: BooleanLike;
      spawnFlags: DM_TurfSpawnFlags;
    }
    areas?: {
      enabled: BooleanLike;
      allowUnique?: BooleanLike;
      allowSpecial?: BooleanLike;
    }
  };
} & BoxProps> {

  onUnfocusedClick: () => void;
  state: { open: boolean, searchString: string };

  constructor(props) {
    super(props);
    this.state = {
      open: false,
      searchString: "",
    };
    this.onUnfocusedClick = () => {};
    // this.onUnfocusedClick = () => this.setOpen(false);
  }

  componentWillUnmount() {
    window.removeEventListener('click', this.onUnfocusedClick);
  }

  setOpen(open) {
    this.setState((old) => ({ ...old, open: open }));
    if (open) {
      setTimeout(() => window.addEventListener('click', this.onUnfocusedClick), 0);
      // todo: maybe focus the search bar?
    }
    else {
      window.removeEventListener('click', this.onUnfocusedClick);
    }
  }

  setSearchString(val) {
    this.setState((old) => ({ ...old, searchString: val }));
  }

  render() {
    const {
      selectedPath,
      onSelectPath,
      filter,
      color,
      disabled,
      className,
      ...rest
    } = this.props;

    return (
      <Box className="WorldTypepathDropdown" {...rest}>
        <JsonAssetLoader
          assets={[JsonMappings.WorldTypepaths]}
          loading={() => (
            // todo: better loading display
            <h1>Loading...</h1>
          )}
          loaded={(loaded) => {
            const typepathPack: Json_WorldTypepaths = loaded[JsonMappings.WorldTypepaths] as Json_WorldTypepaths;

            let selectedIcon;
            let selectedName;
            let selectedTooltip;
            if (!selectedPath) {
              selectedIcon = null;
              selectedName = null;
              selectedTooltip = null;
            } else if (typepathPack.areas[selectedPath]) {
              const descriptor = typepathPack.areas[selectedPath];
              selectedIcon = null;
              selectedName = descriptor.name;
              selectedTooltip = `Path: ${selectedPath}`;
            } else if (typepathPack.turfs[selectedPath]) {
              const descriptor = typepathPack.turfs[selectedPath];
              selectedIcon = (<ByondIconRef iconRef={descriptor.iconRef} iconState={descriptor.iconState} />);
              selectedName = descriptor.name;
              selectedTooltip = `Path: ${selectedPath}`;
            } else {
              selectedIcon = null; // todo: csgo no-texture icon
              selectedName = "-- unknown --";
              selectedTooltip = `Somehow you selected ${selectedPath}, which wasn't in the path asset pack. What?`;
            }

            let compiledTypepathEntries: WorldTypepathDropdownEntryData[] = [];
            if (filter?.areas?.enabled) {
              Object.entries(typepathPack.areas)
                .filter(([path, descriptor]) => (!descriptor.unique || filter.areas?.allowUnique))
                .filter(([path, descriptor]) => (!descriptor.special || filter.areas?.allowSpecial))
                .filter(([path, descriptor]) => (
                  !this.state.searchString?.length ||
                  descriptor.name.indexOf(this.state.searchString) !== -1 ||
                  descriptor.path.indexOf(this.state.searchString) !== -1
                ))
                .forEach(([path, descriptor]) => {
                  compiledTypepathEntries.push({
                    name: descriptor.name,
                    path: path,
                    iconRef: null,
                    iconState: null,
                    key: path,
                  });
                });
            }
            if (filter?.turfs?.enabled) {
              Object.entries(typepathPack.turfs)
                .filter(([path, descriptor]) => (descriptor.spawnFlags & (filter.turfs?.spawnFlags || 0)))
                .filter(([path, descriptor]) => (
                  !this.state.searchString?.length ||
                  descriptor.name.indexOf(this.state.searchString) !== -1 ||
                  descriptor.path.indexOf(this.state.searchString) !== -1
                ))
                .forEach(([path, descriptor]) => {
                  compiledTypepathEntries.push({
                    name: descriptor.name,
                    path: path,
                    iconRef: descriptor.iconRef,
                    iconState: descriptor.iconState,
                    key: path,
                  });
                });
            }

            return (
              <div>
                <Stack fill>
                  <Stack.Item>
                    {selectedIcon}
                  </Stack.Item>
                  <Stack.Item grow={1}>
                    {selectedName}
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="question" tooltip={selectedTooltip} />
                  </Stack.Item>
                  <Stack.Item onClick={() => {
                    if (disabled && !this.state.open) {
                      return;
                    }
                    this.setOpen(!this.state.open);
                  }}>
                    <Icon size={1.65} name={this.state.open ? 'chevron-up' : 'chevron-down'} />
                  </Stack.Item>
                </Stack>
                {this.state.open && (
                  <Box className="WorldTypepathDropdown__menu">
                    <Stack vertical>
                      <Stack.Item>
                        <Input onChange={(val) => this.setSearchString(val)}
                          value={this.state.searchString}
                          width="100%"
                          placeholder="Search path/name substring" />
                      </Stack.Item>
                      <Stack.Item grow={1}>
                        <WorldTypepathDropdownScroller
                          data={compiledTypepathEntries}
                          transformer={(entry) => {
                            return (
                              <WorldTypepathDropdownEntry data={entry} />
                            );
                          }} />
                      </Stack.Item>
                    </Stack>
                  </Box>
                )}
              </div>
            );
          }}
        />
      </Box>
    );
  }
}

interface WorldTypepathDropdownEntryData extends VStaticScrollingWindowerEntry {
  name: string | null;
  path: string;
  iconRef: string | null;
  iconState: string | null;
}

class WorldTypepathDropdownScroller extends VStaticScrollingWindower<WorldTypepathDropdownEntryData> { }

const WorldTypepathDropdownEntry = (props: {
  data: WorldTypepathDropdownEntryData,
}) => {
  return (
    <Stack>
      <Stack.Item>
        {!!props.data.iconRef && !!props.data.iconState ? (
          <ByondIconRef iconRef={props.data.iconRef} iconState={props.data.iconState} />
        ) : (
          "<A>"
        )}
      </Stack.Item>
      <Stack.Item grow={1}>
        {props.data.name}
      </Stack.Item>
      <Stack.Item>
        <Button icon="question" tooltip={`Path: ${props.data.path}`} />
      </Stack.Item>
    </Stack>
  );
};
