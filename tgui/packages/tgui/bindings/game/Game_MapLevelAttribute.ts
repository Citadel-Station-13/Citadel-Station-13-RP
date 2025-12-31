/**
 * @file
 * @license MIT
 */

import { BooleanLike } from "tgui-core/react";

export interface Game_MapLevelAttribute {
    id: string,
    desc: string,
    allowEdit: BooleanLike,
    numeric: BooleanLike,
}
