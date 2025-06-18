//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Spreads rust to self, and nearby turfs in view.
 */
/turf/proc/eldritch_spread_rust(amount, probability, range = 0)
	// TODO: amount should be conserved.
	if(range > 0)
		var/turf/dview_out
		FOR_DVIEW(dview_out, range, src, INVISIBILITY_MAXIMUM)
			if(prob(probability))
				dview_out.eldritch_apply_rust(amount)
	else
		if(prob(probability))
			eldritch_apply_rust(amount)
