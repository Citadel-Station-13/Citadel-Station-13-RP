/**
 * lazy man's render plates, used for specific usecases.
 */
/atom/movable/screen/plane_render
	icon = null
	icon_state = null
	abstract_type = /atom/movable/screen/plane_render

	/// our relevant plane master that we're pulling from - if this is not in the plane holder, we don't spawn.
	var/relevant_plane_path

//? game render relay

/atom/movable/screen/plane_render/relay_objs
	plane = GAME_RENDER_RELAY_PLANE
	layer = GAME_RENDER_RELAY_LAYER_OBJS
	render_source = OBJ_PLANE_RENDER_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/game_relay_plate

/atom/movable/screen/plane_render/relay_turfs
	plane = GAME_RENDER_RELAY_PLANE
	layer = GAME_RENDER_RELAY_LAYER_TURFS
	render_source = TURF_PLANE_RENDER_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/game_relay_plate

/atom/movable/screen/plane_render/relay_mobs
	plane = GAME_RENDER_RELAY_PLANE
	layer = GAME_RENDER_RELAY_LAYER_MOBS
	render_source = MOB_PLANE_RENDER_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/game_relay_plate

//? darkvision relays

/atom/movable/screen/plane_render/lighting_lightmask
	plane = LIGHTMASK_PLANE
	layer = LIGHTMASK_LAYER_MAIN
	render_source = LIGHTING_RENDER_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/lightmask

/atom/movable/screen/plane_render/darkvision_game
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_GAME
	render_source = GAME_RENDER_RELAY_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/darkvision
