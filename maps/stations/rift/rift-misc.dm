/obj/overmap/entity/visitable/sector/lythios43c
	name = "Lythios 43c"	// Name of the location on the overmap.
	desc = "A cold, desolate iceball world. Home to the NSB Atlas, a far-frontier research base set up by Nanotrasen shortly after establishing in this sector."
	scanner_desc = @{"[b][i]Registration[/i][/b]: NSB Atlas
[b][i]Class[/i][/b]: ALPHA SITE
[b][i]Transponder[/i][/b]: Transmitting (MIL), Nanotrasen IFF
[b][i]Notice[/i][/b]: RESTRICTED AREA, authorized personnel only"}
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
		"Civilian Century Shuttle" = list("rift_oldcentury_pad"),
		"Dart EMT Shuttle" = list("rift_emt_pad"),
		"Beruang Trade Ship" = list("rift_trade_dock"),
		"Scoophead trade Shuttle" = list ("rift_scoophead_dock"),
		"Udang Transport Shuttle" = list ("rift_udang_dock"),
		"NDV Quicksilver" = list("rift_specops_dock"),
		"Pirate Skiff" = list("rift_pirate_dock"),
		)
		
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

//! legacy below

/// This is the effect that slams people into the ground upon dropping out of the sky //

/obj/effect/step_trigger/teleporter/planetary_fall/lythios43c
	planet_path = /datum/planet/lythios43c

/// Temporary place for this
// Spawner for lythios animals
/obj/tether_away_spawner/lythios_animals
	name = "Lythios Animal Spawner"
	faction = "lythios"
	atmos_comp = TRUE
	prob_spawn = 100
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/icegoat = 2,
		/mob/living/simple_mob/animal/passive/woolie = 3,
		/mob/living/simple_mob/animal/passive/furnacegrub,
		/mob/living/simple_mob/animal/horing = 2
	)
