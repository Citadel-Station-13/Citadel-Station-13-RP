/obj/overmap/entity/visitable/ship/endeavour
	name = "NSV Endeavour"	// Name of the location on the overmap.
	desc = "The Endeavour is one of the many ships that is a part of the NCV Oracle's operational group in this sector"

	scanner_desc = @{"[i]Registration[/i]: NSV Endeavour
[i]Class[/i]: Science Vessel
[i]Transponder[/i]: Transmitting (CIV), Nanotrasen IFF
[b]Notice[/b]: Nanotrasen Vessel, authorized personnel only"}

	icon_state = "ship"
	vessel_mass = 48500 // temporarily buffed by 5x due to vorestation fucking up large gas thruster code
	burn_delay = 2 SECONDS
	fore_dir = EAST	// Which direction the ship/z-level is facing.  It will move dust particles from that direction when moving.
	base = TRUE		// Honestly unsure what this does but it seems the main sector or "Map" we're at has this so here it stays
	// The waypoints that are avaliable once you are at this Navpoint
	initial_generic_waypoints = list("nav_capitalship_docking2", "endeavour_excursion_hangar", "endeavour_space_SW", "endeavour_mining_port")

	initial_restricted_waypoints = list(
		"Excursion Shuttle" = list("endeavour_excursion_hangar"),
		"Courser Scouting Vessel" = list("endeavour_courser_hangar"),
		"Hammerhead Patrol Barge" = list("endeavour_hammerhead_hangar"),
		"Civilian Transport" = list("endeavour_civvie_home"),
		"Dart EMT Shuttle" = list("endeavour_emt_dock"),
		"Beruang Trade Ship" = list("endeavour_annex_dock"),
		"Mining Shuttle" = list("endeavour_mining_port"),
		"NDV Quicksilver" = list("endeavour_specops_dock")
		)
