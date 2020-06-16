// General loadout for Citadel additions.

/datum/gear/tennis_ball
	display_name = "tennis ball selection"
	path = /obj/item/toy/tennis

/datum/gear/tennis_ball/New()
	..()
	var/list/tennis_balls = list()
	for(var/tball in typesof(/obj/item/toy/tennis) - typesof(/obj/item/toy/tennis/rainbow))
		var/obj/item/toy/tennis/ball_type = tball
		tennis_balls[initial(ball_type.name)] = ball_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(tennis_balls, /proc/cmp_text_asc, TRUE))
