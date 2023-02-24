/atom/proc/singularity_act(obj/singularity/S, current_size)
	return

/atom/proc/singularity_pull(obj/singularity/S, current_size)
	return

/mob/living/singularity_act()
	investigate_log("has been consumed by a singularity", INVESTIGATE_SINGULO)
	gib()
	return 20

/mob/living/singularity_pull(S, current_size)
	step_towards(src, S)

/mob/living/carbon/human/singularity_act()
	var/gain = 20
	if(mind)
		if((mind.assigned_role == "Station Engineer") || (mind.assigned_role == "Chief Engineer"))
			gain = 100
		if(mind.assigned_role == USELESS_JOB)
			gain = rand(0, 300)
	investigate_log(INVESTIGATE_SINGULO,"has been consumed by a singularity", INVESTIGATE_SINGULO)
	gib()
	return gain

/mob/living/carbon/human/singularity_pull(S, current_size)
	if(current_size >= STAGE_THREE)
		for(var/obj/item/hand in get_held_items())
			if(prob(current_size*5) && hand.w_class >= ((11-current_size)/2) && drop_item_to_ground(hand))
				step_towards(hand, S)
				to_chat(src, "<span class = 'warning'>The [S] pulls \the [hand] from your grip!</span>")

	if(!lying && (!shoes || !(shoes.clothing_flags & NOSLIP)) && (!species || !(species.species_flags & NOSLIP)) && prob(current_size*5))
		to_chat(src, "<span class='danger'>A strong gravitational force slams you to the ground!</span>")
		Weaken(current_size)
	..()

/obj/singularity_act()
	if(atom_flags & ATOM_ABSTRACT)
		return
	legacy_ex_act(1)
	if(!QDELETED(src))
		qdel(src)
	return 2

/obj/singularity_pull(S, current_size)
	if(atom_flags & ATOM_ABSTRACT)
		return
	if(anchored)
		if(current_size >= STAGE_FIVE)
			step_towards(src, S)
	else
		step_towards(src, S)

/obj/effect/beam/singularity_pull()
	return

/obj/effect/overlay/singularity_pull()
	return

/obj/item/singularity_pull(S, current_size)
	spawn(0) //this is needed or multiple items will be thrown sequentially and not simultaneously
		if(current_size >= STAGE_FOUR)
			//throw_at_old(S, 14, 3)
			step_towards(src,S)
			sleep(1)
			step_towards(src,S)
		else if(current_size > STAGE_ONE)
			step_towards(src,S)
		else ..()

/obj/machinery/atmospherics/pipe/singularity_pull()
	return

/obj/machinery/power/supermatter/shard/singularity_act()
	qdel(src)
	return 5000

/obj/machinery/power/supermatter/singularity_act()
	if(!src.loc)
		return

	var/prints = ""
	if(src.fingerprintshidden)
		prints = ", all touchers : " + src.fingerprintshidden

	SetUniversalState(/datum/universal_state/supermatter_cascade)
	log_admin("New super singularity made by eating a SM crystal [prints]. Last touched by [src.fingerprintslast].")
	message_admins("New super singularity made by eating a SM crystal [prints]. Last touched by [src.fingerprintslast].")
	qdel(src)
	return 50000

/obj/item/projectile/beam/emitter/singularity_pull()
	return

/obj/effect/projectile/emitter/singularity_pull()
	return

/obj/item/storage/backpack/holding/singularity_act(S, current_size)
	var/dist = max((current_size - 2), 1)
	explosion(src.loc,(dist),(dist*2),(dist*4))
	return 1000

/turf/singularity_act(S, current_size)
	ScrapeAway()
	return 2

/turf/simulated/floor/singularity_pull(S, current_size)
	if(flooring && current_size >= STAGE_THREE)
		if(prob(current_size / 2))
			var/leave_tile = TRUE
			if(broken || burnt || flooring.flooring_flags & TURF_IS_FRAGILE)
				leave_tile = FALSE
			playsound(src, 'sound/items/crowbar.ogg', 50, 1)
			make_plating(leave_tile)

/turf/simulated/wall/singularity_pull(S, current_size)

	if(!reinf_material)
		if(current_size >= STAGE_FIVE)
			if(prob(75))
				dismantle_wall()
			return
		if(current_size == STAGE_FOUR)
			if(prob(30))
				dismantle_wall()
	else
		if(current_size >= STAGE_FIVE)
			if(prob(30))
				dismantle_wall()

/turf/space/singularity_act()
	return

/turf/simulated/open/singularity_act()
	return

/*******************
* Nar-Sie Act/Pull *
*******************/
/atom/proc/singuloCanEat()
	return 1

/mob/observer/singuloCanEat()
	return 0

/mob/new_player/singuloCanEat()
	return 0
