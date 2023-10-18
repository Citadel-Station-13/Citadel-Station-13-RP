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

	movement_cooldown = -5

	ai_holder_type = /datum/ai_holder/simple_mob/statue

/mob/living/simple_mob/living_statue/death()
	new /obj/item/ectoplasm (src.loc)
	new /obj/item/stack/material/marble (src.loc)
	..(null,"shatters into a pile of rubble.")
	ghostize()
	qdel(src)

//# Statue Subtypes

/mob/living/simple_mob/living_statue/female
	name = "statue"
	desc = "An incredibly lifelike marble carving. Its eyes seem to follow you.."
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_female"
	gender = NEUTER

//# Mob AI Code.

/datum/ai_holder/simple_mob/statue
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
	add_spell(new/spell/aoe_turf/veil_of_darkness)


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

/// Veil of Darkness Spell
/spell/aoe_turf/veil_of_darkness
	name = "Veil of Darkness"
	desc = "You sheathe yourself in a powerful veil of darkness."

	override_base = "grey"
	hud_state = "wiz_smoke"

	message = "<span class='notice'>You call upon the void.</span>"

	cooldown_min = 5 MINUTE


/spell/aoe_turf/veil_of_darkness/cast(list/targets, mob/user = usr)
	var/mob/living/simple_mob/living_statue/S = holder
	playsound(usr.loc, 'sound/effects/bamf.ogg', 50, 1, 5)
	S.add_modifier(/datum/modifier/veil_of_darkness, 3 SECONDS)

/datum/modifier/veil_of_darkness
	name = "Veil of Darkness"
	desc = "You pull upon the unreality of The Dark to mask your movements. The attempt is heavily taxing."
	mob_overlay_state = "purple_electricity_constant"

	on_created_text = "<span class='warning'>Your edges warp and dim!</span>"
	on_expired_text = "<span class='notice'>You are no longer shrouded in darkness.</span>"

/datum/modifier/veil_of_darkness/on_applied()
	holder.set_light(8, -10, "#FFFFFF")

/datum/modifier/veil_of_darkness/on_expire()
	holder.set_light(0)
