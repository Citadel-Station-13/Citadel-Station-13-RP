//Returns the firelevel
/datum/gas_mixture/proc/zburn(zone/zone, force_burn, no_check = 0)
	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/firelevel_multiplier, firelevel_multiplier)
	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/fuel_energy_release, fuel_energy_release)

	. = 0
	if((temperature > PHORON_MINIMUM_BURN_TEMPERATURE || force_burn) && (no_check ||check_recombustability(zone? zone.fuel_objs : null)))

		#ifdef FIREDBG
		log_debug("***************** FIREDBG *****************")
		log_debug("Burning [zone? zone.name : "zoneless gas_mixture"]!")
		#endif

		var/gas_fuel = 0
		var/liquid_fuel = 0
		var/total_fuel = 0
		var/total_oxidizers = 0

		//*** Get the fuel and oxidizer amounts
		for(var/g in gas)
			if(gas_data.flags[g] & XGM_GAS_FUEL)
				gas_fuel += gas[g]
			if(gas_data.flags[g] & XGM_GAS_OXIDIZER)
				total_oxidizers += gas[g]
		gas_fuel *= group_multiplier
		total_oxidizers *= group_multiplier

		//Liquid Fuel
		var/fuel_area = 0
		if(zone)
			for(var/obj/effect/decal/cleanable/liquid_fuel/fuel in zone.fuel_objs)
				liquid_fuel += fuel.amount*LIQUIDFUEL_AMOUNT_TO_MOL
				fuel_area++

		total_fuel = gas_fuel + liquid_fuel
		if(total_fuel <= 0.005)
			return 0

		//*** Determine how fast the fire burns

		//get the current thermal energy of the gas mix
		//this must be taken here to prevent the addition or deletion of energy by a changing heat capacity
		var/starting_energy = temperature * heat_capacity()

		//determine how far the reaction can progress
		var/reaction_limit = min(total_oxidizers*(FIRE_REACTION_FUEL_AMOUNT/FIRE_REACTION_OXIDIZER_AMOUNT), total_fuel) //stoichiometric limit

		//vapour fuels are extremely volatile! The reaction progress is a percentage of the total fuel (similar to old zburn).)
		var/gas_firelevel = calculate_firelevel(gas_fuel, total_oxidizers, reaction_limit, volume*group_multiplier) / firelevel_multiplier
		var/min_burn = 0.30*volume*group_multiplier/CELL_VOLUME //in moles - so that fires with very small gas concentrations burn out fast
		var/gas_reaction_progress = min(max(min_burn, gas_firelevel*gas_fuel)*FIRE_GAS_BURNRATE_MULT, gas_fuel)

		//liquid fuels are not as volatile, and the reaction progress depends on the size of the area that is burning. Limit the burn rate to a certain amount per area.
		var/liquid_firelevel = calculate_firelevel(liquid_fuel, total_oxidizers, reaction_limit, 0) / firelevel_multiplier
		var/liquid_reaction_progress = min((liquid_firelevel*0.2 + 0.05)*fuel_area*FIRE_LIQUID_BURNRATE_MULT, liquid_fuel)

		var/firelevel = (gas_fuel*gas_firelevel + liquid_fuel*liquid_firelevel)/total_fuel

		var/total_reaction_progress = gas_reaction_progress + liquid_reaction_progress
		var/used_fuel = min(total_reaction_progress, reaction_limit)
		var/used_oxidizers = used_fuel*(FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT)

		#ifdef FIREDBG
		log_debug("gas_fuel = [gas_fuel], liquid_fuel = [liquid_fuel], total_oxidizers = [total_oxidizers]")
		log_debug("fuel_area = [fuel_area], total_fuel = [total_fuel], reaction_limit = [reaction_limit]")
		log_debug("firelevel -> [firelevel] (gas: [gas_firelevel], liquid: [liquid_firelevel])")
		log_debug("liquid_reaction_progress = [liquid_reaction_progress]")
		log_debug("gas_reaction_progress = [gas_reaction_progress]")
		log_debug("total_reaction_progress = [total_reaction_progress]")
		log_debug("used_fuel = [used_fuel], used_oxidizers = [used_oxidizers]; ")
		#endif

		//if the reaction is progressing too slow then it isn't self-sustaining anymore and burns out
		if(zone) //be less restrictive with canister and tank reactions
			if((!liquid_fuel || used_fuel <= FIRE_LIQUD_MIN_BURNRATE) && (!gas_fuel || used_fuel <= FIRE_GAS_MIN_BURNRATE*zone.contents.len))
				return 0


		//*** Remove fuel and oxidizer, add carbon dioxide and heat

		//remove and add gasses as calculated
		var/used_gas_fuel = min(max(0.25, used_fuel*(gas_reaction_progress/total_reaction_progress)), gas_fuel) //remove in proportion to the relative reaction progress
		var/used_liquid_fuel = min(max(0.25, used_fuel-used_gas_fuel), liquid_fuel)

		//remove_by_flag() and adjust_gas() handle the group_multiplier for us.
		remove_by_flag(XGM_GAS_OXIDIZER, used_oxidizers)
		remove_by_flag(XGM_GAS_FUEL, used_gas_fuel)
		adjust_gas("carbon_dioxide", used_oxidizers)

		if(zone)
			zone.remove_liquidfuel(used_liquid_fuel, !check_combustability())

		//calculate the energy produced by the reaction and then set the new temperature of the mix
		temperature = (starting_energy + fuel_energy_release * (used_gas_fuel + used_liquid_fuel)) / heat_capacity()
		update_values()

		#ifdef FIREDBG
		log_debug("used_gas_fuel = [used_gas_fuel]; used_liquid_fuel = [used_liquid_fuel]; total = [used_fuel]")
		log_debug("new temperature = [temperature]; new pressure = [return_pressure()]")
		#endif

		return firelevel

datum/gas_mixture/proc/check_recombustability(list/fuel_objs)
	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_OXIDIZER && gas[g] >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(fuel_objs && fuel_objs.len)
		return 1

	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_FUEL && gas[g] >= 0.1)
			. = 1
			break

/datum/gas_mixture/proc/check_combustability(obj/effect/decal/cleanable/liquid_fuel/liquid=null)
	. = 0
	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/consumption_rate, fire_consumption_rate)
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_OXIDIZER && QUANTIZE(gas[g] * fire_consumption_rate) >= 0.1)
			. = 1
			break

	if(!.)
		return 0

	if(liquid)
		return 1

	. = 0
	for(var/g in gas)
		if(gas_data.flags[g] & XGM_GAS_FUEL && QUANTIZE(gas[g] * fire_consumption_rate) >= 0.005)
			. = 1
			break

//returns a value between 0 and vsc.fire_firelevel_multiplier
/datum/gas_mixture/proc/calculate_firelevel(total_fuel, total_oxidizers, reaction_limit, gas_volume)
	CACHE_VSC_PROP(atmos_vsc, /atmos/fire/firelevel_multiplier, firelevel_multiplier)
	//Calculates the firelevel based on one equation instead of having to do this multiple times in different areas.
	var/firelevel = 0

	var/total_combustables = (total_fuel + total_oxidizers)
	var/active_combustables = (FIRE_REACTION_OXIDIZER_AMOUNT/FIRE_REACTION_FUEL_AMOUNT + 1)*reaction_limit

	if(total_combustables > 0)
		//slows down the burning when the concentration of the reactants is low
		var/damping_multiplier = min(1, active_combustables / (total_moles/group_multiplier))

		//weight the damping mult so that it only really brings down the firelevel when the ratio is closer to 0
		damping_multiplier = 2*damping_multiplier - (damping_multiplier*damping_multiplier)

		//calculates how close the mixture of the reactants is to the optimum
		//fires burn better when there is more oxidizer -- too much fuel will choke the fire out a bit, reducing firelevel.
		var/mix_multiplier = 1 / (1 + (5 * ((total_fuel / total_combustables) ** 2)))

		#ifdef FIREDBG
		ASSERT(damping_multiplier <= 1)
		ASSERT(mix_multiplier <= 1)
		#endif

		//toss everything together -- should produce a value between 0 and fire_firelevel_multiplier
		firelevel = firelevel_multiplier * mix_multiplier * damping_multiplier

	return max( 0, firelevel)
