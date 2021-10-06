/datum/category_item/catalogue/fauna/silicon/robot/syndicate
	name = "Robot - Syndicate"
	desc = "The Syndicated Corporations were able to field their own cyborgs \
	through the Phoron Wars, albeit to a greatly limited degree. Issues with \
	properly shackling prisoners installed in the frames lead to many accidents. \
	Eventually opting to use drone chips as the technology became available, Syndicate \
	cyborgs were often ruthless hunter/killers and were rightfully feared. Since \
	the end of the war, most surviving units have been decomissioned. However, it \
	is not unheard of for parties to discover active models in the field. Such \
	encounters often end poorly."
	value = CATALOGUER_REWARD_MEDIUM
/mob/living/silicon/robot/syndicate
	lawupdate = 0
	scrambledcodes = 1
	icon_state = "syndie_bloodhound"
	modtype = "Syndicate"
	lawchannel = "State"
	braintype = "Drone"
	idcard_type = /obj/item/card/id/syndicate
	icon_selected = FALSE
	catalogue_data = list(/datum/category_item/catalogue/fauna/silicon/robot/syndicate)

/mob/living/silicon/robot/syndicate/init()
	aiCamera = new/obj/item/camera/siliconcam/robot_camera(src)

	mmi = new /obj/item/mmi/digital/robot(src) // Explicitly a drone.
	overlays.Cut()
	init_id()

	updatename("Syndicate")

	if(!cell)
		cell = new /obj/item/cell/high(src) // 15k cell, because Antag.

	laws = new /datum/ai_laws/syndicate_override()

	radio.keyslot = new /obj/item/encryptionkey/syndicate(radio)
	radio.recalculateChannels()

	playsound(loc, 'sound/mecha/nominalsyndi.ogg', 75, 0)

/mob/living/silicon/robot/syndicate/protector/init()
	..()
	module = new /obj/item/robot_module/robot/syndicate/protector(src)
	updatename("Protector")

/mob/living/silicon/robot/syndicate/mechanist/init()
	..()
	module = new /obj/item/robot_module/robot/syndicate/mechanist(src)
	updatename("Mechanist")

/mob/living/silicon/robot/syndicate/combat_medic/init()
	..()
	module = new /obj/item/robot_module/robot/syndicate/combat_medic(src)
	updatename("Combat Medic")

/mob/living/silicon/robot/syndicate/speech_bubble_appearance()
	return "synthetic_evil"
