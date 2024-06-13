/obj/item/gun/projectile/ballistic/giskard
	name = "\improper \"Giskard\" holdout pistol"
	desc = "The FS HG .380 \"Giskard\" can even fit into the pocket! Uses .380 rounds."
	icon_state = "giskardcivil"
	caliber = ".380"
	magazine_type = /obj/item/ammo_magazine/m380
	allowed_magazines = list(/obj/item/ammo_magazine/m380)
	load_method = MAGAZINE
	w_class = WEIGHT_CLASS_SMALL
	fire_sound = 'sound/weapons/gunshot_pathetic.ogg'
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)

/obj/item/gun/projectile/ballistic/giskard/update_icon_state()
	. = ..()
	if(ammo_magazine && ammo_magazine.stored_ammo.len)
		icon_state = "giskardcivil"
	else
		icon_state = "giskardcivil_empty"
