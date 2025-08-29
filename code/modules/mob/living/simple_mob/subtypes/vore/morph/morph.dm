#define MORPH_COOLDOWN 50

/mob/living/simple_mob/vore/hostile/morph
	name = "morph"
	real_name = "morph"
	desc = "A revolting, pulsating pile of flesh."
	tt_desc = "morphus shapeshiftus"
	icon = 'icons/mob/critter.dmi'
	icon_state = "morph"
	icon_living = "morph"
	icon_dead = "morph_dead"
	movement_base_speed = 10 / 1
	status_flags = STATUS_CAN_PUSH
	pass_flags = ATOM_PASS_TABLE
	mob_bump_flag = SLIME

	min_oxy = 0
	max_oxy = 0
	min_tox = 0
	max_tox = 0
	min_co2 = 0
	max_co2 = 0
	min_n2 = 0
	max_n2 = 0

	minbodytemp = 0
	maxHealth = 250
	health = 250
	taser_kill = FALSE
	legacy_melee_damage_lower = 15
	legacy_melee_damage_upper = 20
	see_in_dark = 8

	response_help = "touches"
	response_disarm = "pushes"
	response_harm = "hits"
	attacktext = "glomps"
	attack_sound = 'sound/effects/blobattack.ogg'

	meat_amount = 2

	showvoreprefs = 0

	var/morphed = FALSE
	var/tooltip = TRUE
	var/melee_damage_disguised = 0
	var/eat_while_disguised = FALSE
	var/atom/movable/form = null
	var/morph_time = 0
	var/our_size_multiplier = 1
	var/list/blacklist_typecache

/mob/living/simple_mob/vore/hostile/morph/Initialize(mapload)
	blacklist_typecache = cached_typecacheof(list(
		/atom/movable/screen,
		/obj/singularity,
		/mob/living/simple_mob/vore/hostile/morph,
		/obj/effect,
	))
	add_verb(src, /mob/living/proc/ventcrawl)
	return ..()

/mob/living/simple_mob/vore/hostile/morph/proc/allowed(atom/movable/A)
	return !is_type_in_typecache(A, blacklist_typecache) && (isobj(A) || ismob(A))

/mob/living/simple_mob/vore/hostile/morph/examine(mob/user, dist)
	if(morphed)
		form.examine(user)
		if(get_dist(user,src)<=3)
			. = ..()
			. += "<span class='warning'>It doesn't look quite right...</span>"
	return

/mob/living/simple_mob/vore/hostile/morph/shift_click_on(atom/target, location, control, list/params)
	var/atom/A = target
	if(Adjacent(A))
		if(morph_time <= world.time && !stat)
			if(A == src)
				restore()
				return
			if(istype(A) && allowed(A))
				assume(A)
		else
			to_chat(src, "<span class='warning'>Your chameleon skin is still repairing itself!</span>")
		return TRUE
	else
		return ..()

/mob/living/simple_mob/vore/hostile/morph/proc/assume(atom/movable/target)
	if(morphed)
		to_chat(src, "<span class='warning'>You must restore to your original form first!</span>")
		return
	morphed = TRUE
	form = target

	visible_message("<span class='warning'>[src] suddenly twists and changes shape, becoming a copy of [target]!</span>")
	appearance = target.appearance
	copy_overlays(target)
	alpha = max(alpha, 150)	//fucking chameleons
	transform = initial(transform)
	our_size_multiplier = size_multiplier
	if(isobj(target))
		size_multiplier = 1
		icon_scale_x = target.icon_scale_x
		icon_scale_y = target.icon_scale_y
		update_transform()
	else if(ismob(target))
		var/mob/living/M = target
		resize(M.size_multiplier)
	pixel_y = initial(pixel_y)
	pixel_x = initial(pixel_x)
	density = target.density

	//Morphed is weaker
	legacy_melee_damage_lower = melee_damage_disguised
	legacy_melee_damage_upper = melee_damage_disguised
	movement_base_speed = 10 / 5

	morph_time = world.time + MORPH_COOLDOWN
	return

/mob/living/simple_mob/vore/hostile/morph/proc/restore()
	if(!morphed)
		to_chat(src, "<span class='warning'>You're already in your normal form!</span>")
		return
	morphed = FALSE
	form = null
	alpha = initial(alpha)
	color = initial(color)
	layer = initial(layer)
	plane = initial(plane)
	maptext = null

	visible_message("<span class='warning'>[src] suddenly collapses in on itself, dissolving into a pile of green flesh!</span>")
	name = initial(name)
	desc = initial(desc)
	icon = initial(icon)
	icon_state = initial(icon_state)
	size_multiplier = 0
	resize(our_size_multiplier)
	cut_overlays()
	density = initial(density)

	//Baseline stats
	legacy_melee_damage_lower = initial(legacy_melee_damage_lower)
	legacy_melee_damage_upper = initial(legacy_melee_damage_upper)
	movement_base_speed = initial(movement_base_speed)

	morph_time = world.time + MORPH_COOLDOWN

/mob/living/simple_mob/vore/hostile/morph/death(gibbed)
	if(morphed)
		visible_message("<span class='warning'>[src] twists and dissolves into a pile of green flesh!</span>")
		restore()
	..()

/mob/living/simple_mob/vore/hostile/morph/will_show_tooltip()
	return (!morphed)

/mob/living/simple_mob/vore/hostile/morph/resize(var/new_size, var/animate = TRUE)
	if(morphed && !ismob(form))
		return
	return ..()

/mob/living/simple_mob/vore/hostile/morph/update_icon()
	if(morphed)
		return
	return ..()


/mob/living/simple_mob/vore/hostile/morph/update_icons()
	if(morphed)
		return
	return ..()

/mob/living/simple_mob/vore/hostile/morph/base_transform(matrix/applying)
	var/old_size_multiplier = size_multiplier
	. = ..()
	size_multiplier = old_size_multiplier
