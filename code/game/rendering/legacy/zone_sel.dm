/atom/movable/screen/zone_sel
	name = "damage zone"
	icon_state = "zone_sel"
	screen_loc = ui_zonesel
	var/selecting = BP_TORSO

/atom/movable/screen/zone_sel/Click(location, control,params)
	var/list/PL = params2list(params)
	var/icon_x = text2num(PL["icon-x"])
	var/icon_y = text2num(PL["icon-y"])
	var/old_selecting = selecting //We're only going to update_icon() if there's been a change

	switch(icon_y)
		if(1 to 3) //Feet
			switch(icon_x)
				if(10 to 15)
					selecting = BODY_ZONE_R_FOOT
				if(17 to 22)
					selecting = BODY_ZONE_L_FOOT
				else
					return 1
		if(4 to 9) //Legs
			switch(icon_x)
				if(10 to 15)
					selecting = BODY_ZONE_R_LEG
				if(17 to 22)
					selecting = BODY_ZONE_L_LEG
				else
					return 1
		if(10 to 13) //Hands and groin
			switch(icon_x)
				if(8 to 11)
					selecting = BODY_ZONE_R_HAND
				if(12 to 20)
					selecting = BODY_ZONE_GROIN
				if(21 to 24)
					selecting = BODY_ZONE_L_HAND
				else
					return 1
		if(14 to 22) //Chest and arms to shoulders
			switch(icon_x)
				if(8 to 11)
					selecting = BODY_ZONE_R_ARM
				if(12 to 20)
					selecting = BODY_ZONE_TORSO
				if(21 to 24)
					selecting = BODY_ZONE_L_ARM
				else
					return 1
		if(23 to 30) //Head, but we need to check for eye or mouth
			if(icon_x in 12 to 20)
				selecting = BODY_ZONE_HEAD
				switch(icon_y)
					if(23 to 24)
						if(icon_x in 15 to 17)
							selecting = BODY_ZONE_MOUTH
					if(26) //Eyeline, eyes are on 15 and 17
						if(icon_x in 14 to 18)
							selecting = BODY_ZONE_EYES
					if(25 to 27)
						if(icon_x in 15 to 17)
							selecting = BODY_ZONE_EYES

	if(old_selecting != selecting)
		update_icon()
	return 1

/atom/movable/screen/zone_sel/proc/set_selected_zone(bodypart)
	var/old_selecting = selecting
	selecting = bodypart
	if(old_selecting != selecting)
		update_icon()

/atom/movable/screen/zone_sel/update_icon()
	cut_overlays()
	. = ..()
	add_overlay(image('icons/mob/zone_sel.dmi', "[selecting]"))
