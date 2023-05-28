/atom/movable/screen/darksight_fov
	icon = SOFT_DARKSIGHT_15X15_ICON
	icon_state = "full-square"
	screen_loc = "CENTER-7,CENTER-7"
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_FOV
	alpha = 255
	blend_mode = BLEND_MULTIPLY
	appearance_flags = KEEP_TOGETHER | KEEP_APART
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)
	pixel_y = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)

/atom/movable/screen/darksight_occlusion
	icon = SOFT_DARKSIGHT_15X15_ICON
	icon_state = "full-square"
	screen_loc = "CENTER-7,CENTER-7"
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_OCCLUSION
	alpha = 255
	blend_mode = BLEND_MULTIPLY
	appearance_flags = KEEP_TOGETHER | KEEP_APART
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)
	pixel_y = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)
