/**
 * **Wall.** Our powerful, generic, material wall system.
 * Surely, *surely*, such a nice, amazing thing wouldn't be entirely shitcode.
 * Right?
 */
/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of iron used to separate rooms."
	icon = 'icons/turf/walls/_previews.dmi'
	icon_state = "solid"
	base_icon_state = "wall"
	color = "#666666"

	integrity_enabled = TRUE
	integrity = 200
	integrity_max = 200
	integrity_failure = 0

	armor_type = /datum/armor/wall

	#ifdef IN_MAP_EDITOR // Display disposal pipes etc. above walls in map editors.
	layer = PLATING_LAYER
	#endif

	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	layer = WALL_LAYER
	rad_insulation = RAD_INSULATION_EXTREME
//	air_status = AIR_STATUS_BLOCK
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
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

	var/datum/material/material_outer = /datum/material/steel
	var/datum/material/material_reinf
	var/datum/material/material_girder = /datum/material/steel

	var/last_state
	var/construction_stage
	/// Paint color of which the wall has been painted with.
	var/paint_color
	/// Paint color of which the stripe has been painted with. Will not overlay a stripe if no paint is applied
	var/stripe_color
	var/stripe_icon
	var/cache_key
	var/shiny_wall
	var/shiny_stripe

/turf/simulated/wall/Initialize(mapload)
	. = ..()
	// Remove the color that was set for mapping clarity.
	color = null
	// init materials
	init_materials()

	if(smoothing_flags & SMOOTH_DIAGONAL_CORNERS && fixed_underlay) //Set underlays for the diagonal walls.
		var/mutable_appearance/underlay_appearance = mutable_appearance(layer = TURF_LAYER, plane = TURF_PLANE)
		if(fixed_underlay["space"])
			underlay_appearance.icon = 'icons/turf/space.dmi'
			underlay_appearance.icon_state = "space"
			underlay_appearance.plane = SPACE_PLANE
		else
			underlay_appearance.icon = fixed_underlay["icon"]
			underlay_appearance.icon_state = fixed_underlay["icon_state"]
		fixed_underlay = string_assoc_list(fixed_underlay)
		underlays += underlay_appearance

/turf/simulated/wall/Destroy()
	clear_plants()
	return ..()

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)


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
	if(adj_temp > material.melting_point)
		inflict_atom_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material.melting_point)), flag = ARMOR_FIRE, gradual = TRUE)

	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product)
	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(!no_product)
		if(material_reinf)
			material_reinf.place_dismantled_girder(src, material_reinf, material_girder)
		else
			material.place_dismantled_girder(src, null, material_girder)
		if(!devastated)
			material.place_dismantled_product(src)
			if (!material_reinf)
				material.place_dismantled_product(src)

	for(var/obj/O in src.contents) //Eject contents!
		if(istype(O,/obj/structure/sign/poster))
			var/obj/structure/sign/poster/P = O
			P.roll_and_drop(src)
		else
			O.forceMove(src)
	ScrapeAway()

/turf/simulated/wall/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			if(material_girder.explosion_resistance >= 25 && prob(material_girder.explosion_resistance))
				new /obj/structure/girder/displaced(src, material_girder.name)
			ScrapeAway()
		if(2.0)
			if(prob(75))
				inflict_atom_damage(rand(150, 250), flag = ARMOR_BOMB)
			else
				dismantle_wall(1,1)
		if(3.0)
			inflict_atom_damage(rand(0, 150), flag = ARMOR_BOMB)

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

	if(material_girder.integrity >= 150 && !material_girder.is_brittle()) //Strong girders will remain in place when a wall is melted.
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
	if(material.combustion_effect(src, temperature, 0.7))
		spawn(2)
			new /obj/structure/girder(src, material_girder.name)
			src.ChangeTurf(/turf/simulated/floor)
			for(var/turf/simulated/wall/W in range(3,src))
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
				D.ignite(temperature/4)

/turf/simulated/wall/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	if(!material)
		return
	if(material_reinf && !the_rcd.can_remove_rwalls) // Gotta do it the old fashioned way if your RCD can't.
		return FALSE

	if(passed_mode == RCD_DECONSTRUCT)
		var/delay_to_use = material.integrity / 3 // Steel has 150 integrity, so it'll take five seconds to down a regular wall.
		if(material_reinf)
			delay_to_use += material_reinf.integrity / 3
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
