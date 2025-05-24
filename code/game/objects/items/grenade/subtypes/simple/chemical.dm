/obj/item/grenade/simple/chemical
	name = "grenade casing"
	desc = "A hand made chemical grenade."
	icon = 'icons/items/grenade/chemical.dmi'
	icon_state = "grenade"
	base_icon_state = "grenade"
	inhand_state = "grenade"
	worn_render_flags = NONE
	w_class = WEIGHT_CLASS_SMALL

	detonation_sound = 'sound/effects/bamf.ogg'
	activation_state_append = "-primed"

	/// secured?
	/// * once secured, things cannot be put in / taken out
	/// * must be secured to activate
	var/secured = FALSE
	/// wired?
	/// * all grenades must be wired
	/// * wired grenades can be readied without a detonator for default timing logic
	var/wired = FALSE
	/// allowed number of reagent containers
	var/beakers_max = 2
	/// reagent containers
	/// * all of these will be mixed inside us; technically they don't have to be beakers.
	var/list/atom/movable/beakers = list()

	// todo: legacy, assembly holders need a refactor and are shitcode
	var/obj/item/assembly_holder/detonator
	// todo: legacy, have a proper class system like magazines do
	var/list/allowed_containers = list(
		/obj/item/reagent_containers/glass/beaker,
		/obj/item/reagent_containers/glass/bottle,
	)
	// todo: legacy, do it based on amount
	var/affected_area = 3
	// todo: need a starts with system as we don't want /chemical/large/premade vs /chemical/premade so
	//       starting with beakers logic needs to be on base /chemical

/obj/item/grenade/simple/chemical/Destroy()
	QDEL_NULL(detonator)
	QDEL_LIST_NULL(beakers)
	return ..()

/obj/item/grenade/simple/chemical/examine(mob/user, dist)
	. = ..()
	if(detonator)
		. += SPAN_NOTICE("It has a [detonator] attached to its assembly.")
	if(secured)
		. += SPAN_NOTICE("This one is secured. Open its panel with a screwdriver to access the internals.")
		return
	if(wired)
		. += SPAN_NOTICE("It's wired and ready for assembly.")
	else
		. += SPAN_WARNING("It's missing a detonation mechanism. Use some wires to fix that.")
	. += SPAN_NOTICE("It has [length(beakers)] containers inserted, with room for [beakers_max - length(beakers)] more.")

/obj/item/grenade/simple/chemical/update_icon_state()
	icon_state = "[base_icon_state || initial(icon_state)][wired ? (secured ? "-locked" : "-wired") : ""]"
	return ..()

/obj/item/grenade/simple/chemical/update_name()
	name = "[secured ? "" : "unsecured "]grenade"
	return ..()

/obj/item/grenade/simple/chemical/should_simple_delay_adjust(datum/event_args/actor/actor)
	return secured && ..()

/obj/item/grenade/simple/chemical/context_menu_query(datum/event_args/actor/e_args)
	. = ..()
	if(!detonator && !activated)
		.["adjust-fuse"] = create_context_menu_tuple(
			name = "adjust fuse",
			I = dyntool_image_neutral(TOOL_SCREWDRIVER),
			mobility = MOBILITY_CAN_USE,
		)
	if(secured)
		.["unlock-assembly"] = create_context_menu_tuple(
			name = "unlock grenade",
			I = image(
				/obj/item/tool/screwdriver::icon,
				/obj/item/tool/screwdriver::icon_state,
			),
			mobility = MOBILITY_CAN_USE,
		)

/obj/item/grenade/simple/chemical/context_menu_act(datum/event_args/actor/e_args, key)
	. = ..()
	if(.)
		return
	switch(key)
		if("adjust-fuse")
			if(activated)
				return TRUE
			do_simple_delay_adjust(e_args)
			return TRUE
		if("unlock-assembly")
			if(!secured)
				return TRUE
			if(!use_screwdriver(e_args.performer.get_active_held_item(), e_args, NONE, 0))
				e_args?.chat_feedback(
					SPAN_WARNING("You must be holding a screwdriver in your active hand to unsecure [src]."),
					target = src,
				)
				return TRUE
			secured = FALSE
			e_args?.visible_feedback(
				target = src,
				visible = SPAN_NOTICE("[e_args.performer] [secured ? "secures" : "unsecures"] the cover of [src]."),
				otherwise_self = SPAN_NOTICE("You [secured ? "secure" : "unsecure"] [src]'s cover."),
				audible = SPAN_NOTICE("You hear something being [secured ? "fastened" : "unfastened"]."),
				range = MESSAGE_RANGE_ITEM_SOFT,
			)
			update_appearance()
			return TRUE

/obj/item/grenade/simple/chemical/on_activate_inhand(datum/event_args/actor/actor)
	if(!is_ready_to_activate())
		return FALSE
	if(detonator)
		detonator.attack_self(actor.performer, actor)
		return TRUE
	if(!wired)
		actor?.chat_feedback(
			SPAN_WARNING("You press the activation mechanism of [src], but nothing happens."),
			target = src,
		)
		return TRUE
	return ..()

/obj/item/grenade/simple/chemical/activate(datum/event_args/actor/actor)
	if(!is_ready_to_activate())
		return FALSE
	if(!wired)
		return FALSE
	return ..()

/obj/item/grenade/simple/chemical/proc/is_ready_to_activate()
	return secured

/obj/item/grenade/simple/chemical/on_attack_hand(datum/event_args/actor/clickchain/e_args)
	if(secured)
		return ..()
	if(!e_args.performer.is_holding_inactive(src))
		return ..()
	if(detonator)
		e_args.performer.grab_item_from_interacted_with(detonator, src)
		e_args.chat_feedback(SPAN_NOTICE("You remove [detonator] from [src]."), src)
		detonator = null
		return CLICKCHAIN_DID_SOMETHING
	else if(length(beakers))
		var/obj/item/removed
		for(var/obj/item/removable in beakers)
			removed = removable
			break
		if(!removed)
			e_args.chat_feedback(SPAN_WARNING("There's no removable reagent container in [src]."), target = src)
			return CLICKCHAIN_DID_SOMETHING
		e_args.performer.grab_item_from_interacted_with(removed, src)
		e_args.chat_feedback(SPAN_NOTICE("You remove [removed] from [src]."), src)
		return CLICKCHAIN_DID_SOMETHING
	else
		e_args.chat_feedback(SPAN_WARNING("[src] is empty."), target = src)
		return CLICKCHAIN_DID_SOMETHING

/obj/item/grenade/simple/chemical/using_item_on(obj/item/using, datum/event_args/actor/clickchain/e_args, clickchain_flags, datum/callback/reachability_check)
	. = ..()
	if(.)
		return
	if(istype(using, /obj/item/stack/cable_coil))
		if(activated)
			e_args.chat_feedback(
				SPAN_WARNING("[src] is already primed! Are you crazy?"),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		if(wired)
			e_args.chat_feedback(
				SPAN_WARNING("[src] is already wired."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		if(secured)
			e_args.chat_feedback(
				SPAN_WARNING("You can't do anything to [src] while it's secured."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		var/obj/item/stack/cable_coil/casted_coil = using
		if(!casted_coil.use(5))
			e_args.chat_feedback(
				SPAN_WARNING("[casted_coil] doesn't have enough cable. (need 5)"),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		wired = TRUE
		e_args.chat_feedback(
			SPAN_NOTICE("You wire [src]."),
			target = src,
		)
		// TODO: logging
		update_appearance()
		return CLICKCHAIN_DID_SOMETHING
	if(istype(using, /obj/item/assembly_holder))
		if(activated)
			e_args.chat_feedback(
				SPAN_WARNING("[src] is already primed! Are you crazy?"),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		if(detonator)
			e_args.chat_feedback(
				SPAN_WARNING("[src] already has a detonator assembly attached."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		if(secured)
			e_args.chat_feedback(
				SPAN_WARNING("You can't do anything to [src] while it's secured."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		var/obj/item/assembly_holder/casted_assembly_holder = using
		if(!casted_assembly_holder.secured)
			e_args.chat_feedback(
				SPAN_WARNING("[casted_assembly_holder] must be secured before insertion."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		if(!e_args.performer.attempt_insert_item_for_installation(using, src))
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		detonator = using
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_ITEM_SOFT,
			visible = SPAN_WARNING("[e_args.performer] slots [using] into [src]'s casing, wiring it up to the detonation mechanism."),
			audible = SPAN_WARNING("You hear something being slotted in."),
			otherwise_self = SPAN_WARNING("You insert [using] into [src] and wire it into the detonation mechanism."),
		)
		playsound(src, 'sound/items/Screwdriver2.ogg', 25, TRUE, -3)
		// TODO: logging
		update_appearance()
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
	if(is_type_in_list(using, allowed_containers))
		if(activated)
			e_args.chat_feedback(
				SPAN_WARNING("[src] is already primed! Are you crazy?"),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		if(secured)
			e_args.chat_feedback(
				SPAN_WARNING("You can't do anything to [src] while it's secured."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		if(length(beakers) > beakers_max)
			e_args.chat_feedback(
				SPAN_WARNING("[src] cannot hold more reagent containers."),
				target = src,
			)
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		if(!e_args.performer.attempt_insert_item_for_installation(using, src))
			return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING
		e_args.visible_feedback(
			target = src,
			range = MESSAGE_RANGE_ITEM_SOFT,
			visible = SPAN_WARNING("[e_args.performer] inserts [using] into [src]."),
			audible = SPAN_WARNING("You hear something being slotted in."),
			otherwise_self = SPAN_WARNING("You insert [using] into [src]."),
		)
		beakers += using
		playsound(src, 'sound/items/Screwdriver2.ogg', 25, TRUE, -3)
		// TODO: logging
		update_appearance()
		return CLICKCHAIN_DO_NOT_PROPAGATE | CLICKCHAIN_DID_SOMETHING

/obj/item/grenade/simple/chemical/screwdriver_act(obj/item/I, datum/event_args/actor/clickchain/e_args, flags, hint)
	. = ..()
	if(.)
		return
	. = TRUE
	if(activated)
		e_args?.chat_feedback(
			SPAN_WARNING("[src] is already primed! Are you crazy?"),
			target = src,
		)
		return
	if(!use_screwdriver(I, e_args, flags, 0))
		return
	secured = !secured
	e_args?.visible_feedback(
		target = src,
		visible = SPAN_NOTICE("[e_args.performer] [secured ? "secures" : "unsecures"] the cover of [src]."),
		otherwise_self = SPAN_NOTICE("You [secured ? "secure" : "unsecure"] [src]'s cover."),
		audible = SPAN_NOTICE("You hear something being [secured ? "fastened" : "unfastened"]."),
		range = MESSAGE_RANGE_ITEM_SOFT,
	)
	update_appearance()

/obj/item/grenade/simple/chemical/on_detonate(turf/location, atom/grenade_location)
	..()
	// what could go wrong?
	create_reagents(1000000)
	load_reaction_chamber_with_ratio_of_maximum(1)
	if(reagents.total_volume)
		var/datum/effect_system/steam_spread/steam = new /datum/effect_system/steam_spread()
		steam.set_up(10, 0, get_turf(src))
		steam.attach(src)
		steam.start()

		for(var/turf/spraying_turf in view(affected_area, get_turf(src)))
			reagents.perform_uniform_contact(spraying_turf, 1)
/**
 * Ratio is of total beaker. 0.2 of a 100 unit will pull 20u of a total volume of 30,
 * even if you'd expect it to pull 6.
 */
/obj/item/grenade/simple/chemical/proc/load_reaction_chamber_with_ratio_of_maximum(ratio)
	for(var/atom/movable/pull_from as anything in beakers)
		if(!pull_from.reagents)
			continue
		pull_from.reagents.transfer_to_holder(reagents, amount = pull_from.reagents.maximum_volume * ratio)

/obj/item/grenade/simple/chemical/large
	name = "large chem grenade"
	desc = "An oversized grenade that affects a larger area."
	icon_state = "grenade-large"
	base_icon_state = "grenade-large"
	allowed_containers = list(/obj/item/reagent_containers/glass)
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3)
	affected_area = 4

//* presets below *//

/obj/item/grenade/simple/chemical/premade
	icon_state = "grenade-locked"
	secured = TRUE
	wired = TRUE

/obj/item/grenade/simple/chemical/premade/metalfoam
	name = "metal-foam grenade"
	desc = "Used for emergency sealing of air breaches."

/obj/item/grenade/simple/chemical/premade/metalfoam/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("aluminum", 30)
	B2.reagents.add_reagent("foaming_agent", 10)
	B2.reagents.add_reagent("pacid", 10)

	beakers += B1
	beakers += B2

/obj/item/grenade/simple/chemical/premade/incendiary
	name = "incendiary grenade"
	desc = "Used for clearing rooms of living things."
	worth_intrinsic = 150

/obj/item/grenade/simple/chemical/premade/incendiary/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("aluminum", 15)
	B1.reagents.add_reagent("fuel",20)
	B2.reagents.add_reagent("phoron", 15)
	B2.reagents.add_reagent("sacid", 15)
	B1.reagents.add_reagent("fuel",20)

	beakers += B1
	beakers += B2

/obj/item/grenade/simple/chemical/premade/antiweed
	name = "weedkiller grenade"
	desc = "Used for purging large areas of invasive plant species. Contents under pressure. Do not directly inhale contents."

/obj/item/grenade/simple/chemical/premade/antiweed/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("plantbgone", 25)
	B1.reagents.add_reagent("potassium", 25)
	B2.reagents.add_reagent("phosphorus", 25)
	B2.reagents.add_reagent("sugar", 25)

	beakers += B1
	beakers += B2
	icon_state = "grenade"

/obj/item/grenade/simple/chemical/premade/cleaner
	name = "cleaner grenade"
	desc = "BLAM!-brand foaming space cleaner. In a special applicator for rapid cleaning of wide areas."

/obj/item/grenade/simple/chemical/premade/cleaner/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("fluorosurfactant", 40)
	B2.reagents.add_reagent("water", 40)
	B2.reagents.add_reagent("cleaner", 10)

	beakers += B1
	beakers += B2

/obj/item/grenade/simple/chemical/premade/teargas
	name = "tear gas grenade"
	desc = "Concentrated Capsaicin. Contents under pressure. Use with caution."

/obj/item/grenade/simple/chemical/premade/teargas/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent("phosphorus", 40)
	B1.reagents.add_reagent("potassium", 40)
	B1.reagents.add_reagent("condensedcapsaicin", 40)
	B2.reagents.add_reagent("sugar", 40)
	B2.reagents.add_reagent("condensedcapsaicin", 80)

	beakers += B1
	beakers += B2

/obj/item/grenade/simple/chemical/premade/holy
	name = "PARA disruptor grenade"
	desc = "These modified PMD grenades utilize a similar formula to the standard cleaning grenade, with one important substitution: holy water."

/obj/item/grenade/simple/chemical/premade/holy/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("fluorosurfactant", 30)
	B1.reagents.add_reagent("cleaner", 30)
	B2.reagents.add_reagent("water", 30)
	B2.reagents.add_reagent("holywater", 30)

	beakers += B1
	beakers += B2

/obj/item/grenade/simple/chemical/premade/lube
	name = "lubricant grenade"
	desc = "Originally exported from Columbina, the popularity of this gag item quickly faded."

/obj/item/grenade/simple/chemical/premade/lube/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("fluorosurfactant", 40)
	B2.reagents.add_reagent("lube", 10)
	B2.reagents.add_reagent("water", 40)

	beakers += B1
	beakers += B2

/obj/item/grenade/simple/chemical/premade/lube_tactical
	name = "tactical lubricant grenade"
	desc = "Utilized by Cloumbina Commandos, this variant of the lubricant grenade delivers a more focused payload."

/obj/item/grenade/simple/chemical/premade/lube_tactical/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent("fluorosurfactant", 40)
	B2.reagents.add_reagent("lube", 40)
	B2.reagents.add_reagent("water", 10)

	beakers += B1
	beakers += B2

/obj/item/grenade/simple/chemical/premade/chlorine_gas
	name = "chlorine gas grenade"
	desc = "Chlorine is a powerful corrosive. When deployed in gas form it may often be used for area denial or clearing trenches."

/obj/item/grenade/simple/chemical/premade/chlorine_gas/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/large/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/large/B2 = new(src)

	B1.reagents.add_reagent("phosphorus", 40)
	B1.reagents.add_reagent("chlorine", 80)
	B2.reagents.add_reagent("potassium", 40)
	B2.reagents.add_reagent("sugar", 40)

	beakers += B1
	beakers += B2

//Nanite Cloud Warcrimes!!!

/obj/item/grenade/simple/chemical/premade/nanite_shredder
	name = "shredder nanite grenade"
	desc = "Weaponized nanites are banned by all galactic major powers. On the frontier however there is little authority to stop wannabee \
	Oppenheimers from making weapons such as this."

/obj/item/grenade/simple/chemical/premade/nanite_shredder/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/phosphorus, 30)
	B1.reagents.add_reagent(/datum/reagent/nanite/shredding, 30)
	B2.reagents.add_reagent(/datum/reagent/potassium, 30)
	B2.reagents.add_reagent(/datum/reagent/sugar, 30)

	beakers += B1
	beakers += B2

/obj/item/grenade/simple/chemical/premade/nanite_neurophage
	name = "neurophage nanite grenade"
	desc = "Weaponized nanites are banned by all galactic major powers. On the frontier however there is little authority to stop wannabee \
	Oppenheimers and other mad scientists from making weapons such as this."

/obj/item/grenade/simple/chemical/premade/nanite_neurophage/Initialize(mapload)
	. = ..()
	var/obj/item/reagent_containers/glass/beaker/B1 = new(src)
	var/obj/item/reagent_containers/glass/beaker/B2 = new(src)

	B1.reagents.add_reagent(/datum/reagent/phosphorus, 30)
	B1.reagents.add_reagent(/datum/reagent/nanite/neurophage, 30)
	B2.reagents.add_reagent(/datum/reagent/potassium, 30)
	B2.reagents.add_reagent(/datum/reagent/sugar, 30)

	beakers += B1
	beakers += B2
