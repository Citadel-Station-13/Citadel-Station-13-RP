/obj/item/gun/projectile/ballistic/caseless/wild_hunt //extremely powerful and rare rifle - meant to spawn with maybe 2 mags extra, or be for asset protection/ert/solo antags/etc
	name = "Gorlex WILD-HUNT 12.7mm Caseless Rifle"
	desc = "An ancient rifle of the Phoron Wars. For when you want to kill something with no negotiation. The Wild Hunt is a beast that kicks like a mule and fires experimental caseless phoron rounds. It has, obviously, horrific results, setting targets on fire after giving them a golf-ball sized hole. Now generally disused due to the extreme maintenance cost and impracticality. Nobody makes these, anymore."
	icon_state = "wild-hunt"
	item_state = "wild-hunt"
	caliber = "12.7mm caseless"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	load_method = MAGAZINE
	magazine_type = /obj/item/ammo_magazine/mfiftycalcaseless
	recoil = 1
	accuracy = -10
	allowed_magazines = list(/obj/item/ammo_magazine/mfiftycalcaseless)
	one_handed_penalty = 100 //you simply do not
	auto_eject = 1
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	fire_sound = 'sound/weapons/gunshot/sniper.ogg'

	firemodes = list(
		list(mode_name="semiauto",      	burst=1, 	fire_delay=0,    move_delay=null,	burst_accuracy=null, dispersion=null),
		list(mode_name="automatic",       burst=1, fire_delay=-1,    move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

/obj/item/gun/projectile/ballistic/caseless/wild_hunt/update_icon_state()
	. = ..()
	if(ammo_magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/ballistic/caseless/wild_hunt/Initialize(mapload)
	. = ..()
	var/fluff_date = rand(2501,2543)
	desc += "\n You see a stamp on the side: GORLEX MARAUDERS, MANUFACTURED IN [fluff_date]."
