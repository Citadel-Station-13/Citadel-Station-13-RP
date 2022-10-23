/**
 * i hate that this has to exist
 * hud refactor + plane refactor + redoing augmented plane when
 */
/atom/movable/augmented_holder
	plane = PLANE_AUGMENTED
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	/// our master
	var/atom/movable/holder

/atom/movable/augmented_holder/Initialize(mapload, atom/movable/master, mutable_appearance/A)
	appearance = A
	// incase some idiot (see: myself) forgets to make the mutable appearance move to the right plane..
	plane = PLANE_AUGMENTED
	holder = master
	holder.vis_contents += src
	vis_flags = VIS_INHERIT_ID
	moveToNullspace()
	return ..()

/atom/movable/augmented_holder/Destroy()
	holder.vis_contents -= src
	holder = null
	return ..()
