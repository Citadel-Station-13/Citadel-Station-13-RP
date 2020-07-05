/*

Making Bombs with ZAS:
Get gas to react in an air tank so that it gains pressure. If it gains enough pressure, it goes boom.
The more pressure, the more boom.
If it gains pressure too slowly, it may leak or just rupture instead of exploding.
*/

//#define FIREDBG

/turf/var/obj/fire/fire = null

//Some legacy definitions so fires can be started.
atom/proc/temperature_expose(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	return null


turf/proc/hotspot_expose(exposed_temperature, exposed_volume, soh = 0)


/turf/simulated/hotspot_expose(exposed_temperature, exposed_volume, soh)
	if(fire_protection > world.time-300)
		return 0
	if(locate(/obj/fire) in src)
		return 1
	var/datum/gas_mixture/air_contents = return_air()
	if(!air_contents || exposed_temperature < PHORON_MINIMUM_BURN_TEMPERATURE)
		return 0

	var/igniting = 0
	var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in src

	if(air_contents.check_combustability(liquid))
		igniting = 1

		create_fire(exposed_temperature)
	return igniting

/zone/proc/process_fire()
	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/consumption_rate, consumption_rate)
	var/datum/gas_mixture/burn_gas = air.remove_ratio(consumption_rate, fire_tiles.len)

	var/firelevel = burn_gas.zburn(src, fire_tiles, force_burn = 1, no_check = 1)

	air.merge(burn_gas)

	if(firelevel)
		for(var/turf/T in fire_tiles)
			if(T.fire)
				T.fire.firelevel = firelevel
			else
				var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in T
				fire_tiles -= T
				fuel_objs -= fuel
	else
		for(var/turf/simulated/T in fire_tiles)
			if(istype(T.fire))
				T.fire.RemoveFire()
			T.fire = null
		fire_tiles.Cut()
		fuel_objs.Cut()

	if(!fire_tiles.len)
		air_master.active_fire_zones.Remove(src)

/zone/proc/remove_liquidfuel(var/used_liquid_fuel, var/remove_fire=0)
	if(!fuel_objs.len)
		return

	//As a simplification, we remove fuel equally from all fuel sources. It might be that some fuel sources have more fuel,
	//some have less, but whatever. It will mean that sometimes we will remove a tiny bit less fuel then we intended to.

	var/fuel_to_remove = used_liquid_fuel/(fuel_objs.len*LIQUIDFUEL_AMOUNT_TO_MOL) //convert back to liquid volume units

	for(var/O in fuel_objs)
		var/obj/effect/decal/cleanable/liquid_fuel/fuel = O
		if(!istype(fuel))
			fuel_objs -= fuel
			continue

		fuel.amount -= fuel_to_remove
		if(fuel.amount <= 0)
			fuel_objs -= fuel
			if(remove_fire)
				var/turf/T = fuel.loc
				if(istype(T) && T.fire) qdel(T.fire)
			qdel(fuel)

/turf/proc/create_fire(fl)
	return 0

/turf/simulated/create_fire(fl)
	if(fire)
		fire.firelevel = max(fl, fire.firelevel)
		return 1

	if(!zone)
		return 1

	fire = new(src, fl)
	air_master.active_fire_zones |= zone

	var/obj/effect/decal/cleanable/liquid_fuel/fuel = locate() in src
	zone.fire_tiles |= src
	if(fuel) zone.fuel_objs += fuel

	return 0

/obj/fire
	//Icon for fire on turfs.

	anchored = 1
	mouse_opacity = 0

	blend_mode = BLEND_ADD

	icon = 'icons/effects/fire.dmi'
	icon_state = "1"
	light_color = "#ED9200"
	layer = TURF_LAYER

	var/firelevel = 1 //Calculated by gas_mixture.calculate_firelevel()

/obj/fire/process()
	. = 1

	var/turf/simulated/my_tile = loc
	if(!istype(my_tile) || !my_tile.zone)
		if(my_tile.fire == src)
			my_tile.fire = null
		RemoveFire()
		return 1

	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/firelevel_multiplier, firelevel_multiplier)
	var/datum/gas_mixture/air_contents = my_tile.return_air()

	if(firelevel > 6)
		icon_state = "3"
		set_light(7, 3)
	else if(firelevel > 2.5)
		icon_state = "2"
		set_light(5, 2)
	else
		icon_state = "1"
		set_light(3, 1)

	for(var/mob/living/L in loc)
		L.FireBurn(firelevel, air_contents.temperature, air_contents.return_pressure())  //Burn the mobs!

	loc.fire_act(air_contents, air_contents.temperature, air_contents.volume)
	for(var/atom/A in loc)
		A.fire_act(air_contents, air_contents.temperature, air_contents.volume)

	//spread
	for(var/direction in GLOB.cardinals)
		var/turf/simulated/enemy_tile = get_step(my_tile, direction)

		if(istype(enemy_tile))
			if(my_tile.open_directions & direction) //Grab all valid bordering tiles
				if(!enemy_tile.zone || enemy_tile.fire)
					continue

				//if(!enemy_tile.zone.fire_tiles.len) TODO - optimize
				var/datum/gas_mixture/acs = enemy_tile.return_air()
				var/obj/effect/decal/cleanable/liquid_fuel/liquid = locate() in enemy_tile
				if(!acs || !acs.check_combustability(liquid))
					continue

				//If extinguisher mist passed over the turf it's trying to spread to, don't spread and
				//reduce firelevel.
				if(enemy_tile.fire_protection > world.time-30)
					firelevel -= 1.5
					continue

				//Spread the fire.
				if(prob( 50 + 50 * (firelevel/firelevel_multiplier) ) && my_tile.CanZASPass(enemy_tile) && enemy_tile.CanZASPass(my_tile))
					enemy_tile.create_fire(firelevel)

			else
				enemy_tile.adjacent_fire_act(loc, air_contents, air_contents.temperature, air_contents.volume)

	animate(src, color = fire_color(air_contents.temperature), 5)
	set_light(l_color = color)

/obj/fire/New(newLoc,fl)
	..()

	if(!istype(loc, /turf))
		qdel(src)
		return

	setDir(pick(GLOB.cardinals))

	var/datum/gas_mixture/air_contents = loc.return_air()
	color = fire_color(air_contents.temperature)
	set_light(3, 1, color)

	firelevel = fl
	air_master.active_hotspots.Add(src)

/obj/fire/proc/fire_color(env_temperature)
	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/firelevel_multiplier, firelevel_multiplier)
	var/temperature = max(4000*sqrt(firelevel/firelevel_multiplier), env_temperature)
	return heat2colour(temperature)

/obj/fire/Destroy()
	RemoveFire()

	..()

/obj/fire/proc/RemoveFire()
	var/turf/T = loc
	if (istype(T))
		set_light(0)

		T.fire = null
		loc = null
	air_master.active_hotspots.Remove(src)


/turf/simulated/var/fire_protection = 0 //Protects newly extinguished tiles from being overrun again.
/turf/proc/apply_fire_protection()
/turf/simulated/apply_fire_protection()
	fire_protection = world.time



/mob/living/proc/FireBurn(var/firelevel, var/last_temperature, var/pressure)
	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/firelevel_multiplier, firelevel_multiplier)
	var/mx = 5 * firelevel/firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)
	apply_damage(2.5*mx, BURN)


/mob/living/carbon/human/FireBurn(var/firelevel, var/last_temperature, var/pressure)
	//Burns mobs due to fire. Respects heat transfer coefficients on various body parts.
	//Due to TG reworking how fireprotection works, this is kinda less meaningful.

	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/firelevel_multiplier, firelevel_multiplier)

	var/head_exposure = 1
	var/chest_exposure = 1
	var/groin_exposure = 1
	var/legs_exposure = 1
	var/arms_exposure = 1

	//Get heat transfer coefficients for clothing.

	for(var/obj/item/clothing/C in src)
		if(item_is_in_hands(C))
			continue

		if( C.max_heat_protection_temperature >= last_temperature )
			if(C.body_parts_covered & HEAD)
				head_exposure = 0
			if(C.body_parts_covered & UPPER_TORSO)
				chest_exposure = 0
			if(C.body_parts_covered & LOWER_TORSO)
				groin_exposure = 0
			if(C.body_parts_covered & LEGS)
				legs_exposure = 0
			if(C.body_parts_covered & ARMS)
				arms_exposure = 0
	//minimize this for low-pressure enviroments
	var/mx = 5 * firelevel/firelevel_multiplier * min(pressure / ONE_ATMOSPHERE, 1)

	//Always check these damage procs first if fire damage isn't working. They're probably what's wrong.

	apply_damage(2.5*mx*head_exposure,  BURN, BP_HEAD,  0, 0, "Fire")
	apply_damage(2.5*mx*chest_exposure, BURN, BP_TORSO, 0, 0, "Fire")
	apply_damage(2.0*mx*groin_exposure, BURN, BP_GROIN, 0, 0, "Fire")
	apply_damage(0.6*mx*legs_exposure,  BURN, BP_L_LEG, 0, 0, "Fire")
	apply_damage(0.6*mx*legs_exposure,  BURN, BP_R_LEG, 0, 0, "Fire")
	apply_damage(0.4*mx*arms_exposure,  BURN, BP_L_ARM, 0, 0, "Fire")
	apply_damage(0.4*mx*arms_exposure,  BURN, BP_R_ARM, 0, 0, "Fire")
