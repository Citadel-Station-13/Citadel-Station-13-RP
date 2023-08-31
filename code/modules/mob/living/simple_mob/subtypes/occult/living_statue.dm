// A mob which only moves when it isn't being watched by living beings.

/mob/living/simple_mob/living_statue
	name = "statue"
	desc = "An incredibly lifelike marble carving. Its eyes seem to follow you.."
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_male"
	gender = NEUTER

	faction = list("statue")

	mob_class = MOB_CLASS_ABERRATION

	maxHealth = 200
	health = 200

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"

	harm_intent_damage = 10

	melee_damage_lower = 10
	melee_damage_upper = 18
	attacktext = list("clawed", "mauls")
	friendly = list("pats", "hugs")
	attack_sound = 'sound/hallucinations/growl1.ogg'

	taser_kill = 0

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0

	movement_cooldown = -100

	ai_holder_type = /datum/ai_holder/polaris/simple_mob/statue



//# Statue Subtypes

/mob/living/simple_mob/living_statue/female
	name = "statue"
	desc = "An incredibly lifelike marble carving. Its eyes seem to follow you.."
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_female"
	gender = NEUTER



//# Mob AI Code.

/datum/ai_holder/polaris/simple_mob/statue
	hostile = TRUE
	retaliate = FALSE
	cooperative = FALSE
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 0
	wander = FALSE



//# Mob Code.

/mob/living/simple_mob/living_statue/Initialize(mapload)
	. = ..()

	AddComponent(/datum/component/unobserved_actor, unobserved_flags = NO_OBSERVED_MOVEMENT | NO_OBSERVED_ATTACKS)
	ADD_TRAIT(src, TRAIT_UNOBSERVANT, INNATE_TRAIT)

	// Give spells
	add_spell(new/spell/aoe_turf/flicker_lights)
	add_spell(new/spell/aoe_turf/blindness)


//? Cannot talk
/mob/living/simple_mob/living_statue/say(whispering = FALSE)
	return FALSE


// Turn to dust when gibbed
/mob/living/simple_mob/living_statue/gib()
	dust()



//# Statue powers

/// Flicker lights AOE Spell
/spell/aoe_turf/flicker_lights
	name = "Flicker Lights"
	desc = "You will trigger a large amount of lights around you to flicker."

	override_base = "grey"
	hud_state = "blackout"

	cooldown_min = 1 MINUTE // Overkill but by request.
	charge_max = 300
	range = 14


/spell/aoe_turf/flicker_lights/choose_targets(mob/user = usr)
	var/list/things = list()
	var/turf/center = get_turf(user)
	for(var/obj/machinery/light/nearby_light in range(center, range))
		if(!nearby_light.on)
			continue

		things += nearby_light

	return things

/spell/aoe_turf/flicker_lights/cast(list/targets, mob/user = usr)
	for(var/obj/machinery/light/victim as anything in targets)
		victim.flicker()


/// Blind AOE Spell
/spell/aoe_turf/blindness
	name = "Blindness"
	desc = "Your prey will be momentarily blind for you to advance on them."

	override_base = "grey"
	hud_state = "wiz_blind"

	message = "<span class='notice'>You glare your eyes.</span>"

	cooldown_min = 2 MINUTE // Overkill but by request.
	range = 10

/spell/aoe_turf/blindness/choose_targets(mob/user = usr)
	var/list/things = list()
	var/turf/center = get_turf(user)
	for(var/mob/living/nearby_mob in range(center, range))
		if(nearby_mob == user || nearby_mob == center)
			continue

		things += nearby_mob

	return things


/spell/aoe_turf/blindness/cast(list/targets, mob/user = usr)
	for(var/mob/living/victim as anything in targets)
		victim.Blind(4)
