//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/**
 * new, almost-automated humanoid simplemobs
 *
 * todo: rename back to /humanoid by getting rid of legacy humanoid mobs.
 */
/mob/living/simple_mob/humanoid2
	#warn icon generation

	/// set to species typepath to init as that species
	var/datum/species/species_path
	/// set to outfit typepath to init from that outfit
	var/datum/outfit/outfit_path
	/// default 'charges' of items
	///
	/// * grenades: amount
	/// * guns: magazines
	var/item_supply_default = 3
	/// set to list of item typepaths to use them as weapons/tools/etc
	///
	/// supported typepaths:
	/// * /obj/item/grenade - associate to value for 'amount provided'
	/// * /obj/item/gun - associate to value for 'magazines contained'. = 1 --> one mag. default is 3.
	/// * /obj/item - anything else will be used as a **melee weapon**.
	///
	/// todo:
	/// * currently, medical supplies are infinite.
	///
	/// warnings:
	/// * read the 'supported typepaths'. don't accidentally give something 30 magazines instead of 30 rounds.
	/// * if you give nothing, they're likely stuck using their fists. lol, lmao.
	/// * the *first* item in this, and second if the first is an one-handed item, is used for the preview.
	var/list/item_paths

/mob/living/simple_mob/humanoid2/Initialize(mapload)
	. = ..()

#warn impl
