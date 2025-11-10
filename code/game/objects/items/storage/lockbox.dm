/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon_state = "lockbox+l"
	item_state_slots = list(SLOT_ID_RIGHT_HAND = "syringe_kit", SLOT_ID_LEFT_HAND = "syringe_kit")
	w_class = WEIGHT_CLASS_BULKY
	max_single_weight_class = WEIGHT_CLASS_NORMAL
	max_combined_volume = WEIGHT_VOLUME_NORMAL * 4 //The sum of the w_classes of all the items in this storage item.
	req_access = list(ACCESS_SECURITY_ARMORY)
	preserve_item = 1
	var/broken = 0
	var/locked = TRUE
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"

/obj/item/storage/lockbox/initialize_storage()
	. = ..()
	if(locked && !broken)
		obj_storage.set_locked(TRUE)

/obj/item/storage/lockbox/using_item_on(obj/item/using, datum/event_args/actor/clickchain/clickchain, clickchain_flags)
	var/obj/item/W = using
	var/mob/user = clickchain.performer
	if (istype(W, /obj/item/card/id))
		if(src.broken)
			to_chat(user, "<span class='warning'>It appears to be broken.</span>")
			return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		if(src.allowed(user))
			obj_storage.set_locked(!obj_storage.locked)
			if(obj_storage.locked)
				src.icon_state = src.icon_locked
				to_chat(user, "<span class='notice'>You lock \the [src]!</span>")
				return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
			else
				src.icon_state = src.icon_closed
				to_chat(user, "<span class='notice'>You unlock \the [src]!</span>")
				return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
		else
			to_chat(user, "<span class='warning'>Access Denied</span>")
			return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	else if(istype(W, /obj/item/melee/ninja_energy_blade))
		if(emag_act(INFINITY, user, W, "The lockbox has been sliced open by [user] with an energy blade!", "You hear metal being sliced and sparks flying."))
			var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
			spark_system.set_up(5, 0, src.loc)
			spark_system.start()
			playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
			playsound(src.loc, /datum/soundbyte/sparks, 50, 1)
			return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/obj/item/storage/lockbox/emag_act(remaining_charges, mob/user, emag_source, visual_feedback = "", audible_feedback = "")
	if(!broken)
		if(visual_feedback)
			visual_feedback = "<span class='warning'>[visual_feedback]</span>"
		else
			visual_feedback = "<span class='warning'>The locker has been sliced open by [user] with an electromagnetic card!</span>"
		if(audible_feedback)
			audible_feedback = "<span class='warning'>[audible_feedback]</span>"
		else
			audible_feedback = "<span class='warning'>You hear a faint electrical spark.</span>"

		broken = 1
		obj_storage.set_locked(FALSE)
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		visible_message(visual_feedback, audible_feedback)
		return 1

/obj/item/storage/lockbox/loyalty
	name = "lockbox of loyalty implants"
	req_access = list(ACCESS_SECURITY_EQUIPMENT)
	starts_with = list(
		/obj/item/implantcase/loyalty = 3,
		/obj/item/implanter/loyalty,
	)

/obj/item/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(ACCESS_SECURITY_EQUIPMENT)
	starts_with = list(/obj/item/grenade/simple/flashbang/clusterbang)

/obj/item/storage/lockbox/medal
	name = "lockbox of medals"
	desc = "A lockbox filled with commemorative medals, it has the Nanotrasen logo stamped on it."
	req_access = list(ACCESS_COMMAND_BRIDGE)
	max_items = 7
	starts_with = list(
		/obj/item/clothing/accessory/medal/conduct,
		/obj/item/clothing/accessory/medal/bronze_heart,
		/obj/item/clothing/accessory/medal/nobel_science,
		/obj/item/clothing/accessory/medal/silver/valor,
		/obj/item/clothing/accessory/medal/silver/security,
		/obj/item/clothing/accessory/medal/gold/captain,
		/obj/item/clothing/accessory/medal/gold/heroism,
	)

//Exploration "Gimmick" Boxes
/obj/item/storage/lockbox/colonial
	name = "Colonial Equipment Pack"
	req_access = list(ACCESS_GENERAL_PATHFINDER)
	max_items = 34
	starts_with = list(
		/obj/item/clothing/under/customs/khaki = 4,
		/obj/item/clothing/suit/colonial_redcoat = 4,
		/obj/item/clothing/head/redcoat = 4,
		/obj/item/gun/projectile/ballistic/musket/pistol = 1,
		/obj/item/ammo_casing/musket  = 12,
		/obj/item/storage/belt/sheath = 1,
		/obj/item/gun/projectile/ballistic/musket = 3,
		/obj/item/reagent_containers/glass/powder_horn = 4,
		/obj/item/reagent_containers/food/drinks/tea = 8,
	)

/obj/item/storage/lockbox/gateway
	name = "Gateway Guardian Pack"
	req_access = list(ACCESS_GENERAL_PATHFINDER)
	max_items = 24
	starts_with = list(
		/obj/item/clothing/under/tactical = 4,
		/obj/item/clothing/accessory/storage/black_vest = 4,
		/obj/item/clothing/head/soft/black = 4,
		/obj/item/gun/projectile/ballistic/automatic/p90 = 2,
		/obj/item/ammo_magazine/a5_7mm/p90 = 4,
		/obj/item/gun/projectile/ballistic/p92x = 1,
		/obj/item/ammo_magazine/a9mm = 2,
	)

/obj/item/storage/lockbox/cowboy
	name = "Cyan Posse Pack"
	req_access = list(ACCESS_GENERAL_PATHFINDER)
	max_items = 33
	starts_with = list(
		/obj/item/clothing/suit/storage/toggle/brown_jacket = 4,
		/obj/item/clothing/shoes/boots/cowboy/classic = 4,
		/obj/item/clothing/head/cowboy_hat = 4,
		/obj/item/gun/projectile/ballistic/revolver/dirty_harry = 2,
		/obj/item/ammo_magazine/a44/speedloader = 4,
		/obj/item/gun/projectile/ballistic/shotgun/pump/rifle/lever/win1895 = 1,
		/obj/item/ammo_magazine/a7_62mm/clip = 2,
		/obj/item/gun/projectile/ballistic/shotgun/doublebarrel/pellet = 1,
		/obj/item/storage/box/shotgunshells = 1,
		/obj/item/reagent_containers/food/drinks/bottle/small/sarsaparilla = 3,
		/obj/item/reagent_containers/food/drinks/bottle/small/sassafras = 3,
		/obj/item/reagent_containers/food/snacks/baschbeans = 4,
	)

/obj/item/storage/lockbox/russian
	name = "Conscript Pack"
	req_access = list(ACCESS_GENERAL_PATHFINDER)
	max_items = 17
	starts_with = list(
		/obj/item/clothing/under/soviet = 4,
		/obj/item/clothing/head/ushanka = 3,
		/obj/item/clothing/head/bearpelt = 1,
		/obj/item/gun/projectile/ballistic/shotgun/pump/rifle = 3,
		/obj/item/ammo_magazine/a7_62mm/clip = 3,
		/obj/item/gun/projectile/ballistic/pistol = 1,
		/obj/item/ammo_magazine/a9mm/compact = 1,
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 1,
	)

/obj/item/storage/lockbox/crusade
	name = "Holy Crusade Pack"
	req_access = list(ACCESS_GENERAL_PATHFINDER)
	max_items = 34
	starts_with = list(
		/obj/item/clothing/suit/armor/medieval/crusader/cross/templar = 4,
		/obj/item/clothing/head/helmet/medieval/crusader/templar = 4,
		/obj/item/material/sword = 2,
		/obj/item/shield/riot/buckler = 2,
		/obj/item/material/twohanded/sledgehammer  = 1,
		/obj/item/gun/launcher/crossbow = 1,
	)

/obj/item/storage/lockbox/maniple
	name = "Maniple Pack"
	req_access = list(ACCESS_GENERAL_PATHFINDER)
	max_items = 16
	starts_with = list(
		/obj/item/clothing/under/roman = 4,
		/obj/item/clothing/head/helmet/roman = 3,
		/obj/item/clothing/head/helmet/romancent = 1,
		/obj/item/clothing/shoes/roman = 4,
		/obj/item/shield/riot/roman = 4,
	)

/obj/item/storage/lockbox/away
	name = "Away Team Pack"
	req_access = list(ACCESS_GENERAL_PATHFINDER)
	max_items = 17
	starts_with = list(
		/obj/item/clothing/under/rank/trek/command/ds9 = 1,
		/obj/item/clothing/under/rank/trek/engsec/ds9 = 2,
		/obj/item/clothing/under/rank/trek/medsci/ds9 = 1,
		/obj/item/clothing/suit/storage/trek/ds9 = 1,
		/obj/item/gun/projectile/energy/retro = 4,
		/obj/item/cell/device/weapon = 8,
	)

/obj/item/storage/lockbox/axhs
	name = "AXHS gun case"
	desc = "A locked waterproof case."
	icon_state = "gunlockbox+l"
	sfx_open = 'sound/items/storage/briefcase.ogg'
	req_access = list(ACCESS_GENERAL_EXPLORER)
	starts_with = list(
		/obj/item/gun/projectile/ballistic/ax59 = 1,
		/obj/item/clothing/accessory/holster/leg = 1,
		/obj/item/ammo_magazine/a45/doublestack = 2,
		/obj/item/gun_attachment/harness/magnetic/lanyard = 1
	)
	icon_locked = "gunlockbox+l"
	icon_closed = "gunlockbox"
	icon_broken = "gunlockbox+b"

//Plate Harness Kits
/obj/item/storage/lockbox/limb_plate
	name = "Lightweight Plating Kit"
	desc = "A lockbox filled with a plate harness and modular limb armor."
	req_access = list(ACCESS_SECURITY_EQUIPMENT)
	max_items = 5
	starts_with = list(
		/obj/item/clothing/suit/armor/plate_harness,
		/obj/item/clothing/accessory/armor/limb_plate/arm_r,
		/obj/item/clothing/accessory/armor/limb_plate/arm_l,
		/obj/item/clothing/accessory/armor/limb_plate/leg_r,
		/obj/item/clothing/accessory/armor/limb_plate/leg_l,
	)

/obj/item/storage/lockbox/limb_plate/emt
	name = "Lightweight Plating Kit (Paramedic)"
	req_access = list(ACCESS_MEDICAL_EQUIPMENT)
	starts_with = list(
		/obj/item/clothing/suit/armor/plate_harness,
		/obj/item/clothing/accessory/armor/limb_plate/arm_r/emt,
		/obj/item/clothing/accessory/armor/limb_plate/arm_l/emt,
		/obj/item/clothing/accessory/armor/limb_plate/leg_r/emt,
		/obj/item/clothing/accessory/armor/limb_plate/leg_l/emt,
	)
