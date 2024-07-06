/obj/item/gun/projectile/ballistic/caseless/phoron_spitter // phoron war SMG that fires phoron shards.
	name = "Gorlex 'SHRAPNEL-SPITTER' Phoron SMG"
	desc = "A short-barrel SMG from the Phoron Wars that lacks conventional ammo, instead using compressed matter cartridges. Coils accelerate a ferromagnetic, self-oxidizing cloud of alloy. Lack of traditional cycling means it can fire blindingly fast. Like all caseless weapons, it's fallen by the wayside, and is no longer produced."
	caliber = "phoron shrapnel"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mphoronshot
	allowed_magazines = list(/obj/item/ammo_magazine/mphoronshot)
	icon_state = "phoron_shredder"
	item_state = "ashot" //close enough
	recoil = 1.5
	accuracy = -30
	one_handed_penalty = 50
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	firemodes = list(
		list(mode_name="full auto", burst=1, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1),
		list(mode_name="fuller auto", burst=2, fire_delay=-1, move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/obj/item/gun/projectile/ballistic/caseless/phoron_spitter/Initialize(mapload)
	. = ..()
	var/fluff_date = rand(2501,2543)
	desc += "\nYou see a stamp on the side: GORLEX MARAUDERS, MANUFACTURED IN [fluff_date]."
