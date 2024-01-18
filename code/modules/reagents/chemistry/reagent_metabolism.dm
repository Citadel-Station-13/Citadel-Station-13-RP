//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/reagent_metabolism
	//* Area
	#warn impl

	//* Normal
	/// world.time added at first
	var/added_time
	/// cycles this has been in someone
	var/cycles = 0
	/// current effective dose, usually just the amount in someone
	var/dose

	//* Overdosing
	/// currently overdosing
	var/overdosing = FALSE
	/// cycles we've been overdosing
	var/cycles_overdosing = 0
	/// time we last started overdosing
	var/last_overdose_start
	/// time we last stopped overdosing
	var/last_overdose_end
	#warn overdose cycles, etc

	//* Volume
	/// highest amount that was ever in them so far
	var/highest_so_far = 0

#warn impl all
