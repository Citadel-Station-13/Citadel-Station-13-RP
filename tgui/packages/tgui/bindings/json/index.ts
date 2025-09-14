/**
 * @file
 * @license MIT
 */

/**
 * JSON type enums.
 */
export enum JsonMappings {
  WorldTypepaths = "WorldTypepaths",
  MapSystem = "MapSystem",
}

export interface Json_AssetPackBase {}

export const resolveJsonAssetName = (jsonType: JsonMappings) => `${jsonType}.json`;

export type { Json_MapSystem } from './Json_MapSystem';
export type { Json_WorldTypepaths } from './Json_WorldTypepaths';
