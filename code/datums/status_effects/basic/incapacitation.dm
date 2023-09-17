/datum/status_effect/incapacitation
	var/requires_mobility_update = TRUE
	var/requires_stat_update = FALSE

/datum/status_effect/incapacitation/on_apply(...)
	. = ..()
	if(requires_mobility_update)
		owner.update_mobility()
	if(requires_stat_update)
		owner.update_stat()

/datum/status_effect/incapacitation/on_remove()
	. = ..()
	if(requires_mobility_update)
		owner.update_mobility()
	if(requires_stat_update)
		owner.update_stat()

/datum/status_effect/incapacitation/stun
	identifier = "stun"
	requires_mobility_update = TRUE

/datum/status_effect/incapacitation/knockdown
	identifier = "knockdown"
	requires_mobility_update = TRUE

/datum/status_effect/incapacitation/paralyze
	identifier = "paralyze"
	requires_mobility_update = TRUE

/datum/status_effect/incapacitation/root
	identifier = "root"
	requires_mobility_update = TRUE

/datum/status_effect/incapacitation/unconscious
	identifier = "unconscious"
	requires_stat_update = TRUE

/datum/status_effect/incapacitation/sleeping
	identifier = "sleeping"
	requires_stat_update = TRUE
