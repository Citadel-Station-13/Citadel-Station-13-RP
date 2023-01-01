/**
 * y'know tg's emissive_blocker
 *
 * this is the opposite
 *
 * please don't use this unless you know what you're doing
 *
 * no seriously this is a Citadel Moment, don't do what we did.
 */
/atom/movable/emissive_render
	name = "emissive render"
	plane = EMISSIVE_PLANE
	layer = FLOAT_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	// don't re-apply transform because vis_contents do it already
	appearance_flags = RESET_TRANSFORM

/atom/movable/emissive_render/Initialize(mapload, source)
	. = ..()
	verbs.Cut() //Cargo culting from lighting object, this maybe affects memory usage?
	render_source = source
	color = GLOB.emissive_color

/atom/movable/emissive_render/Destroy()
	if(ismovable(loc))
		var/atom/movable/AM = loc
		AM.vis_contents -= src
		if(AM.em_render == src)
			AM.em_render = null
	return ..()

/atom/movable/emissive_render/forceMove(atom/destination)
	return FALSE	// nope.
