/datum/shuttle/autodock/overmap/reaver
	name = "Reaver-Class Shuttle"
	warmup_time = 3
	shuttle_area = list(/area/shuttle/reaver/fore, /area/shuttle/reaver/prep, /area/shuttle/reaver/cargo, /area/shuttle/reaver/cockpit, /area/shuttle/reaver/engine)
	docking_controller_tag = "reaver_dock"
	fuel_consumption = 4
	move_time = 10
	defer_initialisation = TRUE

/obj/overmap/entity/visitable/ship/landable/reaver
	name = "Unidentified Vessel"
	desc = "Scan returns consistent with Reaver Class Shuttle"
	color = "#751713" //Dark Red
	fore_dir = WEST
	vessel_mass = 7000
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Reaver-Class Shuttle"

/obj/machinery/computer/shuttle_control/explore/reaver
	name = "short jump console"
	shuttle_tag = "Reaver-Class Shuttle"

// Reaver Shuttle
/area/shuttle/reaver
	requires_power = TRUE
	name = "\improper Reaver Shuttle"
	icon_state = "shuttle"

/area/shuttle/reaver/fore
	name = "\improper Reaver Shuttle Fore"

/area/shuttle/reaver/prep
	name = "\improper Reaver Shuttle Prep"

/area/shuttle/reaver/cargo
	name = "\improper Reaver Shuttle Cargo"

/area/shuttle/reaver/cockpit
	name = "\improper Reaver Shuttle Cockpit"

/area/shuttle/reaver/engine
	name = "\improper Reaver Shuttle Engine Bay"
