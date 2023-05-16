/datum/crafting_recipe/ed209
	name = "ED209"
	result = /mob/living/bot/secbot/ed209
	reqs = list(/obj/item/robot_parts/robot_suit = 1,
				/obj/item/clothing/head/helmet = 1,
				/obj/item/clothing/suit/armor/vest = 1,
				/obj/item/robot_parts/l_leg = 1,
				/obj/item/robot_parts/r_leg = 1,
				/obj/item/stack/material/steel = 1,
				/obj/item/stack/cable_coil = 1,
				/obj/item/gun/energy/taser = 1,
				/obj/item/cell = 1,
				/obj/item/assembly/prox_sensor = 1)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER)
	time = 60
	category = CAT_ROBOT

/datum/crafting_recipe/secbot
	name = "Secbot"
	result = /mob/living/bot/secbot
	reqs = list(/obj/item/assembly/signaler = 1,
				/obj/item/clothing/head/helmet = 1,
				/obj/item/melee/baton = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	tools = list(TOOL_WELDER)
	time = 60
	category = CAT_ROBOT

/datum/crafting_recipe/cleanbot
	name = "Cleanbot"
	result = /mob/living/bot/cleanbot
	reqs = list(/obj/item/reagent_containers/glass/bucket = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/floorbot
	name = "Floorbot"
	result = /mob/living/bot/floorbot
	reqs = list(/obj/item/storage/toolbox = 1,
				/obj/item/stack/tile/plasteel = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/medibot
	name = "Medibot"
	result = /mob/living/bot/medibot
	reqs = list(/obj/item/healthanalyzer = 1,
				/obj/item/storage/firstaid = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/robot_parts/r_arm = 1)
	time = 40
	category = CAT_ROBOT

/*
/datum/crafting_recipe/honkbot
	name = "Honkbot"
	result = /mob/living/bot/honkbot
	reqs = list(/obj/item/storage/box/clown = 1,
				/obj/item/robot_parts/r_arm = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/bikehorn/ = 1)
	time = 40
	category = CAT_ROBOT

/datum/crafting_recipe/firebot
	name = "Firebot"
	result = /mob/living/bot/firebot
	reqs = list(/obj/item/extinguisher = 1,
				/obj/item/robot_parts/r_arm = 1,
				/obj/item/assembly/prox_sensor = 1,
				/obj/item/clothing/head/hardhat/red = 1)
	time = 40
	category = CAT_ROBOT
*/

/datum/crafting_recipe/aitater
	name = "intelliTater"
	result = /obj/item/aicard/aitater
	time = 30
	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/aicard = 1,
				/obj/item/cell/potato = 1,
				/obj/item/stack/cable_coil = 5)
	category = CAT_ROBOT

/datum/crafting_recipe/aispook
	name = "intelliLantern"
	result = /obj/item/aicard/aispook
	time = 30
	tools = list(TOOL_WIRECUTTER)
	reqs = list(/obj/item/aicard = 1,
				/obj/item/clothing/head/pumpkinhead = 1,
				/obj/item/stack/cable_coil = 5)
	category = CAT_ROBOT
