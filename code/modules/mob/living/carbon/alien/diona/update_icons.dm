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
		MA.pixel_x = 0
		MA.pixel_y = -8
		overlays |= MA
