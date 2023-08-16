/**
 * lazy man's render plates, used for specific usecases.
 */
/atom/movable/screen/plane_render
	icon = null
	icon_state = null
	abstract_type = /atom/movable/screen/plane_render

	/// our relevant plane master that we're pulling from - if this is not in the plane holder, we don't spawn.
	/// this can be weird for planes like parallax, so just make a best effort at making this make sense.
	var/relevant_plane_path
	/// for overriding base screen loc. do "FULLSCREEN" for fullscreen.
	//  todo: fullscreens are not yet supported on secondary maps
	var/base_screen_loc = "CENTER"

//? darkvision relays

/atom/movable/screen/plane_render/lighting_lightmask
	plane = LIGHTMASK_PLANE
	layer = LIGHTMASK_LAYER_MAIN
	render_source = LIGHTING_RENDER_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/lightmask

/atom/movable/screen/plane_render/darkvision_turfs
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_TURFS
	render_source = TURF_PLANE_RENDER_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/darkvision

/atom/movable/screen/plane_render/darkvision_objs
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_OBJS
	render_source = OBJ_PLANE_RENDER_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/darkvision

/atom/movable/screen/plane_render/darkvision_mobs
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_MOBS
	render_source = MOB_PLANE_RENDER_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/darkvision

/atom/movable/screen/plane_render/darkvision_grain
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_NOISE
	alpha = 150
	relevant_plane_path = /atom/movable/screen/plane_master/darkvision
	icon = 'icons/screen/fullscreen/fullscreen_tiled.dmi'
	icon_state = "noise"
	blend_mode = BLEND_MULTIPLY
	base_screen_loc = "FULLSCREEN"

/**
 * makes SEE_BLACKNESS block darksight
 */
/atom/movable/screen/plane_render/darkvision_blackness
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_BLACKNESS
	blend_mode = BLEND_OVERLAY
	relevant_plane_path = /atom/movable/screen/plane_master/darkvision
	render_source = BYOND_RENDER_TARGET
