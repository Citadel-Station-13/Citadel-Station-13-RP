/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { Json_WorldTypepaths, JsonMappings } from "../bindings/json";
import { Box, BoxProps } from "./Box";
import { Flex } from "./Flex";
import { JsonAssetLoader } from "./JsonAssetLoader";
import { DM_TurfSpawnFlags } from "../bindings/game";

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
export const WorldTypepathDropdown = (props: {
  selectedPath: string;
  onSelectPath: (path: string) => void;
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
} & BoxProps, context) => {
  const {
    selectedPath,
    onSelectPath,
    filter,
    ...rest
  } = props;

  return (
    <Box {...rest}>
      <JsonAssetLoader
        assets={[JsonMappings.WorldTypepaths]}
        loading={() => (
          // todo: better loading display
          <h1>Loading...</h1>
        )}
        loaded={(json) => {
          const typepathPack: Json_WorldTypepaths = json[JsonMappings.WorldTypepaths];

          return (
            <Flex>
              <Flex.Item>
                1
              </Flex.Item>
              <Flex.Item grow={1}>
                2
              </Flex.Item>
              <Flex.Item>
                3
              </Flex.Item>
            </Flex>
          );
        }}
      />
    </Box>
  );
};
