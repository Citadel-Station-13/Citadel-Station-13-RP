/datum/reagent/firefighting_foam
	name = "Firefighting Foam"
	id = "firefoam"
	description = "A historical fire suppressant. Originally believed to simply displace oxygen to starve fires, it actually interferes with the combustion reaction itself. Vastly superior to the cheap water-based extinguishers found on most NT vessels."
	reagent_state = REAGENT_LIQUID
	color = "#A6FAFF"
	taste_description = "the inside of a fire extinguisher"

/datum/reagent/firefighting_foam/on_touch_turf(turf/target, remaining, allocated, data)
	. = ..()

	var/turf/T = target
	if(allocated >= 1)
		var/obj/effect/foam/firefighting/F = (locate(/obj/effect/foam/firefighting) in T)
		if(!F)
			F = new(T)
		else if(istype(F))
			F.lifetime = initial(F.lifetime) //reduce object churn a little bit when using smoke by keeping existing foam alive a bit longer

	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T0C + 100 // 100C, the boiling point of water

	var/hotspot = (locate(/atom/movable/fire) in T)
	if(hotspot && !isspaceturf(T))
		var/datum/gas_mixture/lowertemp = T.remove_cell_volume()
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), TCMB)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, allocated * 19000, -environment.get_thermal_energy_change(min_temperature))
		environment.adjust_thermal_energy(-removed_heat)
		if(prob(5))
			T.visible_message("<span class='warning'>The foam sizzles as it lands on \the [T]!</span>")

/datum/reagent/firefighting_foam/on_touch_obj(obj/target, remaining, allocated, data, spread_between)
	. = ..()

	var/obj/O = target
	O.water_act(allocated / 5)

/datum/reagent/firefighting_foam/on_touch_mob(mob/target, remaining, allocated, data, zone)
	. = ..()

	var/mob/M = target
	if(istype(M, /mob/living/simple_mob/slime)) //I'm sure foam is water-based!
		var/mob/living/simple_mob/slime/S = M
		var/amt = 15 * allocated * (1-S.water_resist)
		if(amt>0)
			S.adjustToxLoss(amt)
			S.visible_message("<span class='warning'>[S]'s flesh sizzles where the foam touches it!</span>", "<span class='danger'>Your flesh burns in the foam!</span>")

	if(isliving(target))
		var/mob/living/L = target
		L.adjust_fire_stacks(-allocated)
		L.ExtinguishMob()
