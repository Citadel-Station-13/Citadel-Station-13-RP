#define REACTOR_RADIATION_MULTIPLIER 200
#define BREACH_RADIATION_MULTIPLIER 1
#define REACTOR_TEMPERATURE_CUTOFF 10000
#define REACTOR_RADS_TO_MJ 10000

/obj/machinery/power/fission
	icon = 'icons/obj/machines/power/fission.dmi'
	density = 1
	anchored = 0
	name = "fission core"
	icon_state = "engine"
	var/announce = 1
	var/decay_archived = 0
	var/exploded = 0
	var/envefficiency = 0.01
	var/gasefficiency = 0.5
	var/health = 200
	var/max_health = 200
	var/warning_delay = 20
	var/meltwarned = 0
	var/lastwarning = 0
	var/cutoff_temp = 1200
	var/rod_capacity = 9
	var/mapped_in = 0
	var/repairing = 0
	// Material properties from Tungsten Carbide, otherwise core'll be too weak.
	// Material properties for the core are just it's heat exchange system, not the entire core.
	var/specific_heat = 40	// J/(mol*K)
	var/molar_mass = 0.196	// kg/mol
	var/mass = 200			// kg
	var/max_temp = 3058
	var/temperature = T20C
	var/list/obj/item/fuelrod/rods
	var/list/obj/machinery/atmospherics/pipe/pipes
	var/obj/item/radio/radio

/obj/machinery/power/fission/Initialize(mapload, newdir)
	. = ..()
	uid = gl_uid++
	rods = new()
	pipes = new()
	radio = new /obj/item/radio(src)
	radio.icon = 'icons/obj/robot_component.dmi'
	radio.icon_state = "radio"
	radio.channels = list("Engineering")

/obj/machinery/power/fission/Destroy()
	for(var/rod in rods) // assume the rods are valid.
		eject_rod(rod)
	rods = null
	pipes = null
	QDEL_NULL(radio)
	return ..()

/obj/machinery/power/fission/process(delta_time)
	var/turf/L = loc

	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but stop for now.
		return

	var/decay_heat = 0
	var/activerods = 0
	var/disabledrods = 0
	var/meltedrods = 0
	var/meltingrods = 0
	if(rods.len > 0)
		for(var/i=1,i<=rods.len,i++)
			var/obj/item/fuelrod/rod = rods[i]
			if(rod.is_melted())
				meltedrods++
			else if(rod.temperature >= rod.melting_point)
				meltingrods++
			if(cutoff_temp > 0 && rod.reflective && temperature > cutoff_temp && rod.insertion > 0)
				rod.insertion = 0
				disabledrods++
			if(rod.life > 0)
				decay_heat += rod.tick_life(decay_archived > 0 ? 1 : 0)
				if(rod.reflective)
					activerods += rod.get_insertion()
				else
					activerods -= rod.get_insertion()
		if(disabledrods > 0 && !exploded)
			radio.autosay("Core exceeded temperature bounds, and has been shut down.", "Nuclear Monitor", "Engineering")
		announce_warning(meltedrods, meltingrods, temperature >= max_temp ? 1 : 0)

	decay_archived = decay_heat
	adjust_thermal_energy(decay_heat * activerods)
	equalize(loc.return_air(), envefficiency)
	equalize_all()

	if(rods.len > 0)
		for(var/i=1,i<=rods.len,i++)
			var/obj/item/fuelrod/rod = rods[i]
			rod.equalize(src, gasefficiency)

	if(temperature > max_temp && health > 0 && max_temp > 0) // Overheating, reduce structural integrity, emit more rads.
		health = max(0, health - (temperature / max_temp))
		health = clamp( health, 0,  max_health)
		if(health < 1)
			go_nuclear()

	var/healthmul = (((health / max_health) - 1) / -1)
	var/power = (decay_heat / REACTOR_RADS_TO_MJ) * max(healthmul, 0.1)
	radiation_pulse(src, max(power * REACTOR_RADIATION_MULTIPLIER, 0), RAD_FALLOFF_ENGINE_FISSION)

/obj/machinery/power/fission/attack_hand(mob/user)
	nano_ui_interact(user)

/obj/machinery/power/fission/attack_robot(mob/user)
	nano_ui_interact(user)

/obj/machinery/power/fission/attack_ai(mob/user)
	nano_ui_interact(user)

/obj/machinery/power/fission/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1)
	if(!powered() || !anchored)
		return

	var/data = nuke_ui_data()

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "fission_engine.tmpl", "Nuclear Fission Core", 500, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/power/fission/proc/nuke_ui_data(need_power = FALSE)
	var/data[0]

	data["integrity_percentage"] = round(get_integrity())
	data["core_temp"] = round(temperature)
	data["max_temp"] = round(max_temp)
	if(need_power && !powered())
		data["powered"] = 0
	else
		if(need_power)
			data["powered"] = 1

		var/datum/gas_mixture/env = null
		if(!isnull(src.loc) && !istype(src.loc, /turf/space))
			env = src.loc.return_air()

		if(!env)
			data["ambient_temp"] = 0
			data["ambient_pressure"] = 0
		else
			data["ambient_temp"] = round(env.temperature)
			data["ambient_pressure"] = round(env.return_pressure())

		data["cutoff_point"] = cutoff_temp

		data["rods"] = new /list(rods.len)
		for(var/i=1,i<=rods.len,i++)
			var/obj/item/fuelrod/rod = rods[i]
			var/roddata[0]
			roddata["rod"] = "\ref[rod]"
			roddata["name"] = rod.name
			roddata["integrity_percentage"] = round(clamp( rod.integrity, 0,  100))
			roddata["life_percentage"] = round(clamp( rod.life, 0,  100))
			roddata["heat"] = round(rod.temperature)
			roddata["melting_point"] = rod.melting_point
			roddata["insertion"] = round(rod.insertion * 100)
			data["rods"][i] = roddata

	return data

/obj/machinery/power/fission/Topic(href,href_list)
	if(..())
		return 1
	if(exploded)
		return 1

	if(href_list["rod_eject"])
		var/obj/item/fuelrod/rod = locate(href_list["rod_eject"])
		if(istype(rod) && rod.loc == src)
			eject_rod(rod)

	if(href_list["rod_insertion"])
		var/obj/item/fuelrod/rod = locate(href_list["rod_insertion"])
		if(istype(rod) && rod.loc == src)
			var/new_insersion = input(usr,"Enter new insertion (0-100)%","Insertion control",rod.insertion * 100) as num
			rod.insertion = clamp( new_insersion / 100, 0,  1)

	if(href_list["cutoff_point"])
		var/new_cutoff = input(usr,"Enter new cutoff point in Kelvin","Cutoff point",cutoff_temp) as num
		cutoff_temp = clamp( new_cutoff, 0,  max_temp)
		if(cutoff_temp == 0)
			message_admins("[key_name(usr)] switched off auto shutdown on [src]",0,1)
			log_game("[src] auto shutdown was switched off by [key_name(usr)]")

	usr.set_machine(src)
	src.add_fingerprint(usr)

/obj/machinery/power/fission/attackby(obj/item/W , mob/user)
	add_fingerprint(user)
	if(exploded)
		return ..()

	if(!anchored && !W.is_wrench())
		return ..()

	if(repairing)
		to_chat(user, "<span class='warning'>\The [src] is being repaired!</span>")
		return

	if(istype(W, /obj/item/multitool))
		to_chat(user, "<span class='notice'>You connect \the [src] to \the [W].</span>")
		var/obj/item/multitool/M = W
		M.connectable = src
		return

	if(istype(W, /obj/item/fuelrod))
		if(rods.len >= rod_capacity)
			to_chat(user, "<span class='notice'>Looks like \the [src] is full.</span>")
		else
			var/obj/item/fuelrod/rod = W
			if(rod.is_melted())
				to_chat(user, "<span class='notice'>That's probably a bad idea.</span>")
				return
			user.visible_message("[user.name] carefully starts to load \the [W] into to \the [src].", \
				"You carefully start loading \the [W] into to \the [src].", \
				"You hear a metallic rattling.")
			if(do_after(user, 20))
				if(!user.attempt_insert_item_for_installation(rod, src))
					return
				rods += rod
				rod.insertion = 0
		return

	if(W.is_wirecutter()) // Wirecutters? Sort of like prongs, for removing a rod. Good luck getting a 20kg fuel rod out with wirecutters though.
		if(rods.len == 0)
			to_chat(user, "<span class='notice'>There's nothing left to remove.</span>")
			return
		for(var/obj/item/fuelrod/rod in rods)
			if(rod.health == 0 || rod.life == 0)
				to_chat(user, "<span class='notice'>You carefully start removing \the [rod] from \the [src].</span>")
				if(do_after(user, 40))
					eject_rod(rod)
				return
		var/obj/item/fuelrod/rod = rods[rods.len]
		to_chat(user, "<span class='notice'>You carefully start removing \the [rod] from \the [src].</span>")
		if(do_after(user, 40))
			eject_rod(rod)
		return

	if(istype(W, /obj/item/weldingtool) && health < max_health)
		var/obj/item/weldingtool/WT = W
		if(!WT.remove_fuel(0, user))
			to_chat(user, "<span class='warning'>\The [WT] must be on to complete this task.</span>")
			return
		repairing = 1
		playsound(src.loc, WT.tool_sound, 50, 1)
		user.visible_message("<span class='warning'>\The [user.name] begins repairing \the [src].</span>", \
			"<span class='notice'>You start repairing \the [src].</span>")
		if(do_after(user, 20 * WT.tool_speed, target = src) && WT.isOn())
			health = clamp( health + 10, 1,  max_health)
		repairing = 0
		return

	if(!W.is_wrench())
		return ..()

	if(anchored && rods.len > 0)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], while it contains fuel rods.</span>")
		return 1

	playsound(src, W.tool_sound, 75, 1)
	if(!anchored || do_after(user, 40 * W.tool_speed))
		anchor()
		user.visible_message("\The [user.name] [anchored ? "secures" : "unsecures"] the bolts holding \the [src.name] to the floor.", \
				"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
				"You hear a ratchet.")

/obj/machinery/power/fission/proc/equalize(datum/gas_mixture/env, var/efficiency)
	var/datum/gas_mixture/sharer = env.remove(efficiency * env.total_moles)
	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	if((abs(temperature-sharer.temperature)>MINIMUM_MEANINGFUL_TEMPERATURE_DELTA) && our_heatcap + share_heatcap)
		var/new_temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
		temperature += (new_temperature - temperature)
		temperature = clamp( temperature, 0,  REACTOR_TEMPERATURE_CUTOFF)
		sharer.temperature += (new_temperature - sharer.temperature)
		sharer.temperature = clamp( sharer.temperature, 0,  REACTOR_TEMPERATURE_CUTOFF)

	env.merge(sharer)

/obj/machinery/power/fission/proc/equalize_all()
	var/our_heatcap = heat_capacity()
	var/total_heatcap = our_heatcap
	var/total_energy = temperature * our_heatcap
	for(var/i=1,i<=pipes.len,i++)
		var/obj/machinery/atmospherics/pipe/pipe = pipes[i]
		if(istype(pipe, /obj/machinery/atmospherics/pipe))
			var/datum/gas_mixture/env = pipe.return_air()
			if(!isnull(env))
				var/datum/gas_mixture/removed = env.remove(gasefficiency * env.total_moles)
				var/env_heatcap = env.heat_capacity()
				total_heatcap += env_heatcap
				total_energy += (env.temperature * env_heatcap)
				env.merge(removed)

	if(!total_heatcap)
		return
	var/new_temperature = total_energy / total_heatcap
	temperature += (new_temperature - temperature) * gasefficiency // Add efficiency here, since there's no gas.remove for non-gas objects.
	temperature = clamp( temperature, 0,  REACTOR_TEMPERATURE_CUTOFF)

	for(var/i=1,i<=pipes.len,i++)
		var/obj/machinery/atmospherics/pipe/pipe = pipes[i]
		if(istype(pipe, /obj/machinery/atmospherics/pipe))
			var/datum/gas_mixture/env = pipe.return_air()
			if(!isnull(env))
				var/datum/gas_mixture/removed = env.remove(gasefficiency * env.total_moles)
				if(!isnull(removed))
					removed.temperature += (new_temperature - removed.temperature)
					removed.temperature = clamp( removed.temperature, 0,  REACTOR_TEMPERATURE_CUTOFF)
				env.merge(removed)

/obj/machinery/power/fission/adjust_thermal_energy(var/thermal_energy)
	if(mass < 1)
		return 0

	var/heat_capacity = heat_capacity()
	if(thermal_energy < 0)
		if(temperature < TCMB)
			return 0
		var/thermal_energy_limit = -(temperature - TCMB)*heat_capacity	//ensure temperature does not go below TCMB
		thermal_energy = max(thermal_energy, thermal_energy_limit)	//thermal_energy and thermal_energy_limit are negative here.
	temperature += thermal_energy/heat_capacity
	return thermal_energy

/obj/machinery/power/fission/proc/heat_capacity()
	. = specific_heat * (mass / molar_mass)

/obj/machinery/power/fission/proc/get_integrity()
	var/integrity = round(health / max_health * 100)
	integrity = integrity < 0 ? 0 : integrity
	return integrity

/obj/machinery/power/fission/proc/eject_rod(var/obj/item/fuelrod/rod)
	if(!istype(rod) || rod.loc != src)
		return
	rods -= rod
	rod.loc = src.loc
	rod.insertion = 0

	if(meltwarned)
		var/melted = 0
		for(var/i=1,i<=rods.len,i++)
			melted += rods[i].is_melted()
		if(melted == 0)
			meltwarned = 0

/obj/machinery/power/fission/proc/anchor()
	if(!anchored)
		anchored = 1
		var/list/datum/pipeline/pipelines = new()
		for(var/obj/machinery/atmospherics/pipe/simple/pipe in loc)
			if (!(pipe.parent in pipelines))
				pipes += pipe
				pipelines += pipe.parent
		for(var/obj/machinery/atmospherics/pipe/manifold/pipe in loc)
			if (!(pipe.parent in pipelines))
				pipes += pipe
				pipelines += pipe.parent
		for(var/obj/machinery/atmospherics/pipe/manifold4w/pipe in loc)
			if (!(pipe.parent in pipelines))
				pipes += pipe
				pipelines += pipe.parent
		for(var/obj/machinery/atmospherics/pipe/cap/pipe in loc)
			if (!(pipe.parent in pipelines))
				pipes += pipe
				pipelines += pipe.parent
	else
		anchored = 0
		pipes = new()

/obj/machinery/power/fission/proc/announce_warning(var/meltedrods, var/meltingrods, var/core_overheat)
	if(src.powered() && !exploded && (meltedrods > 0 || meltingrods > 0 || temperature >= max_temp))
		var/location = sanitize((get_area(src)).name)
		if((world.timeofday - lastwarning) >= warning_delay * 10)
			lastwarning = world.timeofday
			if(core_overheat)
				radio.autosay("Danger! Fission core at [location] is overheating!", "Nuclear Monitor")
			else if(meltedrods > 0 && meltingrods > 0)
				radio.autosay("Warning! [meltedrods] rods have melted and [meltingrods] are overheating!", "Nuclear Monitor", "Engineering")
			else if(meltedrods > 0)
				if(meltedrods == 1)
					radio.autosay("Warning! A rod has melted!", "Nuclear Monitor", "Engineering")
				else
					radio.autosay("Warning! [meltedrods] rods have melted!", "Nuclear Monitor", "Engineering")
			else if(meltingrods > 0)
				if(meltingrods == 1)
					radio.autosay("Warning! A rod is overheating!", "Nuclear Monitor", "Engineering")
				else
					radio.autosay("Warning! [meltingrods] rods are overheating!", "Nuclear Monitor", "Engineering")

/obj/machinery/power/fission/proc/go_nuclear()
	if(health < 1 && !exploded)
		var/off_station = 0
		if(!(src.z in GLOB.using_map.station_levels))
			off_station = 1
		var/turf/L = get_turf(src)
		if(!istype(L))
			return
		message_admins("[name] exploding in 15 seconds at ([L.x],[L.y],[L.z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[L.x];Y=[L.y];Z=[L.z]'>JMP</a>)",0,1)
		log_game("[name] exploded at ([L.x],[L.y],[L.z])")
		exploded = 1
		if(!anchored)
			anchor()
		var/decaying_rods = 0
		var/decay_heat = 0
		for(var/obj/item/fuelrod/rod in rods)
			if(rod.life > 0 && rod.decay_heat > 0)
				decay_heat += rod.tick_life()
				decaying_rods++
			rod.meltdown()
		var/rad_power = decay_heat / REACTOR_RADS_TO_MJ
		if(announce)
			var/sound = sound('sound/effects/nuclear_meltdown.ogg')
			if(!off_station)
				for(var/mob/M in GLOB.player_list)
					SEND_SOUND(M,sound)
			spawn(1 SECONDS)
				radio.autosay("DANGER! FISSION CORE HAS BREACHED!", "Nuclear Monitor")
				radio.autosay("FIND SHELTER IMMEDIATELY!", "Nuclear Monitor")
			spawn(5 SECONDS)
				radio.autosay("CORE BREACH! FIND SHELTER IMMEDIATELY!", "Nuclear Monitor")
			spawn(10 SECONDS)
				radio.autosay("CORE BREACH! FIND SHELTER IMMEDIATELY!", "Nuclear Monitor")

		// Give the alarm time to play. Then... FLASH! AH-AH!
		spawn(15 SECONDS)
			z_radiation(get_turf(src), null, rad_power * BREACH_RADIATION_MULTIPLIER / RAD_MOB_ACT_COEFFICIENT, RAD_FALLOFF_ZLEVEL_FISSION_MELTDOWN)

		// Some engines just want to see the world burn.
		spawn(17 SECONDS)
			for(var/obj/item/fuelrod/rod in rods)
				rod.forceMove(L)
			rods.Cut()
			pipes.Cut()
			empulse(src, decaying_rods * 10, decaying_rods * 100)
			var/explosion_power = 4 * decaying_rods
			if(explosion_power < 1) // If you remove the rods but it's over heating, it's still gunna go bang, but without going nuclear.
				explosion_power = 1
			explosion(L, explosion_power, explosion_power * 2, explosion_power * 3, explosion_power * 4, 1)
/*
You're stupid.
I'm commenting this out until I have time to make this less stupid.
			if(L.z == 13) // underdark z but hardcoded
				now_you_done_it(L)

/obj/machinery/power/fission/proc/now_you_done_it(var/turf/L)
	sleep(3 SECONDS)
	if (!istype(L))
		return
	var/tx = L.x - 3
	var/ty = L.y - 3
	var/turf/spider_spawn
	for(var/iy = 0, iy < 6, iy++)
		for(var/ix = 0, ix < 6, ix++)
			spider_spawn = locate(tx + ix, ty + iy, L.z)
			if (!istype(spider_spawn, /turf/space))
				for (var/i = 0, i < rand(1,3), i++)
					var/a_problem = /obj/nuclear_mistake_spawner
					new a_problem(spider_spawn)
*/

// i know this really shouldn't be the place to put all the code to this but travis is bitching out at me
// see Citadel-Station-13/Citadel-Station-13-RP#2039 for why i had to shove all this in here
// code from _tether_submaps.dm, only pasted here for travis "compliance"
// fuck this
/obj/nuclear_mistake_spawner
	name = "the Underdark's revenge"
	desc = "hardcoded piece of that that should never be seen PLEASE report this if you do"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"
	invisibility = 101
	mouse_opacity = 0
	density = 0
	anchored = 1

	//Weighted with values (not %chance, but relative weight)
	//Can be left value-less for all equally likely
	var/list/mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/giant_spider/hunter = 3,
		/mob/living/simple_mob/animal/giant_spider/webslinger = 5,
		/mob/living/simple_mob/animal/giant_spider/carrier = 5,
		/mob/living/simple_mob/animal/giant_spider/lurker = 4,
		/mob/living/simple_mob/animal/giant_spider/tunneler = 5,
		/mob/living/simple_mob/animal/giant_spider/pepper = 2,
		/mob/living/simple_mob/animal/giant_spider/thermic = 5,
		/mob/living/simple_mob/animal/giant_spider/electric = 3,
		/mob/living/simple_mob/animal/giant_spider/phorogenic = 2,
		/mob/living/simple_mob/animal/giant_spider/frost = 4,
		/mob/living/simple_mob/vore/aggressive/rat/phoron = 4
	)
	//When the below chance fails, the spawner is marked as depleted and stops spawning
	var/prob_spawn = 100	//Chance of spawning a mob whenever they don't have one
	var/prob_fall = 25		//Above decreases by this much each time one spawns

	//Settings to help mappers/coders have their mobs do what they want in this case
	var/faction	= "spiders"			//To prevent infighting if it spawns various mobs, set a faction
	var/atmos_comp = TRUE			//TRUE will set all their survivability to be within 20% of the current air

	//Internal use only
	var/mob/living/simple_mob/my_mob
	var/depleted = FALSE

/obj/nuclear_mistake_spawner/Initialize(mapload)
	. = ..()

	if(!LAZYLEN(mobs_to_pick_from))
		log_world("Mob spawner at [x],[y],[z] ([get_area(src)]) had no mobs_to_pick_from set on it!")
		return INITIALIZE_HINT_QDEL
	START_PROCESSING(SSobj, src)

/obj/nuclear_mistake_spawner/process(delta_time)
	if(my_mob && my_mob.stat != DEAD)
		return //No need

	if(LAZYLEN(loc.human_mobs(world.view)))
		return //I'll wait.

	if(prob(prob_spawn))
		prob_spawn -= prob_fall
		var/picked_type = pickweight(mobs_to_pick_from)
		my_mob = new picked_type(get_turf(src))
		my_mob.low_priority = TRUE

		if(faction)
			my_mob.faction = faction

		if(atmos_comp)
			var/turf/T = get_turf(src)
			var/datum/gas_mixture/env = T.return_air()
			if(env)
				my_mob.minbodytemp = env.temperature * 0.8
				my_mob.maxbodytemp = env.temperature * 1.2

				var/list/gaslist = env.gas
				my_mob.min_oxy = gaslist[/datum/gas/oxygen] * 0.8
				my_mob.min_tox = gaslist[/datum/gas/phoron] * 0.8
				my_mob.min_n2 = gaslist[/datum/gas/nitrogen] * 0.8
				my_mob.min_co2 = gaslist[/datum/gas/carbon_dioxide] * 0.8
				my_mob.max_oxy = gaslist[/datum/gas/oxygen] * 1.2
				my_mob.max_tox = gaslist[/datum/gas/phoron] * 1.2
				my_mob.max_n2 = gaslist[/datum/gas/nitrogen] * 1.2
				my_mob.max_co2 = gaslist[/datum/gas/carbon_dioxide] * 1.2
		return
	else
		STOP_PROCESSING(SSobj, src)
		depleted = TRUE
		return
