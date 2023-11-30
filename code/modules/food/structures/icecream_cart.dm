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
	#warn reorganize sprites
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "icecream_vat"
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

/obj/machinery/icecream_vat/Initialize(mapload)
	create_reagents(1000)
	. = ..()

/obj/machinery/icecream_vat/ui_interact(mob/user, datum/tgui/ui, datum/tgui/parent_ui)
	. = ..()

/obj/machinery/icecream_vat/ui_data(mob/user, datum/tgui/ui, datum/ui_state/state)
	. = ..()

/obj/machinery/icecream_vat/ui_act(action, list/params, datum/tgui/ui)
	. = ..()
	if(.)
		return
	switch(action)
		if("selectInfuse")
		if("selectProduce")
		if("dispenseCone")
		if("dispenseFilled")
		if("ejectSource")
		if("produceCone")

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

/obj/machinery/icecream_vat/proc/give_cone(obj/item/reagent_containers/food/snacks/ice_cream/cone, mob/give_to)
	if(isnull(cone))
		return FALSE
	give_to.put_in_hands_or_drop(cone)
	LAZYREMOVE(cones, cone)
	return TRUE

/obj/machinery/icecream_vat/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	if(user.a_intent == INTENT_HARM)
		return ..()
	#warn impl

/obj/machinery/icecream_vat/MouseDroppedOn(atom/dropping, mob/user, proximity, params)
	. = ..()
	if(. & CLICKCHAIN_DO_NOT_PROPAGATE)
		return


#warn everything below is legacy

/obj/machinery/icecream_vat

/obj/machinery/icecream_vat/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, /obj/item/reagent_containers/food/snacks/icecream))
		var/obj/item/reagent_containers/food/snacks/icecream/I = O
		if(!I.ice_creamed)
			if(product_types[dispense_flavour] > 0)
				src.visible_message("[icon2html(thing = src, target = world)] <span class='info'>[user] scoops delicious [flavour_name] icecream into [I].</span>")
				product_types[dispense_flavour] -= 1
				I.add_ice_cream(flavour_name)
			//	if(beaker)
			//		beaker.reagents.trans_to(I, 10)
				if(I.reagents.total_volume < 10)
					I.reagents.add_reagent("sugar", 10 - I.reagents.total_volume)
			else
				to_chat(user, "<span class='warning'>There is not enough icecream left!</span>")
		else
			to_chat(user, "<span class='notice'>[O] already has icecream in it.</span>")
		return 1
	else if(O.is_open_container())
		return
	else
		..()

/obj/machinery/icecream_vat/proc/make(var/mob/user, var/make_type, var/amount)
	for(var/R in get_ingredient_list(make_type))
		if(reagents.has_reagent(R, amount))
			continue
		amount = 0
		break
	if(amount)
		for(var/R in get_ingredient_list(make_type))
			reagents.remove_reagent(R, amount)
		product_types[make_type] += amount
		var/flavour = get_flavour_name(make_type)
		if(make_type > 4)
			src.visible_message("<span class='info'>[user] cooks up some [flavour] cones.</span>")
		else
			src.visible_message("<span class='info'>[user] whips up some [flavour] icecream.</span>")
	else
		to_chat(user, "<span class='warning'>You don't have the ingredients to make this.</span>")

/obj/machinery/icecream_vat/Topic(href, href_list)

	if(..())
		return

	if(href_list["select"])
		dispense_flavour = text2num(href_list["select"])
		flavour_name = get_flavour_name(dispense_flavour)
		src.visible_message("<span class='notice'>[usr] sets [src] to dispense [flavour_name] flavoured icecream.</span>")

	if(href_list["cone"])
		var/dispense_cone = text2num(href_list["cone"])
		var/cone_name = get_flavour_name(dispense_cone)
		if(product_types[dispense_cone] >= 1)
			product_types[dispense_cone] -= 1
			var/obj/item/reagent_containers/food/snacks/icecream/I = new(src.loc)
			I.cone_type = cone_name
			I.icon_state = "icecream_cone_[cone_name]"
			I.desc = "Delicious [cone_name] cone, but no ice cream."
			src.visible_message("<span class='info'>[usr] dispenses a crunchy [cone_name] cone from [src].</span>")
		else
			to_chat(usr, "<span class='warning'>There are no [cone_name] cones left!</span>")

	if(href_list["make"])
		var/amount = (text2num(href_list["amount"]))
		var/C = text2num(href_list["make"])
		make(usr, C, amount)

	if(href_list["disposeI"])
		reagents.del_reagent(href_list["disposeI"])

	updateDialog()

	if(href_list["refresh"])
		updateDialog()

	if(href_list["close"])
		usr.unset_machine()
		usr << browse(null,"window=icecreamvat")
	return

