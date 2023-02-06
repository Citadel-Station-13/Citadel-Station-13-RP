/**
 * holds information on a planet's day
 */
/datum/day_holder
	/// inverse: first one is day to night (say, if you want 0.25 ratio 6 AM of 24 hour to be day to night)
	var/invert = FALSE
	/// cutoff point of night to day, ratio
	var/day_ratio = 0.25
	/// cutoff point of day to night, ratio
	var/night_ratio = 0.75
	/// time of transition in deciseconds, *CENTERED* on day transition threshold
	var/transition_day = 0.5 HOURS
	/// time of transition in deciseconds, *CENTERED* on night transition threshold
	var/transition_night = 0.5 HOURS

/**
 * get strength of day or night
 *
 * @return 1 for full day, -1 for full night
 */
/datum/day_holder/proc/get_relative_shift(time_of_day)
	#warn impl

/**
 * get "day effect" multiplier
 *
 * @return 0 to 1
 */
/datum/day_holder/proc/get_day_ratio(time_of_day)
	#warn impl

/**
 * get "night effect" multiplier
 *
 * @return 0 to 1
 */
/datum/day_holder/proc/get_night_strength(time_of_day)
	#warn impl

/datum/day_holder/earth
	invert = FALSE
	day_ratio = 0.25
	night_ratio = 0.75
	transition_day = 1 HOURS
	transition_night = 1 HOURS
