/obj/item/gun/projectile/ballistic/p92x
	name = "9mm pistol"
	desc = "A widespread sidearm called the P92X which is used by military, police, and security forces across the galaxy. Uses 9mm rounds."
	icon_state = "p92x"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	caliber = "9mm"
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m9mm
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm) // Can accept illegal large capacity magazines, or compact magazines.

/obj/item/gun/projectile/ballistic/p92x/sec
	desc = "A widespread sidearm called the P92X which is used by military, police, and security forces across the galaxy. This one is a less-lethal variant that only accepts 9mm rubber or flash magazines."
	magazine_type = /obj/item/ammo_magazine/m9mm/rubber
	allowed_magazines = list(/obj/item/ammo_magazine/m9mm/rubber, /obj/item/ammo_magazine/m9mm/flash)

/obj/item/gun/projectile/ballistic/p92x/brown
	icon_state = "p92x-brown"

/obj/item/gun/projectile/ballistic/p92x/large
	magazine_type = /obj/item/ammo_magazine/m9mm/large // Spawns with illegal magazines.
