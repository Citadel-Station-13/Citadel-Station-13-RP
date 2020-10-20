#define SNAKE_SPAM_TICKS 600 //how long between cardboard box openings that trigger the '!'
/obj/structure/closet/cardboard
	name = "Large cardboard box"
	desc = "Just a box..."
	icon = 'icons/obj/closet.dmi'
	icon_state = "cardboard"
	icon_closed = "cardboard"
	icon_opened = "cardboard_open"
	storage_capacity = 1 * MOB_MEDIUM
	health = 70
	var/can_weld_shut = FALSE
	open_sound = "sound/effects/rustle1.ogg"
	var/delivery_icon = "deliverybox"
	var/anchorable = FALSE
	var/move_speed_multiplier = 1
	var/move_delay = 0
	var/egged = 0

/obj/structure/attackby/(obj/item/WC as obj, mob/user as mob)
	if(istype(WC, /obj/item/tool/wirecutters))
		playsound(src, WC.usesound)
		new /obj/item/stack/material/cardboard(src.loc)
		for(var/mob/M in viewers(src))
			M.show_message("<span class= 'notice'>\The [src] has been cut apart by [user] with \the [WC].<span>", 3, "You hear wirecutters.", 2)
	qdel(src)
	return

/obj/structure/closet/cardboard/relaymove(mob/user, direction)
	if(opened || move_delay || user.stat || user.stunned || user.weakened || user.paralysis || !isturf(loc) || !has_gravity(loc))
		return
	move_delay = 1
	if(step(src, direction))
		spawn(config_legacy.walk_speed*move_speed_multiplier)
			move_delay = 0
	else
		move_delay = 0

/obj/structure/closet/cardboard/open()
	if(opened || !can_open())
		return 0
	if(!egged)
		var/mob/living/Snake = null
		for(var/mob/living/L in src.contents)
			Snake = L
			break
		if(Snake)
			var/list/alerted = viewers(7,src)
			if(alerted)
				for(var/mob/living/L in alerted)
					if(!L.stat)
						L.do_alert_animation(L)
						egged = 1
				alerted << sound('sound/machines/chime.ogg')
	..()


/mob/living/proc/do_alert_animation(atom/A)
	var/image/I
	I = image('icons/obj/closet.dmi', A, "cardboard_special", A.layer+1)
	var/list/viewing = list()
	for(var/mob/M in viewers(A))
		if(M.client)
			viewing |= M.client
	flick_overlay(I,viewing,8)
	I.alpha = 0
	animate(I, pixel_z = 32, alpha = 255, time = 5, easing = ELASTIC_EASING)


/obj/structure/closet/cardboard/metal
	name = "Large metal box"
	desc = "THE COWARDS! THE FOOLS!"
	icon_closed = "metalbox"
	icon_opened = "metalbox_open"
	health = 500
	storage_capacity = 5 * MOB_MEDIUM
	move_speed_multiplier = 2
	open_sound = 'sound/machines/click.ogg'
#undef SNAKE_SPAM_TICKS
