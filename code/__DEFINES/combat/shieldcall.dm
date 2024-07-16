//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* shieldcall return status *//

/// terminate; either fully mitigated or we're done here
#define SHIELDCALL_RETURN_TERMINATE (1<<0)
/// terminate attacker swing entirely
///
/// * usually you don't want this
#define SHIELDCALL_RETURN_CANCEL_SWING (1<<1)
/// stop attack effects
///
/// * this is basically the [PROJECTILE_IMPACT_BLOCKED] for shieldcalls
/// * the thing hitting won't do direct damage but aftereffects like exploding rounds still explode
#define SHIELDCALL_RETURN_ATTACK_CANCEL (1<<2)
/// attack redirected entirely
#define SHIELDCALL_RETURN_ATTACK_REDIRECT (1<<3)
/// attack goes through
///
/// * both this and REDIRECT should be used if the original attack should keep going
/// * also use SHIELDCALL_RETURN_ATTACK_CANCEL if original attack shouldn't process! otherwise it might be a pierce.
/// * example: reflecting a bullet
#define SHIELDCALL_RETURN_ATTACK_PASSTHROUGH (1<<4)
/// this attack already invoked a 'specialized' shieldcall proc, and is now invoking
/// the generalized atom_shieldcall() proc.
#define SHIELDCALL_RETURN_SECOND_CALL (1<<5)

/// stop shieldcall chain
#define SHIELDCALL_RETURNS_SHOULD_TERMINATE (SHIELDCALL_RETURN_TERMINATE)
/// these flags means something happens / should happen
#define SHIELDCALL_RETURNS_SHOULD_PROCESS (SHIELDCALL_RETURNS_ABORT_ATTACK | SHIELDCALL_RETURNS_PIERCE_ATTACK)
/// these flags mean to stop processing the attack
#define SHIELDCALL_RETURNS_ABORT_ATTACK (SHIELDCALL_RETURN_ATTACK_CANCEL)
/// these flags means that the attack should keep going after us, regardless of if we're hit
#define SHIELDCALL_RETURNS_PIERCE_ATTACK (SHIELDCALL_RETURN_ATTACK_PASSTHROUGH)

//*                               Atom Shieldcall Args                            *//
//*                                                                               *//
//* The shieldcall system is a very low-level 'damage instance' interception API. *//
//* It's used by the shieldcalls list in atoms to perform low-level intercepts,   *//
//* as well as by default features like armor to perform their damage intercepts. *//
//*                                                                               *//
//* For speed reasons, shieldcalls pass a single argument list down instead of    *//
//* returning new lists every call, as shieldcalls need to be able to edit many   *//
//* facets of a damage instance.                                                  *//

/// damage amount
#define SHIELDCALL_ARG_DAMAGE 1
/// damage type
#define SHIELDCALL_ARG_DAMAGE_TYPE 2
/// damage tier
#define SHIELDCALL_ARG_DAMAGE_TIER 3
/// armor flag
#define SHIELDCALL_ARG_DAMAGE_FLAG 4
/// damage mode
#define SHIELDCALL_ARG_DAMAGE_MODE 5
/// attack type
#define SHIELDCALL_ARG_ATTACK_TYPE 6
/// attacking weapon datum - same as used in armor
#define SHIELDCALL_ARG_WEAPON 7
/// flags returned from other shieldcalls
#define SHIELDCALL_ARG_FLAGS 8
/// hit zone; this is usually a bodypart but this is also optional
#define SHIELDCALL_ARG_HIT_ZONE 9
/// additional list returns; usually empty, but may exist
#define SHIELDCALL_ARG_ADDITIONAL 10

//* list keys for list/additional in atom shieldcalls *//

// none yet
