/**
 * Just holds a definition for ComponentProps so we can derive off of it
 *
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";
import { InfernoNode } from "inferno";

export type ComponentProps = {
  // from inferno; this is everything inside of this component
  children?: InfernoNode;
  // from tgui; injected into props if and only we are the component being rendered by the root window.
  // todo: rethink this
  tguiRoot?: BooleanLike;
  // from tgui; injected into props if and only if we are a module; this will be the name of the module
  // todo: rethink this
  tguiModule?: string;
}
