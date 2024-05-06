/obj/item/gun/ballistic/caseless/prototype
	name = "prototype caseless rifle"
	desc = "This experimental rifle is the efforts of Nanotrasen's R&D division, made manifest. Uses 5mm solid-phoron caseless rounds, obviously."
	icon_state = "caseless"
	item_state = "caseless"
	w_class = WEIGHT_CLASS_BULKY
	caliber = "5mm caseless"
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

/obj/item/gun/ballistic/caseless/usmc
	name = "M41A Pulse Rifle"
	desc = "A relic dating back a very, very long time. The former primary battle rifle of the  United Terran Marine Corps, disused due to cost and lack of need. Still preferred by many. Loads using 10x24mm caseless Magazines"
	icon_state = "usmc"
	item_state = "usmc"
	w_class = WEIGHT_CLASS_BULKY
	caliber = "10mmCL"
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 3)
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/m10x24mm/small
	allowed_magazines = list(/obj/item/ammo_magazine/m10x24mm/small, /obj/item/ammo_magazine/m10x24mm/med, /obj/item/ammo_magazine/m10x24mm/large)
	recoil = 0
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	firemodes = list(
		list(mode_name="semiauto",      	burst=1, 	fire_delay=0,    move_delay=null,	burst_accuracy=null, dispersion=null),
		list(mode_name="4-round bursts", 	burst=4, 	fire_delay=null, move_delay=6, 	burst_accuracy=list(0,-5,-10,-15), dispersion=list(0.0, 0.2, 0.4, 0.6)),//Small damage countered by tight spread.
		)

/obj/item/gun/ballistic/caseless/wild_hunt //extremely powerful and rare rifle - meant to spawn with maybe 2 mags extra, or be for asset protection/ert/solo antags/etc
	name = "Gorlex WILD-HUNT 12.7mm Caseless Rifle"
	desc = "An ancient rifle of the Phoron Wars. For when you want to kill something with no negotiation. The Wild Hunt is a beast that kicks like a mule and fires experimental caseless phoron rounds. It has, obviously, horrific results, setting targets on fire after giving them a golf-ball sized hole. Now generally disused due to the extreme maintenance cost and impracticality. Nobody makes these, anymore."
	icon_state = "wild-hunt"
	item_state = "wild-hunt"
	caliber = "12.7mm caseless"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mfiftycalcaseless
	recoil = 1 //mein leiben
	accuracy = -10
	allowed_magazines = list(/obj/item/ammo_magazine/mfiftycalcaseless)
	one_handed_penalty = 100 //you simply do not
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	firemodes = list(
		list(mode_name="semiauto",      	burst=1, 	fire_delay=0,    move_delay=null,	burst_accuracy=null, dispersion=null),
		list(mode_name="automatic",       burst=1, fire_delay=-1,    move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/obj/item/gun/ballistic/caseless/wild_hunt/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/ballistic/caseless/wild_hunt/Initialize(mapload)
	. = ..()
	var/fluff_date = rand(2501,2543)
	desc += "\n You see a stamp on the side: GORLEX MARAUDERS, MANUFACTURED IN [fluff_date]."
