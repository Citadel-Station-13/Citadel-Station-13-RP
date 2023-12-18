#warn completely replace all of it with main's

/obj/item/gun/projectile/ballistic/automatic/advanced_smg/foam
	name = "toy submachine gun"
	desc = "The existence of this DONKsoft toy has instigated allegations of corporate espionage from NanoTrasen."
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_smg"
	caliber = "foamdart"
	magazine_type = /obj/item/ammo_magazine/mfoam/smg
	allowed_magazines = list(/obj/item/ammo_magazine/mfoam/smg)
	fire_sound = 'sound/items/syringeproj.ogg'

/obj/item/gun/projectile/ballistic/automatic/advanced_smg/foam/update_icon_state()
	. = ..()
	icon_state = (ammo_magazine)? "toy_smg" : "toy_smg-empty"

/obj/item/gun/projectile/ballistic/automatic/advanced_smg/foam/handle_suicide(mob/living/user)
	user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
	mouthshoot = 0

/obj/item/gun/projectile/ballistic/automatic/advanced_smg/foam/blue
	icon_state = "toy_smg_blue"

/obj/item/gun/projectile/ballistic/automatic/advanced_smg/foam/blue/update_icon_state()
	. = ..()
	icon_state = (ammo_magazine)? "toy_smg_blue" : "toy_smg_blue-empty"

/obj/item/gun/projectile/ballistic/automatic/c20r/foam
	name = "toy submachine gun"
	desc = "A DONKsoft rendition of an infamous submachine gun."
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_c20"
	damage_force = 5
	caliber = "foamdart"
	magazine_type = /obj/item/ammo_magazine/mfoam/c20
	allowed_magazines = list(/obj/item/ammo_magazine/mfoam/c20)
	projectile_type = /obj/projectile/bullet/reusable/foam
	one_handed_penalty = 5
	fire_sound = 'sound/items/syringeproj.ogg'

/obj/item/gun/projectile/ballistic/automatic/c20r/foam/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "toy_c20r-[round(ammo_magazine.stored_ammo.len,4)]"
	else
		icon_state = "toy_c20r"

/obj/item/gun/projectile/ballistic/automatic/c20r/foam/handle_suicide(mob/living/user)
	user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
	mouthshoot = 0

/obj/item/gun/projectile/ballistic/automatic/lmg/foam
	name = "toy light machine gun"
	desc = "This plastic replica of a common light machine gun weighs about half as much. It's still pretty bulky, but nothing lays down suppressive fire like this bad boy. The bane of schoolyards across the galaxy."
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_lmgclosed100"
	damage_force = 5
	caliber = "foamdart"
	magazine_type = /obj/item/ammo_magazine/mfoam/lmg
	allowed_magazines = list(/obj/item/ammo_magazine/mfoam/lmg)
	projectile_type = /obj/projectile/bullet/reusable/foam
	one_handed_penalty = 45 //It's plastic.
	fire_sound = 'sound/items/syringeproj.ogg'
	heavy = FALSE
	one_handed_penalty = 25

/obj/item/gun/projectile/ballistic/automatic/lmg/foam/update_icon_state()
	. = ..()
	icon_state = "toy_lmg[cover_open ? "open" : "closed"][ammo_magazine ? round(ammo_magazine.stored_ammo.len, 10) : "-empty"]"
	item_state = "toy_lmg[cover_open ? "open" : "closed"][ammo_magazine ? "" : "-empty"]"

/obj/item/gun/projectile/ballistic/automatic/lmg/foam/update_icon()
	. = ..()
	update_held_icon()

/obj/item/gun/projectile/ballistic/automatic/lmg/foam/handle_suicide(mob/living/user)
	user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
	mouthshoot = 0
	return

/obj/item/gun/projectile/ballistic/pistol/foam
	name = "toy pistol"
	desc = "The Donk Co line of DONKsoft weapons is taking the galaxy by storm. Made of quality plastic, nothing launches darts better."
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_pistol"
	item_state = null
	w_class = ITEMSIZE_SMALL
	caliber = "foamdart"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mfoam/pistol
	allowed_magazines = list(/obj/item/ammo_magazine/mfoam/pistol)
	fire_sound = 'sound/items/syringeproj.ogg'

/obj/item/gun/projectile/ballistic/pistol/foam/handle_suicide(mob/living/user)
	user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
	mouthshoot = 0
	return

/obj/item/gun/projectile/ballistic/pistol/foam/blue
	icon_state = "toy_pistol_blue"

/obj/item/gun/projectile/ballistic/pistol/foam/magnum
	name = "toy automag"
	icon_state = "toy_pistol_orange"
	w_class = ITEMSIZE_NORMAL

/obj/item/gun/projectile/ballistic/shotgun/pump/foam
	name = "toy shotgun"
	desc = "A relatively faithful recreation of a pump action shotgun, this one only accepts foam darts."
	icon = 'icons/obj/toy.dmi'
	icon_state = "toy_shotgun"
	max_shells = 8
	damage_force = 5
	caliber = "foamdart"
	ammo_type = /obj/item/ammo_casing/foam
	projectile_type = /obj/projectile/bullet/reusable/foam
	one_handed_penalty = 5
	fire_sound = 'sound/items/syringeproj.ogg'

/obj/item/gun/projectile/ballistic/shotgun/pump/foam/handle_suicide(mob/living/user)
	user.show_message("<span class = 'warning'>You feel rather silly, trying to commit suicide with a toy.</span>")
	mouthshoot = 0
	return

/obj/item/gun/projectile/ballistic/shotgun/pump/foam/pump(mob/M as mob)
	playsound(M, action_sound, 60, 1)

	if(chambered)//We have a shell in the chamber
		chambered = null

	if(loaded.len)
		var/obj/item/ammo_casing/AC = loaded[1] //load next casing.
		loaded -= AC //Remove casing from loaded list.
		chambered = AC

	if(animated_pump)//This affects all bolt action and shotguns.
		flick("[icon_state]-cycling", src)//This plays any pumping

	update_icon()
/obj/item/gun/projectile/ballistic/shotgun/pump/foam/blue
	icon_state = "toy_shotgun_blue"
