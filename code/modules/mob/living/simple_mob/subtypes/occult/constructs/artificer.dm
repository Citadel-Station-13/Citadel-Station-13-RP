////////////////////////////
//		Artificer
////////////////////////////

/datum/category_item/catalogue/fauna/construct/artificer
	name = "Constructs - Artificer"
	desc = "Artificers appear to function as a kind of builder class \
	amongst Constructs. Able to repair their peers and form fortifications, \
	Artificers are a secondary target. In spite of their specialization, \
	as with all Constructs the Artificer is deadly in close combat and \
	should be kept at range."
	value = CATALOGUER_REWARD_EASY

/mob/living/simple_mob/construct/artificer
	name = "Artificer"
	real_name = "Artificer"
	construct_type = "artificer"
	desc = "A bulbous construct dedicated to building and maintaining temples to their otherworldly lords."
	icon_state = "artificer"
	icon_living = "artificer"
	maxHealth = 100
	health = 100
	response_harm = "viciously beaten"
	harm_intent_damage = 5
	melee_damage_lower = 15 //It's not the strongest of the bunch, but that doesn't mean it can't hurt you.
	melee_damage_upper = 20
	attacktext = list("rammed")
	attack_sound = 'sound/weapons/rapidslice.ogg'
	construct_spells = list(/spell/aoe_turf/conjure/construct/lesser,
							/spell/aoe_turf/conjure/wall,
							/spell/aoe_turf/conjure/floor,
							/spell/aoe_turf/conjure/soulstone,
							/spell/aoe_turf/conjure/pylon,
							/spell/aoe_turf/conjure/door,
							/spell/aoe_turf/conjure/grille,
							/spell/targeted/occult_repair_aura,
							/spell/targeted/construct_advanced/mend_acolyte
							)

	catalogue_data = list(/datum/category_item/catalogue/fauna/construct/artificer)

	ai_holder_type = /datum/ai_holder/mimic

/mob/living/simple_mob/construct/artificer/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura)

////////////////////////////
//		Ranged Artificer
////////////////////////////

/mob/living/simple_mob/construct/artificer/caster
	name = "Artificer"
	real_name = "Artificer"
	construct_type = "artificer"
	desc = "A bulbous construct dedicated to building and maintaining temples to their otherworldly lords. Its central eye glows with unknowable power."
	icon_state = "caster_artificer"
	icon_living = "caster_artificer"
	ai_holder_type = /datum/ai_holder/simple_mob/ranged/kiting
	projectiletype = /obj/item/projectile/beam/inversion
	projectilesound = 'sound/weapons/spiderlunge.ogg'
