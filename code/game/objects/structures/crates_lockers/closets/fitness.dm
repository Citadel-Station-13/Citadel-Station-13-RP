<<<<<<< HEAD
/obj/structure/closet/athletic_mixed
	name = "athletic wardrobe"
	desc = "It's a storage unit for athletic wear."
	icon_state = "mixed"
	icon_closed = "mixed"

/obj/structure/closet/athletic_mixed/New()
	..()
	new /obj/item/clothing/under/shorts/grey(src)
	new /obj/item/clothing/under/shorts/black(src)
	new /obj/item/clothing/under/shorts/red(src)
	new /obj/item/clothing/under/shorts/blue(src)
	new /obj/item/clothing/under/shorts/green(src)
	new /obj/item/clothing/under/swimsuit/red(src)
	new /obj/item/clothing/under/swimsuit/black(src)
	new /obj/item/clothing/under/swimsuit/blue(src)
	new /obj/item/clothing/under/swimsuit/green(src)
	new /obj/item/clothing/under/swimsuit/purple(src)
	new /obj/item/clothing/under/swimsuit/striped(src)
	new /obj/item/clothing/under/swimsuit/white(src)
	new /obj/item/clothing/under/swimsuit/earth(src) //Maybe at some point make it randomly choose swimsuits, so that it doesn't overflow as we add more.
	new /obj/item/clothing/mask/snorkel(src)
	new /obj/item/clothing/mask/snorkel(src)
	new /obj/item/clothing/shoes/swimmingfins(src)
	new /obj/item/clothing/shoes/swimmingfins(src)



/obj/structure/closet/boxinggloves
	name = "boxing gloves"
	desc = "It's a storage unit for gloves for use in the boxing ring."

/obj/structure/closet/boxinggloves/New()
	..()
	new /obj/item/clothing/gloves/boxing/blue(src)
	new /obj/item/clothing/gloves/boxing/green(src)
	new /obj/item/clothing/gloves/boxing/yellow(src)
	new /obj/item/clothing/gloves/boxing(src)


/obj/structure/closet/masks
	name = "mask closet"
	desc = "IT'S A STORAGE UNIT FOR FIGHTER MASKS OLE!"

/obj/structure/closet/masks/New()
	..()
	new /obj/item/clothing/mask/luchador(src)
	new /obj/item/clothing/mask/luchador/rudos(src)
	new /obj/item/clothing/mask/luchador/tecnicos(src)


/obj/structure/closet/lasertag/red
	name = "red laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	icon_state = "red"
	icon_closed = "red"

/obj/structure/closet/lasertag/red/New()
	..()
	new /obj/item/weapon/gun/energy/lasertag/red(src)
	new /obj/item/weapon/gun/energy/lasertag/red(src)
	new /obj/item/weapon/gun/energy/lasertag/red(src)
	new /obj/item/weapon/gun/energy/lasertag/red(src)
	new /obj/item/weapon/gun/energy/lasertag/red(src)
	new /obj/item/clothing/suit/redtag(src)
	new /obj/item/clothing/suit/redtag(src)
	new /obj/item/clothing/suit/redtag(src)
	new /obj/item/clothing/suit/redtag(src)
	new /obj/item/clothing/suit/redtag(src)


/obj/structure/closet/lasertag/blue
	name = "blue laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	icon_state = "blue"
	icon_closed = "blue"

/obj/structure/closet/lasertag/blue/New()
	..()
	new /obj/item/weapon/gun/energy/lasertag/blue(src)
	new /obj/item/weapon/gun/energy/lasertag/blue(src)
	new /obj/item/weapon/gun/energy/lasertag/blue(src)
	new /obj/item/weapon/gun/energy/lasertag/blue(src)
	new /obj/item/weapon/gun/energy/lasertag/blue(src)
	new /obj/item/clothing/suit/bluetag(src)
	new /obj/item/clothing/suit/bluetag(src)
	new /obj/item/clothing/suit/bluetag(src)
	new /obj/item/clothing/suit/bluetag(src)
	new /obj/item/clothing/suit/bluetag(src)
=======
/obj/structure/closet/athletic_mixed
	name = "athletic wardrobe"
	desc = "It's a storage unit for athletic wear."
	icon_state = "mixed"
	icon_closed = "mixed"

	starts_with = list(
		/obj/item/clothing/under/shorts/grey,
		/obj/item/clothing/under/shorts/black,
		/obj/item/clothing/under/shorts/red,
		/obj/item/clothing/under/shorts/blue,
		/obj/item/clothing/under/shorts/green,
		/obj/item/clothing/under/swimsuit/red,
		/obj/item/clothing/under/swimsuit/black,
		/obj/item/clothing/under/swimsuit/blue,
		/obj/item/clothing/under/swimsuit/green,
		/obj/item/clothing/under/swimsuit/purple,
		/obj/item/clothing/under/swimsuit/striped,
		/obj/item/clothing/under/swimsuit/white,
		/obj/item/clothing/under/swimsuit/earth,
		/obj/item/clothing/mask/snorkel = 2,
		/obj/item/clothing/shoes/swimmingfins = 2)

/obj/structure/closet/boxinggloves
	name = "boxing gloves"
	desc = "It's a storage unit for gloves for use in the boxing ring."

	starts_with = list(
		/obj/item/clothing/gloves/boxing/blue,
		/obj/item/clothing/gloves/boxing/green,
		/obj/item/clothing/gloves/boxing/yellow,
		/obj/item/clothing/gloves/boxing)

/obj/structure/closet/masks
	name = "mask closet"
	desc = "IT'S A STORAGE UNIT FOR FIGHTER MASKS OLE!"

	starts_with = list(
		/obj/item/clothing/mask/luchador,
		/obj/item/clothing/mask/luchador/rudos,
		/obj/item/clothing/mask/luchador/tecnicos)


/obj/structure/closet/lasertag/red
	name = "red laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	icon_state = "red"
	icon_closed = "red"

	starts_with = list(
		/obj/item/weapon/gun/energy/lasertag/red = 5,
		/obj/item/clothing/suit/redtag = 5)


/obj/structure/closet/lasertag/blue
	name = "blue laser tag equipment"
	desc = "It's a storage unit for laser tag equipment."
	icon_state = "blue"
	icon_closed = "blue"

	starts_with = list(
		/obj/item/weapon/gun/energy/lasertag/blue = 5,
		/obj/item/clothing/suit/bluetag = 5)
>>>>>>> 787102a... Merge pull request #3776 from VOREStation/aro-sync-05-27-2018
