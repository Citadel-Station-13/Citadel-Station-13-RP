//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

//* pre_impact(), impact(), bullet_act(), on_impact() impact_flags           *//
/// pre_impact, bullet_act, on_impact are called in that order               ///

/// pointblank hit
#define PROJECTILE_IMPACT_POINT_BLANK (1<<0)
/// piercing hit; if returned, forces pierce for current impact
///
/// * projectile has the right to perform special behavior like reducing damage after the impact
#define PROJECTILE_IMPACT_PIERCE (1<<1)
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
/// * fires off on_reflect()
#define PROJECTILE_IMPACT_REFLECT (1<<5)
/// we should pass through without interaction
///
/// * bullet_act(), on_impact(), on_reflect(), and on_phase() will all be cancelled by this.
#define PROJECTILE_IMPACT_PASSTHROUGH (1<<6)
/// instructs piercing projectiles that support this
/// to not reduce damage because the impact was so trivial
/// compared to the force of the projectile
#define PROJECTILE_IMPACT_TRIVIAL (1<<7)
/// aborting duplicate impact due to already being in impacted list of projectile
#define PROJECTILE_IMPACT_DUPLICATE (1<<8)
/// passed from another bullet_act(),
/// like from a target stake to the mounted target
#define PROJECTILE_IMPACT_INDIRECTED (1<<9)
/// used by /impact() on projectile to signal to impact_loop()
/// that the projectile should keep impacting everything on the turf it was trying to hit
#define PROJECTILE_IMPACT_CONTINUE_LOOP (1<<10)
/// this is an impact (usually on the ground) from a projectile expiring
#define PROJECTILE_IMPACT_IS_EXPIRING (1<<11)

/// any of these means the projectile should delete immediately
#define PROJECTILE_IMPACT_FLAGS_SHOULD_DELETE (PROJECTILE_IMPACT_DELETE)
/// any of these means the projectile should not impact
#define PROJECTILE_IMPACT_FLAGS_SHOULD_NOT_HIT (PROJECTILE_IMPACT_REFLECT | PROJECTILE_IMPACT_PHASE | PROJECTILE_IMPACT_PASSTHROUGH)
/// any of these means don't just delete after hit
#define PROJECTILE_IMPACT_FLAGS_SHOULD_GO_THROUGH (PROJECTILE_IMPACT_REFLECT | PROJECTILE_IMPACT_PHASE | PROJECTILE_IMPACT_PASSTHROUGH | PROJECTILE_IMPACT_PIERCE)
/// any of these means the projectile should pass through by piercing the entity
#define PROJECTILE_IMPACT_FLAGS_SHOULD_PIERCE (PROJECTILE_IMPACT_PIERCE)
/// any of these means the projectile should abort bullet_act
#define PROJECTILE_IMPACT_FLAGS_SHOULD_ABORT (PROJECTILE_IMPACT_DELETE | PROJECTILE_IMPACT_REFLECT | PROJECTILE_IMPACT_PHASE | PROJECTILE_IMPACT_PASSTHROUGH)

//* projectile_type bitfield *//

//? base types; all projectiles should have one of these ?//

/// kinetic matter, basically
#define PROJECTILE_TYPE_KINETIC (1<<0)
/// energy projectiles that aren't a beam
#define PROJECTILE_TYPE_ENERGY (1<<1)
/// particle beam, basically
#define PROJECTILE_TYPE_BEAM (1<<2)

//? specific types; projectiles may have one or more of these in addition to the above ?//

/// photonic energy, basically (yes yes lasers are unrealistic i don't care)
#define PROJECTILE_TYPE_PHOTONIC (1<<23)
/// exotic energy or exotic matter
#define PROJECTILE_TYPE_EXOTIC (1<<24)

#warn projectile_type, projectile_type_cant on /obj/structure/prop/prism
#warn projectile_type /obj/projectile

//* helpers *//

/// tiles per second to pixels per decisecond
#define PROJECTILE_SPEED_FOR_TPS(tiles) (tiles * WORLD_ICON_SIZE)
