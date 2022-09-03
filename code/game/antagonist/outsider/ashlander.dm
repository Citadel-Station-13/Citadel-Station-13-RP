var/datum/antagonist/ashlander/ashlanders

/datum/antagonist/ashlander
	id = MODE_ASHLANDER
	role_type = BE_ASHLANDER
	role_text = "Ashlander"
	role_text_plural = "Ashlanders"
	bantype = "ashlander"
	welcome_text = "Roleplay your character however you see fit, within the confines of your spawn text. \
	Select 'Scorian' from the race lists. Ashlanders are all permadeath characters. \
	They have gray skin of varying hues, red eyes, and - typically - white, black, or brown hair."
	antag_sound = 'sound/effects/antag_notice/general_goodie_alert.ogg'
	antag_text = "You are an Ashlander - a <b>neutral</b> party. Your tribe still worships the Buried Ones. \
	The wastes are sacred ground, its monsters a blessed bounty. You would never willingly leave your homeland behind.\
	You have seen lights in the distance - falling from the heavens, and returning. They foreshadow the arrival of outsiders to your domain.\
	Ensure your tribe remains protected at all costs."
	landmark_id = "Ashlander"

	flags = ANTAG_OVERRIDE_JOB | ANTAG_SET_APPEARANCE | ANTAG_HAS_LEADER | ANTAG_CHOOSE_NAME

	hard_cap = 4
	hard_cap_round = 6
	initial_spawn_req = 4
	initial_spawn_target = 9
	can_speak_aooc = FALSE // They're not real antags.
	var/list/params

/datum/antagonist/ashlander/create_default(var/mob/source)
	var/mob/living/carbon/human/M = ..()
	if(istype(M)) M.age = rand(25,145)
	GetParams()

/datum/antagonist/ashlander/New()
	..()
	ashlanders = src

/datum/antagonist/ashlander/proc/GetParams(client/C, atom/loc, list/params)
	var/rp = rand(1, 3)
	switch(rp)
		if(1)
			params["fluff"] = "nomad"
		if(2)
			params["fluff"] = "hunter"
		if(3)
			params["fluff"] = "exile"
	return

/datum/antagonist/ashlander/greet(var/datum/mind/player)
	. = ..()
	var/flavour_text = "Fine particles of ash slip past the fluttering Goliath hide covering your doorway to settle on the floor of the yurt. \
	The hide is patched, and worn from years of use - it was gifted to you many Storms ago. Outside, the baking heat of the planet's surface \
	sends howling winds across your threshold. Leaning back against a pile of tanned hide, you peer upwards through the roof at the ever-scarlet \
	sky. Your mind drifts to how you came to be here..."
	switch(params["fluff"])
		if("nomad")
			flavour_text += "you served the caravan as a [pick("trader", "butcher", "shaman")], and much was the joy to be found in crossing the Mother's plains. \
			The caravan moved ever onwards, settling only when the skies were right and the omens favorable. You trekked across the deceptive Ash Dunes, and \
			paddled across the Sunlight Sea in a blessed vessel. There was great comfort in the caravan. Until one day, when a great ash storm rose up and drove \
			you from their warm embrace. Lost and alone, you set up this yurt and resolved to wait until your tribesmen could find you."
		if("hunter")
			flavour_text += "you have long bemoaned life in the Deep Veins. These ancient caverns have been home to your people since the beginning of time. \
			The farms have not been doing well these last few Storms. The Mother heaves and vomits her firey blood into passages which have been untouched \
			for centuries. The priests foretell an impending cataclysm, but such concerns are beyond you. With the farms failing, you and many others have been \
			sent to the surface, to find whatever game you may. So it is that you shelter in this yurt and rest before the next hunt."
		if("exile")
			flavour_text += "you had always imagined yourself a good steward. Loyal to the [pick("tribe", "caravan")], it came as a great shock to you and your \
			kinsmen when the priests declared you a sinner. For the crime of [pick("murder", "theft", "blasphemy")] you were cast out. Left with nothing but your \
			wits and your strength, you have long traversed this world alone. The brand on your chest marks you among all who may find you - Exile. This simple \
			yurt has become your latest haven. Rarely do others come across you here, a blessing, and a curse."
	to_chat(created, flavour_text)

/datum/antagonist/ashlander/equip(var/mob/living/carbon/human/player)
	var/datum/outfit/outfit = ..()
	switch(params["fluff"])
		if("nomad")
			outfit.uniform = /obj/item/clothing/under/tribal_tunic
			outfit.shoes = /obj/item/clothing/shoes/footwraps
			outfit.belt = /obj/item/material/knife/tacknife/combatknife/bone
			outfit.back = /obj/item/material/twohanded/spear/bone
		if("hunter")
			outfit.uniform = /obj/item/clothing/under/gladiator
			outfit.head = /obj/item/clothing/head/helmet/gladiator
			outfit.shoes = /obj/item/clothing/shoes/ashwalker
			outfit.back = /obj/item/gun/projectile/bow/ashen
			outfit.belt = /obj/item/storage/belt/quiver/full/ash
			outfit.r_hand = /obj/item/material/knife/tacknife/combatknife/bone
		if("exile")
			outfit.uniform = /obj/item/clothing/under/tribal_tunic
			outfit.belt = /obj/item/material/knife/tacknife/combatknife/bone
			outfit.back = /obj/item/kinetic_crusher/glaive/bone
	return 1
