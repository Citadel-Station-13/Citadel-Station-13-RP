/**
 * So what is a cycle?
 *
 * Basically, you know how we used to simulate sun / moon?
 *
 * Yeah uh, that was kind of bad.
 *
 * And I was wondering how to make it better
 *
 * And it occurred to me, the answer was to stop simulating suns. And moons.
 *
 * Instead, we simulate the concept of an orbital body.
 *
 * Cycles:
 * - Can be a visible celestial object, or not
 * - Can "broadcast" a power ratio of a user's choice
 * - Can be set to the "main" cycle of a planet, which is often used for the main day/night cycle.
 * - All planets must have a main cycle, or its main cycle will be 0 ratio always.
 */
/datum/sector_cycle
	/// name of cycle
	var/name = "Cycle"
	/// description of this cycle
	var/desc = "Some sort of natural cycle."

	/// this is the main cycle of a sector
	var/main = FALSE
	/// this is in-sync with the main cycle. useful for moons.
	var/sync_to_main = FALSE
	/// ratio offset from main. for moons, you probably want 0.5 or something.
	var/sync_offset = 0



/datum/sector_cycle/sun
	name = "Sun"
	desc = "The day-night cycle of some kind of star."

/datum/sector_cycle/sun/main
	desc = "The day-night cycle of the planet's sun."
	main = TRUE

/datum/sector_cycle/sun/main/default

/datum/sector_cycle/moon
	name = "Moon"
	desc = "The orbit of some kind of moon."
	sync_to_main = TRUE
	sync_offset = 0.5

/datum/sector_cycle/moon/default
	desc = "The orbit of the planet's primary moon."
