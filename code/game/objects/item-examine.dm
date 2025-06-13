//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Called to build examine desc while worn.
 *
 * * Item will render as "They are [wearing] [OUR DESC HERE] [on] their [slot]".
 * * Return null to not render.
 *
 * @return string
 */
/obj/item/proc/examine_name_in_slot(datum/event_args/examine/e_args)
	return "\a [src]"

/**
 * Called to build examine desc for strip menu.
 *
 * * Item will render as "Suit: [OUR DESC HERE]".
 * * Return null to not render.
 *
 * @return string as unsafe html
 */
/obj/item/proc/examine_name_in_strip(datum/event_args/actor/actor)
	return "[src]"
