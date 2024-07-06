
/obj/item/gun/projectile/ballistic/clown_rifle
	name = "clown assault rifle"
	desc = "The WSS-29m6 is the latest version of the standard Columbina service rifle. Originally a cheap knock-off of the STS-35, the m6 now matches its inspiration in durability. Utilizing a proprietary ROF system, the m6 is able to fire unorthodox, yet effective, weaponry."
	icon_state = "clownrifle"
	item_state = "clownrifle"
	wielded_item_state = "clownrifle_wielded"
	w_class = WEIGHT_CLASS_BULKY
	heavy = TRUE
	damage_force = 10
	caliber = "organic"
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 1, TECH_ILLEGAL = 4)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mcompressedbio/large/banana
	allowed_magazines = list(/obj/item/ammo_magazine/mcompressedbio/large/banana)
	projectile_type = /obj/projectile/bullet/organic

	one_handed_penalty = 30

	firemodes = list(
		list(mode_name="semiauto",       burst=1, fire_delay=0,    move_delay=null, burst_accuracy=null, dispersion=null),
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=6,    burst_accuracy=list(60,50,45), dispersion=list(0.0, 0.6, 0.6))
//		list(mode_name="short bursts", 	burst=5, fire_delay=null, move_delay=6,    burst_accuracy=list(0,-15,-30,-30,-45), dispersion=list(0.6, 1.0, 1.0, 1.0, 1.2)),
		)

/obj/item/gun/projectile/ballistic/clown_rifle/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = "[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/ballistic/clown_pistol
	name = "clown pistol"
	desc = "This curious weapon feeds from a compressed biomatter cartridge, and seems to fabricate its ammunition from that supply."
	icon_state = "clownpistol"
	item_state = "revolver"
	caliber = "organic"
	load_method = MAGAZINE
	w_class = WEIGHT_CLASS_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	magazine_type = /obj/item/ammo_magazine/mcompressedbio/compact
	allowed_magazines = list(/obj/item/ammo_magazine/mcompressedbio/compact)
	projectile_type = /obj/projectile/bullet/organic
