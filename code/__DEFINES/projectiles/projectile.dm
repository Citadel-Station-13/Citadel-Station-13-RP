//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* pre_impact(), impact(), bullet_act(), on_impact() impact_flags           *//
/// pre_impact, bullet_act, on_impact are called in that order by impact().  ///

/// pointblank hit
#define PROJECTILE_IMPACT_POINT_BLANK (1<<0)
/// piercing hit; if returned, forces pierce for current impact
///
/// * projectile has the right to perform special behavior like reducing damage after the impact
#define PROJECTILE_IMPACT_PIERCING (1<<1)
/// was blocked from directly hitting target
///
/// * on impact probably shouldn't do direct damage, but explosive rounds will explode, etc
#define PROJECTILE_IMPACT_BLOCKED (1<<2)
/// if sensing this flag, **immediately** destroy the projectile without elaboration
///
/// * overrides everything else
#define PROJECTILE_IMPACT_DELETE (1<<3)
/// do not hit; if this is present, we phase through without interaction
///
/// * bullet_act(), and on_impact() will be cancelled by this.
/// * on_phase() is called instead to allow for standard hooks to fire
#define PROJECTILE_IMPACT_PHASE (1<<4)
/// signifies that the projectile is reflected.
///
/// * projectile is not deleted like in PIERCING or PHASE
/// * fires off on_reflect() instead
#define PROJECTILE_IMPACT_REFLECT (1<<5)

//* helpers *//

/// tiles per second to pixels per decisecond
#define PROJECTILE_SPEED_FOR_TPS(tiles) (tiles * WORLD_ICON_SIZE / 10)
