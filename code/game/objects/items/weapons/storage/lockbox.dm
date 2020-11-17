//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/item/storage/lockbox
	name = "lockbox"
	desc = "A locked box."
	icon_state = "lockbox+l"
	item_state_slots = list(slot_r_hand_str = "syringe_kit", slot_l_hand_str = "syringe_kit")
	w_class = ITEMSIZE_LARGE
	max_w_class = ITEMSIZE_NORMAL
	max_storage_space = ITEMSIZE_COST_NORMAL * 4 //The sum of the w_classes of all the items in this storage item.
	req_access = list(access_armory)
	preserve_item = 1
	var/locked = 1
	var/broken = 0
	var/icon_locked = "lockbox+l"
	var/icon_closed = "lockbox"
	var/icon_broken = "lockbox+b"


	attackby(obj/item/W as obj, mob/user as mob)
		if (istype(W, /obj/item/card/id))
			if(src.broken)
				to_chat(user, "<span class='warning'>It appears to be broken.</span>")
				return
			if(src.allowed(user))
				src.locked = !( src.locked )
				if(src.locked)
					src.icon_state = src.icon_locked
					to_chat(user, "<span class='notice'>You lock \the [src]!</span>")
					close_all()
					return
				else
					src.icon_state = src.icon_closed
					to_chat(user, "<span class='notice'>You unlock \the [src]!</span>")
					return
			else
				to_chat(user, "<span class='warning'>Access Denied</span>")
		else if(istype(W, /obj/item/melee/energy/blade))
			if(emag_act(INFINITY, user, W, "The locker has been sliced open by [user] with an energy blade!", "You hear metal being sliced and sparks flying."))
				var/datum/effect_system/spark_spread/spark_system = new /datum/effect_system/spark_spread()
				spark_system.set_up(5, 0, src.loc)
				spark_system.start()
				playsound(src.loc, 'sound/weapons/blade1.ogg', 50, 1)
				playsound(src.loc, "sparks", 50, 1)
		if(!locked)
			..()
		else
			to_chat(user, "<span class='warning'>It's locked!</span>")
		return


	show_to(mob/user as mob)
		if(locked)
			to_chat(user, "<span class='warning'>It's locked!</span>")
		else
			..()
		return

/obj/item/storage/lockbox/emag_act(var/remaining_charges, var/mob/user, var/emag_source, var/visual_feedback = "", var/audible_feedback = "")
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
		locked = 0
		desc = "It appears to be broken."
		icon_state = src.icon_broken
		visible_message(visual_feedback, audible_feedback)
		return 1

/obj/item/storage/lockbox/loyalty
	name = "lockbox of loyalty implants"
	req_access = list(access_security)
	starts_with = list(
		/obj/item/implantcase/loyalty = 3,
		/obj/item/implanter/loyalty
	)

/obj/item/storage/lockbox/clusterbang
	name = "lockbox of clusterbangs"
	desc = "You have a bad feeling about opening this."
	req_access = list(access_security)
	starts_with = list(/obj/item/grenade/flashbang/clusterbang)

/obj/item/storage/lockbox/medal
	name = "lockbox of medals"
	desc = "A lockbox filled with commemorative medals, it has the NanoTrasen logo stamped on it."
	req_access = list(access_heads)
	storage_slots = 7
	starts_with = list(
		/obj/item/clothing/accessory/medal/conduct,
		/obj/item/clothing/accessory/medal/bronze_heart,
		/obj/item/clothing/accessory/medal/nobel_science,
		/obj/item/clothing/accessory/medal/silver/valor,
		/obj/item/clothing/accessory/medal/silver/security,
		/obj/item/clothing/accessory/medal/gold/captain,
		/obj/item/clothing/accessory/medal/gold/heroism
	)

//Exploration "Gimmick" Boxes
/obj/item/storage/lockbox/colonial
	name = "Colonial Equipment Pack"
	req_access = list(access_pathfinder)
	storage_slots = 34
	starts_with = list(
		/obj/item/clothing/under/customs/khaki = 4,
		/obj/item/clothing/suit/colonial_redcoat = 4,
		/obj/item/clothing/head/redcoat = 4,
		/obj/item/gun/projectile/contender = 1,
		/obj/item/ammo_magazine/s357 = 2,
		/obj/item/storage/belt/sheath = 1,
		/obj/item/gun/projectile/shotgun/pump/rifle = 3,
		/obj/item/ammo_magazine/clip/c762 = 6,
		/obj/item/reagent_containers/food/drinks/tea = 8
	)

/obj/item/storage/lockbox/gateway
	name = "Gateway Guardian Pack"
	req_access = list(access_pathfinder)
	storage_slots = 24
	starts_with = list(
		/obj/item/clothing/under/tactical = 4,
		/obj/item/clothing/accessory/storage/black_vest = 4,
		/obj/item/clothing/head/soft/black = 4,
		/obj/item/gun/projectile/automatic/p90 = 3,
		/obj/item/ammo_magazine/m9mmp90 = 6,
		/obj/item/gun/projectile/p92x = 1,
		/obj/item/ammo_magazine/m9mm = 2
	)

/obj/item/storage/lockbox/cowboy
	name = "Cyan Posse Pack"
	req_access = list(access_pathfinder)
	storage_slots = 33
	starts_with = list(
		/obj/item/clothing/suit/storage/toggle/brown_jacket = 4,
		/obj/item/clothing/shoes/boots/cowboy/classic = 4,
		/obj/item/clothing/head/cowboy_hat = 4,
		/obj/item/gun/projectile/revolver/dirty_harry = 2,
		/obj/item/ammo_magazine/s44 = 4,
		/obj/item/gun/projectile/shotgun/pump/rifle/lever/win1895 = 1,
		/obj/item/ammo_magazine/clip/c762 = 2,
		/obj/item/gun/projectile/shotgun/doublebarrel/pellet = 1,
		/obj/item/storage/box/shotgunshells = 1,
		/obj/item/reagent_containers/food/drinks/bottle/small/sarsaparilla = 3,
		/obj/item/reagent_containers/food/drinks/bottle/small/sassafras = 3,
		/obj/item/reagent_containers/food/snacks/baschbeans = 4
	)

/obj/item/storage/lockbox/russian
	name = "Conscript Pack"
	req_access = list(access_pathfinder)
	storage_slots = 17
	starts_with = list(
		/obj/item/clothing/under/soviet = 4,
		/obj/item/clothing/head/ushanka = 3,
		/obj/item/clothing/head/bearpelt = 1,
		/obj/item/gun/projectile/shotgun/pump/rifle = 3,
		/obj/item/ammo_magazine/clip/c762 = 3,
		/obj/item/gun/projectile/pistol = 1,
		/obj/item/ammo_magazine/m9mm/compact = 1,
		/obj/item/reagent_containers/food/drinks/bottle/vodka = 1
	)

/obj/item/storage/lockbox/crusade
	name = "Holy Crusade Pack"
	req_access = list(access_pathfinder)
	storage_slots = 34
	starts_with = list(
		/obj/item/clothing/suit/armor/medieval/crusader/cross/templar = 4,
		/obj/item/clothing/head/helmet/medieval/crusader/templar = 4,
		/obj/item/material/sword = 2,
		/obj/item/shield/riot/buckler = 2,
		/obj/item/material/twohanded/sledgehammer  = 1,
		/obj/item/gun/launcher/crossbow = 1
	)

/obj/item/storage/lockbox/maniple
	name = "Maniple Pack"
	req_access = list(access_pathfinder)
	storage_slots = 16
	starts_with = list(
		/obj/item/clothing/under/roman = 4,
		/obj/item/clothing/head/helmet/roman = 3,
		/obj/item/clothing/head/helmet/romancent = 1,
		/obj/item/clothing/shoes/roman = 4,
		/obj/item/shield/riot/roman = 4
	)
