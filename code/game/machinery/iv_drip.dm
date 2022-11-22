#define IV_TAKING 0
#define IV_INJECTING 1

#define MIN_IV_TRANSFER_RATE 0.1
#define MAX_IV_TRANSFER_RATE 5


/// Universal IV that can drain blood or feed reagents over a period of time from or to a replaceable container.
/obj/machinery/iv_drip
	name = "\improper IV drip"
	icon = 'icons/obj/medical/iv_drip.dmi'
	icon_state = "iv_drip"
	base_icon_state = "iv_drip"
	anchored = FALSE
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	use_power = USE_POWER_OFF
	pass_flags_self = ATOM_PASS_TABLE | ATOM_PASS_OVERHEAD_THROW

	/// Who are we sticking our needle in?
	var/mob/living/carbon/attached
	/// Are we donating or injecting?
	var/mode = IV_INJECTING
	/// Whether we feed slower.
	var/transfer_rate = MAX_IV_TRANSFER_RATE
	/// Internal beaker.
	var/obj/item/reagent_container = null
	///Typecache of containers we accept
	var/static/list/drip_containers = typecacheof(list(
		/obj/item/reagent_containers/blood,
	))
	/// If the blood draining tab should be greyed out.
	///! Not Used.
	var/inject_only = FALSE

/obj/machinery/iv_drip/Initialize(mapload)
	. = ..()
	update_appearance()
	// if(use_internal_storage)
	// 	create_reagents(100, TRANSPARENT)
	interaction_flags_machine |= INTERACT_MACHINE_OFFLINE

/obj/machinery/iv_drip/Destroy()
	attached = null
	QDEL_NULL(reagent_container)
	return ..()

/obj/machinery/iv_drip/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "IVDrip", name)
		ui.open()

/obj/machinery/iv_drip/ui_data(mob/user)
	var/list/data = list()
	data["transferRate"] = transfer_rate
	data["maxInjectRate"] = MAX_IV_TRANSFER_RATE
	data["minInjectRate"] = MIN_IV_TRANSFER_RATE
	data["mode"] = mode == IV_INJECTING ? TRUE : FALSE
	data["connected"] = attached ? TRUE : FALSE
	data["beakerAttached"] = reagent_container ? TRUE : FALSE
	// data["useInternalStorage"] = use_internal_storage
	return data

/obj/machinery/iv_drip/ui_act(action, params)
	. = ..()
	if(.)
		return
	switch(action)
		if("changeMode")
			toggle_mode()
			. = TRUE
		if("eject")
			eject_beaker()
			. = TRUE
		if("changeRate")
			var/target_rate = params["rate"]
			if(text2num(target_rate) != null)
				target_rate = text2num(target_rate)
				transfer_rate = round(clamp(target_rate, MIN_IV_TRANSFER_RATE, MAX_IV_TRANSFER_RATE), 0.1)
				. = TRUE
	update_appearance()

/obj/machinery/iv_drip/update_icon_state()
	if(attached)
		icon_state = "[base_icon_state]_[mode ? "injecting" : "donating"]"
	else
		icon_state = "[base_icon_state]_[mode ? "injectidle" : "donateidle"]"
	return ..()

/obj/machinery/iv_drip/update_overlays()
	. = ..()

	if(!reagent_container)
		return

	. += attached ? "beakeractive" : "beakeridle"
	var/datum/reagents/target_reagents = get_reagent_holder()
	if(!target_reagents)
		return

	var/mutable_appearance/filling_overlay = mutable_appearance('icons/obj/medical/iv_drip.dmi', "reagent")
	var/percent = round((target_reagents.total_volume / target_reagents.maximum_volume) * 100)
	switch(percent)
		if(0 to 9)
			filling_overlay.icon_state = "reagent0"
		if(10 to 24)
			filling_overlay.icon_state = "reagent10"
		if(25 to 49)
			filling_overlay.icon_state = "reagent25"
		if(50 to 74)
			filling_overlay.icon_state = "reagent50"
		if(75 to 79)
			filling_overlay.icon_state = "reagent75"
		if(80 to 90)
			filling_overlay.icon_state = "reagent80"
		if(91 to INFINITY)
			filling_overlay.icon_state = "reagent100"

	filling_overlay.color = mix_color_from_reagents(target_reagents.reagent_list)
	. += filling_overlay

/obj/machinery/iv_drip/OnMouseDropLegacy(mob/living/target)
	. = ..()
	if(!ishuman(usr) || !usr.canUseTopic(src, be_close = TRUE) || !isliving(target))
		return

	if(attached)
		visible_message(SPAN_WARNING("[attached] is detached from [src]."))
		attached = null
		update_appearance()
		return

	if(!target.has_dna())
		to_chat(usr, SPAN_DANGER("The drip beeps: Warning, incompatible creature!"))
		return

	if(Adjacent(target) && usr.Adjacent(target))
		if(get_reagent_holder())
			attach_iv(target, usr)
		else
			to_chat(usr, SPAN_WARNING("There's nothing attached to the IV drip!"))

/obj/machinery/iv_drip/attackby(obj/item/W, mob/user, params)
	// if(use_internal_storage)
	// 	return ..()

	if(is_type_in_typecache(W, drip_containers))
		if(reagent_container)
			to_chat(user, SPAN_WARNING("[reagent_container] is already loaded on [src]!"))
			return
		if(!user.attempt_insert_item_for_installation(W, src))
			return
		reagent_container = W
		to_chat(user, SPAN_NOTICE("You attach [W] to [src]."))
		// user.log_message("attached a [W] to [src] at [AREACOORD(src)] containing ([reagent_container.reagents.get_reagent_log_string()])", LOG_ATTACK)
		add_fingerprint(user)
		update_appearance()
		return

	if(W.is_screwdriver())
		playsound(src, W.tool_sound, 50, TRUE)
		to_chat(user, SPAN_NOTICE("You start to dismantle the IV drip."))
		if(do_after(user, 15))
			to_chat(user, SPAN_NOTICE("You dismantle the IV drip."))
			var/obj/item/stack/rods/A = new /obj/item/stack/rods(src.loc)
			A.amount = 6
			if(reagent_container)
				reagent_container.loc = get_turf(src)
				reagent_container = null
			qdel(src)
		return
	else
		return ..()

/obj/machinery/iv_drip/attack_hand(mob/user)
	if(reagent_container)
		reagent_container.loc = get_turf(src)
		reagent_container = null
		update_appearance()
	else
		return ..()

/obj/machinery/iv_drip/process(delta_time)
	if(!attached)
		return PROCESS_KILL

	if(!(get_dist(src, attached) <= 1 && isturf(attached.loc)))
		to_chat(attached, SPAN_USERDANGER("The IV drip needle is ripped out of you, leaving an open bleeding wound!"))
		var/list/arm_zones = shuffle(list(BP_R_ARM, BP_L_ARM))
		var/obj/item/organ/external/chosen_limb = attached.get_organ(arm_zones[1]) || attached.get_organ(arm_zones[2]) || attached.get_organ(BP_TORSO)
		chosen_limb.take_damage(3)
		chosen_limb.createwound(CUT, 5)
		detach_iv()
		return PROCESS_KILL

	var/datum/reagents/target_reagents = get_reagent_holder()
	if(target_reagents)
		// Give blood
		if(mode)
			if(target_reagents.total_volume)
				var/real_transfer_amount = transfer_rate
				if(istype(reagent_container, /obj/item/reagent_containers/blood))
					// speed up transfer on blood packs
					real_transfer_amount *= 2
				target_reagents.trans_to_mob(attached, real_transfer_amount * delta_time * 0.5, type = CHEM_BLOOD)
				update_appearance()

		// Take blood
		else
			var/amount = target_reagents.maximum_volume - target_reagents.total_volume
			amount = min(amount, 4) * delta_time * 0.5
			// If the beaker is full, ping
			if(!amount)
				if(prob(5))
					visible_message(SPAN_HEAR("[src] pings."))
				return

			// If the human is losing too much blood, beep.
			if(attached.species.blood_volume < BLOOD_VOLUME_SAFE && prob(5))
				visible_message(SPAN_HEAR("[src] beeps loudly."))
				playsound(loc, 'sound/machines/twobeep_high.ogg', 50, TRUE)
			// var/atom/movable/target = use_internal_storage ? src : reagent_container
			var/atom/movable/target = reagent_container
			attached.inject_blood(target, amount)
			update_appearance()

/// called when an IV is attached.
/obj/machinery/iv_drip/proc/attach_iv(mob/living/target, mob/user)
	user.visible_message(
		SPAN_WARNING("[usr] begins attaching [src] to [target]..."),
		SPAN_WARNING("You begin attaching [src] to [target]."),
	)
	if(!do_after(usr, 1 SECONDS, target))
		return
	usr.visible_message(
		SPAN_WARNING("[usr] attaches [src] to [target]."),
		SPAN_NOTICE("You attach [src] to [target]."),
	)
	// var/datum/reagents/container = get_reagent_holder()
	// log_combat(usr, target, "attached", src, "containing: ([container.get_reagent_log_string()])")
	add_fingerprint(usr)
	attached = target
	// START_PROCESSING(SSmachines, src)
	update_appearance()

	//! Plumbing Signal
	// SEND_SIGNAL(src, COMSIG_IV_ATTACH, target)

/**
 * Called when an iv is detached.
 * doesn't include chat stuff because there's multiple options and its better handled by the caller.
 */
/obj/machinery/iv_drip/proc/detach_iv()
	//! Plumbing Signal
	// SEND_SIGNAL(src, COMSIG_IV_DETACH, attached)

	attached = null
	update_appearance()

/obj/machinery/iv_drip/proc/get_reagent_holder()
	// return use_internal_storage ? reagents : reagent_container?.reagents
	return reagent_container?.reagents

/obj/machinery/iv_drip/verb/eject_beaker()
	set category = "Object"
	set name = "Remove IV Container"
	set src in view(1)

	if(!isliving(usr))
		to_chat(usr, SPAN_WARNING("You can't do that!"))
		return
	if (!usr.canUseTopic())
		return
	if(usr.incapacitated())
		return
	if(reagent_container)
		if(attached)
			visible_message(SPAN_WARNING("[attached] is detached from [src]."))
			detach_iv()
		reagent_container.forceMove(drop_location())
		reagent_container = null
		update_appearance()

/obj/machinery/iv_drip/verb/toggle_mode()
	set category = "Object"
	set name = "Toggle Mode"
	set src in view(1)

	if(!isliving(usr))
		to_chat(usr, SPAN_WARNING("You can't do that!"))
		return
	if (!usr.canUseTopic())
		return
	if(usr.incapacitated())
		return
	mode = !mode
	to_chat(usr, SPAN_NOTICE("The IV drip is now [mode ? "injecting" : "taking blood"]."))
	update_appearance()

/obj/machinery/iv_drip/examine(mob/user)
	. = ..()
	if(get_dist(user, src) > 2)
		return

	. += "[src] is [mode ? "injecting" : "taking blood"]."

	if(reagent_container)
		if(reagent_container.reagents && reagent_container.reagents.reagent_list.len)
			. += SPAN_NOTICE("Attached is \a [reagent_container] with [reagent_container.reagents.total_volume] units of liquid.")
		else
			. += SPAN_NOTICE("Attached is an empty [reagent_container.name].")
	// else if(use_internal_storage)
	// 	. += SPAN_NOTICE("It has an internal chemical storage.")
	// else
		. += SPAN_NOTICE("No chemicals are attached.")

	. += SPAN_NOTICE("[attached ? attached : "No one"] is attached.")
/*
/obj/machinery/iv_drip/saline
	name = "saline drip"
	desc = "An all-you-can-drip saline canister designed to supply a hospital without running out, with a scary looking pump rigged to inject saline into containers, but filling people directly might be a bad idea."
	icon_state = "saline"
	base_icon_state = "saline"
	density = TRUE
	inject_only = TRUE

/obj/machinery/iv_drip/saline/Initialize(mapload)
	AddElement(/datum/element/update_icon_blocker)
	. = ..()
	reagent_container = new /obj/item/reagent_containers/cup/saline(src)

/obj/machinery/iv_drip/saline/eject_beaker()
	return

/obj/machinery/iv_drip/saline/toggle_mode()
	return
*/
