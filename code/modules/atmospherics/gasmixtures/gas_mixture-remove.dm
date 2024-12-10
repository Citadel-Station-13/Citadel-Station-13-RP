//Removes moles from the gas mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove(amount)
	amount = min(amount, total_moles * group_multiplier) //Can not take more air than the gas mixture has!
	if(amount <= 0)
		return null

	var/datum/gas_mixture/removed = new

	for(var/g in gas)
		removed.gas[g] = XGM_QUANTIZE((gas[g] / total_moles) * amount)
		gas[g] -= removed.gas[g] / group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed


//Removes a ratio of gas from the mixture and returns a gas_mixture containing the removed air.
/datum/gas_mixture/proc/remove_ratio(ratio, out_group_multiplier = 1)
	if(ratio <= 0)
		return null
	out_group_multiplier = clamp( out_group_multiplier, 1,  group_multiplier)

	ratio = min(ratio, 1)

	var/datum/gas_mixture/removed = new
	removed.group_multiplier = out_group_multiplier

	for(var/g in gas)
		removed.gas[g] = (gas[g] * ratio * group_multiplier / out_group_multiplier)
		gas[g] = gas[g] * (1 - ratio)

	removed.temperature = temperature
	removed.volume = volume * group_multiplier / out_group_multiplier
	update_values()
	removed.update_values()

	return removed

//Removes a volume of gas from the mixture and returns a gas_mixture containing the removed air with the given volume
/datum/gas_mixture/proc/remove_volume(removed_volume)
	var/datum/gas_mixture/removed = remove_ratio(removed_volume/(volume*group_multiplier), 1)
	removed.volume = removed_volume
	return removed

//Removes moles from the gas mixture, limited by a given flag.  Returns a gax_mixture containing the removed air.
/datum/gas_mixture/proc/remove_by_flag(flag, amount)
	if(!flag || amount <= 0)
		return

	var/sum = 0
	for(var/g in gas)
		if(global.gas_data.flags[g] & flag)
			sum += gas[g]

	var/datum/gas_mixture/removed = new

	for(var/g in gas)
		if(global.gas_data.flags[g] & flag)
			removed.gas[g] = XGM_QUANTIZE((gas[g] / sum) * amount)
			gas[g] -= removed.gas[g] / group_multiplier

	removed.temperature = temperature
	update_values()
	removed.update_values()

	return removed
