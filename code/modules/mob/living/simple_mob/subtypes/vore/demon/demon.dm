/datum/vision/baseline/demon
	hard_darksight = 0

/mob/living/simple_mob/vore/demon
	name = "Rift Walker"
	desc = "A large bipedal creature, body a mix of dark fur and scales. Marks on the creatures body pulse slowly with red light"

	icon_state = "boxfox"
	icon_living = "boxfox"
	icon_dead = "boxfox_dead"
	icon_rest = "boxfox_rest"
	icon = 'icons/mob/demon_vr.dmi'

	iff_factions = MOB_IFF_FACTION_SANGUINE_CULT

	maxHealth = 300
	health = 300
	movement_base_speed = 6.66

	vision_innate = /datum/vision/baseline/demon

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0
	minbodytemp = 0
	maxbodytemp = INFINITY

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"

	legacy_melee_damage_lower = 10
	legacy_melee_damage_upper = 20
	attacktext = list("clawed")


	var/shifted_out = FALSE
	var/shift_state = AB_SHIFT_NONE
	var/last_shift = 0
	var/is_shifting = FALSE

/mob/living/simple_mob/vore/demon/UnarmedAttack()
	if(shifted_out)
		return FALSE

	. = ..()

/mob/living/simple_mob/vore/demon/can_fall()
	if(shifted_out)
		return FALSE

	return ..()

/mob/living/simple_mob/vore/demon/zMove(direction)
	if(shifted_out)
		var/turf/destination = get_vertical_step(src, direction)
		if(destination)
			forceMove(destination)
		return TRUE

	return ..()

/mob/living/simple_mob/vore/demon/Life(seconds, times_fired)
	if((. = ..()))
		return

	if(shifted_out)
		density = FALSE

/mob/living/simple_mob/vore/demon/handle_atmos()
	if(shifted_out)
		return
	else
		return .=..()

// todo: better way
/mob/living/simple_mob/vore/demon/update_mobility()
	if(is_shifting)
		return (mobility_flags = MOBILITY_CAN_MOVE)
	return ..()
