/obj/item/gun/projectile/ballistic/pirate
	name = "zip gun"
	desc = "Little more than a barrel, handle, and firing mechanism, cheap makeshift firearms like this one are not uncommon in frontier systems."
	icon_state = "sawnshotgun"
	item_state = "sawnshotgun"
	recoil = 3 //Improvised weapons = poor ergonomics
	handle_casings = CYCLE_CASINGS //player has to take the old casing out manually before reloading
	load_method = SINGLE_CASING
	safety_state = GUN_NO_SAFETY
	max_shells = 1 //literally just a barrel
	unstable = 1

	var/global/list/ammo_types = list(
		/obj/item/ammo_casing/a357              = ".357",
		/obj/item/ammo_casing/a9mm		        = "9mm",
		/obj/item/ammo_casing/a45				= ".45",
		/obj/item/ammo_casing/a10mm             = "10mm",
		/obj/item/ammo_casing/a12g              = "12g",
		/obj/item/ammo_casing/a12g              = "12g",
		/obj/item/ammo_casing/a12g/pellet       = "12g",
		/obj/item/ammo_casing/a12g/pellet       = "12g",
		/obj/item/ammo_casing/a12g/pellet       = "12g",
		/obj/item/ammo_casing/a12g/beanbag      = "12g",
		/obj/item/ammo_casing/a12g/stunshell    = "12g",
		/obj/item/ammo_casing/a12g/flare        = "12g",
		/obj/item/ammo_casing/a762              = "7.62mm",
		/obj/item/ammo_casing/a556              = "5.56mm"
		)

/obj/item/gun/projectile/ballistic/pirate/Initialize(mapload)
	ammo_type = pick(ammo_types)
	desc += " Uses [ammo_types[ammo_type]] rounds."

	var/obj/item/ammo_casing/ammo = ammo_type
	caliber = initial(ammo.caliber)
	return ..()

/obj/item/gun/ballistic/pirate/consume_next_projectile(mob/user as mob)
	. = ..()
	if(.)
		if(unstable)
			if(prob(10))
				to_chat(user, "<span class='danger'>The barrel bursts open as the gun backfires!</span>")
				name = "destroyed zip gun"
				desc = "The barrel has burst. It seems inoperable."
				icon_state = "[initial(icon_state)]-destroyed"
				destroyed = 1
				spawn(1 SECOND)
					explosion(get_turf(src), -1, 0, 2, 3)

		if(destroyed)
			to_chat(user, "<span class='notice'>The [src] is broken!</span>")
			handle_click_empty()
			return

/obj/item/gun/ballistic/pirate/Fire(atom/target, mob/living/user, clickparams, pointblank, reflex)
	. = ..()
	if(destroyed)
		to_chat(user, "<span class='notice'>\The [src] is completely inoperable!</span>")
		handle_click_empty()

/obj/item/gun/ballistic/pirate/attack_hand(mob/user, list/params)
	if(user.get_inactive_held_item() == src && destroyed)
		to_chat(user, "<span class='danger'>\The [src]'s chamber is too warped to extract the casing!</span>")
		return
	else
		return ..()
