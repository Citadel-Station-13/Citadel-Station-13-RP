//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* prehit_pierce() return values
/// Default behavior: hit and delete self
#define PROJECTILE_PIERCE_NONE 0
/// Hit the thing but go through without deleting. Causes on_hit to be called with pierced = TRUE
#define PROJECTILE_PIERCE_HIT 1
/// Entirely phase through the thing without ever hitting.
#define PROJECTILE_PIERCE_PHASE 2
// Delete self without hitting
#define PROJECTILE_DELETE_WITHOUT_HITTING 3

//* bullet_act() flags
/// was a pointblank hit
#define BULLET_HIT_POINT_BLANK (1<<0)
/// was a piercing hit
#define BULLET_HIT_PIERCING (1<<1)

//* bullet_act() return values
/// It's a successful hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_HIT				"HIT"
/// It's a blocked hit, whatever that means in the context of the thing it's hitting.
#define BULLET_ACT_BLOCK			"BLOCK"
/// It pierces through the object regardless of the bullet being piercing by default.
#define BULLET_ACT_FORCE_PIERCE		"PIERCE"
/// It hit us but it should hit something on the same turf too. Usually used for turfs.
#define BULLET_ACT_TURF				"TURF"
/// It doesn't hit us - it just doesn't.
#define BULLET_ACT_IGNORE			"IGNORE"

//* submunition_spread_mode; null to not spread
/// spread evenly
#define SUBMUNITION_SPREAD_EVENLY 1
/// spread randomly
#define SUBMUNITION_SPREAD_RANDOM 2

//* helpers
/// tiles per second to pixels per decisecond
#define TILES_PER_SECOND(tiles) (tiles * WORLD_ICON_SIZE / 10)
