/datum/map_config
	// Metadata
	var/config_filename = "_maps/triumph.json"
	var/defaulted = TRUE  // set to FALSE by LoadConfig() succeeding

#warn oh god oh fuck redo this file

	// Config actually from the JSON - should default to Box
	var/map_name = "Tether"
	var/map_path = "map_files/tether"
	var/map_file = list(
	"tether-01-surface1.dmm",
	"tether-02-surface2.dmm",
	"tether-03-surface3.dmm",
	"tether-04-transit.dmm",
	"tether-05-station1.dmm",
	"tether-06-station2.dmm",
	"tether-07-station3.dmm",
	"tether-08-mining.dmm",
	"tether-09-solars.dmm",
	"tether-10-colony.dmm"
	)

	/// List of lists for Zlevel traits.
	var/traits = null

/*
	var/space_ruin_levels = 2
	var/space_empty_levels = 1
	var/station_ruin_budget = -1 // can be set to manually override the station ruins budget on maps that don't support station ruins, stopping the error from being unable to place the ruins.

	var/minetype = "lavaland"
*/

//	var/maptype = MAP_TYPE_STATION //This should be used to adjust ingame behavior depending on the specific type of map being played. For instance, if an overmap were added, it'd be appropriate for it to only generate with a MAP_TYPE_SHIP

/*
	var/announcertype = "standard" //Determines the announcer the map uses. standard uses the default announcer, classic, but has a random chance to use other similarly-themed announcers, like medibot

	var/allow_custom_shuttles = TRUE
	var/shuttles = list(
		"cargo" = "cargo_box",
		"ferry" = "ferry_fancy",
		"whiteship" = "whiteship_box",
		"emergency" = "emergency_box")

	var/year_offset = 540 //The offset of ingame year from the actual IRL year. You know you want to make a map that takes place in the 90's. Don't lie.
*/
	/// Persistence ID, defaulting to name.
	var/persistence_id

	// "fun things"
	/// Orientation to load in by default.
	var/orientation = SOUTH		//byond defaults to placing everyting SOUTH.

/datum/map_config/proc/GetFullMapPaths()
	if (istext(map_file))
		return list("_maps/[map_path]/[map_file]")
	. = list()
	for (var/file in map_file)
		. += "_maps/[map_path]/[file]"

/datum/map_config/proc/MakeNextMap()
	WriteNextMap(path)
