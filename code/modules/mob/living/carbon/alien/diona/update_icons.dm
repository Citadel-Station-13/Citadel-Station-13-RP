/mob/living/carbon/alien/diona/update_icons()

	if(stat == DEAD)
		icon_state = "[initial(icon_state)]_dead"
	else if(lying || resting || stunned)
		icon_state = "[initial(icon_state)]_sleep"
	else
		icon_state = "[initial(icon_state)]"

	overlays.Cut()
	if(hat)
		var/mutable_appearance/MA = hat.render_mob_appearance(src, SLOT_ID_HEAD)
		MA.pixel_x = hat_x_offset
		MA.pixel_y = hat_y_offset
		overlays |= MA
