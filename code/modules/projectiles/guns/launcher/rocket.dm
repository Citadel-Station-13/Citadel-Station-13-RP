/obj/item/gun/launcher/rocket
	name = "rocket launcher"
	desc = "MAGGOT."
	icon_state = "rocket"
	item_state = "rocket"
	w_class = ITEMSIZE_LARGE
	throw_speed = 2
	throw_range = 10
	force = 5.0
	slot_flags = 0
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	fire_sound = 'sound/weapons/rpg.ogg'
	one_handed_penalty = 30

	release_force = 15
	throw_distance = 30
	var/max_rockets = 1
	var/list/rockets = new/list()
	var/caliber = "rocket"

/obj/item/gun/launcher/rocket/examine(mob/user)
	. = ..()
	if(get_dist(user, src) <= 2)
		. += "<font color='blue'>[rockets.len] / [max_rockets] rockets.</font>"

/obj/item/gun/launcher/rocket/proc/load(obj/item/ammo_casing/rocket/R, mob/user)
	if(R.loadable)
		if(rockets.len >= max_rockets)
			to_chat(user, "<span class='warning'>[src] is full.</span>")
			return
		user.remove_from_mob(R)
		R.loc = src
		rockets.Insert(1, R) //add to the head of the list, so that it is loaded on the next pump
		user.visible_message("[user] inserts \a [R] into [src].", "<span class='notice'>You insert \a [R] into [src].</span>")
		return
	to_chat(user, "<span class='warning'>[R] doesn't seem to fit in the [src]!</span>")

/obj/item/gun/launcher/rocket/proc/unload(mob/user)
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/R = rockets[rockets.len]
		rockets.len--
		user.put_in_hands(R)
		user.visible_message("[user] removes \a [R] from [src].", "<span class='notice'>You remove \a [R] from [src].</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	else
		to_chat(user, "<span class='warning'>[src] is empty.</span>")

/obj/item/gun/launcher/rocket/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/ammo_casing/rocket)))
		load(I, user)
	else
		..()

/obj/item/gun/launcher/rocket/attack_hand(mob/user)
	if(user.get_inactive_hand() == src)
		unload(user)
	else
		..()

//According to grenade launcher code, this broke?
/*
/obj/item/gun/launcher/rocket/consume_next_projectile()
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		rockets -= I
		return
	return null
*/

/obj/item/gun/launcher/rocket/handle_post_fire(mob/user, atom/target)
	message_admins("[key_name_admin(user)] fired a rocket from a rocket launcher ([src.name]) at [target].")
	log_game("[key_name_admin(user)] used a rocket launcher ([src.name]) at [target].")
	..()

/obj/item/gun/launcher/rocket/tyrmalin
	name = "rokkit launcher"
	desc = "MAGGOT."
	icon_state = "rokkitlauncher"
	item_state = "rocket"
	var/unstable = 1
	var/jammed = 0

/obj/item/gun/launcher/rocket/tyrmalin/consume_next_projectile(mob/user as mob)
	. = ..()
	if(.)
		if(unstable)
			switch(rand(1,100))
				if(1 to 10)
					to_chat(user, "<span class='danger'>The rocket primer activates early!</span>")
					icon_state = "rokkitlauncher-malfunction"
					if(do_after(user, 20))
						explosion(get_turf(src), -1, 0, 2, 3)
						qdel(src)
				if(11 to 29)
					to_chat(user, "<span class='notice'>The rocket flares out in the tube!</span>")
					playsound(src, 'sound/machines/button.ogg', 25)
					icon_state = "rokkitlauncher-broken"
					jammed = 1
					handle_click_empty()
					return
				if(30 to 100)
					return 1
		if(jammed)
			to_chat(user, "<span class='notice'>The [src] is jammed!</span>")
			handle_click_empty()
			return
