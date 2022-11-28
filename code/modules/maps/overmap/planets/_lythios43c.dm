/datum/atmosphere/planet/lythios43c
	base_gases = list(
	/datum/gas/nitrogen = 0.66,
	/datum/gas/oxygen = 0.34
	)
	base_target_pressure = 76.9
	minimum_pressure = 76.9
	maximum_pressure = 76.9
	minimum_temp = 220.14
	maximum_temp = 241.72

/obj/effect/overmap/visitable/sector/lythios43c
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
		"Civilian Transport" = list("rift_civvie_pad"),
		"Dart EMT Shuttle" = list("rift_emt_pad"),
		"Beruang Trade Ship" = list("rift_trade_dock")
		)


/*	initial_generic_waypoints = list("nav_capitalship_docking2", "triumph_excursion_hangar", "triumph_space_SW", "triumph_mining_port")

	initial_restricted_waypoints = list(
		"Excursion Shuttle" = list("triumph_excursion_hangar"),
		"Courser Scouting Vessel" = list("triumph_courser_hangar"),
		"Civilian Transport" = list("triumph_civvie_home"),
		"Dart EMT Shuttle" = list("triumph_emt_dock"),
		"Beruang Trade Ship" = list("triumph_annex_dock"),
		"Mining Shuttle" = list("triumph_mining_port")
		)

	levels_for_distress = list(
		Z_LEVEL_OFFMAP1,
		Z_LEVEL_BEACH,
		Z_LEVEL_AEROSTAT,
		Z_LEVEL_DEBRISFIELD,
		Z_LEVEL_FUELDEPOT,
		Z_LEVEL_CLASS_D
		)
*/

/obj/effect/overmap/visitable/sector/lythios43c/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = FALSE)

/obj/effect/overmap/visitable/sector/lythios43c/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = TRUE)

/obj/effect/overmap/visitable/sector/lythios43c/proc/announce_atc(var/atom/movable/AM, var/going = FALSE)
	var/message = "Sensor contact for vessel '[AM.name]' has [going ? "left" : "entered"] ATC control area."
	//For landables, we need to see if their shuttle is cloaked
	if(istype(AM, /obj/effect/overmap/visitable/ship/landable))
		var/obj/effect/overmap/visitable/ship/landable/SL = AM //Phew
		var/datum/shuttle/autodock/multi/shuttle = SSshuttle.shuttles[SL.shuttle]
		if(!istype(shuttle) || !shuttle.cloaked) //Not a multishuttle (the only kind that can cloak) or not cloaked
			GLOB.lore_atc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/effect/overmap/visitable/ship))
		GLOB.lore_atc.msg(message)

