/obj/machinery/conveyor_switch

	name = "conveyor switch"
	desc = "A conveyor control switch."
	icon = 'icons/obj/recycling.dmi'
	icon_state = "switch-off"
	var/position = 0			// 0 off, -1 reverse, 1 forward
	var/last_pos = -1			// last direction setting
	var/operated = 1			// true if just operated

	var/id = "" 				// must match conveyor IDs to control them

	var/list/conveyors		// the list of converyors that are controlled by this switch
	anchored = 1

/obj/machinery/conveyor_switch/two_way_on
	position = 1


/obj/machinery/conveyor_switch/Initialize(mapload)
	. = ..()
	update()
	return INITIALIZE_HINT_LATELOAD

/obj/machinery/conveyor_switch/LateInitialize()
	conveyors = list()
	for(var/obj/machinery/conveyor/C in GLOB.machines)
		if(C.id == id)
			conveyors += C

// update the icon depending on the position

/obj/machinery/conveyor_switch/proc/update()
	if(position<0)
		icon_state = "switch-rev"
	else if(position>0)
		icon_state = "switch-fwd"
	else
		icon_state = "switch-off"

// timed process
// if the switch changed, update the linked conveyors

/obj/machinery/conveyor_switch/process(delta_time)
	if(!operated)
		return
	operated = 0

	for(var/obj/machinery/conveyor/C in conveyors)
		C.operating = position
		C.setmove()

// attack with hand, switch position
/obj/machinery/conveyor_switch/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(!allowed(user))
		to_chat(user, "<span class='warning'>Access denied.</span>")
		return

	if(position == 0)
		if(last_pos < 0)
			position = 1
			last_pos = 0
		else
			position = -1
			last_pos = 0
	else
		last_pos = position
		position = 0

	operated = 1
	update()

	// find any switches with same id as this one, and set their positions to match us
	for(var/obj/machinery/conveyor_switch/S in GLOB.machines)
		if(S.id == src.id)
			S.position = position
			S.update()

/obj/machinery/conveyor_switch/attackby(var/obj/item/I, mob/user)
	if(default_deconstruction_screwdriver(user, I))
		return

	if(istype(I, /obj/item/weldingtool))
		if(panel_open)
			var/obj/item/weldingtool/WT = I
			if(!WT.remove_fuel(0, user))
				to_chat(user, "The welding tool must be on to complete this task.")
				return
			playsound(src, WT.tool_sound, 50, 1)
			if(do_after(user, 20 * WT.tool_speed))
				if(!src || !WT.isOn()) return
				to_chat(user, "<span class='notice'>You deconstruct the frame.</span>")
				new /obj/item/stack/material/steel( src.loc, 2 )
				qdel(src)
				return

	if(istype(I, /obj/item/multitool))
		if(panel_open)
			var/input = sanitize(input(usr, "What id would you like to give this conveyor switch?", "Multitool-Conveyor interface", id))
			if(!input)
				to_chat(user, "No input found. Please hang up and try your call again.")
				return
			id = input
			conveyors = list() // Clear list so they aren't double added.
			for(var/obj/machinery/conveyor/C in GLOB.machines)
				if(C.id == id)
					conveyors += C
			return

/obj/machinery/conveyor_switch/oneway
	var/convdir = 1 //Set to 1 or -1 depending on which way you want the convayor to go. (In other words keep at 1 and set the proper dir on the belts.)
	desc = "A conveyor control switch. It appears to only go in one direction."

// attack with hand, switch position
/obj/machinery/conveyor_switch/oneway/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(position == 0)
		position = convdir
	else
		position = 0

	operated = 1
	update()

	// find any switches with same id as this one, and set their positions to match us
	for(var/obj/machinery/conveyor_switch/S in GLOB.machines)
		if(S.id == src.id)
			S.position = position
			S.update()
