/**
 * makes us into a level border, which changeturfs us if we aren't already a /turf/level_border
 */
/turf/proc/_make_transition_border(dir, render = TRUE)
	var/turf/T = src
	if(!istype(T, /turf/level_border))
		T = PlaceOnTop(/turf/level_border)
	var/datum/component/transition_border/border = T.GetComponent(/datum/component/transition_border)
	if(border)
		qdel(border)
	T.AddComponent(/datum/component/transition_border, TRANSITION_VISUAL_RANGE, dir, render)

/**
 * clears us from being a level border, which scrapes us away if we're a /turf/level_border
 */
/turf/proc/_dispose_transition_border()
	var/turf/T = src
	if(istype(T, /turf/level_border))
		T = ScrapeAway(1)
	var/datum/component/transition_border/border = T.GetComponent(/datum/component/transition_border)
	if(border)
		qdel(border)
	return !!border
