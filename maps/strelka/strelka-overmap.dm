/obj/overmap/entity/visitable/ship/strelka
	name = "NSV Strelka"	// Name of the location on the overmap.
	desc = "The Strelka is one of the many ships that is a part of the NDV Marksman's fleet in this sector"

	color = "#2c7bac"

	scanner_desc = @{"[i]Registration[/i]: NEV Strelka
[i]Class[/i]: Exploration Vessel
[i]Transponder[/i]: Transmitting (CIV), Nanotrasen IFF
[b]Notice[/b]: Nanotrasen Vessel, authorized personnel only, heavely refited."}

	icon_state = "ship"
	vessel_mass = 28500 // temporarily buffed by 5x due to vorestation fucking up large gas thruster code
	burn_delay = 2 SECONDS
	fore_dir = EAST	// Which direction the ship/z-level is facing.  It will move dust particles from that direction when moving.
	base = TRUE		// Honestly unsure what this does but it seems the main sector or "Map" we're at has this so here it stays
	// The waypoints that are avaliable once you are at this Navpoint
	initial_generic_waypoints = list("nav_capitalship_docking2",)

	initial_restricted_waypoints = list(
		"Excursion Shuttle" = list("Strelka_excursion_hangar"),
	)
