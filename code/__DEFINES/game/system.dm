//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* Tracking levels; determines how detailed to get with tracking something.

/// just say what, don't track
#define GAME_SYSTEM_TRACKING_LEVEL_NONE 0
/// say roughly where (ship, planet, etc)
#define GAME_SYSTEM_TRACKING_LEVEL_SECTOR 1
/// say roughly where on the map (area, etc)
#define GAME_SYSTEM_TRACKING_LEVEL_AREA 2
/// give exact location
#define GAME_SYSTEM_TRACKING_LEVEL_PINPOINT 3
