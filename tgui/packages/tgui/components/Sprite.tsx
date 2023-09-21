/**
 * @file
 * @license MIT
 */

import { BooleanLike, classes } from "common/react";
import { Box, BoxProps } from "./Box";

interface SpriteProps extends BoxProps {
  sheet: string;
  sizeKey: string;
  prefix?: string;
  sprite: string;
  fill?: BooleanLike;
}

export const Sprite = (props: SpriteProps) => {
  return (
    <Box {...props}
      className={classes([
        "Sprite",
        `${props.sheet}${props.sizeKey}`,
        props.prefix? `${props.prefix}-${props.sprite}` : props.sprite,
        !!props.fill && 'Sprite--fill',
      ])} />
  );
};
