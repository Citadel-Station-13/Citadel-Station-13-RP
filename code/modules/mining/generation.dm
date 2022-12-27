/**
 * handles oregen
 */
/datum/ore_generation
	/// do we support underground ores? ores_at_spot **must** be implemented, as we always lazy-load!
	var/supports_underground = FALSE
	/// do we support aboveground ores? seed(zlevel) will be called, as we never lazyload!
	var/supports_aboveground = FALSE

/datum/ore_generation/proc/ores_at_spot(x, y)
	return list()

/datum/ore_generation/proc/seed(z)
	return

/**
 * default ore generation system
 *
 * uses a noise function to get underground ores
 * randomly seeds patches of aboveground ores based on configured rarity
 */
/datum/ore_generation/default
	supports_underground = TRUE
	supports_aboveground = TRUE

	//! aboveground

	//! underground

/datum/ore_generation/default/seed(z)

/datum/ore_generation/default/ores_at_spot(x, y)
