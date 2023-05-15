/obj/structure/hierophant_shrine
	name = "hierophant's altar"
	desc = "A massive staff holding itself aloft. It seems to call out to you."
	#warn icon, state

	/// tile radius from center
	var/arena_size = 15
	/// how harsh we are when people die
	var/level_of_violence = HIEROPHANT_VIOLENCE_TRIAL
	/// difficulty multiplier
	var/difficulty = 1

/obj/structure/hierophant_shrine/attack_hand(mob/user, list/params)
	. = ..()
	#warn impl

/obj/structure/hierophant_shrine/proc/activation(mob/user)
	#warn impl

/obj/structure/hierophant_shrine/proc/engage()
	#warn animations

	// arena turf
	var/turf/arena_center = get_turf(src)
	// spawn boss
	var/mob/living/simple_mob/boss/hierophant/the_hierophant = new(arena_center)
	// suspend - prelude will handle it
	the_hierophant.ai_holder.suspend()
	// spawn arena
	the_hierophant.vortex.box_arena(arena_center, arena_size)
	// gather contestants
	var/list/mob/gamers = list()
	for(var/mob/M in orange(arena_size, arena_center))
		gamers += M
	// engage!
	var/datum/ai_holder/special/hierophant/boss_ai = the_hierophant.ai_holder
	boss_ai.difficulty = difficulty
	boss_ai.prelude(gamers)

	#warn impl

/obj/structure/hierophant_shrine/proc/
