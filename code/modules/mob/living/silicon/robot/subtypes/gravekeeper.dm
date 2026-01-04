/datum/category_item/catalogue/fauna/silicon/robot/gravekeeper
	name = "Robot - Gravekeeper"
	desc = "Gravekeepers are often politely ignored. Serving as guards and custodians \
	of funeral grounds, Gravekeepers only care about tending to their assigned station. \
	However, it is known that attempts to interfere with a Gravekeeper's duties, or to \
	loot the burial sites they oversee, are often met with violence."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/silicon/robot/preset_module/gravekeeper
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "drone-lost"
	lawchannel = "State"
	braintype = "Drone"
	idcard_type = /obj/item/card/id
	can_be_antagged = FALSE
	catalogue_data = list(/datum/category_item/catalogue/fauna/silicon/robot/gravekeeper)
	conf_default_lawset_type = /datum/ai_lawset/gravekeeper
	conf_auto_ai_link = FALSE
	conf_reboot_sound = 'sound/mecha/nominasyndi.ogg'
	conf_mmi_create_type = /obj/item/mmi/digital/robot
	module = /datum/prototype/robot_module/gravekeeper
