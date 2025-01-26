/**
 * @file
 * @license MIT
 */

import { Component, InfernoNode } from "inferno";
import { ComponentProps } from "./Component";

interface AssetLoaderProps extends ComponentProps {
  readonly loadingContent?: InfernoNode;
}

interface AssetLoaderState {

}

export class AssetLoader extends Component<AssetLoaderProps, AssetLoaderState> {
  constructor(props, context) {
    super();
  }

  render() {

  }
}
