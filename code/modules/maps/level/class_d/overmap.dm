/obj/effect/overmap/visitable/sector/classd
	name = "Class D Moon"
	desc = "A rocky planet with radioactive hazards abundant."
	scanner_desc = @{"[i]Stellar Body[/i]:
[i]Class[/i]: D-Class Planet
[i]Habitability[/i]: Extremely Low (Low Temperature, Toxic Atmosphere, Radioactive Hazards)
[b]Notice[/b]: Planetary environment not suitable for life. Landing may be hazardous."}
	icon_state = "globe"
	in_space = 0
	color = "#eaa17c"
	initial_generic_waypoints = list("classd_east","classd_west","classd_north","classd_south")

// Shuttle landing area waypoints

/obj/effect/shuttle_landmark/premade/classd/east
	name = "Class D - Eastern Zone"
	landmark_tag = "classd_east"

/obj/effect/shuttle_landmark/premade/classd/west
	name = "Class D - Western Zone"
	landmark_tag = "classd_west"

/obj/effect/shuttle_landmark/premade/classd/north
	name = "Class D - Northern Zone"
	landmark_tag = "classd_north"

/obj/effect/shuttle_landmark/premade/classd/south
	name = "Class D - Southern Zone"
	landmark_tag = "classd_south"
