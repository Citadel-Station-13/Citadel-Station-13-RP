/obj/structure/grille
	name = "grille"
	desc = "A flimsy lattice of metal rods, with screws to secure it to the floor."
	icon = 'icons/obj/structures/grille.dmi'
	icon_state = "grille-0"
	base_icon_state = "grille"
	density = TRUE
	anchored = TRUE
	pass_flags_self = ATOM_PASS_GRILLE
	pressure_resistance = 5*ONE_ATMOSPHERE
	rad_flags = RAD_BLOCK_CONTENTS
	layer = GRILLE_LAYER
	explosion_resistance = 1
	color = COLOR_GRAY
	armor_type = /datum/armor/none

	plane = OBJ_PLANE
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_GRILLE)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_GRILLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS )

	integrity = 100
	integrity_max = 100
	integrity_failure = 40

	hit_sound_brute = 'sound/effects/grillehit.ogg'

	var/destroyed = 0

/obj/structure/grille/update_icon_state()
	if(atom_flags & ATOM_BROKEN)
		icon_state = "brokengrille"
	return ..()

/obj/structure/grille/Bumped(atom/user)
	. = ..()
	if(ismob(user))
		shock(user, 70)

/obj/structure/grille/CanAllowThrough(atom/movable/mover, turf/target)
	if(istype(mover, /obj/projectile) && prob(30))
		return TRUE
	return ..()

/obj/structure/grille/bullet_act(var/obj/projectile/Proj)
	//Flimsy grilles aren't so great at stopping projectiles. However they can absorb some of the impact
	var/damage = Proj.get_structure_damage()
	var/passthrough = 0

	if(!damage) return

	//20% chance that the grille provides a bit more cover than usual. Support structure for example might take up 20% of the grille's area.
	//If they click on the grille itself then we assume they are aiming at the grille itself and the extra cover behaviour is always used.
	switch(Proj.damage_type)
		if(BRUTE)
			//bullets
			if(Proj.original == src || prob(20))
				Proj.damage *= clamp( Proj.damage/60, 0,  0.5)
				if(prob(max((damage-10)/25, 0))*100)
					passthrough = 1
			else
				Proj.damage *= clamp( Proj.damage/60, 0,  1)
				passthrough = 1
		if(BURN)
			//beams and other projectiles are either blocked completely by grilles or stop half the damage.
			if(!(Proj.original == src || prob(20)))
				Proj.damage *= 0.5
				passthrough = 1

	if(passthrough)
		. = PROJECTILE_CONTINUE
		damage = between(0, (damage - Proj.damage)*(Proj.damage_type == BRUTE? 0.4 : 1), 10) //if the bullet passes through then the grille avoids most of the damage

	inflict_atom_damage(damage, Proj.damage_tier, Proj.damage_flag, Proj.damage_mode, ATTACK_TYPE_PROJECTILE, Proj)

/obj/structure/grille/attackby(obj/item/W as obj, mob/user as mob)
	if(!istype(W))
		return
	if(istype(W, /obj/item/rcd)) // To stop us from hitting the grille when building windows, because grilles don't let parent handle it properly.
		return FALSE
	else if(W.is_wirecutter())
		if(!shock(user, 100))
			playsound(src, W.tool_sound, 100, 1)
			new /obj/item/stack/rods(get_turf(src), destroyed ? 1 : 2)
			qdel(src)
	else if((W.is_screwdriver()) && (istype(loc, /turf/simulated) || anchored))
		if(!shock(user, 90))
			playsound(src, W.tool_sound, 100, 1)
			anchored = !anchored
			user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the grille.</span>", \
								 "<span class='notice'>You have [anchored ? "fastened the grille to" : "unfastened the grille from"] the floor.</span>")
			return

	//window placing begin //TODO CONVERT PROPERLY TO MATERIAL DATUM
	else if(istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if(!ST.material.created_fulltile_window)
			return 0

		if( !(( x == user.x ) || (y == user.y)) ) //Only supposed to work for cardinal directions.
			to_chat(user, "<span class='notice'>You can't reach.</span>")
			return //Only works for cardinal direcitons, diagonals aren't supposed to work like this.

		for(var/obj/structure/window/WINDOW in loc)
			to_chat(user, "<span class='notice'>There is already a window here.</span>")
			return

		to_chat(user, "<span class='notice'>You start placing the window.</span>")

		if(do_after(user,20))
			for(var/obj/structure/window/WINDOW in loc)
				to_chat(user, "<span class='notice'>There is already a window here.</span>")
				return

			var/wtype = ST.material.created_fulltile_window
			if (ST.use(2))
				var/obj/structure/window/WD = new wtype(loc, 1)
				to_chat(user, "<span class='notice'>You place the [WD] on [src].</span>")
				WD.update_appearance()
	return ..()

/obj/structure/grille/unarmed_act(mob/attacker, datum/unarmed_attack/style, target_zone, mult)
	if(shock(attacker, 70))
		return FALSE
	return ..()

/obj/structure/grille/melee_act(mob/user, obj/item/weapon, target_zone, mult)
	if(shock(user, 70, weapon))
		return FALSE
	return ..()

/obj/structure/grille/drop_products(method, atom/where)
	. = ..()
	drop_product(method, new /obj/item/stack/rods(null, method == ATOM_DECONSTRUCT_DISASSEMBLED? 2 : 1) , drop_location())

/obj/structure/grille/atom_break()
	smoothing_flags = NONE
	. = ..()
	update_icon()

/obj/structure/grille/atom_fix()
	smoothing_flags = initial(smoothing_flags)
	. = ..()
	update_icon()

// shock user with probability prb (if all connections & power are working)
// returns 1 if shocked, 0 otherwise

/obj/structure/grille/proc/shock(mob/user as mob, prb, obj/item/tool)
	if(tool?.atom_flags & NOCONDUCT)
		return 0
	if(!anchored || (atom_flags & ATOM_BROKEN))		// anchored/destroyed grilles are never connected
		return 0
	if(!prob(prb))
		return 0
	if(!in_range(src, user))//To prevent MUTATION_TELEKINESIS and mech users from getting shocked
		return 0
	var/turf/T = get_turf(src)
	var/obj/structure/cable/C = T.get_cable_node()
	if(C)
		if(electrocute_mob(user, C, src))
			if(C.powernet)
				C.powernet.trigger_warning()
			var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			if(!CHECK_MOBILITY(user, MOBILITY_CAN_USE))
				return 1
		else
			return 0
	return 0

/obj/structure/grille/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(!destroyed)
		if(exposed_temperature > T0C + 1500)
			inflict_atom_damage(1, flag = ARMOR_FIRE)
	..()

/obj/structure/grille/proc/is_on_frame()
	if(locate(/obj/structure/wall_frame) in loc)
		return TRUE

/proc/place_grille(mob/user, loc, obj/item/stack/rods/ST)
	if(ST.in_use)
		return
	if(ST.get_amount() < 2)
		to_chat(user, SPAN_WARNING("You need at least two rods to do this."))
		return
	user.visible_message(SPAN_NOTICE("\The [user] begins assembling a grille."))
	if(do_after(user, 1 SECOND, ST) && ST.use(2))
		var/obj/structure/grille/F = new(loc)
		user.visible_message(SPAN_NOTICE("\The [user] finishes building \a [F]."))

/obj/structure/grille/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_WINDOWGRILLE)
			// A full tile window costs 4 glass sheets.
			return list(
				RCD_VALUE_MODE = RCD_WINDOWGRILLE,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 4
			)

		if(RCD_DECONSTRUCT)
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 2
			)
	return FALSE

/obj/structure/grille/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	switch(passed_mode)
		if(RCD_DECONSTRUCT)
			to_chat(user, SPAN_NOTICE("You deconstruct \the [src]."))
			qdel(src)
			return TRUE
		if(RCD_WINDOWGRILLE)
			if(locate(/obj/structure/window) in loc)
				return FALSE
			to_chat(user, SPAN_NOTICE("You construct a window."))
			var/obj/structure/window/WD = new the_rcd.window_type(loc)
			WD.anchored = TRUE
			return TRUE
	return FALSE

// Used in mapping to avoid
/obj/structure/grille/broken
	density = FALSE
	icon_state = "grille-b"

/obj/structure/grille/broken/Initialize()
	. = ..()
	set_integrity(integrity_failure)

/obj/structure/grille/cult
	name = "cult grille"
	desc = "A matrice built out of an unknown material, with some sort of force field blocking air around it."
	icon_state = "grillecult"
	integrity = 40
	integrity_max = 40
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED // Make sure air doesn't drain.

/obj/structure/grille/broken/cult
	icon_state = "grillecult-b"

/obj/structure/grille/rustic
	name = "rustic grille"
	desc = "A lattice of metal, arranged in an old, rustic fashion."
	icon_state = "grillerustic"

/obj/structure/grille/broken/rustic
	icon_state = "grillerustic-b"
