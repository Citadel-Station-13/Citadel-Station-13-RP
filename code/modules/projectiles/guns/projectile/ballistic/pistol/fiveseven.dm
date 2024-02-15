/obj/item/gun/projectile/ballistic/fiveseven
	name = "\improper Five-seven sidearm"
	desc = "This classic sidearm design utilizes an adaptable round considered by some to be superior to 9mm parabellum. Favored amongst sheild bearers in tactical units for its stability in one-handed use, and high capacity magazines."
	icon_state = "fiveseven"
	item_state = "pistol"
	caliber = "5.7x28mm"
	load_method = MAGAZINE
	w_class = ITEMSIZE_SMALL
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2)
	magazine_type = /obj/item/ammo_magazine/m57x28mm/fiveseven
	allowed_magazines = list(/obj/item/ammo_magazine/m57x28mm/fiveseven)
	one_handed_penalty = 0

/obj/item/gun/projectile/ballistic/fiveseven/update_icon_state()
	. = ..()
	if(istype(ammo_magazine,/obj/item/ammo_magazine/m57x28mm/fiveseven/highcap))
		icon_state = "fiveseven-extended"

