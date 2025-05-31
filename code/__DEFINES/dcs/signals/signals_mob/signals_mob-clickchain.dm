//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

//* dynamic hooks *//

/**
 * Fired with (clickchain, clickchain_flags)
 *
 * * This signal is fired on the outgoing (attacking) side.
 * * This signal should be fired after things like attack_hand run; ergo, when we're
 *   about to process intent-ful behavior like hugging, disarming, grabbing, attacking, etc.
 * * This signal is never used if an item is used, and will not be able to intercept an ui_interact() or anything
 *   like that.
 * * This signal should be fired before atom shieldcall / contact / disarm / whatnot. Use this to do
 *   custom behaviors.
 *
 * As a word of warning, be careful using this. If you hook and don't check intent with say, gloves that do an
 * attack, you'll have the person attacking when trying to hug. This is obviuosly suboptimal.
 */
#define COMSIG_MOB_MELEE_INTENTFUL_HOOK "mob-melee-intent"
	/// skip default action
	#define RAISE_MOB_MELEE_INTENTFUL_SKIP (1<<0)
	/// did something
	#define RAISE_MOB_MELEE_INTENTFUL_ACTION (1<<1)

//* melee_attack_chain() *//

/**
 * From base of /mob melee_impact(): (args)
 *
 * * This signal is fired on the outgoing (attacking) side.
 * * args are indexed according to CLICKCHAIN_MELEE_ATTACK_ARG_* defines.
 */
#define COMSIG_MOB_MELEE_IMPACT_HOOK "mob-melee-impact"
	/// skip default action
	#define RAISE_MOB_MELEE_IMPACT_SKIP (1<<0)
