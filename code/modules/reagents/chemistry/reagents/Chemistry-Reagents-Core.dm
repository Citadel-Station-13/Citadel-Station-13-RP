/// How much heat is removed when applied to a hot turf, in J/unit (19000 makes 120 u of water roughly equivalent to 4L)
#define WATER_LATENT_HEAT 19000
/datum/reagent/water
	name = "Water"
	id = "water"
	taste_description = "water"
	description = "A ubiquitous chemical substance that is composed of hydrogen and oxygen."
	reagent_state = REAGENT_LIQUID
	color = "#0064C877"
	bloodstream_metabolism_multiplier = 10
	ingested_distribution_multiplier = 5
	ingested_elimination_multiplier = 5
	dermal_elimination_multiplier = 2

	glass_name = "water"
	glass_desc = "The father of all refreshments."

	cup_name = "water"
	cup_desc = "The father of all refreshments."

/datum/reagent/water/contact_expose_turf(turf/target, volume, temperature, list/data, vapor)
	. = ..()

	// legacy code
	if(!istype(target, /turf/simulated))
		return
	var/turf/simulated/T = target
	var/datum/gas_mixture/environment = T.return_air()
	var/min_temperature = T0C + 100 // 100C, the boiling point of water

	var/hotspot = (locate(/atom/movable/fire) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_cell_volume()
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if (environment && environment.temperature > min_temperature) // Abstracted as steam or something
		var/removed_heat = between(0, volume * WATER_LATENT_HEAT, -environment.get_thermal_energy_change(min_temperature))
		environment.adjust_thermal_energy(-removed_heat)
		if (prob(5))
			T.visible_message("<span class='warning'>The water sizzles as it lands on \the [T]!</span>")

	else if(volume >= 10)
		T.wet_floor(1)

/datum/reagent/water/contact_expose_obj(obj/target, volume, list/data, vapor)
	. = ..()

	var/obj/O = target
	if(istype(O, /obj/item/reagent_containers/food/snacks/monkeycube))
		var/obj/item/reagent_containers/food/snacks/monkeycube/cube = O
		if(!cube.wrapped)
			cube.Expand()
	else
		O.water_act(volume / 5)
	var/effective = volume || 10
	O.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (effective / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (effective / 10)))

/datum/reagent/water/touch_expose_mob(mob/target, volume, temperature, list/data, organ_tag)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/L = target
	if(istype(L))
		// First, kill slimes.
		if(istype(L, /mob/living/simple_mob/slime))
			var/mob/living/simple_mob/slime/S = L
			var/amt = 15 * volume * (1-S.water_resist)
			if(amt>0)
				S.adjustToxLoss(amt)
				S.visible_message("<span class='warning'>[S]'s flesh sizzles where the water touches it!</span>", "<span class='danger'>Your flesh burns in the water!</span>")

		// Then extinguish people on fire.
		var/needed = L.fire_stacks * 5
		if(volume > needed)
			L.ExtinguishMob()
		L.adjust_fire_stacks(-(volume / 5))
		. += needed
	var/effective = volume || 10
	L.clean_radiation(RAD_CONTAMINATION_CLEANSE_POWER * (effective / 10), RAD_CONTAMINATION_CLEANSE_FACTOR ** (1 / (effective / 10)))

/datum/reagent/water/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	entity.adjust_hydration(removed * 10)

/datum/reagent/fuel
	name = "Welding fuel"
	id = "fuel"
	description = "Required for welders. Flamable."
	taste_description = "gross metal"
	reagent_state = REAGENT_LIQUID
	color = "#660000"

	glass_name = "welder fuel"
	glass_desc = "Unless you are an industrial tool, this is probably not safe for consumption."

/datum/reagent/fuel/contact_expose_turf(turf/target, volume, temperature, list/data, vapor)
	. = ..()
	new /obj/effect/debris/cleanable/liquid_fuel(target, volume, FALSE)
	. += volume

/datum/reagent/fuel/on_metabolize_bloodstream(mob/living/carbon/entity, datum/reagent_metabolism/metabolism, list/data, removed)
	. = ..()
	entity.adjustToxLoss(4 * removed)

/datum/reagent/fuel/touch_expose_mob(mob/target, volume, temperature, list/data, organ_tag)
	. = ..()
	var/mob/living/L = target
	if(istype(L))
		L.adjust_fire_stacks(volume / 10) // Splashing people with welding fuel to make them easy to ignite!
