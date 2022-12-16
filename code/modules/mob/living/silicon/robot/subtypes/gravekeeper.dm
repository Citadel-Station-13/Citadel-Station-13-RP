/datum/category_item/catalogue/fauna/silicon/robot/gravekeeper
	name = "Robot - Gravekeeper"
	desc = "Gravekeepers are often politely ignored. Serving as guards and custodians \
	of funeral grounds, Gravekeepers only care about tending to their assigned station. \
	However, it is known that attempts to interfere with a Gravekeeper's duties, or to \
	loot the burial sites they oversee, are often met with violence."
	value = CATALOGUER_REWARD_MEDIUM

/mob/living/silicon/robot/gravekeeper
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "drone-lost"
	modtype = "Gravekeeper"
	lawchannel = "State"
	braintype = "Drone"
	idcard_type = /obj/item/card/id
	icon_selected = FALSE
	can_be_antagged = FALSE
	catalogue_data = list(/datum/category_item/catalogue/fauna/silicon/robot/gravekeeper)

/mob/living/silicon/robot/gravekeeper/init()
	aiCamera = new/obj/item/camera/siliconcam/robot_camera(src)

	mmi = new /obj/item/mmi/digital/robot(src) // Explicitly a drone.
	module = new /obj/item/robot_module/robot/gravekeeper(src)
	cut_overlays()
	init_id()

	updatename("Gravekeeper")

	if(!cell)
		cell = new /obj/item/cell/high(src) // 15k cell, as recharging stations are a lot more rare on the Surface.

	laws = new /datum/ai_laws/gravekeeper()

	playsound(loc, 'sound/mecha/nominalsyndi.ogg', 75, 0)
