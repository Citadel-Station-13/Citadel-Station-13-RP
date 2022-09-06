/atom/movable/screen/hud/throwmode
	name = "throw"
	desc = "Toggles throwmode. Shift + click to overhand throw."
	icon_state = "act_throw_off"
	screen_loc = ui_drop_throw

/atom/movable/screen/hud/throwmode/clicked(mob/user)
	user.toggle_throw_mode()

/atom/movable/screen/hud/throwmode/shift_clicked(mob/user)
	user.toggle_throw_mode(TRUE)

/atom/movable/screen/hud/update_icon_state()
	. = ..()
	remove_filter("overhand", FALSE)
	switch(hud?.mymob?.in_throw_mode)
		if(THROW_MODE_ON)
			icon_state = "act_throw_on"
		if(THROW_MODE_OFF)
			icon_state = "act_throw_off"
		if(THROW_MODE_OVERHAND)
			icon_state = "act_throw_on"
			add_filter("overhand", 1, outline_filter(
				1,
				"#00cc00",
				NONE
			), FALSE)
	update_filters()
