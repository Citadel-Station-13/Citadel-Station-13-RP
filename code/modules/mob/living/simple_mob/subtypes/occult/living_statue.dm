// A mob which only moves when it isn't being watched by living beings.

/mob/living/simple_mob/living_statue
	name = "statue"
	desc = "An incredibly lifelike marble carving. Its eyes seem to follow you.."
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_male"
	gender = NEUTER
	catalogue_data = list()
	var/cannot_be_seen = 1
	var/mob/living/creator = null

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
	attacktext = list("clawed")
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

	movement_cooldown = -1

	ai_holder_type = /datum/ai_holder/simple_mob/statue

//Mob AI Code.
/datum/ai_holder/simple_mob/statue
	hostile = TRUE
	retaliate = FALSE
	cooperative = FALSE
	returns_home = FALSE
	can_flee = FALSE
	speak_chance = 0
	wander = FALSE

/*
/datum/ai_holder/simple_mob/statue/walk_to_destination()
	. = ..()
	var/turf/T = get_turf(src)
	if(T && destination && T.lighting_overlay)
		if(T.get_lumcount()<0.1 && destination.get_lumcount()<0.1) // No one can see us in the darkness, right?
			return null
		if(T == destination)
			destination = null

/datum/ai_holder/simple_mob/statue/can_attack(atom/movable/the_target)
	. = ..()
	var/turf/T = get_turf(src)
	if(T.get_lumcount()<0.1)
		if(isliving(the_target))
			var/mob/living/L = the_target
			if(!L.client && !L.ckey)
				return 0
		else
			return 1
	else
		return ..()
*/

// No movement while seen code.

/mob/living/simple_mob/living_statue/Initialize(mapload, var/mob/living/creator)
	. = ..()
	// Give spells
	//src.add_spell(/spell/noclothes)
	//src.add_spell(/spell/aoe_turf/flicker_lights)
	//src.add_spell(/spell/aoe_turf/blindness)

	// Set creator
	if(creator)
		src.creator = creator

/mob/living/simple_mob/living_statue/Move(turf/NewLoc)
	if(can_be_seen(NewLoc))
		if(client)
			to_chat(src, "<span class='warning'>You cannot move, there are eyes on you!</span>")
		return 0
	return ..()

/mob/living/simple_mob/living_statue/attack_target()
	if(can_be_seen(get_turf(loc)))
		if(client)
			to_chat(src, "<span class='warning'>You cannot attack, there are eyes on you!</span>")
		return FALSE
	else
		return ..()

/mob/living/simple_mob/living_statue/face_atom()
	if(!can_be_seen(get_turf(loc)))
		..()

/mob/living/simple_mob/living_statue/proc/can_be_seen(turf/destination)
	if(!cannot_be_seen)
		return null
	// Check for darkness
	var/turf/T = get_turf(loc)
	if(T && destination && T.lighting_overlay)
		if(T.get_lumcount()<0.1 && destination.get_lumcount()<0.1) // No one can see us in the darkness, right?
			return null
		if(T == destination)
			destination = null

	// We aren't in darkness, loop for viewers.
	var/list/check_list = list(src)
	if(destination)
		check_list += destination

	// This loop will, at most, loop twice.
	for(var/atom/check in check_list)
		for(var/mob/living/M in viewers(world.view + 1, check) - src)
			if(M.client && CanAttack(M) && !M.silicon_privileges)
				if(!M.eye_blind)
					return M
	return null

// Cannot talk

/mob/living/simple_mob/living_statue/say(whispering = 0)
	return 0

// Turn to dust when gibbed

/mob/living/simple_mob/living_statue/gib()
	dust()

// Stop attacking clientless mobs

/mob/living/simple_mob/living_statue/proc/CanAttack(atom/the_target)
	if(isliving(the_target))
		var/mob/living/L = the_target
		if(!L.client && !L.ckey)
			return 0
	return

/*
// Don't attack your creator if there is one

/mob/living/simple_mob/living_statue/proc/ListTargets()
	return . - creator

// Statue powers

// Flicker lights
/spell/aoe_turf/flicker_lights
	name = "Flicker Lights"
	desc = "You will trigger a large amount of lights around you to flicker."

	charge_max = 300
	range = 14

/spell/aoe_turf/flicker_lights/cast(list/targets,mob/user = usr)
	for(var/turf/T in targets)
		for(var/obj/machinery/light/L in T)
			L.flicker()
	return

//Blind AOE
/spell/aoe_turf/blindness
	name = "Blindness"
	desc = "Your prey will be momentarily blind for you to advance on them."

	message = "<span class='notice'>You glare your eyes.</span>"
	range = 10

/spell/aoe_turf/blindness/cast(list/targets,mob/user = usr)
	for(var/mob/living/L)
		var/turf/T = get_turf(L.loc)
		if(T && (T in targets))
			L.Blind(4)
	return
*/

/mob/living/simple_mob/living_statue/female
	name = "statue"
	desc = "An incredibly lifelike marble carving. Its eyes seem to follow you.."
	icon = 'icons/obj/statue.dmi'
	icon_state = "human_female"
	gender = NEUTER
