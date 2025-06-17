/**
 * @file
 * @license MIT
 */

import { Component, InfernoNode } from "inferno";
import { JsonMappings, resolveJsonAssetName } from "../bindings/json";
import { fetchRetry } from "../http";
import { LoadingScreen } from "./LoadingScreen";

/**
 * Loads JSON assets; can display a different set of contents while not loaded.
 * Provides loaded assets via lambda.
 * * Can additionally verify other assets are loaded before proceeding.
 * * Will never re-fetch the asset while the window is still open. Makes sense in a lot of
 *   use cases, but said just in case.
 */
export class JsonAssetLoader extends Component<{
  loading?: (waiting: JsonMappings[], finished: JsonMappings[], elapsedMillis: number) => InfernoNode;
  loaded: (json: {[K in JsonMappings]? : Object}) => InfernoNode;
  assets: JsonMappings[];
}, {
  remaining: number;
  fetched: {[K in JsonMappings]? : Object};
}> {

  // not in state; state update will trigger redraw
  waiting: JsonMappings[];
  // not in state; state update will trigger redraw
  finished: JsonMappings[];
  // start time
  startTimeMillis: number;

  constructor() {
    super();

    this.waiting = this.props.assets.slice();
    this.finished = [];
    this.startTimeMillis = Date.now();
    this.state = {
      remaining: this.waiting.length,
      fetched: {},
    };

    this.props.assets.forEach((mapping) => {
      const assetUrl = resolveJsonAssetName(mapping);
      fetchRetry(assetUrl).then((resp) => this.setState((curr) => {
        let updatedFetched = { ...curr.fetched };
        updatedFetched[mapping] = resp.json();

        this.finished.push(mapping);
        this.waiting = this.waiting.filter((v) => `${v}` !== `${mapping}`);

        return {
          ...curr,
          remaining: curr.remaining - 1,
          fetched: updatedFetched,
        };
      }));
    });
  }

  render() {
    return this.waiting.length ? (this.props.loading ? this.props.loading(this.waiting, this.finished, Date.now() - this.startTimeMillis) : (
      <LoadingScreen />
    )) : this.props.loaded(this.state?.fetched || {});
  }
}
