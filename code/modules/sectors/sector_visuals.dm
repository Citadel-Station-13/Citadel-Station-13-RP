/**
 * holder put into the vis contents of every tile of a world sector
 */
/atom/movable/sector_visuals
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/**
 * sets up visuals on outdoors turfs
 */
/datum/world_sector/proc/initialize_visuals()
	ASSERT(!visuals_initialized)
	#warn impl

/**
 * cleans up visuals on outdoors turfs
 */
/datum/world_sector/proc/cleanup_visuals()
	ASSERT(visuals_initialized)
	#warn impl

/**
 * makes sure visuals are set up on outdoors turfs
 */
/datum/world_sector/proc/ensure_visuals()
	if(visuals_initialized)
		return
	initialize_visuals()

/**
 * holder put into the client.screen of all mobs on level
 */
/atom/movable/screen/sector_parallax
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	screen_loc = "CENTER"
	#warn impl

/**
 * occlusion mask out on all outdoors tiles when needed
 */
/atom/movable/sector_occlusion
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	plane = WEATHER_OCCLUSION_PLANE
	icon = 'icons/screen/weather/occlusion.dmi'
	icon_state = "full"
	vis_flags = NONE

GLOBAL_DATUM_INIT(sector_occlusion_graphics, /atom/movable/sector_occlusion, new)

/datum/world_sector/proc/reconsider_occlusion()
	if(needs_occlusion())
		add_occlusion()
	else
		remove_occlusion()

/datum/world_sector/proc/needs_occlusion()
	if(weather?.has_visuals())
		return TRUE
	return FALSE

/datum/world_sector/proc/add_occlusion()
	ensure_visuals()
	tile_holder.vis_contents |= GLOB.sector_occlusion_graphics

/datum/world_sector/proc/remove_occlusion()
	tile_holder?.vis_contents -= GLOB.sector_occlusion_graphics
