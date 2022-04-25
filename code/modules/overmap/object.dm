/atom/movable/overmap_object
	name = "map object"
	#warn move stuff
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	color = "#fffffe"

	var/known = 1		//shows up on nav computers automatically
	var/scannable       //if set to TRUE will show up on ship sensors for detailed scans
	var/scanner_name	// Name for scans, replaces name once scanned
	var/scanner_desc	// Description for scans

	var/skybox_icon 		//Icon file to use for skybox
	var/skybox_icon_state	//Icon state to use for skybox
	var/skybox_pixel_x		//Shift from lower left corner of skybox
	var/skybox_pixel_y		//Shift from lower left corner of skybox
	var/image/cached_skybox_image	//Cachey
	var/image/real_appearance

	/// parallax vis contents object if any
	var/atom/movable/overmap_object_skybox_holder/parallax_image_holder

/atom/movable/overmap_object_skybox_holder
	plane = PARALLAX_PLANE
	layer = PARALLAX_VIS_LAYER_BELOW
	blend_mode = BLEND_OVERLAY

/atom/movable/overmap_object/proc/generate_parallax_holder()
	parallax_image_holder = new

/atom/movable/overmap_object/proc/get_parallax_image()
	var/image/I = get_skybox_representation()
	if(!I)
		return
	if(isnull(parallax_image_holder))
		parallax_image_holder = generate_parallax_holder()
		// eh we can optimize this/clean it up later
		if(isnull(parallax_image_holder))
			return
	parallax_image_holder.layer = PARALLAX_PLANE
	parallax_image_holder.overlays = list(I)
	return parallax_image_holder

//Overlay of how this object should look on other skyboxes
/atom/movable/overmap_object/proc/get_skybox_representation()
	if(!cached_skybox_image)
		build_skybox_representation()
	return cached_skybox_image

/atom/movable/overmap_object/proc/build_skybox_representation()
	if(!skybox_icon)
		return
	var/image/I = image(icon = skybox_icon, icon_state = skybox_icon_state)
	if(isnull(skybox_pixel_x))
		skybox_pixel_x = rand(200,600)
	if(isnull(skybox_pixel_y))
		skybox_pixel_y = rand(200,600)
	I.pixel_x = skybox_pixel_x
	I.pixel_y = skybox_pixel_y
	I.blend_mode = BLEND_OVERLAY
	I.plane = PARALLAX_PLANE
	I.layer = PARALLAX_VIS_LAYER_BELOW
	cached_skybox_image = I

/atom/movable/overmap_object/proc/expire_skybox_representation()
	cached_skybox_image = null

/atom/movable/overmap_object/proc/update_skybox_representation()
	expire_skybox_representation()
	build_skybox_representation()
	for(var/atom/movable/overmap_object/entity/visitable/O in loc)
		for(var/z in O.map_z)
			SSparallax.queue_z_vis_update(z)

/atom/movable/overmap_object/proc/get_scan_data(mob/user)
	if(scanner_name && (name != scanner_name)) //A silly check, but 'name' is part of appearance, so more expensive than you might think
		name = scanner_name

	var/dat = {"\[b\]Scan conducted at\[/b\]: [stationtime2text()] [stationdate2text()]\n\[b\]Grid coordinates\[/b\]: [x],[y]\n\n[scanner_desc]"}

	return dat

/atom/movable/overmap_object/Initialize(mapload)
	. = ..()
	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(known && !mapload)
		SSovermaps.queue_helm_computer_rebuild()
	update_icon()

/atom/movable/overmap_object/Crossed(var/atom/movable/overmap_object/entity/visitable/other)
	. = ..()
	if(istype(other))
		for(var/z in other.map_z)
			SSparallax.queue_z_vis_update(z)

/atom/movable/overmap_object/Uncrossed(var/atom/movable/overmap_object/entity/visitable/other)
	. = ..()
	if(istype(other))
		for(var/z in other.map_z)
			SSparallax.queue_z_vis_update(z)

/atom/movable/overmap_object/update_icon()
	filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0)

/atom/movable/overmap_object/proc/update_bounds_visual()
	return
