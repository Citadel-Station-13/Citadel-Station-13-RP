//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Kinda self explanatory; stores points you can apply to a card.
 */
/obj/item/point_redemption_voucher
	name = "point redemption voucher"
	desc = "A voucher with redemption points that you can apply to an ID card to use at an equipment vendor."
	icon = 'icons/obj/card_cit.dmi'
	icon_state = "generic"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = SLOT_ID | SLOT_EARS
	pickup_sound = 'sound/items/pickup/card.ogg'

	/// stored points
	var/list/stored_redemption_points

/obj/item/point_redemption_voucher/Initialize(mapload, list/points)
	. = ..()
	if(points)
		src.stored_redemption_points = points.Copy()

/obj/item/point_redemption_voucher/examine(mob/user, dist)
	. = ..()
	var/any_found = FALSE
	for(var/key in stored_redemption_points)
		var/amount = stored_redemption_points[key]
		if(!amount)
			continue
		any_found = TRUE
		. += SPAN_NOTICE("There's [amount] [key] equipment redemption point[amount > 1 ? "s" : ""] loaded on this card.")
	if(!any_found)
		. += SPAN_NOTICE("There's no equipment redemption points loaded on this voucher.")

/obj/item/point_redemption_voucher/using_as_item(atom/target, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(target, /obj/item/card/id))
		transfer_to_card(target, e_args)
		return CLICKCHAIN_DID_SOMETHING

/obj/item/point_redemption_voucher/using_item_on(obj/item/using, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(. & CLICKCHAIN_FLAGS_INTERACT_ABORT)
		return
	if(istype(using, /obj/item/card/id))
		transfer_to_card(using, e_args)
		return CLICKCHAIN_DID_SOMETHING

/obj/item/point_redemption_voucher/proc/transfer_to_card(obj/item/card/id/to_id_card, datum/event_args/actor/actor)
	if(!length(stored_redemption_points))
		actor?.chat_feedback(
			SPAN_NOTICE("[src] has no stored redemption points."),
			target = src,
		)
		return
	for(var/key in stored_redemption_points)
		var/amount = stored_redemption_points[key]
		to_id_card.adjust_redemption_points(key, amount)
		actor?.chat_feedback(
			SPAN_NOTICE("You transfer [amount] [key] points to [to_id_card] from [src]."),
		)
	stored_redemption_points = null

//* Presets *//

/obj/item/point_redemption_voucher/preloaded

/obj/item/point_redemption_voucher/preloaded/mining/c500
	stored_redemption_points = list(
		POINT_REDEMPTION_TYPE_MINING = 500,
	)

/obj/item/point_redemption_voucher/preloaded/mining/c1000
	stored_redemption_points = list(
		POINT_REDEMPTION_TYPE_MINING = 1000,
	)

/obj/item/point_redemption_voucher/preloaded/mining/c2000
	stored_redemption_points = list(
		POINT_REDEMPTION_TYPE_MINING = 2000,
	)

/obj/item/point_redemption_voucher/preloaded/mining/c3000
	stored_redemption_points = list(
		POINT_REDEMPTION_TYPE_MINING = 3000,
	)

/obj/item/point_redemption_voucher/preloaded/mining/c50000
	stored_redemption_points = list(
		POINT_REDEMPTION_TYPE_MINING = 50000,
	)

/obj/item/point_redemption_voucher/preloaded/survey/c50
	stored_redemption_points = list(
		POINT_REDEMPTION_TYPE_SURVEY = 50,
	)

/obj/item/point_redemption_voucher/preloaded/survey/c100
	stored_redemption_points = list(
		POINT_REDEMPTION_TYPE_SURVEY = 100,
	)

/obj/item/point_redemption_voucher/preloaded/survey/c200
	stored_redemption_points = list(
		POINT_REDEMPTION_TYPE_SURVEY = 200,
	)

/obj/item/point_redemption_voucher/preloaded/survey/c300
	stored_redemption_points = list(
		POINT_REDEMPTION_TYPE_SURVEY = 300,
	)

/obj/item/point_redemption_voucher/preloaded/engineering/c50
	stored_redemption_points = list(
		POINT_REDEMPTION_TYPE_ENGINEERING = 50,
	)
