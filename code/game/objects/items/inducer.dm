/obj/item/inducer
	name = "industrial inducer"
	desc = "A tool for inductively charging internal power cells."

	icon = 'icons/obj/item/inducer.dmi'
	icon_state = "inducer-engi"
	item_state = "inducer-engi"
	item_icons = list(
		SLOT_ID_LEFT_HAND = 'icons/obj/item/inducer.dmi',
		SLOT_ID_RIGHT_HAND = 'icons/obj/item/inducer.dmi',
	)
	item_state_slots = list(
		SLOT_ID_LEFT_HAND = "inducer_lefthand",
		SLOT_ID_RIGHT_HAND = "inducer_righthand"
	)
	damage_force = 7
	/// transfer amount per second
	var/transfer_rate = 1000
	/// type of cell to spawn
	var/cell_type = /obj/item/cell/high
	/// panel open?
	var/opened = FALSE
	/// currently inducing?
	var/inducing = FALSE
	/// inducer flags
	var/inducer_flags = INDUCER_NO_GUNS
	/// recharge distance
	var/recharge_dist = 7

/obj/item/inducer/unloaded
	cell_type = null
	opened = TRUE

/obj/item/inducer/Initialize(mapload)
	. = ..()
	var/datum/object_system/cell_slot/cell_slot = init_cell_slot(cell_type)
	cell_slot.receive_emp = TRUE
	cell_slot.receive_inducer = TRUE
	cell_slot.remove_yank_offhand = TRUE
	cell_slot.remove_yank_context = TRUE
	cell_slot.remove_yank_inhand = TRUE
	update_appearance()

/obj/item/inducer/examine(mob/user, dist)
	. = ..()
	if(!isnull(obj_cell_slot.cell))
		. += "<br><span class='notice'>Its display shows: [round(obj_cell_slot.cell.charge)] / [obj_cell_slot.cell.maxcharge].</span>"
	else
		. += "<br><span class='notice'>Its display is dark.</span>"
	if(opened)
		. += SPAN_NOTICE("Its battery compartment is open, and looks like it can be closed with a <b>screwdriver</b>")
	else
		. += SPAN_NOTICE("Its battery compartment is closed, and looks like it can be opened with a <b>screwdriver</b>")

/obj/item/inducer/afterattack(atom/target, mob/user, clickchain_flags, list/params)
	if(user.a_intent == INTENT_HARM)
		return ..()
	if(cantbeused(user))
		return
	recharge(target, user)

/obj/item/inducer/proc/cantbeused(mob/user)
	if(!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You don't have the dexterity to use [src]!</span>")
		return TRUE

	if(!obj_cell_slot.cell)
		to_chat(user, "<span class='warning'>[src] doesn't have a power cell installed!</span>")
		return TRUE

	if(!obj_cell_slot.cell.charge)
		to_chat(user, "<span class='warning'>[src]'s battery is dead!</span>")
		return TRUE
	return FALSE

/obj/item/inducer/attackby(obj/item/W, mob/user)
	if(W.is_screwdriver())
		playsound(src, W.tool_sound, 50, 1)
		if(!opened)
			to_chat(user, "<span class='notice'>You open the battery compartment.</span>")
			opened = TRUE
			update_icon()
			return
		else
			to_chat(user, "<span class='notice'>You close the battery compartment.</span>")
			opened = FALSE
			update_icon()
			return

	return ..()

/obj/item/inducer/proc/recharge(atom/movable/A, mob/user)
	if(inducing)
		return FALSE
	if(!isturf(A) && user.loc == A)
		return FALSE
	if(get_dist(user, A) > recharge_dist)
		to_chat(user, "<span class='warning'>[src] can't reach that far!</span>")
		return FALSE
	var/list/targets = list()
	var/result = A._inducer_scan(src, targets, inducer_flags)
	if(result == INDUCER_SCAN_BLOCK || (result == INDUCER_SCAN_NORMAL && !length(targets)))
		to_chat(user, SPAN_WARNING("Unable to interface with device."))
		return FALSE
	else if(result == INDUCER_SCAN_INTERFERE)
		to_chat(user, SPAN_WARNING("Device interference detected; Aborting."))
		return FALSE
	else if(result == INDUCER_SCAN_FULL)
		to_chat(user, SPAN_NOTICE("[A] is already fully charged!"))
		return FALSE
	if(!targets.len)
		CRASH("Empty targets list")

	// enter recharge loop
	inducing = TRUE

	var/used = 0

	user.visible_message(SPAN_NOTICE("[user] starts recharging [A] with [src]."), SPAN_NOTICE("You start recharging [A] with [src]."))
	A.add_filter("inducer_outline", 1, outline_filter(1, "#22aaFF"))

	var/datum/beam/charge_beam = user.Beam(A, icon_state = "rped_upgrade", time = 20 SECONDS)
	var/datum/effect_system/spark_spread/spark_system = new
	spark_system.set_up(5, 0, get_turf(A))
	spark_system.attach(A)

	while(targets.len && !QDELETED(A))
		var/datum/current = targets[1]
		targets.Cut(1, 2)

		while(!QDELETED(A) && do_after(user, 2 SECONDS, A, DO_AFTER_IGNORE_MOVEMENT, max_distance = recharge_dist) && !QDELETED(obj_cell_slot.cell))
			var/amount = min(obj_cell_slot.cell.charge, transfer_rate * 2)	// transfer rate is per second, we do this every 2 seconds
			var/charged = current.inducer_act(src, amount, inducer_flags)
			spark_system.start()
			if(charged == INDUCER_ACT_CONTINUE)
				continue
			if(charged == INDUCER_ACT_STOP)
				break
			if(charged <= 0)
				break
			obj_cell_slot.cell.use(charged)
			used += charged

	qdel(spark_system)
	qdel(charge_beam)
	A.remove_filter("inducer_outline")
	inducing = FALSE
	user.visible_message(SPAN_NOTICE("[user] recharged [A]."), SPAN_NOTICE("Rechraged [A] with [used] units of power."))

/obj/item/inducer/object_cell_slot_removed(obj/item/cell/cell, datum/object_system/cell_slot/slot)
	. = ..()
	update_icon()

/obj/item/inducer/object_cell_slot_inserted(obj/item/cell/cell, datum/object_system/cell_slot/slot)
	. = ..()
	update_icon()

/obj/item/inducer/object_cell_slot_mutable(mob/user, datum/object_system/cell_slot/slot)
	return opened && ..()

/obj/item/inducer/update_icon()
	..()
	cut_overlays()
	if(opened)
		if(isnull(obj_cell_slot.cell))
			add_overlay("inducer-nobat")
		else
			add_overlay("inducer-bat")

//////// Variants
/obj/item/inducer/sci
	name = "inducer"
	desc = "A tool for inductively charging internal power cells. This one has a science color scheme, and is less potent than its engineering counterpart."
	icon_state = "inducer-sci"
	item_state = "inducer-sci"
	cell_type = null
	transfer_rate = 500
	opened = TRUE

/obj/item/inducer/syndicate
	name = "suspicious inducer"
	desc = "A tool for inductively charging internal power cells. This one has a suspicious colour scheme, and seems to be rigged to transfer charge at a much faster rate."
	icon_state = "inducer-syndi"
	item_state = "inducer-syndi"
	transfer_rate = 2000
	cell_type = /obj/item/cell/super
	inducer_flags = NONE

/*
/obj/item/inducer/hybrid
	name = "hybrid-tech inducer"
	desc = "A tool for inductively charging internal power cells. This one has some flashy bits and recharges devices slower, but seems to recharge itself between uses."
	icon_state = "inducer-hybrid"
	item_state = "inducer-hybrid"
	transfer_rate = 125
	cell_type = /obj/item/cell/void
	inducer_flags = NONE
*/

/atom/proc/_inducer_scan(obj/item/inducer/I, list/things_to_induce = list(), inducer_flags)
	SHOULD_NOT_OVERRIDE(TRUE)
	. = inducer_scan(I, things_to_induce, inducer_flags)
	var/signal = SEND_SIGNAL(src, COMSIG_INDUCER_SCAN, I, things_to_induce, inducer_flags)
	if((signal & COMPONENT_BLOCK_INDUCER) || . == INDUCER_SCAN_BLOCK)
		return INDUCER_SCAN_BLOCK
	else if((signal & COMPONENT_INTERFERE_INDUCER) || . == INDUCER_SCAN_INTERFERE)
		return INDUCER_SCAN_INTERFERE
	else if((signal & COMPONENT_FULL_INDUCER) && . == INDUCER_SCAN_FULL)
		return INDUCER_SCAN_FULL
	else
		return INDUCER_SCAN_NORMAL

/**
 * even if full, always add things, or the inducer might think we don't support induction when we do!
 */
/atom/proc/inducer_scan(obj/item/inducer/I, list/things_to_induce = list(), inducer_flags)
	var/obj/item/cell/C = get_cell(TRUE)
	if(C)
		things_to_induce += C
		if(C.charge >= C.maxcharge)
			return INDUCER_SCAN_FULL

/**
 * returns amount used - this is a datum proc so components can use it with only one signal necessary
 *
 * do NOT used this on components to take charge, put the component/signal registered in inducer scan!
 */
/datum/proc/inducer_act(obj/item/inducer/I, amount, inducer_flags)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(I, COMSIG_INDUCER_ACT, amount, inducer_flags)
	return 0

/atom/inducer_act(obj/item/inducer/I, amount, inducer_flags)
	. = ..()
	var/obj/item/cell/C = get_cell()
	if(C)
		var/use = clamp(C.maxcharge - C.charge, 0, amount)
		C.give(use)
		return use
	else
		return 0
