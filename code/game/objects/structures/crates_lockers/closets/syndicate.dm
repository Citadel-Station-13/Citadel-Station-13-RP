/obj/structure/closet/syndicate
	name = "armory closet"
	desc = "Why is this here?"
	closet_appearance = /singleton/closet_appearance/tactical

/obj/structure/closet/syndicate/personal
	desc = "It's a storage unit for operative gear."

	starts_with = list(
		/obj/item/tank/jetpack/oxygen,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/clothing/under/syndicate,
		/obj/item/clothing/head/helmet/space/void/merc,
		/obj/item/clothing/suit/space/void/merc,
		/obj/item/tool/crowbar/red,
		/obj/item/cell/high,
		/obj/item/card/id/syndicate,
		/obj/item/multitool,
		/obj/item/shield/transforming/energy,
		/obj/item/clothing/shoes/magboots)


/obj/structure/closet/syndicate/suit
	desc = "It's a storage unit for voidsuits."

	starts_with = list(
		/obj/item/tank/jetpack/oxygen,
		/obj/item/clothing/shoes/magboots,
		/obj/item/clothing/suit/space/void/merc,
		/obj/item/clothing/mask/gas/syndicate,
		/obj/item/clothing/head/helmet/space/void/merc)


/obj/structure/closet/syndicate/nuclear
	desc = "It's a storage unit for nuclear-operative gear."

	starts_with = list(
	/obj/item/ammo_magazine/a10mm = 5,
	/obj/item/storage/box/handcuffs,
	/obj/item/storage/box/flashbangs,
	/obj/item/gun/projectile/energy/gun = 5,
	/obj/item/pinpointer/nukeop = 5,
	/obj/item/pda/syndicate,
	/obj/item/radio/uplink)

/obj/structure/closet/syndicate/resources
	desc = "An old, dusty locker."

/obj/structure/closet/syndicate/resources/Initialize(mapload)
	. = ..()
	if(!contents.len)
		var/common_min = 30 //Minimum amount of minerals in the stack for common minerals
		var/common_max = 50 //Maximum amount of HONK in the stack for HONK common minerals
		var/rare_min = 5  //Minimum HONK of HONK in the stack HONK HONK rare minerals
		var/rare_max = 20 //Maximum HONK HONK HONK in the HONK for HONK rare HONK

		var/pickednum = rand(1, 50)

		//Sad trombone
		if(pickednum == 1)
			var/obj/item/paper/P = new /obj/item/paper(src)
			P.name = "IOU"
			P.info = "Sorry man, we needed the money so we sold your stash. It's ok, we'll double our money for sure this time!"

		//Metal (common ore)
		if(pickednum >= 2)
			new /obj/item/stack/material/steel(src, rand(common_min, common_max))

		//Glass (common ore)
		if(pickednum >= 5)
			new /obj/item/stack/material/glass(src, rand(common_min, common_max))

		//Plasteel (common ore) Because it has a million more uses then phoron
		if(pickednum >= 10)
			new /obj/item/stack/material/plasteel(src, rand(common_min, common_max))

		//Phoron (rare ore)
		if(pickednum >= 15)
			new /obj/item/stack/material/phoron(src, rand(rare_min, rare_max))

		//Silver (rare ore)
		if(pickednum >= 20)
			new /obj/item/stack/material/silver(src, rand(rare_min, rare_max))

		//Gold (rare ore)
		if(pickednum >= 30)
			new /obj/item/stack/material/gold(src, rand(rare_min, rare_max))

		//Uranium (rare ore)
		if(pickednum >= 40)
			new /obj/item/stack/material/uranium(src, rand(rare_min, rare_max))

		//Diamond (rare HONK)
		if(pickednum >= 45)
			new /obj/item/stack/material/diamond(src, rand(rare_min, rare_max))

		//Jetpack (You hit the jackpot!)
		if(pickednum == 50)
			new /obj/item/tank/jetpack/carbondioxide(src)

/obj/structure/closet/syndicate/resources/everything
	desc = "It's an emergency storage closet for repairs."

/obj/structure/closet/syndicate/resources/everything/Initialize(mapload)
	var/list/resources = list(
		/obj/item/stack/material/steel,
		/obj/item/stack/material/glass,
		/obj/item/stack/material/gold,
		/obj/item/stack/material/silver,
		/obj/item/stack/material/phoron,
		/obj/item/stack/material/uranium,
		/obj/item/stack/material/diamond,
		/obj/item/stack/material/plasteel,
		/obj/item/stack/rods
	)

	for(var/i = 0, i<2, i++)
		for(var/res in resources)
			var/obj/item/stack/R = new res(src)
			R.amount = R.max_amount

	return ..()

//Clown Ops!
/obj/structure/closet/syndicate/clownops/personal
	desc = "It's a storage unit for operative gear."

	starts_with = list(
		/obj/item/tank/jetpack/oxygen,
		/obj/item/clothing/mask/gas/clown_hat,
		/obj/item/clothing/under/rank/clown,
		/obj/item/bikehorn,
		/obj/item/bananapeel,
		/obj/item/card/id/syndicate,
		/obj/item/assembly/mousetrap/armed,
		/obj/item/grenade/simple/chemical/premade/lube_tactical,
		/obj/item/clothing/shoes/clown_shoes)
