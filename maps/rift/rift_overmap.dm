/obj/effect/overmap/visitable/sector/lythios43c
	extra_z_levels = list(
		Z_LEVEL_WEST_PLAIN,
		Z_LEVEL_WEST_CAVERN,
		Z_LEVEL_WEST_DEEP,
		Z_LEVEL_WEST_BASE
	)

//////////////////////////////////////////////////////////////////////////
// There is literally a dm file for triumph shuttles, why are these here//
//////////////////////////////////////////////////////////////////////////

// Vox Pirate ship (Yaya, yous be giving us all your gear now.)

/obj/effect/overmap/visitable/ship/landable/pirate
	name = "Pirate Skiff"
	desc = "Yous need not care about this."
	fore_dir = WEST
	vessel_mass = 7000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Pirate Skiff"

/datum/shuttle/autodock/overmap/pirate
	name = "Pirate Skiff"
	warmup_time = 3
	shuttle_area = list(/area/shuttle/pirate/cockpit, /area/shuttle/pirate/general, /area/shuttle/pirate/cargo)
	current_location = "piratebase_hanger"
	docking_controller_tag = "pirate_docker"
	fuel_consumption = 5

/obj/machinery/computer/shuttle_control/explore/pirate
	name = "short jump raiding console"
	shuttle_tag = "Pirate Skiff"
