
/obj/overmap/entity/visitable/sector/pirate_base
	name = "Pirate Base"
	desc = "A nest of hostiles to the company. Caution is advised."
	scanner_desc = @{"[i]Information[/i]
Warning, unable to scan through sensor shielding systems at location. Possible heavy hostile life-signs."}
	in_space = 1
	known = FALSE
	icon_state = "piratebase"
	color = "#FF3333"
	initial_generic_waypoints = list("pirate_docking_arm")

//Tracked here due to ID access changes. It's going to be pretty barebones compared to other job datums.
/datum/role/job/pirate
	title = "Unknown"
	id = JOB_ID_PIRATE
	departments = list(DEPARTMENT_UNKNOWN)
	minimal_access = list(ACCESS_FACTION_PIRATE)
	additional_access = list(ACCESS_FACTION_PIRATE)

// -- Objs -- //

/obj/effect/step_trigger/teleporter/piratebase_loop/north/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = 2
	teleport_z = z

/obj/effect/step_trigger/teleporter/piratebase_loop/south/Initialize(mapload)
	. = ..()
	teleport_x = x
	teleport_y = world.maxy - 1
	teleport_z = z

/obj/effect/step_trigger/teleporter/piratebase_loop/west/Initialize(mapload)
	. = ..()
	teleport_x = world.maxx - 1
	teleport_y = y
	teleport_z = z

/obj/effect/step_trigger/teleporter/piratebase_loop/east/Initialize(mapload)
	. = ..()
	teleport_x = 2
	teleport_y = y
	teleport_z = z
