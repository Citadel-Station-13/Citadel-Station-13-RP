/obj/machinery/floodlight
	name = "Emergency Floodlight"
	icon = 'icons/obj/machines/floodlight.dmi'
	icon_state = "flood00"
	density = TRUE
	var/on = FALSE
	var/obj/item/cell/cell = null
	var/use = 200 // 200W light
	var/unlocked = FALSE
	var/open = FALSE
	var/brightness_on = 8		//can't remember what the maxed out value is

/obj/machinery/floodlight/Initialize(mapload)
	. = ..()
	cell = new(src)

/obj/machinery/floodlight/update_icon()
	cut_overlays()
	icon_state = "flood[open ? "o" : ""][open && cell ? "b" : ""]0[on]"

/obj/machinery/floodlight/process(delta_time)
	if(!on)
		return

	if(!cell || (cell.charge < (DYNAMIC_W_TO_CELL_UNITS(use, 1))))
		turn_off(1)
		return

	// If the cell is almost empty rarely "flicker" the light. Aesthetic only.
	if((cell.percent() < 10) && prob(5))
		set_light(brightness_on/2, brightness_on/4)
		spawn(20)
			if(on)
				set_light(brightness_on, brightness_on/2)

	cell.use(DYNAMIC_W_TO_CELL_UNITS(use, 1))

/// Returns FALSE on failure and TRUE on success.
/obj/machinery/floodlight/proc/turn_on(loud = FALSE)
	if(!cell)
		return FALSE
	if(cell.charge < (DYNAMIC_W_TO_CELL_UNITS(use, 1)))
		return FALSE

	on = TRUE
	set_light(brightness_on, brightness_on / 2)
	update_icon()
	if(loud)
		visible_message("\The [src] turns on.")
	return TRUE

/obj/machinery/floodlight/proc/turn_off(loud = FALSE)
	on = FALSE
	set_light(0, 0)
	update_icon()
	if(loud)
		visible_message("\The [src] shuts down.")

/obj/machinery/floodlight/attack_ai(mob/user)
	if(istype(user, /mob/living/silicon/robot) && Adjacent(user))
		return attack_hand(user)

	if(on)
		turn_off(TRUE)
	else
		if(!turn_on(TRUE))
			to_chat(user, "You try to turn on \the [src] but it does not work.")

/obj/machinery/floodlight/attack_hand(mob/user)
	if(open && cell)
		if(ishuman(user))
			if(!user.get_active_held_item())
				user.put_in_hands(cell)
				cell.loc = user.loc
		else
			cell.loc = src.loc

		cell.add_fingerprint(user)
		cell.update_icon()

		cell = null
		on = FALSE
		set_light(0)
		to_chat(user, "You remove the power cell")
		update_icon()
		return

	if(on)
		turn_off(TRUE)
	else
		if(!turn_on(TRUE))
			to_chat(user, "You try to turn on \the [src] but it does not work.")

	update_icon()

/obj/machinery/floodlight/attackby(obj/item/W, mob/user)
	if(W.is_screwdriver())
		if(!open)
			if(unlocked)
				unlocked = FALSE
				to_chat(user, SPAN_NOTICE("You screw the battery panel in place."))
			else
				unlocked = TRUE
				to_chat(user, SPAN_NOTICE("You unscrew the battery panel."))

	if(W.is_crowbar())
		if(unlocked)
			if(open)
				open = FALSE
				overlays = null
				to_chat(user, SPAN_NOTICE("You crowbar the battery panel in place."))
			else
				if(unlocked)
					open = TRUE
					to_chat(user, SPAN_NOTICE("You remove the battery panel."))

	if(istype(W, /obj/item/cell))
		if(open)
			if(cell)
				to_chat(user, SPAN_NOTICE("There is a power cell already installed."))
			else
				if(!user.attempt_insert_item_for_installation(W, src))
					return
				cell = W
				to_chat(user, SPAN_NOTICE("You insert the power cell."))
	update_icon()
