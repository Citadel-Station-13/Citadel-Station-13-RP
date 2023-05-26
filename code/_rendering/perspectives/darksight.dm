/atom/movable/screen/darksight
	icon = null
	icon_state = null
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	vis_flags = VIS_INHERIT_DIR

/image/darksight_overlay
	icon = SOFT_DARKSIGHT_15X15_ICON
	icon_state = "full-square"
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_OCCLUSION
	alpha = 255
	blend_mode = BLEND_MULTIPLY
	appearance_flags = KEEP_TOGETHER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)
	pixel_y = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)
	override = TRUE
