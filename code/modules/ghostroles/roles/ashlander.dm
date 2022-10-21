/datum/ghostrole/ashlander
	name = "Ashlander"
	assigned_role = "Ashlander"
	desc = "You are an Ashlander! An old and storied race of subterranean xenos."
	spawntext = "The nomadic Ashlanders are a neutral party. The Ashlander race (Scorian), is selected by default. If you accidentally swap, make sure to change it back. Ashlanders are all permadeath characters. They have gray skin of varying hues, red eyes, and - typically - white, black, or brown hair. These options are selectable through the appearance menu, directly below the race block, and above hairstyles. "
	important_info = "Your tribe still worships the Buried Ones. The wastes are sacred ground, its monsters a blessed bounty - your people have long farmed these creatures. From Goliaths you can harvest fresh meat and hardy leather, and you may breed them using Bentar seeds. Gutshank glands may be milked for water. You would never willingly leave your homeland behind. You have seen lights in the distance - falling from the heavens, and returning. They foreshadow the arrival of outsiders to your domain. Ensure your tribe remains protected at all costs."
	instantiator = /datum/ghostrole_instantiator/human/random/species/ashlander

/datum/ghostrole/ashlander/Instantiate(client/C, atom/loc, list/params)
	var/rp = rand(1, 4)
	switch(rp)
		if(1)
			params["fluff"] = "nomad"
		if(2)
			params["fluff"] = "hunter"
		if(3)
			params["fluff"] = "exile"
		if(4)
			params["fluff"] = "sentry"
	return ..()

/datum/ghostrole/ashlander/Greet(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	var/flavour_text = "<i>Fine particles of ash slip past the fluttering Goliath hide covering your doorway to settle on the floor of the yurt. \
	The hide is patched, and worn from years of use - it was gifted to you many Storms ago. Outside, the baking heat of the planet's surface \
	sends howling winds across your threshold. Leaning back against a pile of tanned hide, you peer upwards through the roof at the ever-scarlet \
	sky. Your mind drifts to how you came to be here...</i>"
	switch(params["fluff"])
		if("nomad")
			flavour_text += "<i>You served the caravan as a [pick("trader", "butcher", "shaman")], and much was the joy to be found in crossing the Mother's plains. \
			The caravan moved ever onwards, settling only when the skies were right and the omens favorable. You trekked across the deceptive Ash Dunes, and \
			paddled across the Sunlight Sea in a blessed vessel. There was great comfort in the caravan. Until one day, when a great ash storm rose up and drove \
			you from their warm embrace. Lost and alone, you set up this yurt and resolved to wait until your tribesmen could find you.</i>"
		if("hunter")
			flavour_text += "<i>You have long bemoaned life in the Deep Veins. These ancient caverns have been home to your people since the beginning of time. \
			The farms have not been doing well these last few Storms. The Mother heaves and vomits her firey blood into passages which have been untouched \
			for centuries. The priests foretell an impending cataclysm, but such concerns are beyond you. With the farms failing, you and many others have been \
			sent to the surface, to find whatever game you may. So it is that you shelter in this yurt and rest before the next hunt.</i>"
		if("exile")
			flavour_text += "<i>You had always imagined yourself a good steward. Loyal to the [pick("tribe", "caravan")], it came as a great shock to you and your \
			kinsmen when the priests declared you a sinner. For the crime of [pick("murder", "theft", "blasphemy")] you were cast out. Left with nothing but your \
			wits and your strength, you have long traversed this world alone. The brand on your chest marks you among all who may find you - Exile. This simple \
			yurt has become your latest haven. Rarely do others come across you here - a blessing, and a curse.</i>"
		if("sentry") //Credit to YourDoom for writing this one! <3
			flavour_text += "<i>You were one of the [pick("tribe", "caravan")]'s most reliable guards. It was your sacred duty to keep the Mother's \
			more dangerous children away from those you called family. However, the new threat of the Corrupted has thrown daily life into disarray. The priests \
			believe these abominations are the harbingers of an impending cataclysm - they were right. A twisted horde of Corrupted overwhelmed your post as \
			you slept. In the ensuing battle, a tunnel collapse separated you from your charges. Alone, you shelter in this yurt and wait for your kin to return.</i>"
	to_chat(created, flavour_text)

/datum/ghostrole_instantiator/human/random/species/ashlander
	possible_species = list(
		/datum/species/scori
	)

/datum/ghostrole_instantiator/human/random/species/ashlander/GetOutfit(client/C, mob/M, list/params)
	var/datum/outfit/outfit = ..()
	//var/mob/M = /mob/living/carbon/human/H
	M.faction = "lavaland"
	switch(params["fluff"])
		if("nomad")
			outfit.uniform = /obj/item/clothing/under/tribal_tunic/ashlander
			outfit.shoes = /obj/item/clothing/shoes/footwraps
			outfit.belt = /obj/item/material/knife/tacknife/combatknife/bone
			outfit.back = /obj/item/storage/backpack/satchel/bone
			outfit.r_hand = /obj/item/material/twohanded/spear/bone
		if("hunter")
			outfit.uniform = /obj/item/clothing/under/gladiator/ashlander
			outfit.head = /obj/item/clothing/head/helmet/gladiator/ashlander
			outfit.shoes = /obj/item/clothing/shoes/ashwalker
			outfit.back = /obj/item/gun/projectile/bow/ashen
			outfit.belt = /obj/item/storage/belt/quiver/full/ash
			outfit.r_hand = /obj/item/material/knife/tacknife/combatknife/bone
		if("exile")
			outfit.uniform = /obj/item/clothing/under/tribal_tunic/ashlander
			outfit.belt = /obj/item/material/knife/tacknife/combatknife/bone
			outfit.back = /obj/item/bo_staff
		if("sentry")
			outfit.uniform = /obj/item/clothing/under/gladiator/ashlander
			outfit.shoes = /obj/item/clothing/shoes/ashwalker
			outfit.belt = /obj/item/reagent_containers/glass/powder_horn/tribal
			outfit.back = /obj/item/storage/backpack/satchel/bone
			outfit.r_hand = /obj/item/gun/projectile/musket/tribal
			outfit.l_hand = /obj/item/storage/box/munition_box
	return outfit

/obj/structure/ghost_role_spawner/ashlander
	name = "ashlander yurt"
	desc = "A coarse leather tent. Squat and vaguely onion shaped, the thick red hide acting as a door covering flaps in the warm breeze. It seems like it could easily be dismantled and moved. A strange red icon shaped out of sinew and leather hangs over the doorway."
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "yurt"
	anchored = TRUE
	density = TRUE
	role_type = /datum/ghostrole/ashlander
	role_spawns = 1
	//var/datum/team/ashlanders/team

/*
/obj/structure/ghost_role_spawner/ashlander/Destroy()
	new /obj/structure/fluff/empty_cryostasis_sleeper(get_turf(src))
	return ..()

//This all appears to be /tg/ flavored stuff. Retaining in case we want to use it later.
	var/turf/T = get_turf(created)
	if(is_mining_level(T.z))
		to_chat(created, "<b>Drag the corpses of men and beasts to your yurt. The bounty may attract more of your tribe. Glory to the Buried Ones!</b>")
		to_chat(created, "<b>You can expand the weather proof area provided by your shelters by using the 'New Area' key near the bottom right of your HUD.</b>")
	else
		to_chat(created, "<span class='userdanger'>You have awoken outside of your natural home! Whether you decide to return below the surface, or make due with your current surroundings is your own decision.</span>")

/datum/ghostrole/ashlander/AllowSpawn(client/C, list/params)
	if(params && params["team"])
		var/datum/team/ashlanders/team = params["team"]
		if(C.ckey in team.players_spawned)
			to_chat(C, span_warning("<b>You have exhausted your usefulness to the tribe</b>."))
			return FALSE
	return ..()

/datum/ghostrole/ashlander/PostInstantiate(mob/created, datum/component/ghostrole_spawnpoint/spawnpoint, list/params)
	. = ..()
	if(params["team"])
		var/datum/team/ashlanders/team = spawnpoint.params["team"]
		team.players_spawned += ckey(created.key)
		created.mind.add_antag_datum(/datum/antagonist/ashlander, team)

/obj/structure/ghost_role_spawner/ashlander/Destroy()
	var/mob/living/carbon/human/yolk = new /mob/living/carbon/human/(get_turf(src))
	yolk.fully_replace_character_name(null,random_name(gender))
	yolk.set_species(/datum/species/human/ashlander)
	yolk.underwear = "Nude"
	yolk.equipOutfit(/datum/outfit/ashlander)//this is an authentic mess we're making
	yolk.update_body()
	yolk.gib()
	return ..()
*/
