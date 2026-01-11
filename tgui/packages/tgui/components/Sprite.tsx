/**
 * @file
 * @license MIT
 */

import { Box } from "tgui-core/components";
import { classes } from "tgui-core/react";

import { BoxProps } from ".";

interface SpriteProps extends BoxProps {
  readonly sheet: string;
  readonly sizeKey: string;
  readonly prefix?: string;
  readonly sprite: string;
}

export const Sprite = (props: SpriteProps) => {
  return (
    <Box {...props}
      className={classes([
        "Sprite",
        `${props.sheet}${props.sizeKey}`,
        props.prefix ? `${props.prefix}-${props.sprite}` : props.sprite,
      ])} />
  );
};

// todo: this is all kind of terrible; we need a way to autodetect sizeKeys too so it's more friendly to users.
