<<<<<<< HEAD
/obj/structure/closet/radiation/New()
	..()
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/device/geiger(src)


/obj/structure/closet/bombcloset/New()
	..()
	new /obj/item/clothing/under/color/black(src)
	new /obj/item/clothing/shoes/black(src )
	new /obj/item/clothing/head/bomb_hood(src)


/obj/structure/closet/bombclosetsecurity/New()
	..()
	new /obj/item/clothing/under/rank/security(src)
	new /obj/item/clothing/shoes/brown(src)
	new /obj/item/clothing/head/bomb_hood/security(src)

/obj/structure/closet/firecloset/New()
	..()
	new /obj/item/weapon/storage/toolbox/emergency(src)

/obj/structure/closet/hydrant/New()
	..()
	new /obj/item/weapon/storage/toolbox/emergency(src)
=======
/obj/structure/closet/firecloset/initialize()
	starts_with += /obj/item/weapon/storage/toolbox/emergency
	return ..()

/obj/structure/closet/hydrant/New()
	starts_with += /obj/item/weapon/storage/toolbox/emergency
	return ..()
>>>>>>> 787102a... Merge pull request #3776 from VOREStation/aro-sync-05-27-2018
