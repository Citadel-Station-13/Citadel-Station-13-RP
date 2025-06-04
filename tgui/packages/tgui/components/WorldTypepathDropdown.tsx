/**
 * @file
 * @license MIT
 */

import { BoxProps } from "./Box";

/**
 * WARNING: HERE BE DRAGONS
 *
 * Dropdown field capable of rendering with icons a searchable typepath/entity selector.
 * This is used for admin UIs like buildnode, maploader, and more.
 *
 * * Requries WorldTypepaths json asset pack to be sent.
 * * Will resolve icons directly from rsc.
 * * Only works with compile-time typepaths; do not try to use this with non-WorldTypepath paths.
 */
export const WorldTypepathDropdown = (props: {
  selectedPath: string;
  onSelectPath: (path: string) => void;
} & BoxProps, context) => {

};
