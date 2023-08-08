/**
 * default implementation of cellular automata based terrain
 */
/datum/map_layer/terrain/cellular
	/// number of times to iterate automata
	var/iterations = 5
	/// closed % at start: 0 to 100
	var/initial_closed_percentage = 55
	/// neighbors above = become alive. 0 to 8
	var/live_threshold = 5
	/// neighbors below = become dead. 0 to 8
	var/live_threshold = 4

#warn impl all

// rustg_cnoise_generate(percentage, smoothing_iterations, birth_limit, death_limit, width, height)
