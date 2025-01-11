/**
 * Just holds a definition for ComponentProps so we can derive off of it
 *
 * @file
 * @license MIT
 */

import { InfernoNode } from "inferno";

// essentialy react propswithchildren
export type PropsWithChildren = {
  children?: InfernoNode;
}
