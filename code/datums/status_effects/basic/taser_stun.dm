//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2024 silicons                             *//

/datum/status_effect/taser_stun
	identifier = "taser_stun"

	/// pain to inflict per decisecond
	///
	/// * given this usually lasts 5 seconds, 0.75 is around 37.5, which is pretty reasonable for something not meant to be a magdump stun
	var/pain_per_ds = 0.75

#warn impl - movespeed modifier, pain damage
