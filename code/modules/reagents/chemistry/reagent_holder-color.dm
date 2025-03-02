//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 Citadel Station Developers           *//

/datum/reagent_holder/proc/get_color()
	switch(length(reagent_volumes))
		if(0)
			return "#ffffff"
		if(1)
			var/datum/reagent/solo_reagent = SSchemistry.reagent_lookup[reagent_volumes[1]]
			return solo_reagent.holds_data ? solo_reagent.compute_color_with_data(reagent_datas?[solo_reagent.id]) : solo_reagent.color
	var/total_r = 0
	var/total_g = 0
	var/total_b = 0
	var/total_a = 0
	var/total_weight = 0
	for(var/id in reagent_volumes)
		var/volume = reagent_volumes[id]
		var/datum/reagent/resolved_reagent = SSchemistry.reagent_lookup[id]
		var/effective_color = resolved_reagent.holds_data ? resolved_reagent.compute_color_with_data(reagent_datas?[resolved_reagent.id]) : resolved_reagent.color
		var/effective_weight = volume * resolved_reagent.color_weight
		switch(length(effective_color))
			if(7)
				total_a += 255 * effective_weight
			if(9)
				total_a += hex2num(copytext(resolved_reagent.color, 8, 10)) * effective_weight
			else
				// todo: this should be checked in reagent init. just runtime at this point.
				stack_trace("reagent id [id] has an incorrect color set: [resolved_reagent.color]")
				resolved_reagent.color = "#ffffff"
		total_r += hex2num(copytext(resolved_reagent.color, 2, 4)) * effective_weight
		total_g += hex2num(copytext(resolved_reagent.color, 4, 6)) * effective_weight
		total_b += hex2num(copytext(resolved_reagent.color, 6, 8)) * effective_weight
		total_weight += effective_weight
	return rgb(total_r / total_weight, total_g / total_weight, total_b / total_weight, total_a / total_weight)
