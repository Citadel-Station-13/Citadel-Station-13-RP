/**
 * todo: entirely rework this
 */
/proc/standard_mineral_roll(rare)
	var/static/list/probabilities = list(
		/datum/ore/uranium::name = 4,
		/datum/ore/hematite::name = 5,
		/datum/ore/coal::name = 5,
		/datum/ore/phoron::name = 8,
		/datum/ore/silver::name = 8,
		/datum/ore/gold::name = 8,
		/datum/ore/diamond::name = 2,
		/datum/ore/platinum::name = 3,
		/datum/ore/verdantium::name = 1,
		/datum/ore/lead::name = 4,
		/datum/ore/copper::name = 6,
	)
	var/static/list/probabilities_rare = list(
		/datum/ore/uranium::name = 4 + 2,
		/datum/ore/hematite::name = 5,
		/datum/ore/coal::name = 5,
		/datum/ore/phoron::name = 8 + 1,
		/datum/ore/silver::name = 8 + 1,
		/datum/ore/gold::name = 8 + 1,
		/datum/ore/diamond::name = 2 + 3,
		/datum/ore/platinum::name = 3 + 3,
		/datum/ore/verdantium::name = 1 + 3,
		/datum/ore/lead::name = 4,
		/datum/ore/copper::name = 6,
	)
	return pickweight(rare ? probabilities_rare : probabilities)
