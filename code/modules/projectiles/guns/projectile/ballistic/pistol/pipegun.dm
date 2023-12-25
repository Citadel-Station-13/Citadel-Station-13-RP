/obj/item/gun/projectile/ballistic/contender/pipegun
	name = "improvised pipe rifle"
	desc = "A single shot, handmade pipe rifle. It almost functions like a bolt action. Accepts shotgun shells."
	icon_state = "pipegun"
	icon_retracted = "pipegun-empty"
	item_state = "revolver"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g/improvised
	projectile_type = /obj/projectile/bullet/shotgun
	unstable = 1

/obj/item/gun/projectile/ballistic/contender/pipegun/consume_next_projectile(mob/user as mob)
	. = ..()
	//var/instability = rand(1,100)
	if(.)
		if(unstable)
			if(prob(10))
				to_chat(user, "<span class='danger'>The pipe bursts open as the gun backfires!</span>")
				name = "ruptured pipe rifle"
				desc = "The barrel has blown wide open."
				icon_state = "pipegun-destroyed"
				destroyed = 1
				spawn(1 SECOND)
					explosion(get_turf(src), -1, 0, 2, 3)

		if(destroyed)
			to_chat(user, "<span class='notice'>The [src] is broken!</span>")
			handle_click_empty()
			return

/obj/item/gun/ballistic/contender/pipegun/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex)
	. = ..()
	if(destroyed)
		to_chat(user, "<span class='notice'>\The [src] is completely inoperable!</span>")
		handle_click_empty()

/obj/item/gun/ballistic/contender/pipegun/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src && destroyed)
		to_chat(user, "<span class='danger'>\The [src]'s chamber is too warped to extract the casing!</span>")
		return
	else
		return ..()
