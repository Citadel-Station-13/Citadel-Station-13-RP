/obj/item/gun/projectile/contender
	name = "Thompson Contender"
	desc = "A perfect, pristine replica of an ancient one-shot hand-cannon. For when you really want to make a hole. This one has been modified to work almost like a bolt-action."
	icon_state = "pockrifle"
	var/icon_retracted = "pockrifle-empty"
	item_state = "revolver"
	caliber = ".357"
	handle_casings = HOLD_CASINGS
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/a357
	projectile_type = /obj/item/projectile/bullet/pistol/strong
	var/retracted_bolt = 0
	load_method = SINGLE_CASING

/obj/item/gun/projectile/contender/attack_self(mob/user as mob)
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
		to_chat(user, "<span class='notice'>You cycle the boly back into position, leaving the gun empty.</span>")
	icon_state = initial(icon_state)
	retracted_bolt = 0

/obj/item/gun/projectile/contender/load_ammo(var/obj/item/A, mob/user)
	if(!retracted_bolt)
		to_chat(user, "<span class='notice'>You can't load [src] without cycling the bolt.</span>")
		return
	..()

/obj/item/gun/projectile/contender/a44
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/contender/a762
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762

/obj/item/gun/projectile/contender/tacticool
	desc = "A modified replica of an ancient one-shot hand-cannon, reinvented with a tactical look. For when you really want to make a hole. This one has been modified to work almost like a bolt-action."
	icon_state = "pockrifle_b"
	icon_retracted = "pockrifle_b-empty"

/obj/item/gun/projectile/contender/tacticool/a44
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44

/obj/item/gun/projectile/contender/tacticool/a762
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762

/obj/item/gun/projectile/contender/holy
	name = "Divine Challenger"
	desc = "A beautifully engraved pocket rifle with a silvered barrel made of incense wood.Sometimes one good hit is all you need to vanquish a great evil and these handcannons will deliver that one shot."
	icon_state = "pockrifle_c"
	icon_retracted = "pockrifle_c-empty"
	ammo_type = /obj/item/ammo_casing/a357/silver
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_OCCULT = 1)

/obj/item/gun/projectile/contender/holy/a44
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/a44/silver

/obj/item/gun/projectile/contender/holy/a762
	caliber = "7.62mm"
	ammo_type = /obj/item/ammo_casing/a762/silver


