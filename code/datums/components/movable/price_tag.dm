//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * /obj only
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

#warn impl all

//* /atom/movable hooks *//

/atom/movable/proc/get_price_tag() as /datum/component/price_tag
	RETURN_TYPE(/datum/component/price_tag)

/atom/movable/proc/set_price_tag(price)
	var/datum/component/price_tag/price_tag = get_price_tag()
	if(!price_tag)
		AddComponent(/datum/component/price_tag, price)
	else
		price_tag.price = price
