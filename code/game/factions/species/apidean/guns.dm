
/obj/item/gun/projectile/energy/retro/apidean
	name = "apidean retro laser"
	icon_state = "apilaser"
	desc = "An older model of the basic lasergun. This version's casing has been painted yellow. Originating from, and carried by, Apidean combatants, it's unclear where they obtained them."

	#warn impl - sprites

/obj/item/gun/projectile/ballistic/apinae_pistol
	name = "\improper Apinae Enforcer pistol"
	desc = "Used by Hive-guards to detain deviants."
	icon_state = "apipistol"
	item_state = "florayield"
	caliber = "apidean"
	load_method = MAGAZINE
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_BIO = 5)
	magazine_type = /obj/item/ammo_magazine/biovial
	allowed_magazines = list(/obj/item/ammo_magazine/biovial)
	projectile_type = /obj/projectile/bullet/organic/wax

/obj/item/gun/projectile/ballistic/apinae_pistol/update_icon_state()
	. = ..()
	icon_state = "apipistol-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "e"]"
