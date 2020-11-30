/obj/item/gun/projectile/caseless/prototype
	name = "prototype caseless rifle"
	desc = "A rifle cooked up in NanoTrasen's R&D labs that operates with Kraut Space Magic™ clockwork internals. Uses solid phoron 5mm caseless rounds."
	icon_state = "caseless"
	item_state = "caseless"
	w_class = ITEMSIZE_LARGE
	caliber = "5mm caseless"
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = null // R&D builds this. Starts unloaded.
	allowed_magazines = list(/obj/item/ammo_magazine/m5mmcaseless)

/obj/item/gun/projectile/caseless/prototype/update_icon()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/caseless/prototype/loaded
	magazine_type = /obj/item/ammo_magazine/m5mmcaseless

/obj/item/gun/projectile/caseless/usmc
	name = "M41A Pulse Rifle"
	desc = "A relic dating back to the Xenomorph Wars and the former primary battle rifle of the  United Solar Marine Corps. Loads using 10x24mm caseless Magazines"
	icon_state = "usmc"
	item_state = "usmc"
	w_class = ITEMSIZE_LARGE
	caliber = "10mmCL"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	slot_flags = SLOT_BACK
	pin = /obj/item/firing_pin/explorer
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m10x24mm/small
	allowed_magazines = list(/obj/item/ammo_magazine/m10x24mm/small, /obj/item/ammo_magazine/m10x24mm/med, /obj/item/ammo_magazine/m10x24mm/large)
	recoil = 0
	firemodes = list(
		list(mode_name="semiauto",      	burst=1, 	fire_delay=0,    move_delay=null,	burst_accuracy=null, dispersion=null),
		list(mode_name="4-round bursts", 	burst=4, 	fire_delay=null, move_delay=6, 	burst_accuracy=list(0,-5,-10,-15), dispersion=list(0.0, 0.2, 0.4, 0.6)),//Small damage countered by tight spread.
		)
