/datum/role/ghostrole/pirate
	name = "Pirate"
	assigned_role = "Pirate"
	desc = "You are a pirate! A legendary, if oft maligned, profession."
	spawntext = "There are countless roving gangs of pirates across the Frontier. A constant menace to honest traders and Corporate convoys alike, pirates are part of a never ending conflict with local SDF and private security forces from system to system."
	important_info = "You are a member of a pirate crew. You pillage, kidnap, and steal for profit and pleasure. Although you recently moved into this system, it is owned by NanoTrasen. A Corporate presence provides plenty of opportunities for plunder, but beware! Certain areas are considered off limits, even to pirates. Only a fool would anger Nebula Gas by raiding their station, although NebGas vessels in transit are fair game. Attempting to visit NanoTrasen's primary facility is equally dangerous and ill-advised. Focusing on isolated vessels in flight or expeditions on planets may be the most reliable way to score precious booty. Proteans and Xenochimerae are currently excluded from being Pirates, if you own either Whitelist."
	instantiator = /datum/ghostrole_instantiator/human/random/species/pirate

/datum/role/ghostrole/pirate/Instantiate(client/C, atom/loc, list/params)
	var/rp = rand(1, 3)
	switch(rp)
		if(1)
			params["fluff"] = "immigrant"
		if(2)
			params["fluff"] = "dilettante"
		if(3)
			params["fluff"] = "professional"
	return ..()

/datum/role/ghostrole/pirate/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/flavour_text = "<i>The sound of something dripping on the top of your bunk unit wakes you up. Spears of light shine in through old \
	bullet holes. The unit's door slides back with the push of a button, letting stale recycled air rush out. A yellowed poster on the wall \
	flutters momentarily in the artificial breeze. You climb out of the unit and stand up. Just another day in paradise, right? As you look \
	over your rusty bunk, your mind drifts to how you came to be here...</i>"
	switch(params["fluff"])
		if("immigrant")
			flavour_text += "<i>You came to the Frontier seeking riches and success, just like in all the films and games. Unfortunately, you quickly learned \
			that the Corporations weren't interested in your talents as a [pick("line cook","security guard","fashion model","actor","veterinarian","competitive VR-athlete","laborer")]. \
			Unfortunately, you were so convinced that you could make it that you only bought a one-way ticket. Without any way to afford the basic necessities of life, \
			you quickly fell in with a bad crowd. Whether you're still with that same band of pirates or not, adjusting to your new life has been difficult.</i>"
		if("dilettante")
			flavour_text += "<i>You've never been afraid of rough trade. Whenever needs have risen and there's no honest work to be had, you've been happy to be \
			less than honest. Unfortunately, this tendency to bend the rules of polite society has resulted in much persecution from the stodgier elements of the \
			law. You came out to the Frontier for one simple reason: no extradition. Even then, your history has had a way of haunting you, but that's alright. \
			This band of misfits has been more than welcoming, and they never even thought of running a background check. Whether these pirates are the same band \
			that you first started out with or not, one thing's for sure: the trade is as rough as ever, but it pays much better.</i>"
		if("professional")
			flavour_text += "<i>You always knew what you wanted to be in life, from the first time you heard a swashbuckling adventure story. You dedicated your life \
			to it. Sure, your time in [pick("the SDF","merchant security","corporate security")] wasn't so bad, but you never planned on staying. You were just there to \
			learn the skills that you still use to this day. Some people join an outfit for necessity's sake, or because they think they're hard. Tourists. You're here \
			because you were born to be here, whether this is the band you started out with or not doesn't matter. All that matters to you is the job.</i>"
	to_chat(created, flavour_text)

/datum/ghostrole_instantiator/human/random/species/pirate
	possible_species = list(
		/datum/species/human
	)

/datum/ghostrole_instantiator/human/random/species/pirate/GetOutfit(client/C, mob/M, list/params)
	var/datum/outfit/outfit = ..()
	//var/mob/M = /mob/living/carbon/human/H
	M.faction = "pirate"
	switch(params["fluff"])
		if("immigrant")
			return /datum/outfit/pirate/immigrant
		if("dilettante")
			return /datum/outfit/pirate/dilettante
		if("professional")
			return /datum/outfit/pirate/professional
	return outfit

/obj/structure/ghost_role_spawner/pirate
	name = "pirate bunk"
	desc = "An aged personal bunk unit. Prized in communal living areas for their enclosed nature, units like this can be locked from the inside and outside, allowing the relatively safe storage of personal effects."
	icon = 'icons/obj/structures.dmi'
	icon_state = "piratebunk"
	anchored = TRUE
	density = TRUE
	role_type = /datum/role/ghostrole/pirate
	role_spawns = 1

//This is from the original untranslated DM. It still isn't translated, but this is neat and maybe we should use it sometime? It seems worth retaining for now.
/*
/obj/structure/ghost_role_spawner/pirate
	name = "space pirate sleeper"
	desc = "A cryo sleeper smelling faintly of rum. The sleeper looks unstable. <i>Perhaps the pirate within can be killed with the right tools...</i>"
	icon = 'icons/obj/machines/sleeper.dmi'
	icon_state = "sleeper"
	role_type = /datum/role/ghostrole/pirate
	role_params = list(
		"rank" = "Mate"
	)

/obj/structure/ghost_role_spawner/pirate/on_attack_hand(mob/living/user, act_intent = user.a_intent, unarmed_attack_flags)
	. = ..()
	if(.)
		return
	if(user.mind.has_antag_datum(/datum/antagonist/pirate))
		to_chat(user, "<span class='notice'>Your shipmate sails within their dreams for now. Perhaps they may wake up eventually.</span>")
	else
		to_chat(user, "<span class='notice'>If you want to kill the pirate off, something to pry open the sleeper might be the best way to do it.</span>")

/obj/structure/ghost_role_spawner/pirate/attackby(obj/item/W, mob/user, params)
	if(W.tool_behaviour == TOOL_CROWBAR && user.a_intent != INTENT_HARM)
		if(user.mind.has_antag_datum(/datum/antagonist/pirate))
			to_chat(user,"<span class='warning'>Why would you want to do that to your shipmate? That'd kill them.</span>")
			return
		user.visible_message("<span class='warning'>[user] start to pry open [src]...</span>",
				"<span class='notice'>You start to pry open [src]...</span>",
				"<span class='italics'>You hear prying...</span>")
		W.play_tool_sound(src)
		if(do_after(user, 100*W.tool_speed, target = src))
			user.visible_message("<span class='warning'>[user] pries open [src], disrupting the sleep of the pirate within and killing them.</span>",
				"<span class='notice'>You pry open [src], disrupting the sleep of the pirate within and killing them.</span>",
				"<span class='italics'>You hear prying, followed by the death rattling of bones.</span>")
			log_game("[key_name(user)] has successfully pried open [src] and disabled a space pirate spawner.")
			W.play_tool_sound(src)
			playsound(src.loc, 'modular_citadel/sound/voice/scream_skeleton.ogg', 50, 1, 4, 1.2)
			if(role_params["rank"] == "Captain")
				new /obj/effect/mob_spawn/human/pirate/corpse/captain(get_turf(src))
			else
				new /obj/effect/mob_spawn/human/pirate/corpse(get_turf(src))
			qdel(src)
	else
		..()

/obj/effect/mob_spawn/human/pirate
	mob_species = /datum/species/skeleton/space
	outfit = /datum/outfit/pirate/space

/obj/effect/mob_spawn/human/pirate/corpse //occurs when someone pries a pirate out of their sleeper.
	mob_name = "Dead Space Pirate"
	death = TRUE
	instant = TRUE
	random = FALSE

/obj/effect/mob_spawn/human/pirate/corpse/captain
	mob_name = "Dead Space Pirate Captain"
	outfit = /datum/outfit/pirate/space/captain

/obj/structure/ghost_role_spawner/pirate/Destroy()
	new /obj/structure/showcase/machinery/oldpod/used(drop_location())
	return ..()

/obj/structure/ghost_role_spawner/pirate/captain
	role_params = list(
		"rank" = "Captain"
	)

/obj/structure/ghost_role_spawner/pirate/gunner
	role_params = list(
		"rank" = "Gunner"
	)
*/
