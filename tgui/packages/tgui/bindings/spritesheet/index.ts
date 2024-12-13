/**
 * @file
 * @license MIT
 */

/**
 * Spritesheet type enums.
 */
export enum SpritesheetMappings {
  WorldTypepaths = "WorldTypepaths",
}

export const resolveSpritesheetAssetName = (spritesheetType: SpritesheetMappings) => `${spritesheetType}.json`;
