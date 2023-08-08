/obj/overmap/entity/visitable/sector/lythios43c
	name = "Lythios 43c"	// Name of the location on the overmap.
	desc = "A cold, desolate iceball world. Home to the NSB Atlas, a far-frontier research base set up by NanoTrasen shortly after establishing in this sector."
	scanner_desc = @{"[b][i]Registration[/i][/b]: NSB Atlas
[b][i]Class[/i][/b]: ALPHA SITE
[b][i]Transponder[/i][/b]: Transmitting (MIL), NanoTrasen IFF
[b][i]Notice[/i][/b]: RESTRICTED AREA, authorized personnel only"}
	base = TRUE
	icon_state = "globe"
	color = "#5bbbd3"
	start_x = 15
	start_y = 10
	initial_generic_waypoints = list(
		"rift_airspace_SE",
		"rift_airspace_E",
		"rift_airspace_NE",
		"rift_airspace_N",
		"rift_plains",
		)

	initial_restricted_waypoints = list(
		"Excursion Shuttle" = list("rift_excursion_pad"),
		"Courser Scouting Vessel" = list("rift_courser_hangar"),
		"Hammerhead Patrol Barge" = list("rift_hammerhead_hangar"),
		"Civilian Transport" = list("rift_civvie_pad"),
		"Dart EMT Shuttle" = list("rift_emt_pad"),
		"Beruang Trade Ship" = list("rift_trade_dock"),
		"NDV Quicksilver" = list("rift_specops_dock"),
		"Pirate Skiff" = list("rift_pirate_dock"),
		)

//Despite not being in the multi-z complex, these levels are part of the overmap sector
/* This should be placed in the map's define files.

/obj/overmap/entity/visitable/sector/lythios43c
	extra_z_levels = list(
		Z_LEVEL_WEST_PLAIN,
		Z_LEVEL_WEST_CAVERN,
		Z_LEVEL_WEST_DEEP,
		Z_LEVEL_WEST_BASE
	)
	levels_for_distress = list(
		Z_LEVEL_DEBRISFIELD,
		Z_LEVEL_MININGPLANET,
		Z_LEVEL_UNKNOWN_PLANET,
		Z_LEVEL_DESERT_PLANET,
		Z_LEVEL_GAIA_PLANET,
		Z_LEVEL_FROZEN_PLANET
		)
*/


/obj/overmap/entity/visitable/sector/lythios43c/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = FALSE)

/obj/overmap/entity/visitable/sector/lythios43c/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = TRUE)

/obj/overmap/entity/visitable/sector/lythios43c/proc/announce_atc(var/atom/movable/AM, var/going = FALSE)
	var/message = "Sensor contact for vessel '[AM.name]' has [going ? "left" : "entered"] ATC control area."
	//For landables, we need to see if their shuttle is cloaked
	if(istype(AM, /obj/overmap/entity/visitable/ship/landable))
		var/obj/overmap/entity/visitable/ship/landable/SL = AM //Phew
		var/datum/shuttle/autodock/multi/shuttle = SSshuttle.shuttles[SL.shuttle]
		if(!istype(shuttle) || !shuttle.cloaked) //Not a multishuttle (the only kind that can cloak) or not cloaked
			SSlegacy_atc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/overmap/entity/visitable/ship))
		SSlegacy_atc.msg(message)
