//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Citadel Station's dynamic icecream module, now with added grief potential.
 *
 * - Cones can be made out of flour by the machine
 * - Cones can be infused with reagents as they are created
 * - Cones can be scoops of anything added to them, as long as it's turned into icecream-ified reagents
 * - You ice-creamify reagents with ice, milk, and sugar; minimum ice, but it won't taste as good without the others.
 *
 * Only flour, ice, milk, and sugar are stored internally.
 * Other reagents are provided from reagent containers.
 *
 * This fully supports separated chemicals. Take that as you will.
 */
/obj/structure/icecream_cart
	name = "icecream cart"
	desc = "Here on the galactic frontiers, even the ice-cream carts are advanced! Now with support for separated chemicals."
	icon = 'icons/modules/food/structures/ice_cream.dmi'
	icon_state = "cart"
	density = TRUE
	anchored = FALSE

	// todo: temporary, as this is unbuildable
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

	/// stored reagent containers to be used for drawing from
	var/list/obj/item/reagent_containers/sources

	/// selected index of reagent container to make ice cream with
	var/selected_ice_cream_source

	/// flour cost of cone
	var/cone_flour_cost = 2
	/// max cones held
	var/cone_storage = 10
	/// milk cost of scoop
	var/scoop_milk_cost = 2
	/// ice cost of scoop - this is mandatory
	var/scoop_ice_cost = 2
	/// how much reagents it can pack into a single scoop of ice cream
	var/scoop_infuse_amount = 2
	/// how much sugar is needed per scoop for it to taste good
	var/scoop_sugar_cost = 1

	/// self-explanatory
	var/max_sources = 10

/obj/structure/icecream_cart/Initialize(mapload)
	create_reagents(1000)
	. = ..()

/obj/structure/icecream_cart/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("<b>Use</b> a reagent container with an open lid on this to refill its core ingredients.")
	. += SPAN_NOTICE("<b>Click-drag</b> a reagent container with an open lid on this to add it as a mixing source.")
	. += SPAN_NOTICE("<b>Click</b> on this with an intact ice-cream cone to dispense a dollop of ice cream into it.")

/obj/structure/icecream_cart/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "IcecreamCart")
		ui.open()

/obj/structure/icecream_cart/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["scoopSource"] = selected_ice_cream_source

/obj/structure/icecream_cart/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["coneFlourCost"] = cone_flour_cost
	.["scoopMilkCost"] = scoop_milk_cost
	.["scoopIceCost"] = scoop_ice_cost
	.["scoopInfuseCost"] = scoop_infuse_amount
	var/list/collect_sources = list()
	var/list/collect_base = list(
		"milk" = reagents.get_reagent_amount(/datum/reagent/drink/milk),
		"flour" = reagents.get_reagent_amount(/datum/reagent/nutriment/flour),
		"sugar" = reagents.get_reagent_amount(/datum/reagent/sugar),
		"ice" = reagents.get_reagent_amount(/datum/reagent/drink/ice),
	)
	for(var/obj/item/reagent_containers/container as anything in sources)
		collect_sources[++collect_sources.len] = list(
			"name" = container.name,
			"volume" = container.reagents.total_volume,
			"maxVolume" = container.reagents.maximum_volume,
			"color" = container.reagents.get_color(),
			"ref" = ref(container),
		)
	.["baseIngredients"] = collect_base
	.["sources"] = collect_sources

/obj/structure/icecream_cart/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	switch(action)
		if("selectProduce")
			var/index = text2num(params["index"])
			selected_ice_cream_source = (sources && index >= 1 && index <= length(sources))? index : null
			return TRUE
		if("ejectSource")
			var/index = text2num(params["index"])
			var/obj/item/reagent_containers/container = SAFEINDEXACCESS(sources, index)
			if(isnull(container))
				return TRUE
			usr.grab_item_from_interacted_with(container, src)
			sources -= container
			usr.visible_action_feedback(
				target = src,
				hard_range = MESSAGE_RANGE_CONFIGURATION,
				visible_hard = SPAN_NOTICE("[usr] removes [container] from [src]."),
			)
			update_static_data()
			return TRUE
		if("produceCone")
			if(!reagents.has_reagent(/datum/reagent/nutriment/flour, cone_flour_cost))
				usr.action_feedback(SPAN_WARNING("[src] doesn't have enough flour left for a new cone."), src)
				return TRUE
			if(!give_cone(produce_cone(), usr))
				return TRUE
			usr.action_feedback(SPAN_NOTICE("You create an empty waffle cone."), src)
			return TRUE

/obj/structure/icecream_cart/proc/produce_cone(force)
	if(!force)
		if(!reagents.has_reagent(/datum/reagent/nutriment/flour, cone_flour_cost))
			return FALSE
	reagents.remove_reagent(/datum/reagent/nutriment/flour, cone_flour_cost)
	// todo: doesn't require full resend
	update_static_data()
	var/obj/item/reagent_containers/food/snacks/ice_cream/cone = new(src)
	return cone

/obj/structure/icecream_cart/proc/give_cone(obj/item/reagent_containers/food/snacks/ice_cream/cone, mob/give_to)
	if(isnull(cone))
		return FALSE
	give_to.put_in_hands_or_drop(cone, drop_loc = drop_location())
	return TRUE

/obj/structure/icecream_cart/proc/fill_cone(obj/item/reagent_containers/food/snacks/ice_cream/cone, force, mob/user)
	if(!reagents.has_reagent(/datum/reagent/drink/ice, scoop_ice_cost))
		user.action_feedback(SPAN_WARNING("There is not enough ice left in [src] to make a dollop."), src)
		return FALSE
	if(!reagents.has_reagent(/datum/reagent/drink/milk, scoop_milk_cost))
		user.action_feedback(SPAN_WARNING("There is not enough milk left in [src] to make a dollop."), src)
		return FALSE
	var/has_sugar = !reagents.has_reagent(/datum/reagent/sugar, scoop_sugar_cost)
	reagents.remove_reagent(/datum/reagent/drink/ice, scoop_ice_cost)
	reagents.remove_reagent(/datum/reagent/drink/milk, scoop_milk_cost)
	if(has_sugar)
		reagents.remove_reagent(/datum/reagent/sugar, scoop_sugar_cost)
	var/obj/item/reagent_containers/infuse_source = SAFEINDEXACCESS(sources, selected_ice_cream_source)
	cone.add_scoop(infuse_source?.reagents || /datum/reagent/drink/milk, scoop_infuse_amount, has_sugar, TRUE)
	return TRUE

/obj/structure/icecream_cart/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	// handle cones
	if(istype(I, /obj/item/reagent_containers/food/snacks/ice_cream))
		var/obj/item/reagent_containers/food/snacks/ice_cream/ice_cream = I
		if(!ice_cream.can_keep_scooping)
			user.action_feedback(SPAN_WARNING("[ice_cream] was already bitten out of!"), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(ice_cream.scoop_current >= ice_cream.scoop_max)
			user.action_feedback(SPAN_WARNING("[ice_cream] is more than topped off already!"), src)
			return CLICKCHAIN_DO_NOT_PROPAGATE
		if(!fill_cone(ice_cream, user = user))
			return CLICKCHAIN_DO_NOT_PROPAGATE
		user.visible_action_feedback(
			target = src,
			hard_range = MESSAGE_RANGE_CONSTRUCTION,
			visible_hard = SPAN_NOTICE("[user] fills \the [ice_cream] with [ice_cream.scoop_current > 1? "another" : "a"] delicious dollop of ice cream from \the [src].")
		)
		update_static_data()
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	// handle filling
	if(!istype(I, /obj/item/reagent_containers))
		// not a container
		return ..()
	var/obj/item/reagent_containers/container = I
	if(!container.reagents)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(!container.is_open_container())
		user.action_feedback(SPAN_WARNING("[container] is not an open container. Did you try removing the lid, if it has one?"), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	var/units_transferred = container.reagents.transfer_to_holder(
		target = reagents,
		reagents = list(
			/datum/reagent/nutriment/flour,
			/datum/reagent/drink/ice,
			/datum/reagent/drink/milk,
			/datum/reagent/sugar,
		),
	)
	if(!units_transferred)
		user.action_feedback(SPAN_WARNING("[container] has no valid reagents to transfer to [src]. Did you mean to insert the container as a reagent source instead? (<b>Click-drag</b>)"), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	user.visible_action_feedback(
		target = src,
		hard_range = MESSAGE_RANGE_CONFIGURATION,
		visible_hard = SPAN_NOTICE("[user] refills [src] with [container]."),
		visible_self = SPAN_NOTICE("You refill [src] with [units_transferred] units of reagents from [container]."),
	)
	// todo: this doesn't need a full data push
	update_static_data()
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/structure/icecream_cart/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	. = ..()
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return
	if(!istype(dropping, /obj/item/reagent_containers))
		return
	var/obj/item/reagent_containers/container = dropping
	if(!container.reagents)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(!container.is_open_container())
		user.action_feedback(SPAN_WARNING("[container] is not an open container. Did you try removing the lid, if it has one?"), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	if(length(sources) > max_sources)
		user.action_feedback(SPAN_WARNING("[src] already has too many containers in it. Remove one first."), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	user.visible_action_feedback(
		src,
		hard_range = MESSAGE_RANGE_CONFIGURATION,
		visible_hard = SPAN_NOTICE("[user] inserts [dropping] into one of [src]'s reagent slots."),
	)
	container.forceMove(src)
	LAZYADD(sources, container)
	update_static_data()
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/structure/icecream_cart/loaded
	var/prefill_amount = 60

/obj/structure/icecream_cart/loaded/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/ice, prefill_amount)
	reagents.add_reagent(/datum/reagent/drink/milk, prefill_amount)
	reagents.add_reagent(/datum/reagent/sugar, prefill_amount)
	reagents.add_reagent(/datum/reagent/nutriment/flour, prefill_amount)
