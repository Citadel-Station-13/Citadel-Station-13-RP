/atom/movable/screen/darksight_fov
	icon = SOFT_DARKSIGHT_15X15_ICON
	icon_state = "full-square"
	screen_loc = "CENTER-7,CENTER-7"
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_FOV
	alpha = 255
	blend_mode = BLEND_MULTIPLY
	appearance_flags = KEEP_TOGETHER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)
	pixel_y = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)

/atom/movable/screen/darksight_occlusion
	icon = 'icons/screen/fullscreen/fullscreen_tiled.dmi'
	icon_state = "black"
	screen_loc = "CENTER"
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_OCCLUSION
	alpha = 255
	blend_mode = BLEND_OVERLAY
	appearance_flags = KEEP_TOGETHER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)
	pixel_y = -((15 * WORLD_ICON_SIZE) / 2) + (WORLD_ICON_SIZE / 2)
	color = list(
		0, 0, 0, -1,
		0, 0, 0, -1,
		0, 0, 0, -1,
		0, 0, 0, 1,
		0, 0, 0, 0,
	)

/atom/movable/screen/darksight_occlusion/Initialize(mapload)
	. = ..()
	// fit any size screen; we resize via overlays.
	var/matrix/expansion = matrix()
	expansion.Scale(SOFT_DARKSIGHT_OCCLUSION_EXPAND, SOFT_DARKSIGHT_OCCLUSION_EXPAND)
	transform = expansion
