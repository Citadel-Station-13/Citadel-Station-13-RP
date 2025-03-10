//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* Firing Cycles *//

/**
 * Called before initiation of a firing cycle, with (datum/gun_firing_cycle/cycle).
 */
#define COMSIG_GUN_FIRING_CYCLE_START "gun-firing-start"

/**
 * Called on end of a firing cycle, with (datum/gun_firing_cycle/cycle).
 */
#define COMSIG_GUN_FIRING_CYCLE_END "gun-firing-end"

//* Fire() Injections *//

/**
 * Signature: (datum/gun_firing_cycle/cycle)
 * * Raised before every fire() call.
 */
#define COMSIG_GUN_FIRING_PREFIRE "gun-firing-prefire"

/**
 * Signature: (datum/gun_firing_cycle/cycle, obj/projectile/proj)
 * * Raised before every fire() call, after consume_next_projectile().
 * * Only valid on /obj/item/gun/projectile
 * * This happens after the nominal PNR, so anything like energy drains and whatnot would have already
 *   been done by now. Keep that in mind.
 */
#define COMSIG_GUN_FIRING_PROJECTILE_INJECTION "gun-firing-projectile"

/**
 * Signature: (datum/gun_firing_cycle/cycle, atom/movable/proj)
 * * Raised before every fire() call, after consume_next_throwable().
 * * Only valid on /obj/item/gun/launcher
 * * This happens after the nominal PNR, so anything like energy drains and whatnot would have already
 *   been done by now. Keep that in mind.
 */
#define COMSIG_GUN_FIRING_THROWABLE_INJECTION "gun-firing-throwable"

/**
 * Signature: (datum/gun_firing_cycle/cycle)
 * * Raised after every fire() call, before post_fire().
 */
#define COMSIG_GUN_FIRING_POSTFIRE "gun-firing-postfire"
