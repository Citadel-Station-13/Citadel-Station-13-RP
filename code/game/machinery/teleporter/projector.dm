#define BASE_ITEM_KJ_COST 72000
#define BASE_MOB_KJ_COST 140000

/obj/machinery/tele_projector
	name = "projector"
	desc = "This machine is capable of projecting a miniature wormhole leading directly to its provided target."
	icon = 'icons/obj/machines/teleporter.dmi'
	icon_state = "station"
	density = TRUE
	anchored = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 10
	active_power_usage = 2000
	circuit = /obj/item/circuitboard/tele_projector

	var/obj/machinery/tele_pad/pad
	var/obj/machinery/power/terminal
	var/engaged = FALSE
	var/building_terminal = FALSE 		//Suggestions about how to avoid clickspam building several terminals accepted!
	var/power_capacity = 0
	var/recharge_capacity = 0
	var/current_joules = 0
	var/recharge_rate = 0


/obj/machinery/tele_projector/Initialize(mapload)
	. = ..()
	update_appearance()


	component_parts = list()
	component_parts += new /obj/item/smes_coil(src)
	component_parts += new /obj/item/smes_coil(src)
	update_charge()
	recharge_rate = recharge_capacity/4

	return INITIALIZE_HINT_LATELOAD

/obj/machinery/tele_projector/examine(mob/user)
	. = ..()
	. += SPAN_NOTICE("It has [render_power(power_capacity, ENUM_POWER_SCALE_KILO)] stored, according to a meter on [src].")
	. += SPAN_NOTICE("It is set to consume [render_power(recharge_rate, ENUM_POWER_SCALE_KILO)].")

/obj/machinery/tele_projector/process()
	if(machine_stat & (NOPOWER|BROKEN))
		return
	if(current_joules == power_capacity)
		return
	if(terminal && terminal.powernet)
		var/energy_buffer = 0
		energy_buffer = terminal.draw_power(recharge_rate)
		current_joules += KW_TO_KWM(energy_buffer, 1)
		current_joules = clamp(current_joules, 0, power_capacity)


/obj/machinery/tele_projector/LateInitialize()
	. = ..()
	for(var/target_dir in GLOB.cardinal)
		var/obj/machinery/tele_pad/found_pad = locate() in get_step(src, target_dir)
		if(found_pad)
			setDir(get_dir(src, found_pad))
			break

	for(var/d in GLOB.cardinal)
		var/turf/T = get_step(src, d)
		for(var/obj/machinery/power/terminal/term in T)
			if(term && term.dir == turn(d, 180))
				terminal = term
				break
	if(!terminal)
		return
	if(!terminal.powernet)
		terminal.connect_to_network()

/obj/machinery/tele_projector/update_icon()
	cut_overlays()
	if(engaged)
		var/image/I = image(icon, src, "[initial(icon_state)]_active_overlay")
		I.plane = ABOVE_LIGHTING_PLANE
		I.layer = ABOVE_LIGHTING_LAYER_MAIN
		add_overlay(I)
	else
		if(operable())
			var/image/I = image(icon, src, "[initial(icon_state)]_idle_overlay")
			I.plane = ABOVE_LIGHTING_PLANE
			I.layer = ABOVE_LIGHTING_LAYER_MAIN
			add_overlay(I)

/obj/machinery/tele_projector/attackby(obj/item/W, mob/living/user)
	if(W.is_screwdriver())
		if(!panel_open)
			panel_open = TRUE
			to_chat(user, "<span class='notice'>You open the maintenance hatch of [src].</span>")
			playsound(src, W.tool_sound, 50, 1)
			return FALSE
		else
			panel_open = FALSE
			to_chat(user, "<span class='notice'>You close the maintenance hatch of [src].</span>")
			playsound(src, W.tool_sound, 50, 1)
			return FALSE

	if (!panel_open)
		to_chat(user, "<span class='warning'>You need to open access hatch on [src] first!</span>")
		return FALSE

	if(istype(W, /obj/item/stack/cable_coil) && !terminal && !building_terminal)
		building_terminal = 1
		var/obj/item/stack/cable_coil/CC = W
		if (CC.get_amount() < 10)
			to_chat(user, "<span class='warning'>You need more cables.</span>")
			building_terminal = FALSE
			return FALSE
		if (make_terminal(user))
			building_terminal = FALSE
			return FALSE
		building_terminal = FALSE
		CC.use(10)
		user.visible_message(\
				"<span class='notice'>[user.name] has added cables to the [src].</span>",\
				"<span class='notice'>You added cables to the [src].</span>")
		machine_stat = NONE
		return FALSE

	else if(W.is_wirecutter() && terminal && !building_terminal)
		building_terminal = FALSE
		var/turf/tempTDir = terminal.loc
		if (istype(tempTDir))
			if(!tempTDir.is_plating())
				to_chat(user, "<span class='warning'>You must remove the floor plating first.</span>")
			else
				to_chat(user, "<span class='notice'>You begin to cut the cables...</span>")
				playsound(get_turf(src), 'sound/items/Deconstruct.ogg', 50, 1)
				if(do_after(user, 50 * W.tool_speed))
					if (prob(50) && electrocute_mob(usr, terminal.powernet, terminal))
						var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
						s.set_up(5, 1, src)
						s.start()
						building_terminal = FALSE
						if(!CHECK_MOBILITY(usr, MOBILITY_CAN_USE))
							return 0
					new /obj/item/stack/cable_coil(loc,10)
					user.visible_message(\
						"<span class='notice'>[user.name] cut the cables and dismantled the power terminal.</span>",\
						"<span class='notice'>You cut the cables and dismantle the power terminal.</span>")
					qdel(terminal)
		building_terminal = FALSE
		return FALSE
	return TRUE

/obj/machinery/tele_projector/proc/make_terminal(const/mob/user)
	if (user.loc == loc)
		to_chat(user, "<span class='warning'>You must not be on the same tile as the [src].</span>")
		return FALSE

	//Direction the terminal will face to
	var/tempDir = get_dir(user, src)
	switch(tempDir)
		if (NORTHEAST, SOUTHEAST)
			tempDir = EAST
		if (NORTHWEST, SOUTHWEST)
			tempDir = WEST
	var/turf/tempLoc = get_step(src, global.reverse_dir[tempDir])
	if (istype(tempLoc, /turf/space))
		to_chat(user, "<span class='warning'>You can't build a terminal on space.</span>")
		return TRUE
	else if (istype(tempLoc))
		if(!tempLoc.is_plating())
			to_chat(user, "<span class='warning'>You must remove the floor plating first.</span>")
			return TRUE
	to_chat(user, "<span class='notice'>You start adding cable to the [src].</span>")
	if(do_after(user, 50))
		terminal = new /obj/machinery/power/terminal(tempLoc)
		terminal.setDir(tempDir)
		terminal.connect_to_network()
		return FALSE
	return TRUE

/obj/machinery/tele_projector/attack_ai()
	attack_hand()

/obj/machinery/tele_projector/attack_hand(mob/user, list/params)
	if(engaged)
		disengage()
	else
		engage()

/obj/machinery/tele_projector/proc/update_charge()
	power_capacity = 0
	recharge_capacity = 0
	for(var/obj/item/smes_coil/S in component_parts)
		power_capacity += KWH_TO_KJ(S.charge_capacity)
		recharge_capacity += S.flow_capacity
	current_joules = clamp(current_joules, 0, power_capacity)

/obj/machinery/tele_projector/proc/consume_charge(var/atom/teleporting)
	var/teleport_cost = 0
	if(istype(teleporting, /obj/)) //on god this recursive shit will be the end of me.
		var/obj/O = teleporting
		teleport_cost += O.w_class*BASE_ITEM_KJ_COST
		if(O.contents)
			for(var/obj/I in recursive_content_check(O))
				teleport_cost += I.w_class*BASE_ITEM_KJ_COST

	if(istype(teleporting, /obj/structure))
		var/obj/structure/S = teleporting
		teleport_cost += S.w_class*BASE_ITEM_KJ_COST
		if(S.contents) //uh oh, it contains something!
			for(var/obj/I in recursive_content_check(S))
				teleport_cost += I.w_class*BASE_ITEM_KJ_COST
			for(var/mob/M in recursive_content_check(S))
				for(var/obj/MI in recursive_content_check(M))
					teleport_cost += MI.w_class*BASE_ITEM_KJ_COST

	if(istype(teleporting, /mob/))
		var/mob/M = teleporting
		teleport_cost += BASE_MOB_KJ_COST
		if(M.contents) //uh oh, it contains something!
			for(var/obj/I in recursive_content_check(M))
				teleport_cost += I.w_class*BASE_ITEM_KJ_COST

	if(current_joules >= teleport_cost)
		current_joules -= teleport_cost
		current_joules = clamp(current_joules, 0, power_capacity)
		return TRUE
	return FALSE

/obj/machinery/tele_projector/proc/engage()
	if(machine_stat & (BROKEN|NOPOWER))
		return

	engaged = TRUE
	update_appearance()
	if(pad)
		pad.update_icon()
		pad.update_use_power(USE_POWER_ACTIVE)
		update_use_power(USE_POWER_ACTIVE)
		use_power(5000)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_NOTICE("Teleporter engaged!"), 2)
	add_fingerprint(usr)
	return

/obj/machinery/tele_projector/proc/disengage()
	if(machine_stat & (BROKEN|NOPOWER))
		return

	engaged = FALSE
	update_appearance()
	if(pad)
		pad.update_icon()
		pad.update_use_power(USE_POWER_IDLE)
		update_use_power(USE_POWER_IDLE)
		for(var/mob/O in hearers(src, null))
			O.show_message(SPAN_NOTICE("Teleporter disengaged!"), 2)
	add_fingerprint(usr)
	return

/atom/proc/laserhit(obj/L)
	return TRUE
