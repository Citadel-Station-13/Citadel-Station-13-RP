/**
 * gives an atom the ability to be seen anywhere
 */
/atom/proc/vfx_make_see_anywhere()
	__vfx_apply_see_anywhere_overlay()
	appearance_flags &= ~TILE_BOUND

/**
 * removes the ability for an atom to be seen anywhere
 */
/atom/proc/vfx_remove_see_anywhere()
	__vfx_remove_see_anywhere_overlay()
	appearance_flags |= TILE_BOUND

GLOBAL_DATUM_INIT(see_anywhere_appearance, /mutable_appearance, init_see_anywhere_overlay())

/proc/__vfx_see_anywhere_atom_holder_at(loc)
	var/atom/movable/AM = new /atom/movable/vfx_see_anywhere_holder(loc)
	AM.appearance = GLOB.see_anywhere_appearance

/atom/movable/vfx_see_anywhere_holder
	vis_flags = VIS_HIDE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = KEEP_TOGETHER

/proc/init_see_anywhere_overlay()
	var/mutable_appearance/I = new
	I.icon = 'icons/screen/rendering/vfx/see_anywhere_overlay.dmi'
	I.icon_state = ""
	I.alpha = 1
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	I.appearance_flags = RESET_TRANSFORM | KEEP_APART | RESET_ALPHA | RESET_COLOR | KEEP_TOGETHER
	I.vis_flags = VIS_HIDE
	I.plane = FLOAT_PLANE
	I.layer = FLOAT_LAYER
	I.pixel_x = -320
	I.pixel_y = -320

/**
 * just applies the see anywhere overlay to the atom.
 */
/atom/proc/__vfx_apply_see_anywhere_overlay()
	add_overlay(GLOB.see_anywhere_appearance)

/**
 * just removes the see anywhere overlay to the atom
 */
/atom/proc/__vfx_remove_see_anywhere_overlay()
	cut_overlay(GLOB.see_anywhere_appearance)
