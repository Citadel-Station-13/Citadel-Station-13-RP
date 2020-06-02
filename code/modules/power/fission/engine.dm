#define REACTOR_RADIATION_MULTIPLIER 20
#define BREACH_RADIATION_MULTIPLIER 0.1
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
	var/cutoff_temp = 600
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

/obj/machinery/power/fission/New()
	. = ..()
	rods = new()
	pipes = new()
	radio = new /obj/item/radio{channels=list("Engineering")
		icon = 'icons/obj/robot_component.dmi'
		icon_state = "radio"}(src)
	if(mapped_in)
		anchor()

/obj/machinery/power/fission/Destroy()
	for(var/i=1,i<=rods.len,i++)
		eject_rod(rods[i])
	rods = null
	pipes = null
	qdel(radio)
	. = ..()

/obj/machinery/power/fission/process()
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
	add_thermal_energy(decay_heat * activerods)
	equalize(loc.return_air(), envefficiency)
	equalize_all()

	if(rods.len > 0)
		for(var/i=1,i<=rods.len,i++)
			var/obj/item/fuelrod/rod = rods[i]
			rod.equalize(src, gasefficiency)

	if(temperature > max_temp && health > 0 && max_temp > 0) // Overheating, reduce structural integrity, emit more rads.
		health = max(0, health - (temperature / max_temp))
		health = between(0, health, max_health)
		if(health < 1)
			go_nuclear()

	var/healthmul = (((health / max_health) - 1) / -1)
	var/power = (decay_heat / REACTOR_RADS_TO_MJ) * max(healthmul, 0.1)
	SSradiation.radiate(src, max(power * REACTOR_RADIATION_MULTIPLIER, 0))

/obj/machinery/power/fission/attack_hand(mob/user as mob)
	ui_interact(user)

/obj/machinery/power/fission/attack_robot(mob/user as mob)
	ui_interact(user)

/obj/machinery/power/fission/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/power/fission/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	if(!src.powered())
		return

	var/data[0]

	data["integrity_percentage"] = round(get_integrity())
	var/datum/gas_mixture_old/env = null
	if(!isnull(src.loc) && !istype(src.loc, /turf/space))
		env = src.loc.return_air()

	if(!env)
		data["ambient_temp"] = 0
		data["ambient_pressure"] = 0
	else
		data["ambient_temp"] = round(env.temperature)
		data["ambient_pressure"] = round(env.return_pressure())

	data["core_temp"] = round(temperature)
	data["max_temp"] = round(max_temp)
	data["cutoff_point"] = cutoff_temp

	data["rods"] = new /list(rods.len)
	for(var/i=1,i<=rods.len,i++)
		var/obj/item/fuelrod/rod = rods[i]
		var/roddata[0]
		roddata["rod"] = "\ref[rod]"
		roddata["name"] = rod.name
		roddata["integrity_percentage"] = round(between(0, rod.integrity, 100))
		roddata["life_percentage"] = round(between(0, rod.life, 100))
		roddata["heat"] = round(rod.temperature)
		roddata["melting_point"] = rod.melting_point
		roddata["insertion"] = round(rod.insertion * 100)
		data["rods"][i] = roddata

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "fission_engine.tmpl", "Nuclear Fission Core", 500, 600)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/power/fission/Topic(href,href_list)
	if(..())
		return 1
	if(exploded)
		return 1

	if(href_list["rod_eject"])
		var/obj/item/fuelrod/rod = locate(href_list["rod_eject"])
		if(istype(rod))
			eject_rod(rod)

	if(href_list["rod_insertion"])
		var/obj/item/fuelrod/rod = locate(href_list["rod_insertion"])
		if(istype(rod) && rod.loc == src)
			var/new_insersion = input(usr,"Enter new insertion (0-100)%","Insertion control",rod.insertion * 100) as num
			rod.insertion = between(0, new_insersion / 100, 1)

	if(href_list["cutoff_point"])
		var/new_cutoff = input(usr,"Enter new cutoff point in Kelvin","Cutoff point",cutoff_temp) as num
		cutoff_temp = between(0, new_cutoff, max_temp)
		if(cutoff_temp == 0)
			message_admins("[key_name(usr)] switched off auto shutdown on [src]",0,1)
			log_game("[src] auto shutdown was switched off by [key_name(usr)]")

	usr.set_machine(src)
	src.add_fingerprint(usr)

/obj/machinery/power/fission/attackby(var/obj/item/W as obj, var/mob/user as mob)
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
			if(do_after(user, 40))
				user.drop_from_inventory(rod)
				rod.loc = src
				rods += rod

				rod.insertion = 0
		return

	if(W.is_wirecutter()) // Wirecutters? Sort of like prongs, for removing a rod. Good luck getting a 20kg fuel rod out with wirecutters though.
		if(rods.len == 0)
			to_chat(user, "<span class='notice'>There's nothing left to remove.</span>")
			return
		for(var/i=1,i<=rods.len,i++)
			var/obj/item/fuelrod/rod = rods[i]
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
		playsound(src.loc, WT.usesound, 50, 1)
		user.visible_message("<span class='warning'>\The [user.name] begins repairing \the [src].</span>", \
			"<span class='notice'>You start repairing \the [src].</span>")
		if(do_after(user, 20 * WT.toolspeed, target = src) && WT.isOn())
			health = between(1, health + 10, max_health)
		repairing = 0
		return

	if(!W.is_wrench())
		return ..()

	if(anchored && rods.len > 0)
		to_chat(user, "<span class='warning'>You cannot unwrench \the [src], while it contains fuel rods.</span>")
		return 1

	playsound(src, W.usesound, 75, 1)
	if(!anchored || do_after(user, 40 * W.toolspeed))
		anchor()
		user.visible_message("\The [user.name] [anchored ? "secures" : "unsecures"] the bolts holding \the [src.name] to the floor.", \
				"You [anchored ? "secure" : "unsecure"] the bolts holding [src] to the floor.", \
				"You hear a ratchet.")

/obj/machinery/power/fission/proc/equalize(datum/gas_mixture_old/env, var/efficiency)
	var/datum/gas_mixture_old/sharer = env.remove(efficiency * env.total_moles)
	var/our_heatcap = heat_capacity()
	var/share_heatcap = sharer.heat_capacity()

	if((abs(temperature-sharer.temperature)>MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER) && our_heatcap + share_heatcap)
		var/new_temperature = ((temperature * our_heatcap) + (sharer.temperature * share_heatcap)) / (our_heatcap + share_heatcap)
		temperature += (new_temperature - temperature)
		temperature = between(0, temperature, REACTOR_TEMPERATURE_CUTOFF)
		sharer.temperature += (new_temperature - sharer.temperature)
		sharer.temperature = between(0, sharer.temperature, REACTOR_TEMPERATURE_CUTOFF)

	env.merge(sharer)

/obj/machinery/power/fission/proc/equalize_all()
	var/our_heatcap = heat_capacity()
	var/total_heatcap = our_heatcap
	var/total_energy = temperature * our_heatcap
	for(var/i=1,i<=pipes.len,i++)
		var/obj/machinery/atmospherics/pipe/pipe = pipes[i]
		if(istype(pipe, /obj/machinery/atmospherics/pipe))
			var/datum/gas_mixture_old/env = pipe.return_air()
			if(!isnull(env))
				var/datum/gas_mixture_old/removed = env.remove(gasefficiency * env.total_moles)
				var/env_heatcap = env.heat_capacity()
				total_heatcap += env_heatcap
				total_energy += (env.temperature * env_heatcap)
				env.merge(removed)

	if(!total_heatcap)
		return
	var/new_temperature = total_energy / total_heatcap
	temperature += (new_temperature - temperature) * gasefficiency // Add efficiency here, since there's no gas.remove for non-gas objects.
	temperature = between(0, temperature, REACTOR_TEMPERATURE_CUTOFF)

	for(var/i=1,i<=pipes.len,i++)
		var/obj/machinery/atmospherics/pipe/pipe = pipes[i]
		if(istype(pipe, /obj/machinery/atmospherics/pipe))
			var/datum/gas_mixture_old/env = pipe.return_air()
			if(!isnull(env))
				var/datum/gas_mixture_old/removed = env.remove(gasefficiency * env.total_moles)
				if(!isnull(removed))
					removed.temperature += (new_temperature - removed.temperature)
					removed.temperature = between(0, removed.temperature, REACTOR_TEMPERATURE_CUTOFF)
				env.merge(removed)

/obj/machinery/power/fission/proc/add_thermal_energy(var/thermal_energy)
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
		if((world.timeofday - lastwarning) >= warning_delay * 10)
			lastwarning = world.timeofday
			if(core_overheat)
				radio.autosay("Danger! Fission core is overheating!", "Nuclear Monitor")
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
		for(var/i=1,i<=rods.len,i++)
			var/obj/item/fuelrod/rod = rods[i]
			if(rod.life > 0 && rod.decay_heat > 0)
				decay_heat += rod.tick_life()
				decaying_rods++
			rod.meltdown()
		var/rad_power = decay_heat / REACTOR_RADS_TO_MJ
		if(announce)
			var/sound = sound('sound/effects/carter_alarm_cut.ogg')
			for(var/a in player_list)
				var/mob/M = a
				var/turf/T = get_turf(M)
				if(T.z == L.z)
					M.playsound_local(T, soundin = sound, vol = 50, vary = FALSE, is_global = TRUE)
			spawn(1 SECONDS)
				radio.autosay("Danger! Fission core has breached!", "Nuclear Monitor")
				radio.autosay("Find shelter immediately!", "Nuclear Monitor")
			spawn(5 SECONDS)
				radio.autosay("Core breach! Find shelter immediately!", "Nuclear Monitor")
			spawn(10 SECONDS)
				radio.autosay("Core breach! Find shelter immediately!", "Nuclear Monitor")

		// Give the alarm time to play. Then... FLASH! AH-AH!
		spawn(15 SECONDS)
			SSradiation.z_radiate(locate(1, 1, L.z), rad_power * BREACH_RADIATION_MULTIPLIER, 1)
			for(var/mob/living/mob in living_mob_list)
				var/turf/T = get_turf(mob)
				if(T && (L.z == T.z))
					var/root_distance = sqrt(1 / (get_dist(mob, src) + 1))
					var/rads = rad_power * root_distance
					if(mob.loc != T) // Not on turf, ergo, sheltered.
						rads = rads / 2
					var/eye_safety = 3 // Don't stun unless they have the correct eye organs.
					if(iscarbon(mob))
						var/mob/living/carbon/M = mob
						eye_safety = M.eyecheck()
					if(eye_safety < 3) // You've got a welding helmet over sunglasses? Congratulations, you're not blind.
						mob.Stun(2)
						mob.Weaken(10)
						mob.flash_eyes()
					if(istype(mob, /mob/living/carbon/human))
						var/mob/living/carbon/human/H = mob
						if(eye_safety < 2)
							var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
							if(istype(E))
								E.damage += root_distance * 100
								if(E.damage >= E.min_broken_damage)
									to_chat(H, "<span class='danger'>You are blinded by the flash!</span>")
									H.sdisabilities |= BLIND
								else if(E.damage >= E.min_bruised_damage)
									to_chat(H, "<span class='danger'>You are blinded by the flash!</span>")
									H.eye_blind = 5
									H.eye_blurry = 5
								else if(E.damage > 10)
									to_chat(H, "<span class='warning'>Your eyes burn.</span>")
						if(!H.isSynthetic())
							H.radiation += max(rads / 10, 0) // Not even a radsuit can save you now.
						H.apply_damage(max((rads / 10) * H.species.radiation_mod, 0), BURN) // Flash burns

		// Some engines just want to see the world burn.
		spawn(17 SECONDS)
			for(var/i=1,i<=rods.len,i++)
				var/obj/item/fuelrod/rod = rods[i]
				rod.loc = L
				rods = new()
				pipes = new()
			empulse(src, decaying_rods * 10, decaying_rods * 100)
			var/explosion_power = 4 * decaying_rods
			if(explosion_power < 1) // If you remove the rods but it's over heating, it's still gunna go bang, but without going nuclear.
				explosion_power = 1
			explosion(L, explosion_power, explosion_power * 2, explosion_power * 3, explosion_power * 4, 1)
