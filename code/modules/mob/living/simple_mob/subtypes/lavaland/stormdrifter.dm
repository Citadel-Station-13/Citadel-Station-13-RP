//Stormdrifters
/datum/category_item/catalogue/fauna/stormdrifter/stormdrifters
	name = "Stormdrifters"
	desc = "Stormdrifters are a rare sight on the surface of Surt. Where for other native fauna this may have \
	been true due to their subterranean lifestyle, Stormdrifters exist on the opposite side of the spectrum. These \
	floating creatures are typically found in the lower atmosphere of Surt. Travelling in pods of hundreds, Stormdrifters \
	were so named due to their tendency to get caught up in ash storms, which might carry them for hundreds to thousands of \
	miles before dropping them nearby. The arrival of a pod of Stormdrifters is often considered an omen of especially bad \
	weather. Rarely, these creatures may drift down closer to Surt's surface, where Ashlanders will eagerly capture them for \
	unknown purposes."
	value = CATALOGUER_REWARD_TRIVIAL
	unlocked_by_any = list(/datum/category_item/catalogue/fauna/stormdrifter)

/datum/category_item/catalogue/fauna/all_stormdrifters
	name = "Collection - Stormdrifters"
	desc = "You have scanned all known variants of Stormdrifter, \
	and therefore you have been granted a fair sum of points, through this \
	entry."
	value = CATALOGUER_REWARD_MEDIUM
	unlocked_by_all = list(
		/datum/category_item/catalogue/fauna/stormdrifter,
		/datum/category_item/catalogue/fauna/stormdrifter/bull
		)

//Netches! (Expand on this later with more detail.)

/datum/category_item/catalogue/fauna/stormdrifter
	name = "Stormdrifter Polyp"
	desc = "The common Stormdrifter is passive. If provoked, this creature is able to attack with the tendrils which dangle \
	below its body. In a mechanism vaguely similar to Old Earth jellyfish, these tendrils pass on a debilitating pulse of electricity \
	which scrambles the motor control of their assailant. Stormdrifters are very rarely seen being cultivated by Ashlanders, leading \
	to speculation that the Scori may be experimenting with air travel."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/stormdrifter
	name = "stormdrifter polyp"
	desc = "These curious entities are able to fly thanks to the gaseous bags which comprise most of their body. They are generally passive, unless threatened."
	icon = 'icons/mob/lavaland/lavaland_mobs.dmi'
	icon_state = "stormdrifter"
	icon_living = "stormdrifter"
	icon_dead = "stormdrifter_dead"
	icon_gib = "syndicate_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/stormdrifter)

	maxHealth = 100
	health = 100
	min_oxy = 0
	min_co2 = 5
	max_co2 = 0
	minbodytemp = 0
	maxbodytemp = 700
	heat_resist = 1
	hovering = TRUE
	softfall = TRUE
	parachuting = TRUE

	mob_class = MOB_CLASS_ANIMAL
	taser_kill = FALSE
	movement_cooldown = 5
	melee_damage_lower = 8
	melee_damage_upper = 12
	attacktext = list ("lashed", "whipped", "stung")
	attack_sound = 'sound/weapons/towelwhip.ogg'

	exotic_type = /obj/item/elderstone
	meat_amount = 0
	bone_amount = 0
	exotic_amount = 1

	faction = "lavaland"
	speak_emote = list("rumbles")
	say_list_type = /datum/say_list/stormdrifter
	ai_holder_type = /datum/ai_holder/simple_mob/stormdrifter

/datum/say_list/stormdrifter
	emote_hear = list("drifts back and forth.", "gently flails its tendrils about.", "warbles.")
	emote_see = list ("wriggles its tendrils.", "bobs up and down.")

/datum/ai_holder/simple_mob/stormdrifter
	hostile = FALSE
	retaliate = TRUE
	can_flee = TRUE

/mob/living/simple_mob/animal/stormdrifter/apply_melee_effects(atom/A)
	. = ..()
	if(isliving(A))
		var/mob/living/L = A
		L.adjustHalLoss(10)
		to_chat(L, SPAN_DANGER("\The [src] strikes you with a crackling tendril!"))
		playsound(L, 'sound/effects/sparks6.ogg', 75, 1)

//Stormdrifter Bulls!
/datum/category_item/catalogue/fauna/stormdrifter/bull
	name = "Stormdrifter Bull"
	desc = "The hide of a Stormdrifter Bull is much thicker than that of a Polyp. Bulls also possess significantly \
	better developed tendrils. These two factors alone make the Bull a far more formidable opponnent than the simple Polyp. \
	However, Bulls are also far more territorial and aggressive than Polyps, and will attack to protect any threat to the pod, \
	real or perceived."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/animal/stormdrifter/bull
	name = "stormdrifter bull"
	desc = "Unlike the more passive Polyp, Stormdrifter Bulls are hardy and formidable. Fiercely territorial, Bulls will aggressively protect Stormdrifter pods."
	icon_state = "bulldrifter"
	icon_living = "bulldrifter"
	icon_dead = "bulldrifter_dead"
	catalogue_data = list(/datum/category_item/catalogue/fauna/stormdrifter/bull)

	maxHealth = 200
	health = 200

	movement_cooldown = 5
	melee_damage_lower = 10
	melee_damage_upper = 15
	attack_sound = 'sound/weapons/punch2.ogg'

	exotic_type = /obj/item/stack/sinew
	exotic_amount = 5

	ai_holder_type = /datum/ai_holder/simple_mob/stormdrifter/bull

/datum/ai_holder/simple_mob/stormdrifter/bull
	hostile = TRUE
	cooperative = TRUE
	can_flee = FALSE
