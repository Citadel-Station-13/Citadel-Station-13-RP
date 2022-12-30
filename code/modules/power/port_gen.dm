//Baseline portable generator. Has all the default handling. Not intended to be used on it's own (since it generates unlimited power).
/obj/machinery/power/port_gen
	name = "Placeholder Generator"	//seriously, don't use this. It can't be anchored without VV magic.
	desc = "A portable generator for emergency backup power"
	icon = 'icons/obj/power.dmi'
	icon_state = "portgen0"
	density = 1
	anchored = 0
	use_power = USE_POWER_OFF

	var/active = 0
	/// in kw
	var/power_gen = 5
	var/recent_fault = 0
	var/power_output = 1

/obj/machinery/power/port_gen/proc/IsBroken()
	return (machine_stat & (BROKEN|EMPED))

/obj/machinery/power/port_gen/proc/HasFuel() //Placeholder for fuel check.
	return 1

/obj/machinery/power/port_gen/proc/UseFuel() //Placeholder for fuel use.
	return

/obj/machinery/power/port_gen/proc/DropFuel()
	return

/obj/machinery/power/port_gen/proc/handleInactive()
	return

/obj/machinery/power/port_gen/process(delta_time)
	if(active && HasFuel() && !IsBroken() && anchored && powernet)
		add_avail(power_gen * power_output * 0.001)
		UseFuel()
		src.updateDialog()
	else
		active = 0
		icon_state = initial(icon_state)
		handleInactive()

/obj/machinery/power/powered()
	return 1 //doesn't require an external power source

/obj/machinery/power/port_gen/attack_hand(mob/user as mob)
	if(..())
		return
	if(!anchored)
		return

/obj/machinery/power/port_gen/examine(mob/user)
	. = ..()
	if(active)
		. += "<span class='notice'>The generator is on.</span>"
	else
		. += "<span class='notice'>The generator is off.</span>"

/obj/machinery/power/port_gen/emp_act(severity)
	if(!active)
		return
	var/duration = 6000 //ten minutes
	switch(severity)
		if(1)
			machine_stat &= BROKEN
			if(prob(75))
				explode()
		if(2)
			if(prob(50))
				machine_stat &= BROKEN
			if(prob(10))
				explode()
		if(3)
			if(prob(25))
				machine_stat &= BROKEN
			duration = 300
		if(4)
			if(prob(10))
				machine_stat &= BROKEN
			duration = 300

	machine_stat |= EMPED
	if(duration)
		spawn(duration)
			machine_stat &= ~EMPED

/obj/machinery/power/port_gen/proc/explode()
	explosion(src.loc, -1, 3, 5, -1)
	qdel(src)

/obj/machinery/power/port_gen/proc/TogglePower()
	if(active)
		active = FALSE
	else if(HasFuel())
		active = TRUE

#define TEMPERATURE_DIVISOR 40
#define TEMPERATURE_CHANGE_MAX 20

//A power generator that runs on solid plasma sheets.
/obj/machinery/power/port_gen/pacman
	name = "\improper P.A.C.M.A.N.-type Portable Generator"
	desc = "A power generator that runs on solid phoron sheets. Rated for 80 kW max safe output."
	circuit = /obj/item/circuitboard/pacman
	var/sheet_name = "Phoron Sheets"
	var/sheet_path = /obj/item/stack/material/phoron

	/*
		These values were chosen so that the generator can run safely up to 80 kW
		A full 50 phoron sheet stack should last 20 minutes at power_output = 4
		temperature_gain and max_temperature are set so that the max safe power level is 4.
		Setting to 5 or higher can only be done temporarily before the generator overheats.
	*/
	power_gen = 20000			//Watts output per power_output level
	var/max_power_output = 5	//The maximum power setting without emagging.
	var/max_safe_output = 4		// For UI use, maximal output that won't cause overheat.
	var/time_per_sheet = 96		//fuel efficiency - how long 1 sheet lasts at power level 1
	var/max_sheets = 100 		//max capacity of the hopper
	var/max_temperature = 300	//max temperature before overheating increases
	var/temperature_gain = 50	//how much the temperature increases per power output level, in degrees per level

	var/sheets = 0			//How many sheets of material are loaded in the generator
	var/sheet_left = 0		//How much is left of the current sheet
	var/temperature = 0		//The current temperature
	var/overheating = 0		//if this gets high enough the generator explodes

/obj/machinery/power/port_gen/pacman/Initialize(mapload)
	. = ..()
	component_parts = list()
	component_parts += new /obj/item/stock_parts/matter_bin(src)
	component_parts += new /obj/item/stock_parts/micro_laser(src)
	component_parts += new /obj/item/stack/cable_coil(src, 2)
	component_parts += new /obj/item/stock_parts/capacitor(src)
	RefreshParts()
	if(anchored)
		connect_to_network()

/obj/machinery/power/port_gen/pacman/Destroy()
	DropFuel()
	return ..()

/obj/machinery/power/port_gen/pacman/dismantle()
	while ( sheets > 0 )
		DropFuel()
	return ..()

/obj/machinery/power/port_gen/pacman/RefreshParts()
	var/temp_rating = 0
	for(var/obj/item/stock_parts/SP in component_parts)
		if(istype(SP, /obj/item/stock_parts/matter_bin))
			max_sheets = SP.rating * SP.rating * 50
		else if(istype(SP, /obj/item/stock_parts/micro_laser) || istype(SP, /obj/item/stock_parts/capacitor))
			temp_rating += SP.rating

	power_gen = round(initial(power_gen) * (max(2, temp_rating) / 2))

/obj/machinery/power/port_gen/pacman/examine(mob/user)
	. = ..()
	. += "\The [src] appears to be producing [power_gen*power_output] W."
	. += "There [sheets == 1 ? "is" : "are"] [sheets] sheet\s left in the hopper."
	if(IsBroken())
		. += "<span class='warning'>\The [src] seems to have broken down.</span>"
	if(overheating)
		. += "<span class='danger'>\The [src] is overheating!</span>"

/obj/machinery/power/port_gen/pacman/HasFuel()
	var/needed_sheets = power_output / time_per_sheet
	if(sheets >= needed_sheets - sheet_left)
		return 1
	return 0

//Removes one stack's worth of material from the generator.
/obj/machinery/power/port_gen/pacman/DropFuel()
	if(sheets)
		var/obj/item/stack/material/S = new sheet_path(loc)
		var/amount = min(sheets, S.max_amount)
		S.amount = amount
		sheets -= amount

/obj/machinery/power/port_gen/pacman/UseFuel()

	//how much material are we using this iteration?
	var/needed_sheets = power_output / time_per_sheet

	//HasFuel() should guarantee us that there is enough fuel left, so no need to check that
	//the only thing we need to worry about is if we are going to rollover to the next sheet
	if (needed_sheets > sheet_left)
		sheets--
		sheet_left = (1 + sheet_left) - needed_sheets
	else
		sheet_left -= needed_sheets

	//calculate the "target" temperature range
	//This should probably depend on the external temperature somehow, but whatever.
	var/lower_limit = 56 + power_output * temperature_gain
	var/upper_limit = 76 + power_output * temperature_gain

	/*
		Hot or cold environments can affect the equilibrium temperature
		The lower the pressure the less effect it has. I guess it cools using a radiator or something when in vacuum.
		Gives traitors more opportunities to sabotage the generator or allows enterprising engineers to build additional
		cooling in order to get more power out.
	*/
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		var/ratio = min(environment.return_pressure()/ONE_ATMOSPHERE, 1)
		var/ambient = environment.temperature - T20C
		lower_limit += ambient*ratio
		upper_limit += ambient*ratio

	var/average = (upper_limit + lower_limit)/2

	//calculate the temperature increase
	var/bias = 0
	if (temperature < lower_limit)
		bias = min(round((average - temperature)/TEMPERATURE_DIVISOR, 1), TEMPERATURE_CHANGE_MAX)
	else if (temperature > upper_limit)
		bias = max(round((temperature - average)/TEMPERATURE_DIVISOR, 1), -TEMPERATURE_CHANGE_MAX)

	//limit temperature increase so that it cannot raise temperature above upper_limit,
	//or if it is already above upper_limit, limit the increase to 0.
	var/inc_limit = max(upper_limit - temperature, 0)
	var/dec_limit = min(temperature - lower_limit, 0)
	temperature += between(dec_limit, rand(-7 + bias, 7 + bias), inc_limit)

	if (temperature > max_temperature)
		overheat()
	else if (overheating > 0)
		overheating--

/obj/machinery/power/port_gen/pacman/handleInactive()
	var/cooling_temperature = 20
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		var/ratio = min(environment.return_pressure()/ONE_ATMOSPHERE, 1)
		var/ambient = environment.temperature - T20C
		cooling_temperature += ambient*ratio

	if (temperature > cooling_temperature)
		var/temp_loss = (temperature - cooling_temperature)/TEMPERATURE_DIVISOR
		temp_loss = between(2, round(temp_loss, 1), TEMPERATURE_CHANGE_MAX)
		temperature = max(temperature - temp_loss, cooling_temperature)
		src.updateDialog()

	if(overheating)
		overheating--

/obj/machinery/power/port_gen/pacman/proc/overheat()
	overheating++
	if (overheating > 60)
		explode()

/obj/machinery/power/port_gen/pacman/explode()
	//Vapourize all the phoron
	//When ground up in a grinder, 1 sheet produces 20 u of phoron -- Chemistry-Machinery.dm
	//1 mol = 10 u? I dunno. 1 mol of carbon is definitely bigger than a pill
	var/phoron = (sheets+sheet_left)*20
	var/datum/gas_mixture/environment = loc.return_air()
	if (environment)
		environment.adjust_gas_temp(/datum/gas/phoron, phoron/10, temperature + T0C)

	sheets = 0
	sheet_left = 0
	..()

/obj/machinery/power/port_gen/pacman/emag_act(var/remaining_charges, var/mob/user)
	if (active && prob(25))
		explode() //if they're foolish enough to emag while it's running

	if (!emagged)
		emagged = 1
		return 1

/obj/machinery/power/port_gen/pacman/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(istype(O, sheet_path))
		var/obj/item/stack/addstack = O
		var/amount = min((max_sheets - sheets), addstack.amount)
		if(amount < 1)
			to_chat(user, "<span class='warning'>The [src.name] is full!</span>")
			return
		to_chat(user, "<span class='notice'>You add [amount] sheet\s to the [src.name].</span>")
		sheets += amount
		addstack.use(amount)
		updateUsrDialog()
		return
	else if(!active)
		if(O.is_wrench())
			if(!anchored)
				connect_to_network()
				to_chat(user, "<span class='notice'>You secure the generator to the floor.</span>")
			else
				disconnect_from_network()
				to_chat(user, "<span class='notice'>You unsecure the generator from the floor.</span>")
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 50, 1)
			anchored = !anchored
			return
		else if(default_deconstruction_screwdriver(user, O))
			return
		else if(default_deconstruction_crowbar(user, O))
			return
		else if(default_part_replacement(user, O))
			return
	return ..()

/obj/machinery/power/port_gen/pacman/attack_hand(mob/user as mob)
	..()
	if (!anchored)
		return
	nano_ui_interact(user)

/obj/machinery/power/port_gen/pacman/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/power/port_gen/pacman/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortableGenerator", name)
		ui.open()

/obj/machinery/power/port_gen/pacman/ui_data(mob/user)
	var/list/data = list()

	data["active"] = active

	if(istype(user, /mob/living/silicon/ai))
		data["is_ai"] = TRUE
	else if(istype(user, /mob/living/silicon/robot) && !Adjacent(user))
		data["is_ai"] = TRUE
	else
		data["is_ai"] = FALSE

	data["sheet_name"] = capitalize(sheet_name)
	data["fuel_stored"] = round((sheets * 1000) + (sheet_left * 1000))
	data["fuel_capacity"] = round(max_sheets * 1000, 0.1)
	data["fuel_usage"] = active ? round((power_output / time_per_sheet) * 1000) : 0

	data["anchored"] = anchored
	data["connected"] = (powernet == null ? 0 : 1)
	data["ready_to_boot"] = anchored && HasFuel()
	data["power_generated"] = render_power(power_gen, ENUM_POWER_SCALE_NONE, ENUM_POWER_UNIT_WATT, 0.01, FALSE)
	data["power_output"] = render_power(power_gen * power_output, ENUM_POWER_SCALE_NONE, ENUM_POWER_UNIT_WATT, 0.01, FALSE)
	data["unsafe_output"] = power_output > max_safe_output
	data["power_available"] = (powernet == null ? 0 : render_power(avail(), ENUM_POWER_SCALE_KILO, ENUM_POWER_UNIT_WATT, 0.01, FALSE))
	data["temperature_current"] = temperature
	data["temperature_max"] = max_temperature
	data["temperature_overheat"] = overheating
	// 1 sheet = 1000cm3?

	return data

/obj/machinery/power/port_gen/pacman/ui_act(action, params)
	if(..())
		return

	add_fingerprint(usr)
	switch(action)
		if("toggle_power")
			TogglePower()
			. = TRUE

		if("eject")
			if(!active)
				DropFuel()
				. = TRUE

		if("lower_power")
			if(power_output > 1)
				power_output--
				. = TRUE

		if("higher_power")
			if(power_output < max_power_output || (emagged && power_output < round(max_power_output * 2.5)))
				power_output++
				. = TRUE
/*
/obj/machinery/power/port_gen/pacman/nano_ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(IsBroken())
		return

	var/data[0]
	data["active"] = active
	if(istype(user, /mob/living/silicon/ai))
		data["is_ai"] = 1
	else if(istype(user, /mob/living/silicon/robot) && !Adjacent(user))
		data["is_ai"] = 1
	else
		data["is_ai"] = 0
	data["output_set"] = power_output
	data["output_max"] = max_power_output
	data["output_safe"] = max_safe_output
	data["output_watts"] = power_output * power_gen
	data["temperature_current"] = src.temperature
	data["temperature_max"] = src.max_temperature
	data["temperature_overheat"] = overheating
	// 1 sheet = 1000cm3?
	data["fuel_stored"] = round((sheets * 1000) + (sheet_left * 1000))
	data["fuel_capacity"] = round(max_sheets * 1000, 0.1)
	data["fuel_usage"] = active ? round((power_output / time_per_sheet) * 1000) : 0
	data["fuel_type"] = sheet_name



	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "pacman.tmpl", src.name, 500, 560)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

*/
/*
/obj/machinery/power/port_gen/pacman/interact(mob/user)
	if (get_dist(src, user) > 1 )
		if (!istype(user, /mob/living/silicon/ai))
			user.unset_machine()
			user << browse(null, "window=port_gen"
			return

	user.set_machine(src)

	var/dat = text("<b>[name]</b><br>")
	if (active)
		dat += text("Generator: <A href='?src=\ref[src];action=disable'>On</A><br>")
	else
		dat += text("Generator: <A href='?src=\ref[src];action=enable'>Off</A><br>")
	dat += text("[capitalize(sheet_name)]: [sheets] - <A href='?src=\ref[src];action=eject'>Eject</A><br>")
	var/stack_percent = round(sheet_left * 100, 1)
	dat += text("Current stack: [stack_percent]% <br>")
	dat += text("Power output: <A href='?src=\ref[src];action=lower_power'>-</A> [power_gen * power_output] Watts<A href='?src=\ref[src];action=higher_power'>+</A><br>")
	dat += text("Power current: [(powernet == null ? "Unconnected" : "[avail()]")]<br>")

	var/tempstr = "Temperature: [temperature]&deg;C<br>"
	dat += (overheating)? "<span class='danger'>[tempstr]</span>" : tempstr
	dat += "<br><A href='?src=\ref[src];action=close'>Close</A>"
	user << browse("[dat]", "window=port_gen")
	onclose(user, "port_gen")
*/

/obj/machinery/power/port_gen/pacman/Topic(href, href_list)
	if(..())
		return

	src.add_fingerprint(usr)
	if(href_list["action"])
		if(href_list["action"] == "enable")
			if(!active && HasFuel() && !IsBroken())
				active = 1
				icon_state = "portgen1"
		if(href_list["action"] == "disable")
			if (active)
				active = 0
				icon_state = "portgen0"
		if(href_list["action"] == "eject")
			if(!active)
				DropFuel()
		if(href_list["action"] == "lower_power")
			if (power_output > 1)
				power_output--
		if (href_list["action"] == "higher_power")
			if (power_output < max_power_output || (emagged && power_output < round(max_power_output*2.5)))
				power_output++

/obj/machinery/power/port_gen/pacman/super
	name = "S.U.P.E.R.P.A.C.M.A.N.-type Portable Generator"
	desc = "A power generator that utilizes uranium sheets as fuel. Can run for much longer than the standard PACMAN type generators. Rated for 80 kW max safe output."
	icon_state = "portgen1"
	sheet_path = /obj/item/stack/material/uranium
	sheet_name = "Uranium Sheets"
	time_per_sheet = 576 //same power output, but a 50 sheet stack will last 2 hours at max safe power
	circuit = /obj/item/circuitboard/pacman/super

/obj/machinery/power/port_gen/pacman/super/UseFuel()
	//produces a tiny amount of radiation when in use
	if (prob(2*power_output))
		radiation_pulse(src, RAD_INTENSITY_SUPERPACMAN)
	..()

/obj/machinery/power/port_gen/pacman/super/explode()
	//a nice burst of radiation
	var/rads = (sheets + sheet_left) * RAD_INTENSITY_SUPERPACMAN_BOOM_FACTOR
	radiation_pulse(src, rads)

	explosion(src.loc, 3, 3, 5, 3)
	qdel(src)

/obj/machinery/power/port_gen/pacman/mrs
	name = "M.R.S.P.A.C.M.A.N.-type Portable Generator"
	desc = "An advanced power generator that runs on tritium. Rated for 200 kW maximum safe output!"
	icon_state = "portgen2"
	sheet_path = /obj/item/stack/material/tritium
	sheet_name = "Tritium Fuel Sheets"

	//I don't think tritium has any other use, so we might as well make this rewarding for players
	//max safe power output (power level = 8) is 200 kW and lasts for 1 hour - 3 or 4 of these could power the station
	power_gen = 25000 //watts
	max_power_output = 10
	max_safe_output = 8
	time_per_sheet = 576
	max_temperature = 800
	temperature_gain = 90
	circuit = /obj/item/circuitboard/pacman/mrs

/obj/machinery/power/port_gen/pacman/mrs/explode()
	//no special effects, but the explosion is pretty big (same as a supermatter shard).
	explosion(src.loc, 3, 6, 12, 16, 1)
	qdel(src)

// Radioisotope Thermoelectric Generator (RTG)
// Simple power generator that would replace "magic SMES" on various derelicts.
/obj/machinery/power/rtg
	name = "radioisotope thermoelectric generator"
	desc = "A simple nuclear power generator, used in small outposts to reliably provide power for decades."
	icon = 'icons/obj/power_vr.dmi'
	icon_state = "rtg"
	density = TRUE
	use_power = USE_POWER_OFF
	circuit = /obj/item/circuitboard/machine/rtg

	// You can buckle someone to RTG, then open its panel. Fun stuff.
	buckle_allowed = TRUE
	buckle_lying = 0

	var/power_gen = 1 // Enough to power a single APC. 4000 output with T4 capacitor.
	var/irradiate = TRUE // RTGs irradiate surroundings, but only when panel is open.

/obj/machinery/power/rtg/Initialize(mapload)
	. = ..()
	if(ispath(circuit))
		circuit = new circuit(src)
	default_apply_parts()
	connect_to_network()

/obj/machinery/power/rtg/process()
	..()
	add_avail(power_gen)
	if(panel_open && irradiate)
		radiation_pulse(src, RAD_INTENSITY_RADIOISOTOPE_GEN)

/obj/machinery/power/rtg/examine(mob/user)
	. = ..()
	if(Adjacent(user, src) || isobserver(user))
		. += "<span class='notice'>The status display reads: Power generation now at <b>[power_gen]</b>kW.</span>"

/obj/machinery/power/rtg/attackby(obj/item/I, mob/user, params)
	if(default_deconstruction_screwdriver(user, I))
		return
	else if(default_deconstruction_crowbar(user, I))
		return
	return ..()

/obj/machinery/power/rtg/update_icon()
	if(panel_open)
		icon_state = "[initial(icon_state)]-open"
	else
		icon_state = initial(icon_state)

/obj/machinery/power/rtg/advanced
	desc = "An advanced RTG capable of moderating isotope decay, increasing power output but reducing lifetime. It uses plasma-fueled radiation collectors to increase output even further."
	power_gen = 1.25 // 2500 on T1, 10000 on T4.
	circuit = /obj/item/circuitboard/machine/rtg/advanced

/obj/machinery/power/rtg/fake_gen
	name = "area power generator"
	desc = "Some power generation equipment that might be powering the current area."
	icon_state = "rtg_gen"
	power_gen = 6
	circuit = /obj/item/circuitboard/machine/rtg
	buckle_allowed = FALSE

/obj/machinery/power/rtg/fake_gen/RefreshParts()
	return
/obj/machinery/power/rtg/fake_gen/attackby(obj/item/I, mob/user, params)
	return
/obj/machinery/power/rtg/fake_gen/update_icon()
	return


// Void Core, power source for Abductor ships and bases.
// Provides a lot of power, but tends to explode when mistreated.
/obj/machinery/power/rtg/abductor
	name = "Void Core"
	icon_state = "core-nocell"
	desc = "An alien power source that produces energy seemingly out of nowhere."
	circuit = /obj/item/circuitboard/machine/abductor/core
	power_gen = 10
	irradiate = FALSE // Green energy!
	buckle_allowed = FALSE
	pixel_y = 7
	var/going_kaboom = FALSE // Is it about to explode?
	var/obj/item/cell/device/weapon/recharge/alien

	var/icon_base = "core"
	var/state_change = TRUE

/obj/machinery/power/rtg/abductor/RefreshParts()
	..()
	if(!alien)
		power_gen = 0

/obj/machinery/power/rtg/abductor/proc/asplod()
	if(going_kaboom)
		return
	going_kaboom = TRUE
	visible_message("<span class='danger'>\The [src] lets out an shower of sparks as it starts to lose stability!</span>",\
		"<span class='italics'>You hear a loud electrical crack!</span>")
	playsound(src, 'sound/effects/lightningshock.ogg', 100, 1, extrarange = 5)
	tesla_zap(src, 5, power_gen * 50)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/explosion, get_turf(src), 2, 3, 4, 8), 100) // Not a normal explosion.

/obj/machinery/power/rtg/abductor/bullet_act(obj/item/projectile/Proj)
	. = ..()
	if(!going_kaboom && istype(Proj) && !Proj.nodamage && ((Proj.damage_type == BURN) || (Proj.damage_type == BRUTE)))
		log_and_message_admins("[ADMIN_LOOKUPFLW(Proj.firer)] triggered an Abductor Core explosion at [x],[y],[z] via projectile.")
		asplod()

/obj/machinery/power/rtg/abductor/attack_hand(var/mob/living/user)
	if(!istype(user) || (. = ..()))
		return

	if(alien)
		alien.forceMove(get_turf(src))
		user.put_in_active_hand(alien)
		alien = null
		state_change = TRUE
		RefreshParts()
		update_icon()
		playsound(src, 'sound/effects/metal_close.ogg', 50, 1)
		return TRUE

/obj/machinery/power/rtg/abductor/attackby(obj/item/I, mob/user, params)
	state_change = TRUE //Can't tell if parent did something
	if(istype(I, /obj/item/cell/device/weapon/recharge/alien) && !alien)
		if(!user.attempt_insert_item_for_installation(I, src))
			return
		alien = I
		RefreshParts()
		update_icon()
		playsound(src, 'sound/effects/metal_close.ogg', 50, 1)
		return
	return ..()

/obj/machinery/power/rtg/abductor/update_icon()
	if(!state_change)
		return //Stupid cells constantly update our icon so trying to be efficient

	if(alien)
		if(panel_open)
			icon_state = "[icon_base]-open"
		else
			icon_state = "[icon_base]"
	else
		icon_state = "[icon_base]-nocell"

	state_change = FALSE

/obj/machinery/power/rtg/abductor/blob_act(obj/structure/blob/B)
	asplod()

/obj/machinery/power/rtg/abductor/legacy_ex_act()
	if(going_kaboom)
		qdel(src)
	else
		asplod()

/obj/machinery/power/rtg/abductor/fire_act(exposed_temperature, exposed_volume)
	asplod()

/obj/machinery/power/rtg/abductor/tesla_act()
	..() //extend the zap
	asplod()

// Comes with an installed cell
/obj/machinery/power/rtg/abductor/built
	icon_state = "core"

/obj/machinery/power/rtg/abductor/built/Initialize(mapload)
	. = ..()
	alien = new(src)
	RefreshParts()

// Bloo version
/obj/machinery/power/rtg/abductor/hybrid
	icon_state = "coreb-nocell"
	icon_base = "coreb"
	circuit = /obj/item/circuitboard/machine/abductor/core/hybrid

/obj/machinery/power/rtg/abductor/hybrid/built
	icon_state = "coreb"

/obj/machinery/power/rtg/abductor/hybrid/built/Initialize(mapload)
	. = ..()
	alien = new /obj/item/cell/device/weapon/recharge/alien(src)
	RefreshParts()
