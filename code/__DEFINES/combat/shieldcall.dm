//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* shieldcall return status *//

/// terminate; either fully mitigated or we're done here
#define SHIELDCALL_FLAG_TERMINATE (1<<0)
/// terminate attacker swing entirely
///
/// * usually you don't want this
#define SHIELDCALL_FLAG_CANCEL_SWING (1<<1)
/// stop attack effects
///
/// * this is basically the [PROJECTILE_IMPACT_BLOCKED] for shieldcalls
/// * the thing hitting won't do direct damage but aftereffects like exploding rounds still explode
#define SHIELDCALL_FLAG_ATTACK_BLOCKED (1<<2)
/// attack redirected entirely
#define SHIELDCALL_FLAG_ATTACK_REDIRECT (1<<3)
/// attack goes through
///
/// * both this and REDIRECT should be used if the original attack should keep going
/// * also use SHIELDCALL_FLAG_ATTACK_BLOCKED if original attack shouldn't process! otherwise it might be a pierce.
/// * example: reflecting a bullet
#define SHIELDCALL_FLAG_ATTACK_PASSTHROUGH (1<<4)
/// this attack already invoked a 'specialized' shieldcall proc, and is now invoking
/// the generalized atom_shieldcall() proc.
#define SHIELDCALL_FLAG_SECOND_CALL (1<<5)
/// asks the shieldcall nicely to not make a message
#define SHIELDCALL_FLAG_SUPPRESS_MESSAGE (1<<6)
/// asks the shieldcall nicely to not make a sound
#define SHIELDCALL_FLAG_SUPPRESS_SOUND (1<<7)
/// do not call armorcalls
#define SHIELDCALL_FLAG_SKIP_ARMORCALLS (1<<8)
/// do not call shieldcalls
#define SHIELDCALL_FLAG_SKIP_SHIELDCALLS (1<<9)
/// this is a passive / single parry
#define SHIELDCALL_FLAG_SINGLE_PARRY (1<<10)

/// these flags mean to stop processing the attack
#define SHIELDCALL_FLAGS_BLOCK_ATTACK (SHIELDCALL_FLAG_ATTACK_BLOCKED)
/// these flags means that the attack should keep going after us, regardless of if we're hit
#define SHIELDCALL_FLAGS_PIERCE_ATTACK (SHIELDCALL_FLAG_ATTACK_PASSTHROUGH)
/// stop shieldcall chain
#define SHIELDCALL_FLAGS_SHOULD_TERMINATE (SHIELDCALL_FLAG_TERMINATE)
/// these flags means something happens / should happen
#define SHIELDCALL_FLAGS_SHOULD_PROCESS (SHIELDCALL_FLAGS_BLOCK_ATTACK | SHIELDCALL_FLAGS_PIERCE_ATTACK)

/// flags set in a projectile reflect
///
/// * you should be using /datum/shieldcall's bullet intercept / bullet signals if possible but this works too
#define SHIELDCALL_FLAGS_FOR_PROJECTILE_DEFLECT (SHIELDCALL_FLAG_TERMINATE | SHIELDCALL_FLAG_ATTACK_BLOCKED | SHIELDCALL_FLAG_ATTACK_REDIRECT | SHIELDCALL_FLAG_ATTACK_PASSTHROUGH)
/// flags set in a full block
#define SHIELDCALL_FLAGS_FOR_COMPLETE_BLOCK (SHIELDCALL_FLAG_TERMINATE | SHIELDCALL_FLAG_ATTACK_BLOCKED)

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
/// attack type; this is always optional!
#define SHIELDCALL_ARG_ATTACK_TYPE 6
/// attacking weapon datum; this is always optional!
///
/// * /obj/projectile if projectile
/// * /datum/event_args/actor/clickchain if melee
/// * /datum/thrownthing if thrown
#define SHIELDCALL_ARG_ATTACK_SOURCE 7
/// flags returned from other shieldcalls
#define SHIELDCALL_ARG_FLAGS 8
/// hit zone; this is usually a bodypart but this is also optional
#define SHIELDCALL_ARG_HIT_ZONE 9
/// additional list returns; usually empty, but may exist
#define SHIELDCALL_ARG_ADDITIONAL 10

/// A proc header with all the shieldcall args.
///
/// * We use this so it's easy to check where shieldcall args are being used if shieldcalls need to be refactored.
#define SHIELDCALL_PROC_HEADER damage, damage_type, damage_tier, damage_flag, damage_mode, attack_type, attack_source, shieldcall_flags, hit_zone, list/additional

//* list keys for list/additional in atom shieldcalls *//

// none yet

//* Helpers to manipulate shieldcall args *//

#define RESOLVE_SHIELDCALL_ATTACK_TEXT(SHIELDCALL) resolve_shieldcall_attack_text(SHIELDCALL)

/proc/resolve_shieldcall_attack_text(list/shieldcall_args)
	switch(shieldcall_args[SHIELDCALL_ARG_ATTACK_TYPE])
		if(ATTACK_TYPE_PROJECTILE)
			. = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]
		if(ATTACK_TYPE_THROWN)
			var/datum/thrownthing/thrown = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]
			if(thrown)
				. = "the impact from [thrown.thrownthing]"
		if(ATTACK_TYPE_MELEE)
			. = "the force of the blow"

	if(!.)
		. = "the attack"

#define RESOLVE_SHIELDCALL_WEAPON_DESCRIPTOR(SHIELDCALL) resolve_shieldcall_weapon_descriptor(SHIELDCALL)

/proc/resolve_shieldcall_weapon_descriptor(list/shieldcall_args)
	switch(shieldcall_args[SHIELDCALL_ARG_ATTACK_TYPE])
		if(ATTACK_TYPE_MELEE)
			var/datum/event_args/actor/clickchain/clickchain = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]
			if(clickchain)
				return "a [clickchain.using_melee_weapon || clickchain.using_melee_attack]"
		if(ATTACK_TYPE_PROJECTILE)
			var/obj/projectile/proj = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]
			return "a [proj]"
		if(ATTACK_TYPE_THROWN)
			var/datum/thrownthing/thrown = shieldcall_args[SHIELDCALL_ARG_ATTACK_SOURCE]
			return "a [thrown.thrownthing]"
	if(!.)
		. = "an attack"

//* handle_touch - contact_flags *//.

// broad descriptors

/// generally helpful actions (shake up, etc)
#define SHIELDCALL_CONTACT_FLAG_HELPFUL (1<<0)
/// potentially helpful but also potentially harmful actions
#define SHIELDCALL_CONTACT_FLAG_NEUTRAL (1<<1)
/// harmful actions
#define SHIELDCALL_CONTACT_FLAG_HARMFUL (1<<2)

// categories

/// medical items/techniques
#define SHIELDCALL_CONTACT_FLAG_MEDICAL (1<<23)

//* handle_touch - contact_specific *//

/// trying to inject someone
#define SHIELDCALL_CONTACT_SPECIFIC_SYRINGE_INJECTION "inject"
/// trying to shake someone up
#define SHIELDCALL_CONTACT_SPECIFIC_SHAKE_UP "help"
/// being disarmed
#define SHIELDCALL_CONTACT_SPECIFIC_DISARM "disarm"
/// trying to drag someone
#define SHIELDCALL_CONTACT_SPECIFIC_PULL "pull"
/// trying to grab someone, **or** intensify a grab
#define SHIELDCALL_CONTACT_SPECIFIC_GRAB "grab"
/// trying to perform a surgery step - generic
#define SHIELDCALL_CONTACT_SPECIFIC_SURGERY "surgery"
/// being sprayed with chemicals
#define SHIELDCALL_CONTACT_SPECIFIC_CHEMICAL_SPRAY "spray"

//* handle_touch - helpers *//

/**
 * Gets text to put in say, "blocks \the [text]" when someone has a blocked touch.
 */
#define RESOLVE_SHIELDCALL_TOUCH_TEXT(CONTACT_FLAGS, CONTACT_SPECIFIC) resolve_shieldcall_touch_text(CONTACT_FLAGS, CONTACT_SPECIFIC)

/proc/resolve_shieldcall_touch_text(flags, specific)
	switch(specific)
		if(SHIELDCALL_CONTACT_SPECIFIC_SYRINGE_INJECTION)
			return "syringe"
		if(SHIELDCALL_CONTACT_SPECIFIC_SHAKE_UP)
			return "help-up"
		if(SHIELDCALL_CONTACT_SPECIFIC_GRAB)
			return "grab"
		if(SHIELDCALL_CONTACT_SPECIFIC_SURGERY)
			return "operation"
		if(SHIELDCALL_CONTACT_SPECIFIC_CHEMICAL_SPRAY)
			return "spray"
