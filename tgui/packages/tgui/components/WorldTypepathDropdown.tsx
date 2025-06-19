/**
 * @file
 * @license MIT
 */

import { BooleanLike, classes } from "common/react";
import { Json_WorldTypepaths, JsonMappings } from "../bindings/json";
import { Box, BoxProps } from "./Box";
import { JsonAssetLoader } from "./JsonAssetLoader";
import { DM_TurfSpawnFlags } from "../bindings/game";
import { Component } from "inferno";
import { Stack } from "./Stack";
import { Button } from "./Button";
import { Icon } from "./Icon";
import { ByondIconRef } from "./ByondIconRef";
import { Flex } from "./Flex";

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
  color: string;
  disabled: BooleanLike;
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
  state: { open: boolean, searchString: string | null };

  constructor(props) {
    super(props);
    this.state = {
      open: false,
      searchString: null,
    };
    this.onUnfocusedClick = () => this.setState((prev) => ({ ...prev, open: false }));
  }

  componentWillUnmount() {
    window.removeEventListener('click', this.onUnfocusedClick);
  }

  setOpen(open) {
    this.setState({ open: open });
    if (open) {
      setTimeout(() => window.addEventListener('click', this.onUnfocusedClick));
      // todo: maybe focus the search bar?
    }
    else {
      window.removeEventListener('click', this.onUnfocusedClick);
    }
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

    const menuEntries = (
      <>
        {!!filter?.areas?.enabled && (
          <>
            Test
          </>
        )}
        {!!filter?.turfs?.enabled && (
          <>
            Test
          </>
        )}
      </>
    );

    return (
      <Box className="WorldTypepathDropdown" {...rest}>
        <JsonAssetLoader
          assets={[JsonMappings.WorldTypepaths]}
          loading={() => (
            // todo: better loading display
            <h1>Loading...</h1>
          )}
          loaded={(json) => {
            const typepathPack: Json_WorldTypepaths = json[JsonMappings.WorldTypepaths] as Json_WorldTypepaths;
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
            return (
              <>
                <Stack fill onClick={() => {
                  if (disabled && !this.state.open) {
                    return;
                  }
                  this.setOpen(!this.state.open);
                }}
                  className={classes(['Button', 'Button--color--' + color, disabled && 'Button--disabled', className])}>
                  <Stack.Item>
                    {selectedIcon}
                  </Stack.Item>
                  <Stack.Item grow={1}>
                    {selectedName}
                  </Stack.Item>
                  <Stack.Item>
                    <Button icon="question" tooltip={selectedTooltip} />
                  </Stack.Item>
                  <Stack.Item>
                    <Icon name={this.state.open ? 'chevron-up' : 'chevron-down'} />
                  </Stack.Item>
                </Stack>
                {this.state.open && (
                  <Box className="WorldTypepathDropdown__menu">
                    <Stack fill vertical>
                      <Stack.Item>
                        Search
                      </Stack.Item>
                      <Stack.Item grow={1}>
                        <Flex width="100%" height="100%" direction="column" overflowY="auto">
                          {menuEntries}
                        </Flex>
                      </Stack.Item>
                    </Stack>
                  </Box>
                )}
              </>
            );
          }}
        />
      </Box>
    );
  }
}

