//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * /obj only
 *
 * * This is an extension-style component, and is hooked into /obj level via GetComponent().
 *
 * todo: allow ripping it off of things
 */
/datum/component/price_tag
	registered_type = /datum/component/price_tag

	/// price to set
	var/price

/datum/component/price_tag/Initialize(price)
	if(!ismovable(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return
	src.price = price

#warn impl all;

//* /atom/movable hooks *//

/atom/movable/proc/get_price_tag() as /datum/component/price_tag
	RETURN_TYPE(/datum/component/price_tag)
	return GetComponent(/datum/component/price_tag)

/atom/movable/proc/set_price_tag(price)
	var/datum/component/price_tag/price_tag = get_price_tag()
	if(!price_tag)
		AddComponent(/datum/component/price_tag, price)
	else
		price_tag.price = price

/**
 * @return TRUE if something was deleted, FALSE otherwise
 */
/atom/movable/proc/delete_price_tag()
	var/datum/component/price_tag/price_tag = get_price_tag()
	if(price_tag)
		qdel(price_tag)
		return TRUE
	return FALSE
