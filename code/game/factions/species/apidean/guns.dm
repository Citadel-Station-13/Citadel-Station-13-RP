
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
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2, TECH_BIO = 5)
	magazine_type = /obj/item/ammo_magazine/biovial
	allowed_magazines = list(/obj/item/ammo_magazine/biovial)
	projectile_type = /obj/projectile/bullet/organic/wax

/obj/item/gun/projectile/ballistic/apinae_pistol/update_icon_state()
	. = ..()
	icon_state = "apipistol-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "e"]"

/obj/item/gun/projectile/ballistic/apinae_stinger
	name = "\improper Apinae Stinger Rifle"
	desc = "A biotechnological marvel, this living rifle can grow its ammo when provided with liquified wax. It fires poisonous bolts of barbed chitin."
	icon_state = "apigun"
	item_state = "speargun"
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	caliber = "apidean"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 3, TECH_BIO = 7)
	slot_flags = SLOT_BACK
	fire_sound = 'sound/weapons/rifleshot.ogg'
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/biovial
	allowed_magazines = list(/obj/item/ammo_magazine/biovial)
	projectile_type = /obj/projectile/bullet/organic/stinger
	one_handed_penalty = 25

/obj/item/gun/projectile/ballistic/apinae_stinger/update_icon_state()
	. = ..()
	icon_state = "apigun-[ammo_magazine ? round(ammo_magazine.stored_ammo.len, 2) : "e"]"
