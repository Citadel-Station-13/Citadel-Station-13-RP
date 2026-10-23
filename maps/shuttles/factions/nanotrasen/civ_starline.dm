DECLARE_SHUTTLE_TEMPLATE(/factions/nanotrasen/civ_starline)
	id = "nanotrasen-civ_starline"
	name = "CIV - Starline"
	desc = "A slow civilian shuttle used for short range transport."
	display_name = "Starline Shuttle"

	descriptor = /datum/shuttle_descriptor{
		mass = 12000;
		overmap_legacy_name = "Starline Shuttle";
	}
	facing_dir = NORTH
#warn impl


/obj/overmap/entity/visitable/ship/landable/civvie
/area/shuttle/civvie
#warn map
