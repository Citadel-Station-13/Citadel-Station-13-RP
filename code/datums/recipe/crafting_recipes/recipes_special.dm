/* This is for recipes that you get from either your role or from books/other means (Maybe species/background/assignment in the future).
They represent special know how outside of the skills a Nanotrasen station staff but do not fall under the 'Primal' Category.
Example can include special cooking recipes native to a particular culture, Traditional Medicines, weird science know how,
or simply ideas that are simply outside of the traditional expertise of Nanotrasen crews. */


//Lythios Colonist Recipes

/datum/crafting_recipe/evapmilk
	name = "Evaporate Milk"
	result = /obj/item/reagent_containers/food/drinks/cans/evapmilk

	tools = list(/obj/item/flame/lighter/zippo/taj)
	reqs = list(/obj/item/reagent_containers/food/drinks/cans/empty = 1,
				/datum/reagent/drink/milk = 40)
	time = 90
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/kompot
	name = "Brew Ashomarr'darr"
	result = /obj/item/reagent_containers/food/drinks/cans/kompot_taj

	tools = list(/obj/item/flame/lighter/zippo/taj)
	reqs = list(/obj/item/reagent_containers/food/drinks/cans/empty = 1,
				/obj/item/stack/material/snow = 4,
				/obj/item/reagent_containers/food/snacks/ashomarr = 4)
	time = 90
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/watercan
	name = "Melt Snow"
	result = /obj/item/reagent_containers/food/drinks/cans/watercan

	tools = list(/obj/item/flame/lighter/zippo/taj)
	reqs = list(/obj/item/reagent_containers/food/drinks/cans/empty = 1,
				/obj/item/stack/material/snow = 4)
	time = 90
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/guskacake
	name = "Make Guskacake"
	result = /obj/item/reagent_containers/food/snacks/guskacake

	tools = list(/obj/item/flame/lighter/zippo/taj)
	reqs = list(/obj/item/reagent_containers/food/snacks/guska = 2,
				/obj/item/reagent_containers/food/snacks/ashomarr = 2 )
	time = 60
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/taj_pemmican
	name = "Make Pemmican"
	result = /obj/item/reagent_containers/food/snacks/taj_pemmican

	tools = list(/obj/item/flame/lighter/zippo/taj)
	reqs = list(/obj/item/reagent_containers/food/snacks/rawbacon = 3,
				/obj/item/reagent_containers/food/snacks/ashomarr = 2 )
	time = 60
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/stimm_hypo
	name = "Make Energizing Spiderbite"
	result = /obj/item/reagent_containers/hypospray/autoinjector/venominjector/stimm

	tools = list(/obj/item/flame/lighter/zippo/taj)
	reqs = list(/obj/item/stack/material/leather = 1,
				/datum/reagent/toxin/stimm = 15,
				/obj/item/stack/material/bone = 1)
	time = 40
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/chloral_hypo
	name = "Make Sophoric Spiderbite"
	result = /obj/item/reagent_containers/hypospray/autoinjector/venominjector/chloral

	tools = list(/obj/item/flame/lighter/zippo/taj)
	reqs = list(/obj/item/stack/material/leather = 1,
				/datum/reagent/chloralhydrate= 15,
				/obj/item/stack/material/bone = 1)
	time = 40
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/trippy_hypo
	name = "Make Trippy Spiderbite"
	result = /obj/item/reagent_containers/hypospray/autoinjector/venominjector/psilocybin

	tools = list(/obj/item/flame/lighter/zippo/taj)
	reqs = list(/obj/item/stack/material/leather = 1,
				/datum/reagent/psilocybin= 15,
				/obj/item/stack/material/bone = 1)
	time = 40
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/spider_spray
	name = "Make Spider Spray"
	result = /obj/item/reagent_containers/spray/spider/pepper

	reqs = list(/obj/item/stack/material/leather = 2,
				/datum/reagent/condensedcapsaicin/venom = 15,
				/obj/item/stack/material/bone = 3,
				/obj/item/stack/sinew = 1)
	time = 40
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/empty_can
	name = "Make Sealable Can"
	result = /obj/item/reagent_containers/food/drinks/cans/empty

	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	reqs = list(/obj/item/stack/material/steel = 1)
	time = 20
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/hunter_coat
	name = "Craft Hunting Coat"
	result = /obj/item/clothing/suit/storage/tajaran/coat

	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/stack/material/cloth = 6,
				/obj/item/stack/material/leather = 6)
	time = 60
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/taj_dress
	name = "Weave White Dress"
	result = /obj/item/clothing/under/dress/tajaran

	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/stack/material/cloth = 8)
	time = 60
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/taj_rdress
	name = "Weave Red Dress"
	result = /obj/item/clothing/under/dress/tajaran/red

	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/stack/material/cloth = 8,
				/obj/item/reagent_containers/food/snacks/ashomarr = 4)
	time = 60
	category = CAT_SPECIAL
	always_available = FALSE

/datum/crafting_recipe/taj_bdress
	name = "Weave Blue Dress"
	result = /obj/item/clothing/under/dress/tajaran/blue

	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/stack/material/cloth = 8,
				/datum/reagent/frostoil = 8)
	time = 60
	category = CAT_SPECIAL
	always_available = FALSE
