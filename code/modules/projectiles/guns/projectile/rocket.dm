/obj/item/gun/projectile/rocket
	name = "rocket launcher"
	desc = "MAGGOT."
	icon_state = "rocket"
	item_state = "rocket"
	caliber = "rocket"
	max_shells = 1
	load_method = SINGLE_CASING
	w_class = ITEMSIZE_LARGE
	heavy = TRUE
	throw_speed = 2
	throw_range = 10
	force = 5.0
	slot_flags = SLOT_BACK
	origin_tech = list(TECH_COMBAT = 8, TECH_MATERIAL = 5)
	fire_sound = 'sound/weapons/rpg.ogg'
	one_handed_penalty = 30

/*
/obj/item/gun/projectile/rocket/proc/load(obj/item/ammo_casing/rocket/R, mob/user)
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

/obj/item/gun/projectile/rocket/proc/unload(mob/user)
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/R = rockets[rockets.len]
		rockets.len--
		user.put_in_hands(R)
		user.visible_message("[user] removes \a [R] from [src].", "<span class='notice'>You remove \a [R] from [src].</span>")
		playsound(src.loc, 'sound/weapons/empty.ogg', 50, 1)
	else
		to_chat(user, "<span class='warning'>[src] is empty.</span>")

/obj/item/gun/projectile/rocket/attackby(obj/item/I, mob/user)
	if((istype(I, /obj/item/ammo_casing/rocket)))
		load(I, user)
	else
		..()

/obj/item/gun/projectile/rocket/attack_hand(mob/user)
	if(user.get_inactive_held_item() == src)
		unload(user)
	else
		..()

/obj/item/gun/launcher/rocket/consume_next_projectile()
	if(rockets.len)
		var/obj/item/ammo_casing/rocket/I = rockets[1]
		rockets -= I
		return
	return null
*/

/obj/item/gun/projectile/rocket/handle_post_fire(mob/user, atom/target)
	message_admins("[key_name_admin(user)] fired a rocket from a rocket launcher ([src.name]) at [target].")
	log_game("[key_name_admin(user)] used a rocket launcher ([src.name]) at [target].")
	..()

/obj/item/gun/projectile/rocket/collapsible
	name = "disposable rocket launcher"
	desc = "A single use rocket launcher designed with portability in mind. This disposable launcher must be extended before it can fire."
	icon_state = "missile"
	item_state = "missile"
	w_class = ITEMSIZE_NORMAL
	slot_flags = SLOT_BELT
	handle_casings = HOLD_CASINGS
	ammo_type = /obj/item/ammo_casing/rocket
	var/collapsed = 1
	var/empty = 0

/obj/item/gun/projectile/rocket/collapsible/special_check(mob/user)
	if(collapsed)
		to_chat(user, "<span class='warning'>[src] is collapsed! You must extend it before firing!</span>")
		return 0
	return ..()

/obj/item/gun/projectile/rocket/collapsible/attackby(var/obj/item/A as obj, mob/user as mob)
	to_chat(user, "<span class='danger'>You cannot reload the [src]!</span>")
	return

/obj/item/gun/projectile/rocket/collapsible/attack_hand(mob/user as mob)
	if(user.get_inactive_held_item() == src)
		to_chat(user, "<span class='danger'>You cannot unload the [src]'s munition!</span>")
		return
	else
		return ..()

/obj/item/gun/projectile/rocket/collapsible/attack_self(mob/user, obj/item/gun/G)
	if(collapsed)
		to_chat(user, "<span class='notice'>You pull out the tube on the [src], readying the weapon to be fired.</span>")
		icon_state = "[initial(icon_state)]-extended"
		item_state = "[initial(item_state)]-extended"
		collapsed = 0
	else if(!collapsed && empty)
		to_chat(user, "<span class='danger'>You cannot collapse the [src] after it has been fired!</span>")
		return
	else
		to_chat(user, "<span class='notice'>You push the tube back into the [src], collapsing the weapon.</span>")
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"
		collapsed = 1

/obj/item/gun/projectile/rocket/collapsible/examine(mob/user)
	. = ..()
	return

/obj/item/gun/projectile/rocket/collapsible/consume_next_projectile(mob/user as mob)
	. = ..()
	if(empty)
		return
	else
		name = "spent collapsible missile launcher"
		desc = "This missile launcher has been used. It is no longer able to fire."
		icon_state = "[initial(icon_state)]-empty"
		empty = 1

/obj/item/gun/projectile/rocket/tyrmalin
	name = "rokkit launcher"
	desc = "A sloppily machined tube designed to function as a recoilless rifle. Sometimes used by Tyrmalin defense teams, it draws skeptical looks even amongst their ranks."
	icon_state = "rokkitlauncher"
	item_state = "rocket"
	var/unstable = 1
	var/jammed = 0

/obj/item/gun/projectile/rocket/tyrmalin/consume_next_projectile(mob/user as mob)
	. = ..()
	if(.)
		if(unstable)
			switch(rand(1,100))
				if(1 to 10)
					to_chat(user, "<span class='danger'>The rocket primer activates early!</span>")
					icon_state = "rokkitlauncher-malfunction"
					spawn(rand(1,5))
						if(src && !jammed)
							visible_message("<span class='critical'>\The [src] detonates!</span>")
							jammed = 1
							explosion(get_turf(src), -1, 0, 2, 3)
							qdel(chambered)
							qdel(src)
					return ..()
				if(11 to 29)
					to_chat(user, "<span class='notice'>The rocket flares out in the tube!</span>")
					playsound(src, 'sound/machines/button.ogg', 25)
					icon_state = "rokkitlauncher-broken"
					jammed = 1
					name = "broken rokkit launcher"
					desc = "The tube has burst outwards like a sausage."
					qdel(chambered)
					handle_click_empty()
					return
				if(30 to 100)
					return 1
		if(jammed)
			to_chat(user, "<span class='notice'>The [src] is jammed!</span>")
			handle_click_empty()
			return
