/obj/item/gun/ballistic/caseless/prototype
	name = "prototype caseless rifle"
	desc = "This experimental rifle is the efforts of Nanotrasen's R&D division, made manifest. Uses 5mm solid-phoron caseless rounds, obviously."
	icon_state = "caseless"
	item_state = "caseless"
	w_class = WEIGHT_CLASS_BULKY
	regex_this_caliber = /datum/ammo_caliber/a5mm
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 3)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = null // R&D builds this. Starts unloaded.
	allowed_magazines = list(/obj/item/ammo_magazine/m5mmcaseless)
	one_handed_penalty = 15

/obj/item/gun/ballistic/caseless/prototype/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/ballistic/caseless/prototype/loaded
	magazine_type = /obj/item/ammo_magazine/m5mmcaseless

/obj/item/gun/ballistic/caseless/phoron_spitter // phoron war SMG that fires phoron shards.
	name = "Gorlex 'SHRAPNEL-SPITTER' Phoron SMG"
	desc = "A short-barrel SMG from the Phoron Wars that lacks conventional ammo, instead using compressed matter cartridges. Coils accelerate a ferromagnetic, self-oxidizing cloud of alloy. Lack of traditional cycling means it can fire blindingly fast. Like all caseless weapons, it's fallen by the wayside, and is no longer produced."
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	regex_this_caliber = /datum/ammo_caliber/phoron_shard
	magazine_type = /obj/item/ammo_magazine/mphoronshot
	allowed_magazines = list(/obj/item/ammo_magazine/mphoronshot)
	icon_state = "phoron_shredder"
	item_state = "ashot" //close enough
	recoil = 1.5
	accuracy = -30
	one_handed_penalty = 50
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	fire_sound = 'sound/weapons/gunshot/gunshot_tech_smg.ogg'

	firemodes = list(
		list(mode_name="full auto", burst=1, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1),
		list(mode_name="fuller auto", burst=2, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/obj/item/gun/ballistic/caseless/phoron_spitter/Initialize(mapload)
	. = ..()
	var/fluff_date = rand(2501,2543)
	desc += "\nYou see a stamp on the side: GORLEX MARAUDERS, MANUFACTURED IN [fluff_date]."

/obj/item/gun/ballistic/caseless/pellet
	name = "pellet gun"
	desc = "An air powered rifle that shoots near harmless pellets. Used for recreation in enviroments where firearm ownership is restricted."
	icon_state = "pellet"
	item_state = "pellet"
	wielded_item_state = "pellet-wielded"
	regex_this_caliber = /datum/ammo_caliber/pellet
	fire_sound = 'sound/weapons/tap.ogg'
	max_shells = 1
	ammo_type = /obj/item/ammo_casing/p_pellet
	load_method = SINGLE_CASING
