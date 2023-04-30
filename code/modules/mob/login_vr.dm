/mob/Login()
	. = ..()

	var/atom/movable/screen/plane_master/augmented/aug = plane_holder.plane_masters[VIS_AUGMENTED]
	aug.apply()
