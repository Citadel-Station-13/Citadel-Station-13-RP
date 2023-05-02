/**
 * lazy man's render plates, used for specific usecases.
 */
/atom/movable/screen/plane_render
	abstract_type = /atom/movable/screen/plane_render

	/// our relevant plane master that we're pulling from - if this is not in the plane holder, we don't spawn.
	var/relevant_plane_path

/atom/movable/screen/plane_render/darkvision_plate
	render_target = DARKVISION_PLATE_FORWARD_TARGET
	// convert all color to alpha
	color = list(

	)

#warn uhh

/atom/movable/screen/plane_render/lighting_as_alpha
	render_target = LIGHTING_ALPHA_FORWARD_TARGET
	// convert all color to alpha
	color = list(

	)
