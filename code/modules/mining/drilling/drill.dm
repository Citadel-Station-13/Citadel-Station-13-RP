/obj/machinery/mining_drill
	icon = 'icons/obj/mining_drill.dmi'
	anchored = 0
	use_power = USE_POWER_OFF //The drill takes power directly from a cell.
	density = 1
	layer = MOB_LAYER+0.1 //So it draws over mobs in the tile north of it.

/obj/machinery/mining_drill/head
	name = "mining drill head"
	desc = "An enormous drill."
	icon_state = "mining_drill"
	circuit = /obj/item/circuitboard/miningdrill

	/// how many braces we need
	var/braces_needed = 2
	/// connected braces
	var/list/supports = list()
	/// do we have enough supports?
	var/supported = FALSE
	/// inserted power cell
	var/obj/item/cell/cell

	#warn check below
	var/active = 0
	var/list/resource_field = list()
	var/obj/item/radio/intercom/faultreporter = new /obj/item/radio/intercom{channels=list("Supply")}(null)

	//Upgrades
	var/harvest_speed
	var/capacity
	var/charge_use

	//Flags
	var/need_update_field = 0
	var/need_player_check = 0

/obj/machinery/mining_drill/head/Initialize(mapload)
	. = ..()
	default_apply_parts()

/obj/machinery/mining_drill/head/Destroy()
	for(var/obj/machinery/mining_drill/brace/B in supports)
		B.disconnect()
	return ..()

/obj/machinery/mining_drill/head/get_cell()
	return cell

#warn refactor - has_resources too
/obj/machinery/mining_drill/head/process(delta_time)

	if(need_player_check)
		return

	check_supports()

	if(!active) return

	if(!anchored || !use_cell_power())
		system_error("System configuration or charge error.")
		return

	if(need_update_field)
		get_resource_field()

	if(world.time % 10 == 0)
		update_icon()

	if(!active)
		return

	//Drill through the flooring, if any.
	if(istype(get_turf(src), /turf/simulated))
		var/turf/simulated/T = get_turf(src)
		LEGACY_EX_ACT(T, 2, null)

	//Dig out the tasty ores.
	if(resource_field.len)
		var/turf/simulated/harvesting = pick(resource_field)

		while(resource_field.len && !harvesting.resources)
			harvesting.has_resources = 0
			harvesting.resources = null
			resource_field -= harvesting
			if(resource_field.len) // runtime protection
				harvesting = pick(resource_field)
			else
				harvesting = null

		if(!harvesting) return

		var/total_harvest = harvest_speed //Ore harvest-per-tick.
		var/found_resource = 0 //If this doesn't get set, the area is depleted and the drill errors out.

		for(var/metal in GLOB.ore_types)

			if(contents.len >= capacity)
				system_error("Insufficient storage space.")
				active = 0
				need_player_check = 1
				update_icon()
				return

			if(contents.len + total_harvest >= capacity)
				total_harvest = capacity - contents.len

			if(total_harvest <= 0) break
			if(harvesting.resources[metal])

				found_resource  = 1

				var/create_ore = 0
				if(harvesting.resources[metal] >= total_harvest)
					harvesting.resources[metal] -= total_harvest
					create_ore = total_harvest
					total_harvest = 0
				else
					total_harvest -= harvesting.resources[metal]
					create_ore = harvesting.resources[metal]
					harvesting.resources[metal] = 0

				for(var/i=1, i <= create_ore, i++)
					var/oretype = GLOB.ore_types[metal]
					new oretype(src)

		if(!found_resource)	// If a drill can't see an advanced material, it will destroy it while going through.
			harvesting.has_resources = 0
			harvesting.resources = null
			resource_field -= harvesting
	else
		active = 0
		need_player_check = 1
		update_icon()
		system_error("Resources depleted.")

/obj/machinery/mining_drill/head/attack_ai(var/mob/user as mob)
	return src.attack_hand(user)


/obj/machinery/mining_drill/head/attackby(obj/item/O as obj, mob/user as mob)
	if(!active)
		if(istype(O, /obj/item/multitool))
			var/newtag = text2num(sanitizeSafe(input(user, "Enter new ID number or leave empty to cancel.", "Assign ID number") as text, 4))
			if(newtag)
				name = "[initial(name)] #[newtag]"
				to_chat(user, "<span class='notice'>You changed the drill ID to: [newtag]</span>")
			return
		if(default_deconstruction_screwdriver(user, O))
			return
		if(default_deconstruction_crowbar(user, O))
			return
		if(default_part_replacement(user, O))
			return
	if(!panel_open || active) return ..()

	if(istype(O, /obj/item/cell))
		if(cell)
			to_chat(user, "The drill already has a cell installed.")
		else
			if(!user.attempt_insert_item_for_installation(O, src))
				return
			cell = O
			component_parts += O
			to_chat(user, "You install \the [O].")
		return
	..()

/obj/machinery/mining_drill/head/attack_hand(mob/user as mob)
	check_supports()

	if (panel_open && cell && user.Adjacent(src))
		to_chat(user, "You take out \the [cell].")
		cell.loc = get_turf(user)
		component_parts -= cell
		cell = null
		return
	else if(need_player_check)
		to_chat(user, "You hit the manual override and reset the drill's error checking.")
		need_player_check = 0
		if(anchored)
			get_resource_field()
		update_icon()
		return
	else if(supported && !panel_open)
		if(use_cell_power())
			active = !active
			if(active)
				visible_message("<span class='notice'>\The [src] lurches downwards, grinding noisily.</span>")
				need_update_field = 1
			else
				visible_message("<span class='notice'>\The [src] shudders to a grinding halt.</span>")
		else
			to_chat(user, "<span class='notice'>The drill is unpowered.</span>")
	else
		to_chat(user, "<span class='notice'>Turning on a piece of industrial machinery without sufficient bracing or wires exposed is a bad idea.</span>")

	update_icon()

/obj/machinery/mining_drill/head/update_icon_state()
	. = ..()
	if(need_player_check)
		icon_state = "mining_drill_error"
	else if(active)
		icon_state = "mining_drill_active"
	else if(supported)
		icon_state = "mining_drill_braced"
	else
		icon_state = "mining_drill"

/obj/machinery/mining_drill/head/RefreshParts()
	..()
	harvest_speed = 0
	capacity = 0
	charge_use = 50

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/micro_laser))
			harvest_speed = P.rating
		if(istype(P, /obj/item/stock_parts/matter_bin))
			capacity = 200 * P.rating
		if(istype(P, /obj/item/stock_parts/capacitor))
			charge_use -= 10 * P.rating
	cell = locate(/obj/item/cell) in component_parts

/obj/machinery/mining_drill/head/proc/check_supports()
	var/braces = LAZYLEN(supports)
	supported = braces >= braces_needed
	set_anchored(!!braces)
	update_icon()

/obj/machinery/mining_drill/head/proc/set_active(active)
	src.active = active

#warn impl

/obj/machinery/mining_drill/head/proc/system_error(rror)
	if(error)
		visible_message(SPAN_NOTICE("[src] flashes a warning: [error]"))
		faultreporter.autosay(error, name, "Supply")

	need_player_check = 1
	active = 0
	update_icon()

/obj/machinery/mining_drill/head/proc/get_resource_field()

	resource_field = list()
	need_update_field = 0

	var/turf/T = get_turf(src)
	if(!istype(T)) return

	var/tx = T.x - 2
	var/ty = T.y - 2
	var/turf/simulated/mine_turf
	for(var/iy = 0,iy < 5, iy++)
		for(var/ix = 0, ix < 5, ix++)
			mine_turf = locate(tx + ix, ty + iy, T.z)
			if(!istype(mine_turf, /turf/space/))
				if(mine_turf && mine_turf.has_resources)
					resource_field += mine_turf

	if(!resource_field.len)
		system_error("Resources depleted.")

/obj/machinery/mining_drill/head/proc/use_cell_power()
	if(!cell) return 0
	if(cell.charge >= charge_use)
		cell.use(charge_use)
		return 1
	return 0


/obj/machinery/mining_drill/head/verb/unload()
	set name = "Unload Drill"
	set category = "Object"
	set src in oview(1)

	if(usr.stat) return

	var/obj/structure/ore_box/B = locate() in orange(1)
	if(B)
		for(var/obj/item/ore/O in contents)
			B.take(O)
		to_chat(usr, "<span class='notice'>You unload the drill's storage cache into the ore box.</span>")
	else
		to_chat(usr, "<span class='notice'>You must move an ore box up to the drill before you can unload it.</span>")


/obj/machinery/mining_drill/brace
	name = "mining drill brace"
	desc = "A machinery brace for an industrial drill. It looks easily two feet thick."
	icon_state = "mining_brace"
	circuit = /obj/item/circuitboard/miningdrillbrace

	/// connected drill
	var/obj/machinery/mining_drill/head/drill

/obj/machinery/mining_drill/brace/Initialize(mapload, newDir)
	. = ..()
	if(newDir)
		setDir(newDir)
	if(anchored)
		connect()
	default_apply_parts()

#warn tool act standardization time for machines o_o
#warn machine flagS?

/obj/machinery/mining_drill/brace/attackby(obj/item/W as obj, mob/user as mob)
	if(connected && connected.active)
		to_chat(user, "<span class='notice'>You can't work with the brace of a running drill!</span>")
		return

	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return

	if(W.is_wrench())

		if(istype(get_turf(src), /turf/space))
			to_chat(user, "<span class='notice'>You can't anchor something to empty space. Idiot.</span>")
			return

		playsound(src, W.tool_sound, 100, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "un" : ""]anchor the brace.</span>")

		anchored = !anchored
		if(anchored)
			connect()
		else
			disconnect()

/obj/machinery/mining_drill/update_icon_state()
	. = ..()
	icon_state = drill? "mining_brace_active" : "mining_brace"

/obj/machinery/mining_drill/brace/proc/connect()
	disconnect()
	var/turf/T = get_step(src, dir)
	var/obj/machinery/mining_drill/head/potential = locate() in T
	if(!potential)
		return
	LAZYADD(potential.supports, src)
	drill = potential
	drill.check_supports()
	update_icon()

/obj/machinery/mining_drill/brace/proc/disconnect()
	if(!drill)
		return
	LAZYREMOVE(drill.supports, src)
	drill.check_supports()
	drill = null
	update_icon()

#warn standardize rotation, perhaps on machinery and structure level
#warn element: worth it? 200 bytes per obj is a lot.
/obj/machinery/mining_drill/brace/verb/rotate_clockwise()
	set name = "Rotate Brace Clockwise"
	set category = "Object"
	set src in oview(1)

	if(usr.stat) return

	if (src.anchored)
		to_chat(usr, "It is anchored in place!")
		return 0

	src.setDir(turn(src.dir, 270))
	return 1
