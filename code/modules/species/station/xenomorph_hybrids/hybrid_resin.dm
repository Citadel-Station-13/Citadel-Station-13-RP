//contains the relavant data for the xenohybrid resin, a more versitile, and legaly distinct material.

/datum/material/hybrid_resin
	id = "xenoresin_hybrid"
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
	material = /datum/material/hybrid_resin
	no_variants = TRUE
	apply_colour = TRUE
	pass_color = TRUE
	strict_color_stacking = TRUE

/datum/material/hybrid_resin/generate_recipes()
	recipes = list()
	recipes += new/datum/stack_recipe("[display_name] door", /obj/structure/simple_door/hybrid_resin, 10, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] barricade", /obj/structure/alien/hybrid_resin/wall, 5, time = 5 SECONDS, one_per_turf = 1, on_floor = 1, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] nest", /obj/structure/bed/hybrid_nest, 2, one_per_turf = 1, on_floor = 1, supplied_material = "[name]", pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("crude [display_name] bandage", /obj/item/stack/medical/crude_pack, 1, time = 2 SECONDS, pass_stack_color = TRUE)
	recipes += new/datum/stack_recipe("[display_name] membrane", /obj/structure/alien/hybrid_resin/membrane, 1, time = 2 SECONDS, pass_stack_color = TRUE)

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
			O = new /obj/structure/alien/hybrid_resin/wall(loc)
		if("resin membrane")
			O = new /obj/structure/alien/hybrid_resin/membrane(loc)
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
	hit_sound_brute = 'sound/effects/attackblob.ogg'

	integrity = 100
	integrity_max = 100

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

/obj/structure/alien/hybrid_resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "resin"

	density = 1
	opacity = 1
	anchored = 1
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED

	integrity = 200
	integrity_max = 200

	hit_sound_brute = 'sound/effects/attackblob.ogg'

/obj/structure/alien/hybrid_resin/wall
	name = "resin wall"
	desc = "Purple slime solidified into a wall."
	icon_state = "resinwall" //same as resin, but consistency ho!

/obj/structure/alien/hybrid_resin/membrane
	name = "resin membrane"
	desc = "Purple slime just thin enough to let light pass through."
	icon_state = "resinmembrane"
	opacity = 0
	intercom_range_display_status = 120
	integrity_max = 120

/obj/structure/alien/hybrid_resin/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

/obj/structure/alien/hybrid_resin/Destroy()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = initial(T.thermal_conductivity)
	..()

/obj/structure/alien/hybrid_resin/attack_hand(mob/user, list/params)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(locate(/obj/item/organ/internal/xenos/hivenode) in C.internal_organs)
			visible_message(SPAN_WARNING("[C] strokes the [name], and it melts away!"))
			qdel(src)
			return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

#define WEED_NORTH_EDGING "north"
#define WEED_SOUTH_EDGING "south"
#define WEED_EAST_EDGING "east"
#define WEED_WEST_EDGING "west"

/obj/structure/alien/weeds/hybrid
	name = "hybrid weeds"
	desc = "A rubbery organic covering, you might know it from a Xenomorph Hybrid friend already."
	icon_state = "weeds"

	anchored = 1
	density = 0
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	color = "#422649"
