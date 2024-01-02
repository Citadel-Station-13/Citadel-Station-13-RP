//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/reagent_metabolism
	//* Normal
	/// world.time added at first
	var/added_time
	/// cycles this has been in someone
	var/cycles = 0

	//* Volume
	/// highest amount that was ever in them so far
	var/highest_so_far = 0

#warn impl all
