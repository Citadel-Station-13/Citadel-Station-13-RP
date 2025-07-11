//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/prototype/eldritch_passive/eldritch_antimagic/awakening
	id = "antimagic-awakening"
	name = "Awakening - Reinforcement"
	desc = "Passive antimagic for eldritch cultists."

	antimagic_struct = new /datum/antimagic/simple_linear/eldritch_antimagic/awakening

/datum/antimagic/simple_linear/eldritch_antimagic/awakening
	magic_types = MAGIC_TYPES_ALL
	full_block_potency = MAGIC_POTENCY_ELDRITCH_AWAKENING_ANTIMAGIC_FULL_BLOCK
	cant_block_potency = MAGIC_POTENCY_ELDRITCH_AWAKENING_ANTIMAGIC_NONE_BLOCK
