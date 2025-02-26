/obj/item/gun/projectile/ballistic/caseless/wild_hunt //extremely powerful and rare rifle - meant to spawn with maybe 2 mags extra, or be for asset protection/ert/solo antags/etc
	name = "Gorlex WILD-HUNT 12.7mm Caseless Rifle"
	desc = "An ancient rifle of the Phoron Wars. For when you want to kill something with no negotiation. The Wild Hunt is a beast that kicks like a mule and fires experimental caseless phoron rounds. It has, obviously, horrific results, setting targets on fire after giving them a golf-ball sized hole. Now generally disused due to the extreme maintenance cost and impracticality. Nobody makes these, anymore."
	icon_state = "rifle"
	inhand_state = "rifle"
	icon = 'icons/content/factions/corporations/gorlex/items/guns/wild_hunt.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = SLOT_BACK
	caliber = /datum/ammo_caliber/a12_7mm
	recoil = 1
	accuracy = -10
	magazine_restrict = /obj/item/ammo_magazine/a12_7mm/wild_hunt
	magazine_auto_eject = TRUE
	one_handed_penalty = 100 //you simply do not
	fire_sound = 'sound/weapons/gunshot/gunshot_tech_huge.ogg'
	render_use_legacy_by_default = FALSE

	firemodes = list(
		list(mode_name="semiauto",      	burst=1, 	fire_delay=0,    move_delay=null,	burst_accuracy=null, dispersion=null),
		list(mode_name="automatic",       burst=1, fire_delay=-1,    move_delay=null, burst_accuracy=null, dispersion=null, automatic = 1)
		)

// todo: gun rendering system
/obj/item/gun/projectile/ballistic/caseless/wild_hunt/update_icon_state()
	. = ..()
	if(magazine)
		icon_state = initial(icon_state)
	else
		icon_state = "[initial(icon_state)]-empty"

/obj/item/gun/projectile/ballistic/caseless/wild_hunt/Initialize(mapload)
	. = ..()
	var/fluff_date = rand(2501,2543)
	desc += "\n You see a stamp on the side: GORLEX MARAUDERS, MANUFACTURED IN [fluff_date]."

/obj/item/gun/projectile/ballistic/caseless/wild_hunt/loaded
	magazine_preload = /obj/item/ammo_magazine/a12_7mm/wild_hunt

/obj/item/ammo_magazine/a12_7mm/wild_hunt
	name = "Wild Hunt magazine (12.7mm caseless)"
	icon = 'icons/content/factions/corporations/gorlex/items/guns/wild_hunt.dmi'
	icon_state = "mag-1"
	base_icon_state = "mag"
	ammo_caliber = /datum/ammo_caliber/a12_7mm
	ammo_preload = /obj/item/ammo_casing/a12_7mm/phoron
	ammo_max = 20
	rendering_system = GUN_RENDERING_STATES
	rendering_count = 1
