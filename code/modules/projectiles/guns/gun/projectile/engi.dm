#define COILGUN_EFFICIENCY_CURVE(SPEED, SWEETSPOT, BASE_EFF) max((-0.0001 * (SPEED - SWEETSPOT)**2 + BASE_EFF),0.005)//0.5% :D)
#define CHARGE_SPEED_CONVERSION(CHARGE, CELLRATE) sqrt((CHARGE * (1000 * CELLRATE) )/ 3.925)
#define SPEED_CHARGE_CONVERSION(SPEED, CELLRATE) ((3.925 * (SPEED**2))/ (1000*CELLRATE))
#define ATMOS_MULT_CURVE(MOLS) MOLS/1000 //linear
#define COILGUN_HEAT_CAPACITY 1.274  //0.49kJ per 1C @ 1kg for 2.6kg
#define MAX_OPERATING_TEMP 213.15 //-60c
#define GAS_CONSUMED_OPEN_LOOP 0.7 //0.7L


/obj/item/coilgun_coil
	name = "base coilgun coil"
	desc = "A heavily modified SMES coil designed to accelerate objects instead of store energy. It's connected to a capacitor mounting bracket."
	icon = 'icons/obj/tools.dmi'
	icon_state = "screwdriver"
	item_state = "screwdriver"
	//declares the speed range our efficiency is at maximum in, falling off sharply outside of this range
	var/speed_min = 0
	var/speed_max = 400

	//efficiency, e.g how much capacitor charge is translated to kinetic energy. 0.3=30%, 30% is for the most basic coils
	var/efficiency = 0.3


	//how much charge it takes across the entire speed range. saves a little logic/calculation time later
	var/charge_use_speed_range

	var/obj/item/stock_parts/capacitor/capacitor

/obj/item/coilgun_coil/Initialize(mapload)
	. = ..()
	charge_use_speed_range = ((3.925 * (speed_max**2))/ (1000/GLOB.cellrate))/efficiency
	capacitor = new /obj/item/stock_parts/capacitor(src)

/obj/item/coilgun_coil/engineering/attackby(var/obj/item/thing, var/mob/user)
	if(thing.tool_check(TOOL_SCREWDRIVER))
		if(!capacitor)
			to_chat(user, "<span class='warning'>\The [src] has no capacitor installed.</span>")
			return
		user.grab_item_from_interacted_with(capacitor, src)
		user.visible_message("<span class='notice'>\The [user] unscrews \the [capacitor] from \the [src].</span>")
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		capacitor = null
		update_icon()
		return

	if(istype(thing, /obj/item/stock_parts/capacitor))
		if(capacitor)
			to_chat(user, "<span class='warning'>\The [src] already has a capacitor installed!</span>")
			return
		if(!user.attempt_insert_item_for_installation(thing, src))
			return
		capacitor = thing

	. = ..()

/obj/item/coilgun_coil/simple
	name = "simple coilgun coil"
	desc = "A heavily modified simple SMES coil designed to accelerate objects instead of store energy. It's connected to a capacitor mounting bracket."


/obj/item/coilgun_coil/standard
	name = "standard coilgun coil"
	desc = "A heavily modified standard SMES coil designed to accelerate objects instead of store energy. It's connected to a capacitor mounting bracket."

	speed_min = 0
	speed_max = 450
	efficiency = 0.33

/obj/item/coilgun_coil/super_capacity
	name = "super-capacity coilgun coil"
	desc = "A heavily modified high-capacity SMES coil designed to accelerate objects instead of store energy. It's connected to a capacitor mounting bracket."


	//stellar efficiency, but poor maximum speed
	speed_min = 0
	speed_max = 350
	efficiency = 0.5

/obj/item/coilgun_coil/super_io
	name = "transmission coilgun coil"
	desc = "A heavily modified transmission SMES coil designed to accelerate objects instead of store energy. It's connected to a capacitor mounting bracket."


	//opposite of supercap, poor efficiency but good max speed
	speed_min = 400
	speed_max = 650
	efficiency = 0.2


/obj/item/coilgun_coil/hyper_accelerator
	name = "esoteric coilgun coil"
	desc = "A coil of strange material, likely some sort of electromagnet. It's connected to a capacitor mounting bracket."

	speed_min = 750
	speed_max = 900

/obj/item/gun/projectile/engineering
	name = "multistage coilgun"
	desc = "A modular coilgun consisting of three coil mounting brackets attached to a central power supply and gas cooling system."
	icon_state = "coilgun"
	item_state = "coilgun"
	icon = 'icons/obj/railgun.dmi'
	one_handed_penalty = 0 //there's a special
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 4, TECH_ILLEGAL = 2, TECH_MAGNET = 4)
	w_class = WEIGHT_CLASS_BULKY
	cell_system = TRUE

	var/list/coils = list()
	var/max_coils = 3

	var/obj/item/loaded                                        // Currently loaded object, for retrieval/unloading.
	var/load_type = /obj/item/stack/rods                       // Type of stack to load with.


	var/loop_open = FALSE //is the cooling loop open?
	var/obj/item/tank/coolant_tank
	projectile_type = /obj/projectile/bullet/magnetic/engineering


/obj/item/gun/projectile/engineering/Initialize(mapload)
	START_PROCESSING(SSobj, src)
	. = ..()
	obj_cell_slot.legacy_use_device_cells = FALSE

/obj/item/gun/projectile/engineering/examine(mob/user, dist)
	. = ..()
	. += show_ammo()
	var/slotnum = 1
	for(var/obj/item/coilgun_coil/charging_coil in coils)
		. += "It has the [charging_coil] installed in the number [slotnum] coil bracket, drawing power from its [charging_coil.capacitor]."
		slotnum++


/obj/item/gun/projectile/engineering/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(loaded)
	. = ..()

/obj/item/gun/projectile/engineering/process(delta_time)
	if(coils.len)
		for(var/obj/item/coilgun_coil/charging_coil in coils)
			if(obj_cell_slot.cell)
				var/ppt = (charging_coil.capacitor.max_charge/5) //10 seconds to charge each shot. placeholder
				if(charging_coil.capacitor.charge < charging_coil.capacitor.max_charge && obj_cell_slot.cell.checked_use(ppt))
					charging_coil.capacitor.charge(ppt)
			else
				charging_coil.capacitor.use(charging_coil.capacitor.charge * 0.01) //1% per tick
	update_icon()

/obj/item/gun/projectile/engineering/update_icon()
	var/list/overlays_to_add = list()
	cut_overlays()/*
	if(removable_components)
		if(obj_cell_slot.cell)
			overlays_to_add += image(icon, "[icon_state]_cell")
		if(capacitor)
			overlays_to_add += image(icon, "[icon_state]_capacitor")
	if(!obj_cell_slot.cell || !capacitor)
		overlays_to_add += image(icon, "[icon_state]_red")
	else if(capacitor.charge < power_cost)
		overlays_to_add += image(icon, "[icon_state]_amber")
	else
		overlays_to_add += image(icon, "[icon_state]_green")
	if(loaded)
		overlays_to_add += image(icon, "[icon_state]_loaded")
*/
	add_overlay(overlays_to_add)
	..()

/obj/item/gun/projectile/engineering/proc/show_ammo()
	if(loaded)
		return "<span class='notice'>It has \the [loaded] loaded.</span>"
/*
/obj/item/gun/projectile/engineering/examine(var/mob/user)
	. = ..()


	if(obj_cell_slot.cell)
		. += "<span class='notice'>The installed [obj_cell_slot.cell.name] has a charge level of [round((obj_cell_slot.cell.charge/obj_cell_slot.cell.maxcharge)*100)]%.</span>"
	if(capacitor)
		. += "<span class='notice'>The installed [capacitor.name] has a charge level of [round((capacitor.charge/capacitor.max_charge)*100)]%.</span>"

	if(!obj_cell_slot.cell || !capacitor)
		. += "<span class='notice'>The capacitor charge indicator is blinking <font color ='[COLOR_RED]'>red</font>. Maybe you should check the cell or capacitor.</span>"
	else
		if(capacitor.charge < power_cost)
			. += "<span class='notice'>The capacitor charge indicator is <font color ='[COLOR_ORANGE]'>amber</font>.</span>"
		else
			. += "<span class='notice'>The capacitor charge indicator is <font color ='[COLOR_GREEN]'>green</font>.</span>"
*/
/obj/item/gun/projectile/engineering/attackby(var/obj/item/thing, var/mob/user)
	if(thing.tool_check(TOOL_SCREWDRIVER))
		if(!(coils.len))
			to_chat(user, "<span class='warning'>\The [src] has no coils installed.</span>")
			return
		user.grab_item_from_interacted_with(coils[coils.len], src)
		user.visible_message("<span class='notice'>\The [user] unscrews \the [coils[coils.len]] from \the [src].</span>")
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		coils -= coils[coils.len]
		update_icon()
		return
	if(thing.tool_check(TOOL_WRENCH))
		if(!coolant_tank)
			to_chat(user, "<span class='warning'>\The [src] has no tank installed.</span>")
			return
		user.grab_item_from_interacted_with(coolant_tank, src)
		user.visible_message("<span class='notice'>\The [user] removes \the [coolant_tank] from \the [src].</span>")
		playsound(src, 'sound/items/Screwdriver.ogg', 50, 1)
		coolant_tank = null
		update_icon()
		return

	if(istype(thing, /obj/item/coilgun_coil))
		if(LAZYLEN(coils) >= max_coils)
			to_chat(user, "<span class='warning'>\The [src] already has [max_coils] coils installed!</span>")
			return
		var/obj/item/coilgun_coil/CC = thing
		if(!CC.capacitor)
			to_chat(user, "<span class='warning'>\The [CC] doesn't have a capacitor installed!</span>")
			return
		if(!user.attempt_insert_item_for_installation(thing, src))
			return
		coils += thing
		playsound(src, 'sound/machines/click.ogg', 10, 1)
		user.visible_message("<span class='notice'>\The [user] slots \the [thing] into \the [src].</span>")
		update_icon()
		return

	if(istype(thing, load_type))

		if(loaded)
			to_chat(user, "<span class='warning'>\The [src] already has \a [loaded] loaded.</span>")
			return

		// This is not strictly necessary for the engineering gun but something using
		// specific ammo types may exist down the track.
		var/obj/item/stack/ammo = thing
		if(!istype(ammo))
			if(!user.attempt_insert_item_for_installation(thing, src))
				return
			loaded = thing
		else
			loaded = new load_type(src, 1)
			ammo.use(1)

		user.visible_message("<span class='notice'>\The [user] loads \the [src] with \the [loaded].</span>")
		playsound(src, 'sound/weapons/flipblade.ogg', 50, 1)
		update_icon()
		return
	if(istype(thing,/obj/item/tank))
		if(!coolant_tank)
			if(thing.w_class != WEIGHT_CLASS_NORMAL)
				to_chat(user, SPAN_NOTICE("[thing] isn't the right size to fit into the tank mount!"))
				return
			if(!user.attempt_insert_item_for_installation(thing, src))
				return
			coolant_tank = thing
			return
		else
			to_chat(user, SPAN_NOTICE("[src] already has a tank mounted!"))
			return

	. = ..()

/obj/item/gun/projectile/engineering/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	if(user.get_inactive_held_item() == src)
		var/obj/item/removing

		if(loaded)
			removing = loaded
			loaded = null

		if(removing)
			removing.forceMove(get_turf(src))
			user.put_in_hands(removing)
			user.visible_message("<span class='notice'>\The [user] removes \the [removing] from \the [src].</span>")
			playsound(src, 'sound/machines/click.ogg', 10, 1)
			update_icon()
			return
	. = ..()

/obj/item/gun/projectile/engineering/proc/check_ammo()
	return loaded

/obj/item/gun/projectile/engineering/proc/use_ammo()
	qdel(loaded)
	loaded = null

/obj/item/gun/projectile/engineering/proc/thermal_check()
	var/turf/our_turf = get_turf(src)
	if(istype(our_turf, /turf/space))
		return (coolant_tank.return_temperature() < MAX_OPERATING_TEMP)
	else
		var/turf_mol = our_turf.total_mole()
		//do turf calc (we can share Some heat with turf, hopefully)
		if(turf_mol < 5) //under 5 mol of stuff, barely anything, we ignore it and treat it like space
			return (coolant_tank.return_temperature() < MAX_OPERATING_TEMP)
		else
			return (coolant_tank.return_temperature() < MAX_OPERATING_TEMP) || (our_turf.return_temperature() < MAX_OPERATING_TEMP)

/obj/item/gun/projectile/engineering/proc/do_thermal_sharing(var/heat_energy_charge)
	var/energy_kj = DYNAMIC_KJ_TO_CELL_UNITS(heat_energy_charge)
	var/turf/our_turf = get_turf(src)
	var/datum/gas_mixture/turf_air = our_turf.return_air()
	var/datum/gas_mixture/tank_air = coolant_tank.return_air()


	if(istype(our_turf, /turf/space) || !turf_air)
		if(loop_open)
			tank_air.remove_volume(GAS_CONSUMED_OPEN_LOOP)
		else
			tank_air.adjust_thermal_energy(energy_kj * 1000)
	else
		var/turf_mol = turf_air.total_moles
		//do turf calc (we can share Some heat with turf, hopefully)
		if(turf_mol < 5) //under 5 mol of stuff, barely anything, we ignore it and treat it like space
			if(loop_open)
				var/datum/gas_mixture/removed = tank_air.remove_volume(GAS_CONSUMED_OPEN_LOOP)
				removed.adjust_thermal_energy(energy_kj * 1000)
				turf_air.merge(removed)
			else
				tank_air.adjust_thermal_energy(energy_kj * 1000)
		else
			var/sharing_with_turf_proportion = min(ATMOS_MULT_CURVE(turf_mol), 1) //it's based on mol because it represents the amount of gas around and we are (primarily) doing convection sim
			//more gas, even with lower pressure (less movement): your gas is more likely to hit the gun and cool it down
			var/energy_to_turf = energy_kj * sharing_with_turf_proportion

			var/energy_to_tank = energy_kj - energy_to_turf
			if((energy_to_turf*COILGUN_HEAT_CAPACITY) < our_turf.return_temperature() ) //not hot enough, don't move to turf
				turf_air.adjust_thermal_energy(energy_to_turf * 1000)
				if(loop_open)
					var/datum/gas_mixture/removed = tank_air.remove_volume(GAS_CONSUMED_OPEN_LOOP)
					removed.adjust_thermal_energy(energy_to_tank * 1000)
					turf_air.merge(removed)
				else
					tank_air.adjust_thermal_energy(energy_to_tank * 1000)





/obj/item/gun/projectile/engineering/consume_next_projectile(datum/gun_firing_cycle/cycle)
	var/no_power = FALSE
	for(var/obj/item/coilgun_coil/charging_coil in coils)

		no_power = no_power || (charging_coil.capacitor.charge < 1) //you CAN fire it off prematurely! i don't know why you would, but

	if(!check_ammo() || !(coils.len) || no_power || !thermal_check())
		visible_message("<span class='notice'>A light on \the [src] blinks red.</span>") //debug your own gun
		return

	use_ammo()

	var/projectile_energy = 0 //in cell charge units
	var/wasted_power = 0 //in charge units
	var/speed = 0

	for(var/obj/item/coilgun_coil/charging_coil in coils)
		if(speed < charging_coil.speed_min)
			var/used_eff = COILGUN_EFFICIENCY_CURVE(speed, charging_coil.speed_min, charging_coil.efficiency)
			var/energy_delta = SPEED_CHARGE_CONVERSION( (charging_coil.speed_max), GLOB.cellrate) - projectile_energy
			var/post_efficiency_delta = energy_delta/charging_coil.efficiency
			if(post_efficiency_delta > charging_coil.capacitor.charge)
				energy_delta = charging_coil.capacitor.use(charging_coil.capacitor.charge)
				projectile_energy += energy_delta*charging_coil.efficiency
				wasted_power += (energy_delta* (1-charging_coil.efficiency))
				speed = CHARGE_SPEED_CONVERSION(projectile_energy, GLOB.cellrate)
			else
				projectile_energy += charging_coil.capacitor.use(post_efficiency_delta)
				wasted_power += (energy_delta/(1-charging_coil.efficiency))
				speed = CHARGE_SPEED_CONVERSION(projectile_energy, GLOB.cellrate)

		if( (charging_coil.charge_use_speed_range > charging_coil.capacitor.charge) && (speed == charging_coil.speed_min)) //max efficiency
			var/power_used = charging_coil.capacitor.use(charging_coil.capacitor.charge)
			projectile_energy += power_used * charging_coil.efficiency
			wasted_power += (power_used*(1-charging_coil.efficiency))
			speed = CHARGE_SPEED_CONVERSION(projectile_energy, GLOB.cellrate)

		else if(speed < charging_coil.speed_max)
			var/energy_delta = SPEED_CHARGE_CONVERSION((charging_coil.speed_max), GLOB.cellrate) - projectile_energy
			var/post_efficiency_delta = energy_delta/charging_coil.efficiency
			if(post_efficiency_delta > charging_coil.capacitor.charge)
				energy_delta = charging_coil.capacitor.use(charging_coil.capacitor.charge)
				projectile_energy += energy_delta*charging_coil.efficiency
				wasted_power += (energy_delta* (1-charging_coil.efficiency))
				speed = CHARGE_SPEED_CONVERSION(projectile_energy, GLOB.cellrate)
			else
				projectile_energy += charging_coil.capacitor.use(post_efficiency_delta)
				wasted_power += (energy_delta/(1-charging_coil.efficiency))
				speed = CHARGE_SPEED_CONVERSION(projectile_energy, GLOB.cellrate)

		if(speed >= charging_coil.speed_max)
			var/power_used = charging_coil.capacitor.use(charging_coil.capacitor.charge)
			var/used_eff = COILGUN_EFFICIENCY_CURVE(CHARGE_SPEED_CONVERSION(projectile_energy+charging_coil.capacitor.charge, GLOB.cellrate), charging_coil.speed_max, charging_coil.efficiency)
			projectile_energy += power_used*used_eff
			wasted_power += (power_used* (1-used_eff))
			speed = CHARGE_SPEED_CONVERSION(projectile_energy, GLOB.cellrate)

	update_icon()
	do_thermal_sharing(wasted_power)
	var/obj/projectile/our_bb = new projectile_type(src)
	our_bb.damage_force = (speed/10)
	our_bb.speed = speed*WORLD_ICON_SIZE //speed is in m/s
	our_bb.hitscan = (speed>900) //it's over 900!!!! this means 90 damage. it's unachievable without vv
	our_bb.legacy_penetrating = (speed/100)

	return our_bb

#undef COILGUN_EFFICIENCY_CURVE
#undef CHARGE_SPEED_CONVERSION
#undef SPEED_CHARGE_CONVERSION
#undef ATMOS_MULT_CURVE
#undef COILGUN_HEAT_CAPACITY
#undef MAX_OPERATING_TEMP
#undef GAS_CONSUMED_OPEN_LOOP
