/**
 * the supertype of all viablely interacting overmap objects
 *
 * there are two main types
 * /entity - these have heavier simulation. anything requiring ticking or physics should be under this
 * /tiled - these have Crossed/Uncrossed hooked, obviously, but they shouldn't require ticking/physics
 *
 * anything that the player can interact with beyond "crashing through a meteor field" should probably
 * be an entity!
 *
 * anything else should be tiled, because tiled has very little simulation and are practically free
 *
 * entities, however, incur cost to keep on the map due to our makeshift physicis backend in /datum/overmap.
 */
/obj/overmap
	name = "map object"
	icon = 'icons/modules/overmap/entity.dmi'
	icon_state = "object"
	color = "#fffffe"

	/// curernt bounds overlay, if any
	var/bounds_overlay
	/// should we use bounds overlays?
	var/uses_bounds_overlay = FALSE

	//  TODO: ALL OF THESE BELOW VARIABLES shouldn't be on /obj/overmap level
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

/obj/overmap/Initialize(mapload)
	. = ..()

	if(uses_bounds_overlay)
		add_bounds_overlay()

	if(!(LEGACY_MAP_DATUM).use_overmap)
		return INITIALIZE_HINT_QDEL

	update_icon()

/obj/overmap/Destroy()
	cut_bounds_overlay()
	return ..()

/atom/movable/overmap_skybox_holder
	plane = PARALLAX_PLANE
	layer = PARALLAX_VIS_LAYER_BELOW
	blend_mode = BLEND_OVERLAY

/obj/overmap/proc/generate_parallax_holder()
	parallax_image_holder = new

/obj/overmap/proc/get_parallax_image()
	var/image/I = get_skybox_representation()
	if(!I)
		return
	if(isnull(parallax_image_holder))
		parallax_image_holder = generate_parallax_holder()
		// eh we can optimize this/clean it up later
		if(isnull(parallax_image_holder))
			return
	parallax_image_holder.layer = PARALLAX_PLANE
	parallax_image_holder.add_overlay(I)
	return parallax_image_holder

//Overlay of how this object should look on other skyboxes
/obj/overmap/proc/get_skybox_representation()
	if(!cached_skybox_image)
		build_skybox_representation()
	return cached_skybox_image

/obj/overmap/proc/build_skybox_representation()
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

/obj/overmap/proc/expire_skybox_representation()
	cached_skybox_image = null

/obj/overmap/proc/update_skybox_representation()
	expire_skybox_representation()
	build_skybox_representation()
	for(var/obj/overmap/entity/visitable/O in loc)
		for(var/z in O.map_z)
			SSparallax.queue_z_vis_update(z)

/obj/overmap/proc/get_scan_data(mob/user)
	if(scanner_name && (name != scanner_name)) //A silly check, but 'name' is part of appearance, so more expensive than you might think
		name = scanner_name

	var/dat = {"\[b\]Scan conducted at\[/b\]: [stationtime2text()] [stationdate2text()]\n\[b\]Grid coordinates\[/b\]: [x],[y]\n\n[scanner_desc]"}

	return dat

/obj/overmap/Crossed(var/obj/overmap/entity/visitable/other)
	. = ..()
	if(istype(other))
		for(var/z in other.map_z)
			SSparallax.queue_z_vis_update(z)

/obj/overmap/Uncrossed(var/obj/overmap/entity/visitable/other)
	. = ..()
	if(istype(other))
		for(var/z in other.map_z)
			SSparallax.queue_z_vis_update(z)

/obj/overmap/update_icon()
	filters = filter(type="drop_shadow", color = color + "F0", size = 1, offset = 1,x = 0, y = 0)
