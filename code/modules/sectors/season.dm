/**
 * holds info for all seasons
 */
/datum/season_holder
	abstract_type = /datum/season_holder
	/// seasons - ordered
	var/list/seasons = list()
	/// total ratio
	var/computed_ratio
	/// offset ratio for the first one. this is NOT relative (e.g. is between 0 and 1)
	var/offset_ratio = 0

/datum/season_holder/New()
	compute_ratio()

/datum/season_holder/proc/compute_ratio()
	. = 0
	for(var/datum/season/S as anything in seasons)
		. += S.relative_ratio
	computed_ratio = .
	for(var/datum/season/S as anything in seasons)
		S.computed_ratio = S.relative_ratio / computed_ratio

/datum/season_holder/earth
	seasons = list(
		new /datum/season/standard/spring,
		new /datum/season/standard/summer,
		new /datum/season/standard/fall,
		new /datum/season/standard/winter
	)
	offset_ratio = 2 / 12	// kick winter 2 months into the 12 month cycle (relative)

/**
 * holds season data
 */
/datum/season
	/// name
	var/name = "Season"
	/// desc
	var/desc = "A random season."
	/// relative ratio of days
	var/relative_ratio = 1
	/// computed true ratio of days
	var/computed_ratio
	// todo: more stuff; seasons does nothing at the moment

/**
 * bog standard earth seasons
 */
/datum/season/standard
	abstract_type = /datum/season/standard

/datum/season/standard/spring
	name = "Spring"
	desc = "Season of flowers."
	relative_ratio = 2 / 12

/datum/season/standard/summer
	name = "Summer"
	desc = "Perfect beachtime weather."
	relative_ratio = 4 / 12

/datum/season/standard/fall
	name = "Fall"
	desc = "When the leaves fall."
	relative_ratio = 2 / 12

/datum/season/standard/winter
	name = "Winter"
	desc = "Winter. Don't forget a blanket!."
	relative_ratio = 4 / 12
