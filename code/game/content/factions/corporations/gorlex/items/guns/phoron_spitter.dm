
/obj/item/gun/projectile/ballistic/caseless/phoron_spitter // phoron war SMG that fires phoron shards.
	name = "Gorlex 'SHRAPNEL-SPITTER' Phoron SMG"
	desc = "A short-barrel SMG from the Phoron Wars that lacks conventional ammo, instead using compressed matter cartridges. Coils accelerate a ferromagnetic, self-oxidizing cloud of alloy. Lack of traditional cycling means it can fire blindingly fast. Like all caseless weapons, it's fallen by the wayside, and is no longer produced."
	icon = 'icons/content/factions/corporations/gorlex/items/guns/phoron_spitter.dmi'
	icon_state = "gun"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	caliber = /datum/ammo_caliber/phoron_shrap
	magazine_auto_eject = TRUE
	recoil = 1.5
	accuracy = -30
	one_handed_penalty = 50
	fire_sound = 'sound/weapons/gunshot/gunshot_tech_smg.ogg'

	firemodes = list(
		list(mode_name="full auto", burst=1, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1),
		list(mode_name="fuller auto", burst=2, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/obj/item/gun/projectile/ballistic/caseless/phoron_spitter/Initialize(mapload)
	. = ..()
	var/fluff_date = rand(2501,2543)
	desc += "\nYou see a stamp on the side: GORLEX MARAUDERS, MANUFACTURED IN [fluff_date]."

// todo: gun rendering system
/obj/item/gun/projectile/ballistic/caseless/phoron_spitter/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/ballistic/caseless/phoron_spitter/loaded
	magazine_preload = /obj/item/ammo_magazine/phoron_shrap

//* Caliber *//

/datum/ammo_caliber/phoron_shrap
	id = "phoron-shrap"
	caliber = "phoron-shrapnel"

//* Ammunition *//

/obj/item/ammo_casing/phoron_shrap
	name = "phoron shrapnel"
	desc = "Should you really be holding this?"

	icon = 'icons/content/factions/corporations/gorlex/items/guns/phoron_spitter.dmi'
	icon_state = "shrapnel"

	casing_caliber = /datum/ammo_caliber/phoron_shrap
	projectile_type = /obj/projectile/bullet/incendiary/phoronshrap
	casing_flags = CASING_DELETE

//* Magazine *//

/obj/item/ammo_magazine/phoron_shrap
	name = "compressed phoron matter container"
	desc = "A compressed matter container meant for the Gorlex SHRAPNEL-SPITTER SMG. Contains a phoron alloy that self-oxidzes and ignites on contact with air. \n \nThey're in good shape for the shape they're in, \nbut God, I wonder how they think they can win, \nwith phoron rolling down their skin."
	ammo_max = 40
	ammo_caliber = /datum/ammo_caliber/phoron_shrap
	ammo_preload = /obj/item/ammo_casing/phoron_shrap

	icon = 'icons/content/factions/corporations/gorlex/items/guns/phoron_spitter.dmi'
	icon_state = "mag-1"
	base_icon_state = "mag"
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
