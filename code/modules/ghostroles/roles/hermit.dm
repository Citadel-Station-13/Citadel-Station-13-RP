/datum/role/ghostrole/hermit
	name = "Space Hermit"
	assigned_role = "Hermit"
	desc = "A stranded cryo-occupant in deep space."
	spawntext = "You've been late to awaken from your cryo slumber. Blasted machine, you set it to 10 days not 10 weeks!</span><b> Where have the others gone while we were out? Did they manage to survive?"
	instantiator = /datum/ghostrole_instantiator/human/random/hermit

/datum/role/ghostrole/hermit/Instantiate(client/C, atom/loc, list/params)
	var/rp = rand(1, 4)
	switch(rp)
		if(1)
			params["fluff"] = "proper"
		if(2)
			params["fluff"] = "tiger"
		if(3)
			params["fluff"] = "exile"
		if(4)
			params["fluff"] = "tourist"
	return ..()

/datum/role/ghostrole/hermit/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/flavour_text = "Each day you barely scrape by, and between the terrible conditions of your makeshift shelter, \
	the hostile creatures, and the relentless yawn of the cloudless skies, all you can wish for is the feel of soft grass between your toes and \
	the fresh air of Earth. These thoughts are dispelled by yet another recollection of how you got here..."
	switch(params["fluff"])
		if("proper")
			flavour_text += "you were a [pick("arms dealer", "shipwright", "docking manager")]'s assistant on a small trading station several sectors from here. Raiders attacked, and there was \
			only one pod left when you got to the escape bay. You took it and launched it alone, and the crowd of terrified faces peering through the airlock door as your pod's engines burst to \
			life and sent you to this hell are forever branded into your memory."
		if("tiger")
			flavour_text += "you're an exile from the Tiger Cooperative. Their technological fanaticism drove you to question the power and beliefs of the Exolitics, and they saw you as a \
			heretic and subjected you to hours of horrible torture. You were hours away from execution when a high-ranking friend of yours in the Cooperative managed to secure you a pod, \
			scrambled its destination's coordinates, and launched it. You awoke from stasis when you landed and have been surviving - barely - ever since."
		if("exile")
			flavour_text += "you were a doctor on one of Nanotrasen's space stations, but you left behind that damn corporation's tyranny and everything it stood for. From a metaphorical hell \
			to a literal one, you find yourself nonetheless missing the recycled air and warm floors of what you left behind...but you'd still rather be here than there."
		if("tourist")
			flavour_text += "you were always teased by your friends for \"not playing with a full deck\", as they so <i>kindly</i> put it. It seems that they were proven right when, on a tour \
			at one of Nanotrasen's state-of-the-art research facilities, you got lost and wound up trapping yourself in an escape pod. One of the larger red buttons caught your eye. You pressed \
			it, assuming it was a way to exit. You weren't entirely wrong. After a terrifying and fast ride for days, you landed here. \
			You've had time to wisen up since then, and you think that your old friends wouldn't be laughing now."
	to_chat(created, flavour_text)

/datum/ghostrole_instantiator/human/random/hermit
	// mob_traits = list(
	// 	TRAIT_EXEMPT_HEALTH_EVENTS
	// )

/datum/ghostrole_instantiator/human/random/hermit/GetOutfit(client/C, mob/M, list/params)
	var/datum/outfit/outfit = ..()
	switch(params["fluff"])
		if("proper")
			outfit.uniform = /obj/item/clothing/under/assistantformal
			outfit.shoes = /obj/item/clothing/shoes/black
			outfit.back = /obj/item/storage/backpack
		if("tiger")
			outfit.uniform = /obj/item/clothing/under/color/prison
			outfit.shoes = /obj/item/clothing/shoes/orange
			outfit.back = /obj/item/storage/backpack
		if("exile")
			outfit.uniform = /obj/item/clothing/under/rank/medical
			outfit.suit = /obj/item/clothing/suit/toggle/labcoat/paramedic
			outfit.back = /obj/item/storage/backpack/medic
			outfit.shoes = /obj/item/clothing/shoes/black
		if("tourist")
			outfit.uniform = /obj/item/clothing/under/color/grey
			outfit.shoes = /obj/item/clothing/shoes/black
			outfit.back = /obj/item/storage/backpack
	return outfit

//Malfunctioning cryostasis sleepers: Spawns in makeshift shelters in lavaland. Ghosts become hermits with knowledge of how they got to where they are now.
/obj/structure/ghost_role_spawner/hermit
	name = "malfunctioning cryostasis sleeper"
	desc = "A humming sleeper with a silhouetted occupant inside. Its stasis function is broken and it's likely being used as a bed."
	icon = 'icons/obj/spawners.dmi'
	icon_state = "cryostasis_sleeper"
	role_type = /datum/role/ghostrole/hermit
	qdel_on_deplete = TRUE

/obj/structure/ghost_role_spawner/hermit/Destroy()
	// new /obj/structure/fluff/empty_cryostasis_sleeper(get_turf(src))
	return ..()
