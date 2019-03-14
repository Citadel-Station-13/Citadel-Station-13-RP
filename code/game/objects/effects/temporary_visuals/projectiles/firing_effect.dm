/obj/effect/temp_visual/dir_setting/firing_effect
	icon = 'icons/effects/effects.dmi'
	icon_state = "firing_effect"
	duration = 2

/obj/effect/temp_visual/dir_setting/firing_effect/setDir(newdir)
	switch(newdir)
		if(NORTH)
			layer = BELOW_MOB_LAYER
			pixel_x = rand(-3,3)
			pixel_y = rand(4,6)
		if(SOUTH)
			pixel_x = rand(-3,3)
			pixel_y = rand(-1,1)
		else
			pixel_x = rand(-1,1)
			pixel_y = rand(-1,1)
	..()

/obj/effect/temp_visual/dir_setting/firing_effect/energy
	icon_state = "firing_effect_energy"
	duration = 3

/obj/effect/temp_visual/dir_setting/firing_effect/magic
	icon_state = "shieldsparkles"
	duration = 3
