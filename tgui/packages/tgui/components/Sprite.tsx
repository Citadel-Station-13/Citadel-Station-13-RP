/**
 * @file
 * @license MIT
 */

import { classes } from "common/react";
import { Box, BoxProps } from "./Box";

interface SpriteProps extends BoxProps {
  sheet: string;
  sizeKey: string;
  prefix?: string;
  sprite: string;
}

export const Sprite = (props: SpriteProps) => {
  return (
    <Box {...props}
      className={classes([
        `${props.sheet}${props.sizeKey}`,
        props.prefix? `${props.prefix}-${props.sprite}` : props.sprite,
      ])} />
  );
};
