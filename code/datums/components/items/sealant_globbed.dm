//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * A component that registers an item as having been hit by a sealant glob.
 *
 * This is neeeded to sealant globs can stick even if someone has equipment on.
 * On nebula this is rarely the case but on citrp pretty much everyone has
 * a lot of clothing on.
 *
 * The 'wear over' API was considered but ultimately skipped as we do not
 * want sealant globs to suppress item behaviors; ergo sealant guns should
 * not be able to be used to 'erase' people's equipment from their slots.
 */
/datum/component/sealant_globbed

/datum/component/sealant_globbed/Initialize(obj/projectile/sealant/source_sealant_glob)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return

/datum/component/sealant_globbed/RegisterWithParent()
	. = ..()

/datum/component/sealant_globbed/UnregisterFromParent()
	. = ..()

#warn THIS WILL NEED TO HOOK RENDERING


#warn impl
