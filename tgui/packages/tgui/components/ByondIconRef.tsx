import { ReactNode } from "react";
import { Image } from "tgui-core/components";

import { Direction } from "../constants";
import { BoxProps } from ".";

type Props = {
  /** Required: The \ref of the icon */
  iconRef: string;
  /** Required: The state of the icon */
  iconState: string;
} & Partial<{
  /** Facing direction. See direction enum. Default is South */
  direction?: Direction;
  /** Fallback icon. */
  fallback?: ReactNode;
  /** Frame number. Default is 1 */
  frame?: number;
  /** Movement state. Default is false */
  movement?: any;
}> &
  BoxProps;

/**
 * Displays an icon by directly fetching it from the BYOND RSC. Requires Byond 515+.
 */
export function ByondIconRef(props: Props) {
  const query = `${props.iconRef}?state=${props.iconState}&dir=${props.direction || Direction.SOUTH}&movement=${!!props.movement}&frame=${props.frame || 1}`;

  return <Image fixErrors src={query} {...props} />;
}

// Adri: DO NOT TAKE THIS COMPONENT OUT. This component doesn't rely on iconrefmap.
