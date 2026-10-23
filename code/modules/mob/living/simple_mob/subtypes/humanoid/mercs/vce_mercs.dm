///////////////////////////////
//		VCE People
///////////////////////////////

/datum/category_item/catalogue/fauna/vce_people
	name = "Vacuum Crucis Civilian"
	desc = "The exploration of this expanse always brought some brave colonist, trying to make a live in the frontier\
	Here, people regrouped in the Roseline colonist fleet, to fend off pirates, altho, some actually try to settle down.\
	People come and go. People live, people leave, people arrive, people return, people make it big, other gets ruined, and people die.\
	And such is life here."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/vce_people)


/mob/living/simple_mob/humanoid/vce_people
	name = "random citizen"
	desc = "You should probably contact an admin something went wrong."
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "trader"
	icon_living = "trader"
	icon_dead = ""
	icon_gib = ""
	catalogue_data = list(/datum/category_item/catalogue/fauna/vce_people)

	movement_base_speed = 10 / 1
	minbodytemp = 200

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "punch"

	harm_intent_damage = 5
	legacy_melee_damage_lower = 15		//Tac Knife damage
	legacy_melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc
	say_list_type = /datum/say_list/vce/civi
	iff_factions = "neutral"


/mob/living/simple_mob/humanoid/vce_people/old
	name = "Old woman"
	desc = "A older woman living on the fleet."
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "oldwoman"
	icon_living = "oldwoman"


/mob/living/simple_mob/humanoid/vce_people/priest
	name = "Pioneer Priest"
	desc = "Faith must reach the far reach of the universe, so seeing a priest here isn't that weird."
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "priest"
	icon_living = "priest"


/mob/living/simple_mob/humanoid/vce_people/office
	name = "Frontier Bureaucrat"
	desc = "People must still work here. Even if its in offices."
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "office"
	icon_living = "office"

/mob/living/bot/medibot/vce_doctor
	name = "Fleet Doctor"
	desc = "Don't even try to get bedtime manners from him, since doctor are rare here, he is overworked."
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "doctor"
	vocal = FALSE

/mob/living/bot/medibot/vce_doctor/tundra
	name = "Colonist Doctor"
	desc = "That old guy is in complete automatic mode, partially senile, yet still giving first aid."
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "civ3"
	vocal = FALSE

/mob/living/simple_mob/humanoid/vce_people/mechanic
	name = "Fleet Mechanic"
	desc = "Well things break often here, he must be important."
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "mechanic"
	icon_living = "mechanic"

/mob/living/simple_mob/humanoid/vce_people/colonist
	name = "Colonist"
	desc = "Someday they are here, then try to settle down, only to return."
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "civ1"
	icon_living = "civ1"

/mob/living/simple_mob/humanoid/vce_people/colonist/two
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "civ2"
	icon_living = "civ2"

/mob/living/simple_mob/humanoid/vce_people/colonist/tree
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "civ3"
	icon_living = "civ3"

/mob/living/simple_mob/humanoid/vce_people/colonist/four
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "civ4"
	icon_living = "civ4"

/mob/living/simple_mob/humanoid/vce_people/colonist/five
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "civ5"
	icon_living = "civ5"

// MILITIA

/mob/living/simple_mob/humanoid/vce_people/militia
	name = "Militian"
	desc = "A soldier that keep the fleet secured."
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "militia1"
	icon_living = "militia1"
	icon_dead = ""
	icon_gib = ""
	catalogue_data = list(/datum/category_item/catalogue/fauna/vce_people)

	movement_base_speed = 10 / 1
	minbodytemp = 200

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "punch"

	harm_intent_damage = 5
	legacy_melee_damage_lower = 15		//Tac Knife damage
	legacy_melee_damage_upper = 15
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged
	say_list_type = /datum/say_list/vce/civi/militia
	iff_factions = "neutral"
	armor_legacy_mob = list(melee = 30, bullet = 20, laser = 20, energy = 5, bomb = 5, bio = 100, rad = 100)


/mob/living/simple_mob/humanoid/vce_people/militia/two
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "militia2"
	icon_living = "militia2"

/mob/living/simple_mob/humanoid/vce_people/militia/three
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "militia3"
	icon_living = "militia3"
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged
	projectiletype = /obj/projectile/beam/heavylaser
	projectilesound = 'sound/weapons/weaponsounds_laserstrong.ogg'

/mob/living/simple_mob/humanoid/vce_people/militia/four
	icon = 'icons/obj/vce_asset/vce_humanoid.dmi'
	icon_state = "militia4"
	icon_living = "militia4"
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/merc/ranged
	projectiletype = /obj/projectile/beam/heavylaser
	projectilesound = 'sound/weapons/weaponsounds_laserstrong.ogg'
