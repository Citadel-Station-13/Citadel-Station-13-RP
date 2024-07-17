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

/// flags set in a projectile reflect
///
/// * you should be using /datum/shieldcall's bullet intercept / bullet signals if possible but this works too
#define SHIELDCALL_RETURNS_FOR_PROJECTILE_DEFLECT (SHIELDCALL_RETURN_TERMINATE | SHIELDCALL_RETURN_ATTACK_CANCEL | SHIELDCALL_RETURN_ATTACK_REDIRECT | SHIELDCALL_RETURN_ATTACK_PASSTHROUGH)

//*                               Atom Shieldcall Args                            *//
//*                                                                               *//
//* The shieldcall system is a very low-level 'damage instance' interception API. *//
//* It's used by the shieldcalls list in atoms to perform low-level intercepts,   *//
//* as well as by default features like armor to perform their damage intercepts. *//
//*                                                                               *//
//* For speed reasons, shieldcalls pass a single argument list down instead of    *//
//* returning new lists every call, as shieldcalls need to be able to edit many   *//
//* facets of a damage instance.                                                  *//
//*                                                                               *//
//* Many of these are optional.                                                   *//
//*
//* Adding new arguments should be done sparingly.
//* Removing arguments requires every single proc with SHIELDCALL_PROC_HEADER     *//
//* to be audited.                                                                *//

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
/// attacking weapon datum
///
/// * /obj/projectile if projectile
/// * /datum/unarmed_attack if unarmed melee
/// * /obj/item if item melee
/// * /datum/thrownthing if thrown
#define SHIELDCALL_ARG_WEAPON 7
/// flags returned from other shieldcalls
#define SHIELDCALL_ARG_FLAGS 8
/// hit zone; this is usually a bodypart but this is also optional
#define SHIELDCALL_ARG_HIT_ZONE 9
/// additional list returns; usually empty, but may exist
#define SHIELDCALL_ARG_ADDITIONAL 10
/// the clickchain of a melee attack
///
/// * this is passed in so you can grab data like who is doing it / who started the attack.
/// * filled in sometimes but not always if unarmed or item melee.
#define SHIELDCALL_ARG_CLICKCHAIN 11

/// A proc header with all the shieldcall args.
///
/// * We use this so it's easy to check where shieldcall args are being used if shieldcalls need to be refactored.
#define SHIELDCALL_PROC_HEADER damage, damage_type, damage_tier, damage_flag, damage_mode, attack_type, datum/weapon, shieldcall_flags, hit_zone, list/additional, datum/event_args/actor/clickchain/clickchain

//* list keys for list/additional in atom shieldcalls *//

// none yet
