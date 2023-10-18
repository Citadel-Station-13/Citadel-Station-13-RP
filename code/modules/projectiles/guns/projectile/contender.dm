/obj/item/gun/ballistic/contender
	name = "Thompson Contender"
	desc = "A perfect, pristine replica of an ancient one-shot hand-cannon. For when you really want to make a hole. This one has been modified to work almost like a bolt-action."
	icon_state = "pockrifle"
	var/icon_retracted = "pockrifle-empty"
	item_state = "revolver"
	caliber = ".357"
	handle_casings = HOLD_CASINGS
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a357
	projectile_type = /obj/projectile/bullet/pistol/strong
	var/retracted_bolt = 0
	load_method = SINGLE_CASING
	heavy = TRUE

/obj/item/gun/ballistic/contender/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(chambered)
		chambered.loc = get_turf(src)
		chambered = null
		var/obj/item/ammo_casing/C = loaded[1]
		loaded -= C

	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You cycle back the bolt on [src], ejecting the casing and allowing you to reload.</span>")
		icon_state = icon_retracted
		retracted_bolt = 1
		return 1
	else if(retracted_bolt && loaded.len)
		to_chat(user, "<span class='notice'>You cycle the loaded round into the chamber, allowing you to fire.</span>")
	else
		to_chat(user, "<span class='notice'>You cycle the bolt back into position, leaving the gun empty.</span>")
	icon_state = initial(icon_state)
	retracted_bolt = 0

/obj/item/gun/ballistic/contender/load_ammo(var/obj/item/A, mob/user)
	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You can't load [src] without cycling the bolt.</span>")
		return
	..()

/obj/item/gun/ballistic/contender/a44
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/ballistic/contender/a762
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762

/obj/item/gun/ballistic/contender/tacticool
	desc = "A modified replica of an ancient one-shot hand-cannon, reinvented with a tactical look. For when you really want to make a hole. This one has been modified to work almost like a bolt-action."
	icon_state = "pockrifle_b"
	icon_retracted = "pockrifle_b-empty"

/obj/item/gun/ballistic/contender/tacticool/a44
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/ballistic/contender/tacticool/a762
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762

/obj/item/gun/ballistic/contender/holy
	name = "Divine Challenger"
	desc = "A beautifully engraved pocket rifle with a silvered barrel made of incense wood.Sometimes one good hit is all you need to vanquish a great evil and these handcannons will deliver that one shot."
	icon_state = "pockrifle_c"
	icon_retracted = "pockrifle_c-empty"
	ammo_type = /obj/item/ammo_casing/a357/silver
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_OCCULT = 1)
	holy = TRUE

/obj/item/gun/ballistic/contender/holy/a44
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44/silver

/obj/item/gun/ballistic/contender/holy/a762
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762/silver

/obj/item/gun/ballistic/contender/taj
	name = "Adhomai pocket rifle"
	desc = "A hand cannon produced by Akhan and Khan. Its simple design dates back to the civil war where hand cannons like it were rushed into service to counter the massive arms shortage the Kingdom of Adhomai faced at the start of the war. Since then A&K have refined the design into a mainstay backup weapon of solider and civilian alike."
	icon_state = "pockrifle_d"
	icon_retracted = "pockrifle_d-empty"

/obj/item/gun/ballistic/contender/taj/a44
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/ballistic/contender/taj/a762
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762

/obj/item/gun/ballistic/contender/pipegun
	name = "improvised pipe rifle"
	desc = "A single shot, handmade pipe rifle. It almost functions like a bolt action. Accepts shotgun shells."
	icon_state = "pipegun"
	icon_retracted = "pipegun-empty"
	item_state = "revolver"
	caliber = "12g"
	ammo_type = /obj/item/ammo_casing/a12g/improvised
	projectile_type = /obj/projectile/bullet/shotgun
	unstable = 1

/obj/item/gun/ballistic/contender/pipegun/consume_next_projectile(mob/user as mob)
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
