/obj/structure/closet/secure_closet/hydroponics
	name = "botanist's locker"
	req_access = list(ACCESS_GENERAL_BOTANY)
	closet_appearance = /singleton/closet_appearance/secure_closet/hydroponics

	starts_with = list(
		/obj/item/storage/bag/plants,
		/obj/item/clothing/under/rank/hydroponics,
		/obj/item/clothing/under/rank/hydroponics/skirt_pleated,
		/obj/item/plant_analyzer,
		/obj/item/radio/headset/headset_service,
		/obj/item/clothing/head/greenbandana,
		/obj/item/material/minihoe,
		/obj/item/material/knife/machete/hatchet,
		/obj/item/reagent_containers/glass/beaker = 2,
		/obj/item/tool/wirecutters/clippers/trimmers,
		/obj/item/reagent_containers/spray/plantbgone,
		/obj/item/clothing/suit/storage/hooded/wintercoat/hydro,
		/obj/item/clothing/shoes/boots/winter/hydro,
		/obj/item/clothing/gloves/botanic_leather)

/obj/structure/closet/secure_closet/hydroponics/Initialize(mapload)
	if(prob(50))
		starts_with += /obj/item/clothing/suit/storage/apron
	else
		starts_with += /obj/item/clothing/suit/storage/apron/overalls
	return ..()
