//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/obj/item/nullrod
	name = "null rod"
	desc = "A rod of pure obsidian."
	#warn icon

/obj/item/nullrod/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/antimagic_provider, /datum/antimagic/simple/nullrod)

#warn impl all

/datum/antimagic/simple/nullrod
	full_block_potency = MAGIC_POTENCY_NULLROD_FULL_BLOCK
	cant_block_potency = MAGIC_POTENCY_NULLROD_NO_BLOCK
