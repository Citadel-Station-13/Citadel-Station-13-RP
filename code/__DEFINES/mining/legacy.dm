/**
 * todo: entirely rework this
 */
/proc/standard_mineral_roll(rare)
	var/static/list/probabilities = list(
		/datum/ore/uranium::name = 4 + rare * 2,
		/datum/ore/hematite::name = 5,
		/datum/ore/coal::name = 5,
		/datum/ore/phoron::name = 8 + rare * 1,
		/datum/ore/silver::name = 8 + rare * 1,
		/datum/ore/gold::name = 8 + rare * 1,
		/datum/ore/diamond::name = 2 + rare * 3,
		/datum/ore/platinum::name = 3 + rare * 3,
		/datum/ore/verdantium::name = 1 + rare * 3,
		/datum/ore/lead::name = 4,
		/datum/ore/copper::name = 6,
	)
	return pickweight(probabilities)
