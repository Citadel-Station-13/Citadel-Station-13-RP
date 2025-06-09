//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * Spreads rust to self, and nearby turfs in view.
 */
/turf/proc/eldritch_rust_spread(probability, range = 0)
	if(range > 0)
		var/turf/dview_out
		FOR_DVIEW(dview_out, range, src, INVISIBILITY_MAXIMUM)
			if(prob(probability))
				dview_out.AddComponent(/datum/component/eldritch_rust)
	else
		if(prob(probability))
			AddComponent(/datum/component/eldritch_rust)
