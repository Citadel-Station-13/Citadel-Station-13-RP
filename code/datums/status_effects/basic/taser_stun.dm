//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/status_effect/taser_stun
	identifier = "taser_stun"
	duration = 5 SECONDS
	tick_interval = 0.25 SECONDS

	/// pain to inflict per second
	///
	/// * given this usually lasts 5 seconds, 0.75 is around 37.5, which is pretty reasonable for something not meant to be a magdump stun
	var/pain_per_second = 7.5
	/// penalty to reapplication
	/// * tl;dr 0.25 = all remaining pain that would be inflicted
	///   is inflicted at 25% strength on reapply
	var/pain_reapplication_multiplier = 0.25
	/// movespeed modifier path
	#warn impl
	var/movespeed_modifier

/datum/status_effect/taser_stun/tick(dt)
	apply_pain_to_owner(pain_per_second * dt)

/datum/status_effect/taser_stun/on_remove()
	..()
	if(movespeed_modifier)
		owner.remove_movespeed_modifier(movespeed_modifier)

/datum/status_effect/taser_stun/on_apply()
	..()
	if(movespeed_modifier)
		owner.add_movespeed_modifier(movespeed_modifier)

/datum/status_effect/taser_stun/on_refreshed(old_timeleft)
	..()
	apply_pain_to_owner(old_timeleft * 0.1 * pain_per_second * pain_reapplication_multiplier)

/datum/status_effect/taser_stun/proc/apply_pain_to_owner(amount)

#warn impl - movespeed modifier, pain damagewz


/datum/status_effect/taser_stun/nt_isd
	identifier = "taser_stun-nt_isd"
	duration = 3 SECONDS
	pain_per_second = 10
	pain_reapplication_multiplier = 0.5
