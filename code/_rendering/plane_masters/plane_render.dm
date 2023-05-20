/**
 * lazy man's render plates, used for specific usecases.
 */
/atom/movable/screen/plane_render
	abstract_type = /atom/movable/screen/plane_render

	/// our relevant plane master that we're pulling from - if this is not in the plane holder, we don't spawn.
	var/relevant_plane_path

/atom/movable/screen/plane_render/darkvision_plate
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_PLATE
	render_source = DARKVISION_PLATE_RENDER_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/darkvision_plate

/atom/movable/screen/plane_render/darkvision_objs
	plane = DARKVISION_PLATE_PLANE
	layer = DARKVISION_PLATE_LAYER_OBJS
	relevant_plane_path = /atom/movable/screen/plane_master/darkvision_plate

/atom/movable/screen/plane_render/darkvision_turfs
	plane = DARKVISION_PLATE_PLANE
	layer = DARKVISION_PLATE_LAYER_TURFS
	relevant_plane_path = /atom/movable/screen/plane_master/darkvision_plate

/atom/movable/screen/plane_render/darkvision_objs
	plane = DARKVISION_PLATE_PLANE
	layer = DARKVISION_PLATE_LAYER_MOBS
	relevant_plane_path = /atom/movable/screen/plane_master/darkvision_plate

/atom/movable/screen/plane_render/lighting_as_alpha
	plane = RENDER_INTERMEDIATE_PLANE
	render_source = LIGHTING_RENDER_TARGET
	render_target = LIGHTING_ALPHA_FORWARD_TARGET
	relevant_plane_path = /atom/movable/screen/plane_master/lighting
	// convert all color to alpha
	color = list(
		0, 0, 0, 0.33,
		0, 0, 0, 0.33,
		0, 0, 0, 0.33,
		0, 0, 0, 0,
		1, 1, 1, 0
	)
