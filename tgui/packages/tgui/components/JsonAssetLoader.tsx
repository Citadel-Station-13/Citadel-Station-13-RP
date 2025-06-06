/**
 * @file
 * @license MIT
 */

import { Component, InfernoNode } from "inferno";
import { JsonMappings } from "../bindings/json";

/**
 * Loads JSON assets; can display a different set of contents while not loaded.
 * Provides loaded assets via lambda.
 * * Can additionally verify other assets are loaded before proceeding.
 * * Will never re-fetch the asset while the window is still open. Makes sense in a lot of
 *   use cases, but said just in case.
 */
export class JsonAssetLoader extends Component<{
  loading?: (waiting: JsonMappings[], finished: JsonMappings[], elapsedMillis: number) => InfernoNode;
  loaded: (json: Record<JsonMappings, Object>) => InfernoNode;
  assets: JsonMappings[];
}, {}> {
  constructor(props, context) {
    super();
  }

  render() {

  }
}
