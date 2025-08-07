/**
 * **Wall.** Our powerful, generic, material wall system.
 * Surely, *surely*, such a nice, amazing thing wouldn't be entirely shitcode.
 * Right?
 *
 * TODO: /turf/simulated/wall/material; do not have steel defines on base.
 *
 * ## Material System
 *
 * By default, walls are made out of /datum/material's.
 *
 * Sometimes, however, it's necessary to opt out of it. Walls have many generic behaviors;
 * it would suck if they needed to be duplicated just to not have to use materials.
 *
 * If `material_system` is switched off, materials won't do anything, nor will they be applied or updated.
 */
/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of iron used to separate rooms."
	color = /datum/prototype/material/steel::icon_colour
	icon = /datum/prototype/material/steel::icon_base
	icon_state = "wall-0"
	base_icon_state = "wall"

	#ifdef IN_MAP_EDITOR // Display disposal pipes etc. above walls in map editors.
	layer = PLATING_LAYER
	#else
	layer = WALL_LAYER
	#endif

	integrity_enabled = TRUE
	integrity = 200
	integrity_max = 200
	integrity_failure = 0

	armor_type = /datum/armor/object/heavy
	outdoors = FALSE

	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	rad_insulation = RAD_INSULATION_EXTREME
	// air_status = AIR_STATUS_BLOCK
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	baseturfs = /turf/simulated/floor/plating
	edge_blending_priority = INFINITY // let's not have floors render onto us mmkay?

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_LOW_WALL + SMOOTH_GROUP_GRILLE + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

	/// This is a var we are temporarily using until we have falsewall structures, until then we'll store our previous icon_state so we don't need to resmooth every time.
	// TODO: Remove this when falsewalls are implemented.
	var/cached_wall_state

	var/tmp/image/damage_overlay
	// Damage overlays are cached.
	var/global/damage_overlays[16]

	var/active
	var/can_open = FALSE

	/// Do we use materials system?
	var/material_system = TRUE
	/// The material of the girders that are produced when the wall is dismantled.
	var/datum/prototype/material/material_girder = /datum/prototype/material/steel
	/// The base material of the wall.
	var/datum/prototype/material/material_outer = /datum/prototype/material/steel
	/// The reinforcement material of the wall.
	var/datum/prototype/material/material_reinf

	var/last_state
	var/construction_stage

	/// The material color of the wall.
	VAR_PROTECTED/material_color
	/// Paint color of which the wall has been painted with.
	VAR_PROTECTED/paint_color
	/// Paint color of which the stripe has been painted with. Will not overlay a stripe if no paint is applied
	VAR_PROTECTED/stripe_color

	/// This is set by materials, do not touch!
	VAR_PRIVATE/stripe_icon
	/// This is set by update_overlays(), do not touch!
	VAR_PRIVATE/cache_key

	var/shiny_wall //? Not even used rn?
	var/shiny_stripe

/turf/simulated/wall/Initialize(mapload)
	// Remove the color that was set for mapping clarity.
	//? This is before the ..() as it does stuff if there is a color.
	color = null

	. = ..()

	// Init materials
	init_materials()

/turf/simulated/wall/Destroy()
	clear_plants()
	return ..()

/// walls **do not** hide things underfloor
/// why, even though it makes sense?
/// because balance-wise we don't want to make you have to tear down
/// walls just to run pipes through
///
/// if there's a way to do it later then we can set this back to yes but for now, hell no.
/// do not change this without permission ~silicons
/turf/simulated/wall/hides_underfloor_objects()
	return FALSE

/turf/simulated/wall/proc/clear_plants()
	for(var/obj/effect/overlay/wallrot/WR in src)
		qdel(WR)
	for(var/obj/effect/plant/plant in range(src, 1))
		if(!plant.floor) //shrooms drop to the floor
			plant.floor = 1
			plant.update_appearance()
			plant.pixel_x = 0
			plant.pixel_y = 0
		plant.update_neighbors()

//Appearance
/turf/simulated/wall/examine(mob/user, dist)
	. = ..()

	var/percent = percent_integrity()
	if(percent == 1)
		. += "<span class='notice'>It looks fully intact.</span>"
	else
		if(percent > 0.8)
			. += "<span class='warning'>It looks slightly damaged.</span>"
		else if(percent > 0.5)
			. += "<span class='warning'>It looks moderately damaged.</span>"
		else
			. += "<span class='danger'>It looks heavily damaged.</span>"

	if(locate(/obj/effect/overlay/wallrot) in src)
		. += "<span class='warning'>There is fungus growing on [src].</span>"

//Damage

/turf/simulated/wall/melt()

	if(!can_melt())
		return

	src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	if(!F)
		return
	F.burn_tile()
	F.icon_state = "wall_thermite"
	visible_message("<span class='danger'>\The [src] spontaneously combusts!.</span>") //!!OH SHIT!!
	return

/turf/simulated/wall/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	burn(exposed_temperature)

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp > material_outer.melting_point)
		inflict_atom_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material_outer.melting_point)), damage_flag = ARMOR_FIRE, damage_mode = DAMAGE_MODE_GRADUAL)

	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product)
	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(!no_product)
		if(material_reinf)
			material_reinf.place_dismantled_girder(src, material_reinf, material_girder)
		else
			material_girder.place_dismantled_girder(src, null, material_girder)
		if(!devastated)
			material_outer.place_dismantled_product(src)
			if(isnull(material_reinf))
				material_outer.place_dismantled_product(src)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/poster))
			var/obj/structure/poster/P = O
			P.roll_and_drop(src)
		else
			O.forceMove(src)
	ScrapeAway()

/turf/simulated/wall/legacy_ex_act(severity)
	if(integrity_flags & INTEGRITY_INDESTRUCTIBLE)
		return
	switch(severity)
		if(1.0)
			if(material_girder.explosion_resistance >= 25 && prob(material_girder.explosion_resistance))
				new /obj/structure/girder/displaced(src, material_girder.name)
			ScrapeAway()
		if(2.0)
			if(prob(75))
				inflict_atom_damage(rand(150, 250), damage_flag = ARMOR_BOMB)
			else
				dismantle_wall(1,1)
		if(3.0)
			inflict_atom_damage(rand(0, 150), damage_flag = ARMOR_BOMB)

/turf/simulated/wall/proc/can_melt()
	return material_outer?.material_flags & MATERIAL_FLAG_UNMELTABLE

/turf/simulated/wall/proc/thermitemelt(mob/user as mob)
	if(!can_melt())
		return
	var/obj/effect/overlay/O = new/obj/effect/overlay( src )
	O.name = "Thermite"
	O.desc = "Looks hot."
	O.icon = 'icons/effects/fire.dmi'
	O.icon_state = "2"
	O.anchored = 1
	O.density = 1
	O.plane = ABOVE_PLANE

	// todo: refactor?
	if(material_girder.relative_integrity >= 1.5) //Strong girders will remain in place when a wall is melted.
		dismantle_wall(1,1)
	else
		src.ChangeTurf(/turf/simulated/floor/plating)

	var/turf/simulated/floor/F = src
	F.burn_tile()
	F.icon_state = "dmg[rand(1,4)]"
	to_chat(user, "<span class='warning'>The thermite starts melting through the wall.</span>")

	spawn(100)
		if(O)
			qdel(O)
//	F.sd_LumReset()		//TODO: ~Carn
	return

/turf/simulated/wall/proc/burn(temperature)
	if(material_outer.combustion_effect(src, temperature, 0.7))
		addtimer(CALLBACK(src, PROC_REF(do_burn), temperature), 2)

/turf/simulated/wall/proc/do_burn(temperature)
	new /obj/structure/girder(src, material_girder.name)
	src.ChangeTurf(/turf/simulated/floor)
	for(var/turf/simulated/wall/W in range(3,src))
		W.burn((temperature/4))
	for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
		D.ignite(temperature/4)

/turf/simulated/wall/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	if(isnull(material_outer))
		return
	if(material_reinf && !the_rcd.can_remove_rwalls) // Gotta do it the old fashioned way if your RCD can't.
		return FALSE

	if(passed_mode == RCD_DECONSTRUCT)
		var/delay_to_use = material_outer.relative_integrity * 100 / 3 // Steel has 150 integrity, so it'll take five seconds to down a regular wall.
		if(material_reinf)
			delay_to_use += material_reinf.relative_integrity * 100 / 3
		return list(
			RCD_VALUE_MODE = RCD_DECONSTRUCT,
			RCD_VALUE_DELAY = delay_to_use,
			RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 5
			)
	return FALSE

/turf/simulated/wall/rcd_act(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	if(passed_mode == RCD_DECONSTRUCT)
		to_chat(user, SPAN_NOTICE("You deconstruct \the [src]."))
		ScrapeAway()
		return TRUE
	return FALSE
