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
#warn obj/structure/icecream_cart
/obj/machinery/icecream_vat
	name = "icecream cart"
	desc = "Here on the galactic frontiers, even the ice-cream carts are advanced! Now with support for separated chemicals."
	icon = 'icons/modules/food/structures/ice_cream.dmi'
	icon_state = "cart"
	density = TRUE
	anchored = FALSE

	// todo: temporary, as this is unbuildable
	integrity_flags = INTEGRITY_INDESTRUCTIBLE

	/// stored cones; this is a stack, topmost is last in list.
	var/list/obj/item/reagent_containers/food/snacks/ice_cream/cones
	/// stored reagent containers to be used for drawing from
	var/list/obj/item/reagent_containers/sources

	/// selected index of reagent container to infuse waffle cones with
	var/selected_cone_infusion_source
	/// selected index of reagent container to make ice cream with
	var/selected_ice_cream_source

	/// flour cost of cone
	var/cone_flour_cost = 2
	/// max cones held
	var/cone_storage = 10
	/// how much reagents it can pack into a cone
	var/cone_infuse_amount = 2
	/// milk cost of scoop
	var/scoop_milk_cost = 2
	/// ice cost of scoop - this is mandatory
	var/scoop_ice_cost = 2
	/// how much reagents it can pack into a single scoop of ice cream
	var/scoop_infuse_amount = 3

	/// self-explanatory
	var/max_sources = 10

/obj/machinery/icecream_vat/Initialize(mapload)
	create_reagents(1000)
	. = ..()

/obj/machinery/icecream_vat/examine(mob/user, dist)
	. = ..()
	. += SPAN_NOTICE("<b>Use</b> a reagent container with an open lid on this to refill its core ingredients.")
	. += SPAN_NOTICE("<b>Click-drag</b> a reagent container with an open lid on this to add it as a mixing source.")

/obj/machinery/icecream_vat/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "IcecreamCart")
		ui.open()

/obj/machinery/icecream_vat/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["scoopSource"] = selected_ice_cream_source
	.["coneSource"] = selected_cone_infusion_source

/obj/machinery/icecream_vat/ui_static_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	.["coneFlourCost"] = cone_flour_cost
	.["coneInfuseCost"] = cone_infuse_amount
	.["scoopMilkCost"] = scoop_milk_cost
	.["scoopIceCost"] = scoop_ice_cost
	.["scoopInfuseCost"] = scoop_infuse_amount
	var/list/collect_sources = list()
	var/list/collect_base = list(
		reagents.get_reagent_amount(/datum/reagent/drink/milk),
		reagents.get_reagent_amount(/datum/reagent/nutriment/flour),
		reagents.get_reagent_amount(/datum/reagent/sugar),
		reagents.get_reagent_amount(/datum/reagent/drink/ice),
	)
	for(var/obj/item/reagent_containers/container as anything in sources)
		collect_sources[++collect_sources.len] = list(
			"name" = container.name,
			"volume" = container.reagents.total_volume,
			"maxVolume" = container.reagents.maximum_volume,
			"color" = container.reagents.get_color(),
		)
	.["baseIngredients"] = collect_base
	.["sources"] = collect_sources

/obj/machinery/icecream_vat/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("selectInfuse")
			var/index = text2num(params["index"])
			selected_cone_infusion_source = (sources && index >= 1 && index <= length(sources))? index : null
			return TRUE
		if("selectProduce")
			var/index = text2num(params["index"])
			selected_ice_cream_source = (sources && index >= 1 && index <= length(sources))? index : null
			return TRUE
		if("dispenseCone")
			#warn impl
		if("dispenseFilled")
			#warn impl
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
			#warn impl

/obj/machinery/icecream_vat/proc/produce_cone(obj/item/reagent_containers/infuse_from, force)
	if(!force)
		if(!reagents.has_reagent(/datum/reagent/nutriment/flour, cone_flour_cost))
			return FALSE
		if(LAZYLEN(cones) > cone_storage)
			return FALSE
	reagents.remove_reagent(/datum/reagent/nutriment/flour, cone_flour_cost)
	var/obj/item/reagent_containers/food/snacks/ice_cream/cone = new(src)
	LAZYADD(cones, cone)
	var/obj/item/reagent_containers/infusion_source = LAZYACCESS(sources, selected_cone_infusion_source)
	if(!isnull(infusion_source))
		infusion_source.reagents.trans_to(cone, cone_infuse_amount)
	return cone

/obj/machinery/icecream_vat/proc/fill_cone(obj/item/reagent_containers/create_from, force)
	#warn impl

/obj/machinery/icecream_vat/proc/give_cone(obj/item/reagent_containers/food/snacks/ice_cream/cone, mob/give_to)
	if(isnull(cone))
		return FALSE
	give_to.put_in_hands_or_drop(cone)
	LAZYREMOVE(cones, cone)
	return TRUE

/obj/machinery/icecream_vat/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(!istype(I, /obj/item/reagent_containers))
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
		),
	)
	if(!units_transferred)
		user.action_feedback(SPAN_WARNING("[container] has no valid reagents to transfer to [src]. Did you mean to insert the container instead? (<b>Click-drag</b>)"), src)
		return CLICKCHAIN_DO_NOT_PROPAGATE
	user.visible_action_feedback(
		target = src,
		hard_range = MESSAGE_RANGE_CONFIGURATION,
		visible_hard = SPAN_NOTICE("[user] refills [src] with [container]."),
		visible_self = SPAN_NOTICE("You refill [src] with [units_transferred] units of reagents from [container]."),
	)
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE

/obj/machinery/icecream_vat/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
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
	return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
