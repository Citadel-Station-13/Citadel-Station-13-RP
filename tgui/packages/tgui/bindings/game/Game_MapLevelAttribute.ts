/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "common/react";

export interface Game_MapLevelAttribute {
    id: string,
    desc: string,
    allowEdit: BooleanLike,
    numeric: BooleanLike,
}
