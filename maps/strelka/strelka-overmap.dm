/obj/overmap/entity/visitable/ship/strelka
	name = "NEV Strelka"	// Name of the location on the overmap.
	desc = "The Strelka is one of the many ships that is a part of the NDV Marksman's fleet in this sector"

	color = "#2c7bac"

	scanner_desc = @{"[i]Registration[/i]: NEV Strelka
[i]Class[/i]: Exploration Vessel
[i]Transponder[/i]: Transmitting (CIV), Nanotrasen IFF
[b]Notice[/b]: Nanotrasen Vessel, authorized personnel only, heavely refited."}

	icon_state = "ship"
	vessel_mass = 10000
	burn_delay = 2 SECONDS
	fore_dir = EAST	// Which direction the ship/z-level is facing.  It will move dust particles from that direction when moving.
	base = TRUE		// Honestly unsure what this does but it seems the main sector or "Map" we're at has this so here it stays
	// The waypoints that are avaliable once you are at this Navpoint
	initial_generic_waypoints = list("strelka_excursion_hangar","strelka_emt_hangar","strelka_civvie_home","strelka_annex_dock")

	initial_restricted_waypoints = list(
		"Excursion Javelot Shuttle" = list("strelka_excursion_hangar"),
		"Hammerdart Interception and Rescue Shuttle" = list("strelka_emt_hangar"),
		"Decades Old civilian Transport" = list("strelka_civvie_home"),
		"Beruang Trade Ship" = list("strelka_annex_dock"),
	)

/obj/overmap/entity/visitable/ship/strelka/Crossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = FALSE)

/obj/overmap/entity/visitable/ship/strelka/Uncrossed(var/atom/movable/AM)
	. = ..()
	announce_atc(AM,going = TRUE)

/obj/overmap/entity/visitable/ship/strelka/proc/announce_atc(var/atom/movable/AM, var/going = FALSE)
	var/message = "Sensor contact for vessel '[AM.name]' has [going ? "left" : "entered"] the NEV Strelka's operation area."
	//For landables, we need to see if their shuttle is cloaked
	if(istype(AM, /obj/overmap/entity/visitable/ship/landable))
		var/obj/overmap/entity/visitable/ship/landable/SL = AM //Phew
		var/datum/shuttle/autodock/multi/shuttle = SSshuttle.shuttles[SL.shuttle]
		if(!istype(shuttle) || !shuttle.cloaked) //Not a multishuttle (the only kind that can cloak) or not cloaked
			SSlegacy_atc.msg(message)

	//For ships, it's safe to assume they're big enough to not be sneaky
	else if(istype(AM, /obj/overmap/entity/visitable/ship))
		SSlegacy_atc.msg(message)
