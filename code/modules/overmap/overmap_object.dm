/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"

	var/known = 1		// Shows up on nav computers automatically
	var/scannable		// If set to TRUE will show up on ship sensors for detailed scans
	var/scanner_name	// Name for scans, replaces name once scanned
	var/scanner_desc	// Description for scans

// Overlay of how this object should look on other skyboxes
/obj/effect/overmap/proc/get_skybox_representation()
	return

/obj/effect/overmap/proc/get_scan_data(mob/user)
	if(scanner_name && (name != scanner_name))	//A silly check, but 'name' is part of appearance, so more expensive than you might think
		name = scanner_name

	var/dat = {"\[b\]Scan conducted at\[/b\]: [stationtime2text()] [stationdate2text()]\n\[b\]Grid coordinates\[/b\]: [x],[y]\n\n[scanner_desc]"}

	return dat

/obj/effect/overmap/Initialize()
	. = ..()
	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(known)
		//layer = ABOVE_LIGHTING_LAYER
		plane = PLANE_LIGHTING_ABOVE
		for(var/obj/machinery/computer/ship/helm/H in global.machines)
			H.get_known_sectors()

/obj/effect/overmap/Crossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)
/obj/effect/overmap/Uncrossed(var/obj/effect/overmap/visitable/other)
	if(istype(other))
		SSskybox.rebuild_skyboxes(other.map_z)
		for(var/obj/effect/overmap/visitable/O in loc)
			SSskybox.rebuild_skyboxes(O.map_z)

/obj/effect/overmap/update_icon()
	filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0)
