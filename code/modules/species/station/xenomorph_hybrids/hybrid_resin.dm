//contains the relavant data for the xenohybrid resin, a more versitile, and legaly distinct material.

/datum/material/hybrid_resin
	name = "resin compound"
	icon_colour = "#321a49"
	icon_base = "resin"
	dooropen_noise = 'sound/effects/attackblob.ogg'
	door_icon_base = "resin"
	icon_reinf = "reinf_mesh"
	melting_point = T0C+200//we melt faster this isnt a building material you wanna built engines from
	sheet_singular_name = "bar"
	sheet_plural_name = "bars"
	conductive = 0
	explosion_resistance = 20//normal resin has 60, we are much softer
	radiation_resistance = 10
	stack_origin_tech = list(TECH_MATERIAL = 2, TECH_BIO = 2)
	stack_type = /obj/item/stack/material/hybrid_resin

/obj/item/stack/material/hybrid_resin
	name = "resin compound"
	icon_state = "sheet-resin"
	default_type = "resin compound"
	no_variants = TRUE
	apply_colour = TRUE
	pass_color = TRUE
	strict_color_stacking = TRUE

/datum/material/hybrid_resin/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door/hybrid_resin, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/effect/alien/hybrid_resin/wall, 5, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] nest", /obj/structure/bed/hybrid_nest, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crude [display_name] bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] membrane", /obj/effect/alien/hybrid_resin/membrane, 1, time = 2 SECONDS, pass_stack_color = TRUE)

/mob/living/carbon/human/proc/hybrid_resin() //
	set name = "Secrete Resin (75)"
	set desc = "Secrete tough malleable resin."
	set category = "Abilities"

	var/choice = input("Choose what you wish to shape.","Resin building") as null|anything in list("resin door","resin wall","resin membrane","resin nest","resin compound") //would do it through typesof but then the player choice would have the type path and we don't want the internal workings to be exposed ICly - Urist
	if(!choice)
		return

	if(!check_alien_ability(75,1,O_RESIN))
		return

	visible_message("<span class='warning'><B>[src] spits out a thick purple substance and begins to shape it!</B></span>", "<span class='green'>You shape a [choice].</span>")

	var/obj/O

	switch(choice)
		if("resin door")
			O = new /obj/structure/simple_door/hybrid_resin(loc)
		if("resin wall")
			O = new /obj/effect/alien/hybrid_resin/wall(loc)
		if("resin membrane")
			O = new /obj/effect/alien/hybrid_resin/membrane(loc)
		if("resin nest")
			O = new /obj/structure/bed/hybrid_nest(loc)
		if("resin compound")
			O = new /obj/item/stack/material/hybrid_resin(loc)

	if(O)
		O.color = "#321D37"

	return

/obj/structure/simple_door/hybrid_resin/Initialize(mapload, material_name)
	return ..(mapload, "resin compound")

/obj/structure/bed/hybrid_nest
	name = "alien nest"
	desc = "It's a gruesome pile of thick, sticky resin shaped like a nest."
	icon = 'icons/mob/alien.dmi'
	icon_state = "nest"
	color = "#321a49"
	material = "resin compound"
	padding_material = "resin compound"
	var/health = 100

/obj/structure/bed/hybrid_nest/update_icon()
	return

/obj/structure/bed/hybrid_nest/user_unbuckle_feedback(mob/M, flags, mob/user, semantic)
	if(user != M)
		user.visible_message(\
			"<span class='notice'>[user.name] pulls [M.name] free from the sticky nest!</span>",\
			"<span class='notice'>[user.name] pulls you free from the gelatinous resin.</span>",\
			"<span class='notice'>You hear squelching...</span>")
	else
		user.visible_message(
			SPAN_WARNING("[user] tears free of [src]."),
			SPAN_WARNING("You tear free of [src]."),
			SPAN_WARNING("You hear squelching...")
		)

/obj/structure/bed/hybrid_nest/user_buckle_mob(mob/M, flags, mob/user, semantic)
	if ( !ismob(M) || (get_dist(src, user) > 1) || (M.loc != src.loc) || user.restrained() || usr.stat || M.buckled || istype(user, /mob/living/silicon/pai) )
		return

	var/mob/living/carbon/human/xenos = user
	if(istype(xenos) && !istype(xenos.species, /datum/species/xenohybrid))//if a non xenomorph tries to buckle someone in, fail, because they cant secrete resin
		return

	if(M == user)
		return

	return ..()

/obj/structure/bed/hybrid_nest/user_buckle_feedback(mob/M, flags, mob/user, semantic)
	user.visible_message(\
		"<span class='notice'>[user.name] secretes a thick vile goo, securing [M.name] into [src]!</span>",\
		"<span class='warning'>[user.name] drenches you in a foul-smelling resin, trapping you in the [src]!</span>",\
		"<span class='notice'>You hear squelching...</span>")

/obj/structure/bed/hybrid_nest/attackby(obj/item/W as obj, mob/user as mob)
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	for(var/mob/M in viewers(src, 7))
		M.show_message("<span class='warning'>[user] hits [src] with [W]!</span>", 1)
	healthcheck()

/obj/structure/bed/hybrid_nest/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return

/*
 * Resin
 */
/obj/effect/alien/hybrid_resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "resin"

	density = 1
	opacity = 1
	anchored = 1
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
	var/health = 200
	//var/mob/living/affecting = null

/obj/effect/alien/hybrid_resin/wall
	name = "resin wall"
	desc = "Purple slime solidified into a wall."
	icon_state = "resinwall" //same as resin, but consistency ho!

/obj/effect/alien/hybrid_resin/membrane
	name = "resin membrane"
	desc = "Purple slime just thin enough to let light pass through."
	icon_state = "resinmembrane"
	opacity = 0
	health = 120

/obj/effect/alien/hybrid_resin/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

/obj/effect/alien/hybrid_resin/Destroy()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = initial(T.thermal_conductivity)
	..()

/obj/effect/alien/hybrid_resin/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return

/obj/effect/alien/hybrid_resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/effect/alien/hybrid_resin/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	user.do_attack_animation(src)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/hybrid_resin/take_damage(var/damage)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/hybrid_resin/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			health-=50
		if(2.0)
			health-=50
		if(3.0)
			if (prob(50))
				health-=50
			else
				health-=25
	healthcheck()
	return

/obj/effect/alien/hybrid_resin/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	for(var/mob/O in viewers(src, null))
		O.show_message("<span class='danger'>[src] was hit by [AM].</span>", 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM.throw_force
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	health = max(0, health - tforce)
	healthcheck()

/obj/effect/alien/hybrid_resin/attack_hand()
	usr.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if (MUTATION_HULK in usr.mutations)
		to_chat(usr, "<span class='notice'>You easily destroy the [name].</span>")
		for(var/mob/O in oviewers(src))
			O.show_message("<span class='warning'>[usr] destroys the [name]!</span>", 1)
		health = 0
	else

		// Aliens can get straight through these.
		if(istype(usr,/mob/living/carbon))
			var/mob/living/carbon/M = usr
			if(locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs)
				for(var/mob/O in oviewers(src))
					O.show_message("<span class='warning'>[usr] strokes the [name] and it melts away!</span>", 1)
				health = 0
				healthcheck()
				return

		to_chat(usr, "<span class='notice'>You claw at the [name].</span>")
		for(var/mob/O in oviewers(src))
			O.show_message("<span class='warning'>[usr] claws at the [name]!</span>", 1)
		health -= rand(5,10)
	healthcheck()
	return

/obj/effect/alien/hybrid_resin/attackby(obj/item/W as obj, mob/user as mob)

	user.setClickCooldown(user.get_attack_speed(W))
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	healthcheck()
	..()
	return

/obj/effect/alien/hybrid_resin/CanAllowThrough(atom/movable/mover, turf/target)
	if(check_standard_flag_pass(mover))
		return TRUE
	return ..()

#define WEED_NORTH_EDGING "north"
#define WEED_SOUTH_EDGING "south"
#define WEED_EAST_EDGING "east"
#define WEED_WEST_EDGING "west"

/obj/effect/alien/weeds/hybrid
	name = "hybrid weeds"
	desc = "A rubbery organic covering, you might know it from a Xenomorph Hybrid friend already."
	icon_state = "weeds"

	anchored = 1
	density = 0
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	color = "#422649"
