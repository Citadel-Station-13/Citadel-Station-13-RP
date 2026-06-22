DECLARE_SECTOR_SHUTTLE_TEMPLATE(/itv_manta, /boarding_craft)
	id = "sector-itv_manta-boarding_craft"
	name = "SAARE Boarding Craft"
	display_name = "SAARE Boarding Craft"
	descriptor = /datum/shuttle_descriptor{
		mass = 7500;
		overmap_legacy_scan_name = "SAARE Boarding Craft";
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: SAARE Mercenary Cruiser Typhon Four-Niner's Lander
[i]Class[/i]: Unknown Shuttle-approximate
[i]Transponder[/i]: Broadcasting (PMC)
[b]Notice[/b]: SAARE are unlikely to tolerate civilian or corporate personnel interfering with their affairs. Approach with caution."};
		overmap_icon_color = "#333333";
	}
	#warn facing dir

#warn impl

/obj/effect/shuttle_landmark/shuttle_initializer/manta_ship_boat
/datum/shuttle/autodock/overmap/manta_ship_boat
/obj/overmap/entity/visitable/ship/landable/manta_ship_boat
