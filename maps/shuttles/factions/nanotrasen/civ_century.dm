DECLARE_SHUTTLE_TEMPLATE(/nanotrasen/civ_century)
	name = "CIV - Century Shuttle"
	desc = "Some kind of shuttle"
	fluff = "Some kind of shuttle"

	descriptor = /datum/shuttle_descriptor{
		mass = 12000;
		preferred_orientation = NORTH;
	}

DECLARE_SHUTTLE_AREA(/nanotrasen/civ_century)
	name = "Civilian Century Shuttle"

#warn impl

/datum/shuttle/autodock/overmap/oldcentury
	warmup_time = 15
	fuel_consumption = 8
	move_time = 37

/obj/overmap/entity/visitable/ship/landable/oldcentury
	desc = "Is it... A replica ? Or... the real deal ? This shuttle, based on the shuttles from earth's old days. No teasing, this shuttle is a replica, but still a old and crapy ship."

#warn map
