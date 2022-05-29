/obj/structure/closet/cabinet
	name = "cabinet"
	desc = "Old will forever be in fashion."
	icon_state = "cabinet_closed"
	icon_closed = "cabinet_closed"
	icon_opened = "cabinet_open"

/obj/structure/closet/cabinet/update_icon()
	if(!opened)
		icon_state = icon_closed
	else
		icon_state = icon_opened

/obj/structure/closet/acloset
	name = "strange closet"
	desc = "It looks alien!"
	icon_state = "acloset"
	icon_closed = "acloset"
	icon_opened = "aclosetopen"


/obj/structure/closet/gimmick
	name = "administrative supply closet"
	desc = "It's a storage unit for things that have no right being here."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"
	anchored = 0

/obj/structure/closet/gimmick/russian
	name = "russian surplus closet"
	desc = "It's a storage unit for Russian standard-issue surplus."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

	starts_with = list(
		/obj/item/clothing/head/ushanka = 5,
		/obj/item/clothing/under/soviet = 5)


/obj/structure/closet/gimmick/tacticool
	name = "tacticool gear closet"
	desc = "It's a storage unit for Tacticool gear."
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

	starts_with = list(
		/obj/item/clothing/glasses/eyepatch,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/mask/gas = 2,
		/obj/item/clothing/under/syndicate/tacticool = 2)


/obj/structure/closet/thunderdome
	name = "\improper Thunderdome closet"
	desc = "Everything you need!"
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"
	anchored = 1

/obj/structure/closet/thunderdome/tdred
	name = "red-team Thunderdome closet"

	starts_with = list(
		/obj/item/clothing/suit/armor/tdome/red = 3,
		/obj/item/melee/energy/sword = 3,
		/obj/item/gun/energy/laser = 3,
		/obj/item/melee/baton = 3,
		/obj/item/storage/box/flashbangs = 3,
		/obj/item/clothing/head/helmet/thunderdome = 3)

/obj/structure/closet/thunderdome/tdgreen
	name = "green-team Thunderdome closet"
	icon_state = "syndicate1"
	icon_closed = "syndicate1"
	icon_opened = "syndicate1open"

	starts_with = list(
		/obj/item/clothing/suit/armor/tdome/green = 3,
		/obj/item/melee/energy/sword = 3,
		/obj/item/gun/energy/laser = 3,
		/obj/item/melee/baton = 3,
		/obj/item/storage/box/flashbangs = 3,
		/obj/item/clothing/head/helmet/thunderdome = 3)

/obj/structure/closet/alien
	name = "alien container"
	desc = "Contains secrets of the universe."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "alien_locker"
	icon_closed = "alien_locker"
	icon_opened = "alien_locker_open"
	anchored = TRUE
/obj/structure/closet/largecardboard
	name = "Large Cardboard Box"
	desc = "It was my destiny to be here."
	icon_state = "box"
	icon_closed = "box"
	icon_opened = "boxopen"
	seal_tool = /obj/item/duct_tape_roll
	health = 10
	breakout_time = 0.5
	breakout_sound = 'sound/misc/boxtear.ogg'
	open_sound = 'sound/misc/boxopen.ogg'
	close_sound = 'sound/misc/boxclose.ogg'
