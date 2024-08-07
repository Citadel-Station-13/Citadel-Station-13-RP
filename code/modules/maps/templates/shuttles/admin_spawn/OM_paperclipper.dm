// -- Datums -- //
/datum/map_template/shuttle/overmap/generic/paper_clipper
	name = "OM Ship - Paper Clipper (Cylon) (New Z)"
	desc = "An old salvage ship, abandoned but seemingly intact."
	suffix = "overmap_ship_paperclipper.dmm"

// The 'shuttle'
/datum/shuttle/autodock/overmap/paper_clipper
	name = "Cylon"
	current_location = "omship_spawn_paper_clipper"
	docking_controller_tag = "paperclipper_airlock"
	shuttle_area = list(/area/shuttle/paper_clipper,
				/area/shuttle/paper_clipper/left_wing,
				/area/shuttle/paper_clipper/right_wing,
				/area/shuttle/paper_clipper/right_wing/shuttle_hanger
				)
	defer_initialisation = TRUE //We're not loaded until an admin does it
	move_direction = NORTH
	ceiling_type = /turf/simulated/floor/reinforced/airless

// A shuttle lateloader landmark
/obj/effect/shuttle_landmark/shuttle_initializer/paper_clipper
	name = "Cylon"
	base_area = /area/space
	base_turf = /turf/space
	landmark_tag = "omship_spawn_paper_clipper"
	shuttle_type = /datum/shuttle/autodock/overmap/paper_clipper

/obj/overmap/entity/visitable/ship/landable/paper_clipper
	scanner_name = "Cylon-class Vessel"
	scanner_desc = @{"[i]Registration[/i]: Unknown
[i]Class[/i]: Small Shuttle
[i]Transponder[/i]: Transmitting (CIV), non-hostile
[b]Notice[/b]: Small private vessel"}
	color = "#292636"
	vessel_mass = 1000
	known = FALSE
	vessel_size = SHIP_SIZE_SMALL
	shuttle = "Cylon"

// The shuttle's 'shuttle' computer
/obj/machinery/computer/shuttle_control/explore/paper_clipper
	name = "short jump console"
	shuttle_tag = "Cylon"
	req_one_access = list()

/area/shuttle/paper_clipper
	name = "\improper Central Section"
	icon_state = "shuttle"
	requires_power = 1

/area/shuttle/paper_clipper/left_wing
	name = "\improper Left Wing"

/area/shuttle/paper_clipper/right_wing
	name = "\improper Right Wing"

/area/shuttle/paper_clipper/right_wing/shuttle_hanger
	name = "\improper Right Wing Shuttle Hanger"
