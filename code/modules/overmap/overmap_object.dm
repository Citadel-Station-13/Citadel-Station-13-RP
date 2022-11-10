/obj/effect/overmap
	name = "map object"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "object"
	color = "#fffffe"

	/// Does this show up on nav computers automatically.
	var/known = TRUE
	/// If set to TRUE will show up on ship sensors for detailed scans.
	var/scannable
	/// Name for scans, replaces name once scanned.
	var/scanner_name
	/// Description for scans.
	var/scanner_desc

	/// Icon file to use for skybox.
	var/skybox_icon
	/// Icon state to use for skybox.
	var/skybox_icon_state
	/// Shift from lower left corner of skybox.
	var/skybox_pixel_x
	/// Shift from lower left corner of skybox.
	var/skybox_pixel_y

	//Cache stuff
	var/image/cached_skybox_image

	var/image/real_appearance

	/// parallax vis contents object if any
	var/atom/movable/overmap_skybox_holder/parallax_image_holder

/atom/movable/overmap_skybox_holder
	plane = PARALLAX_PLANE
	layer = PARALLAX_VIS_LAYER_BELOW
	blend_mode = BLEND_OVERLAY

/obj/effect/overmap/proc/generate_parallax_holder()
	parallax_image_holder = new

/obj/effect/overmap/proc/get_parallax_image()
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
/obj/effect/overmap/proc/get_skybox_representation()
	if(!cached_skybox_image)
		build_skybox_representation()
	return cached_skybox_image

/obj/effect/overmap/proc/build_skybox_representation()
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

/obj/effect/overmap/proc/expire_skybox_representation()
	cached_skybox_image = null

/obj/effect/overmap/proc/update_skybox_representation()
	expire_skybox_representation()
	build_skybox_representation()
	for(var/obj/effect/overmap/visitable/O in loc)
		for(var/z in O.map_z)
			SSparallax.queue_z_vis_update(z)

/obj/effect/overmap/proc/get_scan_data(mob/user)
	if(scanner_name && (name != scanner_name)) //A silly check, but 'name' is part of appearance, so more expensive than you might think
		name = scanner_name

	var/dat = {"\[b\]Scan conducted at\[/b\]: [stationtime2text()] [stationdate2text()]\n\[b\]Grid coordinates\[/b\]: [x],[y]\n\n[scanner_desc]"}

	return dat

/obj/effect/overmap/Initialize(mapload)
	. = ..()
	if(!GLOB.using_map.use_overmap)
		return INITIALIZE_HINT_QDEL

	if(known && !mapload)
		SSovermaps.queue_helm_computer_rebuild()
	update_icon()

/obj/effect/overmap/Crossed(var/obj/effect/overmap/visitable/other)
	. = ..()
	if(istype(other))
		for(var/z in other.map_z)
			SSparallax.queue_z_vis_update(z)

/obj/effect/overmap/Uncrossed(var/obj/effect/overmap/visitable/other)
	. = ..()
	if(istype(other))
		for(var/z in other.map_z)
			SSparallax.queue_z_vis_update(z)

/obj/effect/overmap/update_icon()
	filters = filter(type="drop_shadow", color = color + "F0", size = 2, offset = 1,x = 0, y = 0)
