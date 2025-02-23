/**
 * @file
 * @license MIT
 */

import { Component, InfernoNode } from "inferno";
import { ComponentProps } from "./Component";
import { Json_AssetPackBase, JsonMappings } from "tgui/bindings/json";
import { SpritesheetMappings } from "tgui/bindings/spritesheet";

type AssetLoaderTypeDeclaration = {
  json?: {
    [key: string]: Json_AssetPackBase,
  },
  sprites?: {

  },
}

interface AssetLoaderProps<T> extends ComponentProps {
  readonly loadingContent?: InfernoNode;
  readonly loadedContent?: (assumedLoaded: T) => InfernoNode;
  readonly requireAssetJson?: JsonMappings[];
  readonly requireAssetSpritesheet?: SpritesheetMappings[];
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
