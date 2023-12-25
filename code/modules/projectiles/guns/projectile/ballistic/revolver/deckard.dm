/obj/item/gun/projectile/ballistic/revolver/deckard
	name = "\improper Deckard .38"
	desc = "A custom-built revolver, based off the semi-popular Detective Special model. Uses .38-Special rounds."
	icon_state = "deckard-empty"
	caliber = ".38"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	ammo_type = /obj/item/ammo_casing/a38

/obj/item/gun/projectile/ballistic/revolver/deckard/emp
	ammo_type = /obj/item/ammo_casing/a38/emp


/obj/item/gun/projectile/ballistic/revolver/deckard/update_icon_state()
	. = ..()
	if(loaded.len)
		icon_state = "deckard-loaded"
	else
		icon_state = "deckard-empty"

/obj/item/gun/projectile/ballistic/revolver/deckard/load_ammo(var/obj/item/A, mob/user)
	if(istype(A, /obj/item/ammo_magazine))
		flick("deckard-reload",src)
	..()
