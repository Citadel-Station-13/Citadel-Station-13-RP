/turf/simulated/open/skyplanet
	name = "the sky"
	desc = "It's the sky! Be careful!"
	icon = 'icons/turf/sky.dmi'
	icon_state = "sky"
	color = "#ffda85"
	edge_blending_priority = 0.5

//mobs

/datum/category_item/catalogue/fauna/cultist/mad
	name = "Cultists - Lost"
	desc = "Understanding the mind of such fellow of cults is a fascinating, yet hard research. \
	Many tried, many failed, some saw success, other gave up. \
	Studying madness may make some mad themself."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/humanoid/cultist/mad
	name = "Crazed Intiate"
	desc = "A Novice Amongst his betters, and the victim of experiment, he seems to have fully embraced his faith, and let all logic leave is mind. He is hurt."
	icon_state = "initiate"
	icon_living = "initiate"
	maxHealth = 50
	health = 50
	catalogue_data = list(/datum/category_item/catalogue/fauna/cultist/mad)

	status_flags = 0

	response_help = "pokes"
	response_disarm = "shoves"
	response_harm = "hits"

	harm_intent_damage = 5
	legacy_melee_damage_lower = 25	//Ritual Knife
	legacy_melee_damage_upper = 25
	attack_sharp = 1
	attack_edge = 1
	attacktext = list("slashed", "stabbed")
	armor_legacy_mob = list(melee = 50, bullet = 30, laser = 50, energy = 80, bomb = 25, bio = 100, rad = 100)	//Armor Rebalanced for Cult Robes.
	attack_sound = 'sound/weapons/rapidslice.ogg'
	movement_cooldown = 4

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee

	say_list_type = /datum/say_list/madcultist


/datum/say_list/madcultist
	speak = list(
		"I AM FINE. I AM NOT MAD. YOU ARE MAD. YOU SHALL DIE.",
		"I PRAYED. HE RESPONDED. HE MADE YOU CRASH. HE LOVES ME.",
		"I WILL BE ONE WITH HIM."
		)

/mob/living/simple_mob/humanoid/cultist/mad/death()
	new /obj/effect/decal/remains/human (src.loc)
	..(null,"lets out a horrified scream of pleasure as his body crumbles away. He will finaly be released.")
	ghostize()
	qdel(src)

//Dragoon

/datum/category_item/catalogue/fauna/dragoon/green
	name = "Creature - Green dragoon"
	desc = "A flying beast, with smooth scales, that shines a bit. \
	It got flat teeths, eats mushrooms, and seems to be flying with powerfull wings. \
	They live above the cloud level, in caves. Green Dragoon are passive."
	value = CATALOGUER_REWARD_MEDIUM

/datum/category_item/catalogue/fauna/dragoon/blue
	name = "Creature - Blue dragoon"
	desc = "A flying beast, with smooth scales, that shines a bit. \
	It got sharpened teeths, and seems to be flying with powerfull wings. \
	They live above the cloud level, in caves, and often hunt for food."
	value = CATALOGUER_REWARD_MEDIUM

/datum/category_item/catalogue/fauna/dragoon/yellow
	name = "Creature - Yellow dragoon"
	desc = "A flying beast, with smooth scales, that shines a bit. \
	It got sharpened teeths, and seems to be flying with powerfull wings. \
	They live above the cloud level, but also get down to the grounds. They are able to drink acid."
	value = CATALOGUER_REWARD_HARD

/datum/category_item/catalogue/fauna/dragoon/red
	name = "Creature - Red dragoon"
	desc = "A flying beast, with smooth scales, that shines a bit. \
	It got sharpened teeths, and seems to be flying with powerfull wings. \
	They live above the cloud level, but also get down to the grounds. \
	They are able to drink acid, and are highly dangerous."
	value = CATALOGUER_REWARD_SUPERHARD


/mob/living/simple_mob/aggressive/dragoon
	name = "Green dragoon"
	desc = "A flying lizard, quite fast, thats fly aboves cloud."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dragoon/green)

	icon_living = "green-dragoon"
	icon_state = "green-dragoon"
	icon = 'icons/mob/64x64.dmi'

	attacktext = list("mauled")

	iff_factions = MOB_IFF_FACTION_MUTANT

	maxHealth = 100
	health = 100

	response_help  = "pets"
	response_disarm = "gently moves aside"
	response_harm   = "swats"

	meat_amount = 1
	bone_amount = 1

	hovering = TRUE
	softfall = TRUE
	parachuting = TRUE
	movement_cooldown = 0

	legacy_melee_damage_lower = 5
	legacy_melee_damage_upper = 5

	base_pixel_x = -16

	randomized = TRUE
	mod_min = 90
	mod_max = 140

//BLUE DRAGOON

/mob/living/simple_mob/aggressive/dragoon/blue
	name = "Blue dragoon"
	desc = "A flying lizard, quite fast, thats fly aboves cloud. Sharpen teeths are visible."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dragoon/blue)

	icon_living = "blue-dragoon"
	icon_state = "blue-dragoon"
	icon = 'icons/mob/64x64.dmi'

	attacktext = list("mauled")

	iff_factions = MOB_IFF_FACTION_MUTANT

	maxHealth = 100
	health = 100

	meat_amount = 1
	bone_amount = 1

	hovering = TRUE
	softfall = TRUE
	parachuting = TRUE
	movement_cooldown = 0

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10

	base_pixel_x = -16

	randomized = TRUE
	mod_min = 90
	mod_max = 140

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/melee/dragoon/blue

// Activate Noms!
/datum/ai_holder/polaris/simple_mob/melee/dragoon/blue
	can_breakthrough = TRUE
	violent_breakthrough = TRUE

// YELLOW DRAGOON

/mob/living/simple_mob/aggressive/dragoon/yellow
	name = "Yellow dragoon"
	desc = "A flying lizard, quite fast, thats fly aboves cloud. Sharpen teeths are visible. This one had also hard scales on its back."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dragoon/yellow)

	icon_living = "yellow-dragoon"
	icon_state = "yellow-dragoon"
	icon = 'icons/mob/64x64.dmi'

	attacktext = list("mauled")

	iff_factions = MOB_IFF_FACTION_MUTANT

	maxHealth = 200
	health = 200

	meat_amount = 1
	bone_amount = 1

	hovering = TRUE
	softfall = TRUE
	parachuting = TRUE
	movement_cooldown = 0

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10

	base_pixel_x = -16

	randomized = TRUE
	mod_min = 90
	mod_max = 140

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/dragoon/yellow

	projectiletype = /obj/projectile/energy/acid
	base_attack_cooldown = 12
	projectilesound = 'sound/effects/splat.ogg'
	attack_sound = 'sound/mobs/biomorphs/spitter_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/spitter_move.ogg'

// Activate Noms!
/datum/ai_holder/polaris/simple_mob/ranged/dragoon/yellow
	can_breakthrough = TRUE
	violent_breakthrough = TRUE
	pointblank = TRUE
	firing_lanes = TRUE
	conserve_ammo = TRUE

//Red Dragoon

/mob/living/simple_mob/aggressive/dragoon/red
	name = "Red dragoon"
	desc = "A flying lizard, quite fast, thats fly aboves cloud. Sharpen teeths are visible. This one had also hard scales on its back."
	catalogue_data = list(/datum/category_item/catalogue/fauna/dragoon/red)

	icon_living = "red-dragoon"
	icon_state = "red-dragoon"
	icon = 'icons/mob/64x64.dmi'

	attacktext = list("mauled")

	iff_factions = MOB_IFF_FACTION_MUTANT

	maxHealth = 300
	health = 300

	meat_amount = 1
	bone_amount = 1

	hovering = TRUE
	softfall = TRUE
	parachuting = TRUE
	movement_cooldown = 0

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 10

	base_pixel_x = -16

	randomized = TRUE
	mod_min = 90
	mod_max = 140

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/ranged/dragoon/yellow

	projectiletype = /obj/projectile/energy/plasmastun
	base_attack_cooldown = 12
	projectilesound = 'sound/effects/splat.ogg'
	attack_sound = 'sound/mobs/biomorphs/spitter_attack.ogg'
	movement_sound = 'sound/mobs/biomorphs/spitter_move.ogg'
