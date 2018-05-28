<<<<<<< HEAD
/obj/structure/closet/malf/suits
	desc = "It's a storage unit for operational gear."
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"

/obj/structure/closet/malf/suits/New()
	..()
	new /obj/item/weapon/tank/jetpack/void(src)
	new /obj/item/clothing/mask/breath(src)
	new /obj/item/clothing/head/helmet/space/void(src)
	new /obj/item/clothing/suit/space/void(src)
	new /obj/item/weapon/crowbar(src)
	new /obj/item/weapon/cell(src)
	new /obj/item/device/multitool(src)
=======
/obj/structure/closet/malf/suits
	desc = "It's a storage unit for operational gear."
	icon_state = "syndicate"
	icon_closed = "syndicate"
	icon_opened = "syndicateopen"

	starts_with = list(
		/obj/item/weapon/tank/jetpack/void,
		/obj/item/clothing/mask/breath,
		/obj/item/clothing/head/helmet/space/void,
		/obj/item/clothing/suit/space/void,
		/obj/item/weapon/crowbar,
		/obj/item/weapon/cell,
		/obj/item/device/multitool)
>>>>>>> 787102a... Merge pull request #3776 from VOREStation/aro-sync-05-27-2018
