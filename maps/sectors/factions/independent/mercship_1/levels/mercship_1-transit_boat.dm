#warn check map, is this viable for moving to generic shuttles?
DECLARE_SECTOR_SHUTTLE_TEMPLATE(/mercship_1, /transit_boat)
	id = "sector-mercship_1-transit_boat"
	name = "Mercenary Transit Boat"
	desc = "A transit boat for a mercenary vessel."
	descriptor = /datum/shuttle_descriptor{
		overmap_legacy_scan_desc = @{"[i]Registration[/i]: UNKNOWN
[i]Class[/i]: UNKNOWN
[i]Transponder[/i]: None Detected
[b]Notice[/b]: Unregistered vessel"};
		overmap_legacy_scan_name = "Unknown Vessel";
		overmap_icon_color = "#f23000"; //Red
		mass = 8000;
	}

#warn impl
/area/shuttle/mercboat
#warn map
