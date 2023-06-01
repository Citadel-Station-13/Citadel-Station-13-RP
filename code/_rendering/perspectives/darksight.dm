/atom/movable/screen/darksight_fov
	icon = SOFT_DARKSIGHT_15X15_ICON
	icon_state = "full-square"
	screen_loc = "CENTER-7,CENTER-7"
	plane = FOV_OCCLUSION_PLANE
	layer = FOV_OCCLUSION_LAYER_MAIN
	alpha = 255
	blend_mode = BLEND_OVERLAY
	appearance_flags = KEEP_TOGETHER | TILE_BOUND
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)
	pixel_y = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)

/atom/movable/screen/darksight_occlusion
	icon = SOFT_DARKSIGHT_15X15_ICON
	icon_state = "fade-omni-super"
	screen_loc = "CENTER-7,CENTER-7"
	plane = DARKVISION_OCCLUSION_PLANE
	layer = DARKVISION_OCCLUSION_LAYER_MAIN
	alpha = 255
	blend_mode = BLEND_OVERLAY
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	appearance_flags = KEEP_TOGETHER | TILE_BOUND
