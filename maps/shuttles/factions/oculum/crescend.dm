DECLARE_SHUTTLE_TEMPLATE(/factions/oculum/crescend)
	id = "oculum-crescend"
	name = "ORS Crescend Radio Shuttle"
	desc = "A racing shuttle, that arrived last during the 2542 Voidline shuttle race."

	descriptor = /datum/shuttle_descriptor{
		mass = 10000;
		overmap_icon_color = "#bcfbff"; //sky blue
		overmap_legacy_scan_name = "ORS Crescend Radio Shuttle";
		overmap_legacy_scan_name = @{"[i]Registration[/i]: ORS Crescend
[i]Class[/i]: Radio Shuttle
[i]Transponder[/i]: Transmitting (CIV), Registered with the Occulum News network
[b]Notice[/b]: A occulum vessel, based on a Teshari design."};
	}
	facing_dir = WEST

#warn impl

/obj/overmap/entity/visitable/ship/landable/trade/crescend
/area/shuttle/crescend
