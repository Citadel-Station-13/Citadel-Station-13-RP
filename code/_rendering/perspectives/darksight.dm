/atom/movable/screen/darksight
	icon = null
	icon_state = null

/image/darksight_overlay
	icon = SOFT_DARKSIGHT_15X15_ICON
	icon_state = "full-square"
	plane = DARKVISION_PLANE
	layer = DARKVISION_LAYER_OCCLUSION
	alpha = 128
	blend_mode = BLEND_MULTIPLY
	appearance_flags = KEEP_TOGETHER
	screen_loc = "CENTER-7,CENTER-7"
	override = TRUE

// todo: auto shift when moving elsewhere?
