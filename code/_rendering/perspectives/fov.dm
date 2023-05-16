
GLOBAL_LIST_INIT(darksight_fov_overlays, darksight_fov_overlays())

/proc/darksight_fov_overlays()
	. = list()
	.[SOFT_DARKSIGHT_FOV_90] = mutable_appearance('icons/screen/rendering/field_of_vision.dmi', "90_hard")
	.[SOFT_DARKSIGHT_FOV_180] = mutable_appearance('icons/screen/rendering/field_of_vision.dmi', "180_hard")
	.[SOFT_DARKSIGHT_FOV_270] = mutable_appearance('icons/screen/rendering/field_of_vision.dmi', "270_hard")
	for(var/key in .)
		var/mutable_appearance/app = .[key]
		app.blend_mode = BLEND_MULTIPLY
