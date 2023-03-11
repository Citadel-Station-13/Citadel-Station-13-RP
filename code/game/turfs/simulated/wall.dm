/**
 * **Wall.** Our powerful, generic, material wall system.
 * Surely, *surely*, such a nice, amazing thing wouldn't be entirely shitcode.
 * Right?
 */
/turf/simulated/wall
	name = "wall"
	desc = "A huge chunk of iron used to separate rooms."
	icon = 'icons/turf/walls/solid.dmi'
	icon_state = "wall-0"
	base_icon_state = "wall"
	color = "#666666"

	#ifdef IN_MAP_EDITOR // Display disposal pipes etc. above walls in map editors.
	layer = PLATING_LAYER
	#endif

	opacity = TRUE
	density = TRUE
	blocks_air = TRUE
	rad_insulation = RAD_INSULATION_EXTREME
//	air_status = AIR_STATUS_BLOCK
	thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT
	heat_capacity = 312500 //a little over 5 cm thick , 312500 for 1 m by 2.5 m by 0.25 m plasteel wall
	baseturfs = /turf/simulated/floor/plating
	edge_blending_priority = INFINITY // let's not have floors render onto us mmkay?

	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = (SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS)
	canSmoothWith = (SMOOTH_GROUP_SHUTTERS_BLASTDOORS + SMOOTH_GROUP_AIRLOCK + SMOOTH_GROUP_LOW_WALL + SMOOTH_GROUP_WINDOW_FULLTILE + SMOOTH_GROUP_WALLS)

	/// This is a var we are temporarily using until we have falsewall structures, until then we'll store our previous icon_state so we don't need to resmooth every time.
	// TODO: Remove this when falsewalls are implemented.
	var/cached_wall_state

	var/damage
	var/tmp/image/damage_overlay
	// Damage overlays are cached.
	var/global/damage_overlays[16]

	var/active
	var/can_open = FALSE

	var/datum/material/material
	var/datum/material/reinf_material
	var/datum/material/girder_material

	var/last_state
	var/construction_stage

// Walls always hide the stuff below them.
/turf/simulated/wall/levelupdate()
	for(var/obj/O in src)
		O.hide(1)

/turf/simulated/wall/Initialize(mapload)
	. = ..()
	//? Remove the color that was set for mapping clarity.
	color = null

	set_materials(material, reinf_material, girder_material)
	set_rad_insulation()

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

	if(material?.radioactivity || reinf_material?.radioactivity || girder_material?.radioactivity)
		START_PROCESSING(SSturfs, src)

/turf/simulated/wall/Destroy()
	STOP_PROCESSING(SSturfs, src)
	clear_plants()
	return ..()

/turf/simulated/wall/process(delta_time)
	// Calling parent will kill processing
	if(!radiate())
		return PROCESS_KILL

/turf/simulated/wall/proc/get_material()
	return material

/turf/simulated/wall/proc/get_default_material()
	. = /datum/material/steel

/turf/simulated/wall/bullet_act(var/obj/item/projectile/Proj)
	if(istype(Proj,/obj/item/projectile/beam))
		burn(2500)
	else if(istype(Proj,/obj/item/projectile/ion))
		burn(500)

	var/proj_damage = Proj.get_structure_damage()

	//cap the amount of damage, so that things like emitters can't destroy walls in one hit.
	var/damage = min(proj_damage, 100)

	if(Proj.damage_type == BURN && damage > 0)
		if(thermite)
			thermitemelt()

	if(istype(Proj,/obj/item/projectile/beam))
		if(material && material.reflectivity >= 0.5) // Time to reflect lasers.
			var/new_damage = damage * material.reflectivity
			var/outgoing_damage = damage - new_damage
			damage = new_damage
			Proj.damage = outgoing_damage

			visible_message("<span class='danger'>\The [src] reflects \the [Proj]!</span>")

			// Find a turf near or on the original location to bounce to
			var/new_x = Proj.starting.x + pick(0, 0, 0, -1, 1, -2, 2)
			var/new_y = Proj.starting.y + pick(0, 0, 0, -1, 1, -2, 2)
			//var/turf/curloc = get_turf(src)
			var/turf/curloc = get_step(src, get_dir(src, Proj.starting))

			Proj.penetrating += 1 // Needed for the beam to get out of the wall.

			// redirect the projectile
			Proj.redirect(new_x, new_y, curloc, null)

	if(Proj.ricochet_sounds && prob(15))
		playsound(src, pick(Proj.ricochet_sounds), 100, 1)

	take_damage(damage)
	return

/turf/simulated/wall/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	if(TT.throw_flags & THROW_AT_IS_GENTLE)
		return

	var/tforce = AM.throw_force * TT.get_damage_multiplier()
	if (tforce < 15)
		return

	take_damage(tforce)

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
/turf/simulated/wall/examine(mob/user)
	. = ..()

	if(!damage)
		. += "<span class='notice'>It looks fully intact.</span>"
	else
		var/dam = damage / material.integrity
		if(dam <= 0.3)
			. += "<span class='warning'>It looks slightly damaged.</span>"
		else if(dam <= 0.6)
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

/turf/simulated/wall/take_damage(dam)
	if(dam)
		damage = max(0, damage + dam)
		update_damage()
	return

/turf/simulated/wall/proc/update_damage()
	var/cap = material.integrity
	if(reinf_material)
		cap += reinf_material.integrity

	if(locate(/obj/effect/overlay/wallrot) in src)
		cap = cap / 10

	if(damage >= cap)
		dismantle_wall()
	else
		update_appearance()

/turf/simulated/wall/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)//Doesn't fucking work because walls don't interact with air :(
	burn(exposed_temperature)

/turf/simulated/wall/adjacent_fire_act(turf/simulated/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	burn(adj_temp)
	if(adj_temp > material.melting_point)
		take_damage(log(RAND_F(0.9, 1.1) * (adj_temp - material.melting_point)))

	return ..()

/turf/simulated/wall/proc/dismantle_wall(var/devastated, var/explode, var/no_product)
	playsound(src, 'sound/items/Welder.ogg', 100, 1)
	if(!no_product)
		if(reinf_material)
			reinf_material.place_dismantled_girder(src, reinf_material, girder_material)
		else
			material.place_dismantled_girder(src, null, girder_material)
		if(!devastated)
			material.place_dismantled_product(src)
			if (!reinf_material)
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
			if(girder_material.explosion_resistance >= 25 && prob(girder_material.explosion_resistance))
				new /obj/structure/girder/displaced(src, girder_material.name)
			ScrapeAway()
		if(2.0)
			if(prob(75))
				take_damage(rand(150, 250))
			else
				dismantle_wall(1,1)
		if(3.0)
			take_damage(rand(0, 250))

// Wall-rot effect, a nasty fungus that destroys walls.
/turf/simulated/wall/proc/rot()
	if(locate(/obj/effect/overlay/wallrot) in src)
		return
	var/number_rots = rand(2,3)
	for(var/i=0, i<number_rots, i++)
		new/obj/effect/overlay/wallrot(src)

/turf/simulated/wall/proc/can_melt()
	if(material.flags & MATERIAL_UNMELTABLE)
		return 0
	return 1

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

	if(girder_material.integrity >= 150 && !girder_material.is_brittle()) //Strong girders will remain in place when a wall is melted.
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

/turf/simulated/wall/proc/radiate()
	var/total_radiation = material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0) + (girder_material ? girder_material.radioactivity / 2 : 0)
	if(!total_radiation)
		return

	radiation_pulse(src, total_radiation)
	return total_radiation

/turf/simulated/wall/proc/set_rad_insulation()
	var/total_rad_insulation = material.weight + material.radiation_resistance + (reinf_material ? (reinf_material.weight + reinf_material.radiation_resistance) / 4 : 0) + (girder_material ? (girder_material.weight + girder_material.radiation_resistance) / 16 : 0)
	rad_insulation = round(1/(total_rad_insulation**1.35*1/21.25**1.35+1),0.01) // 21.25 would be the total_rad_insulation of basic steel walls and return 0.5 rad_insulation. 1.35 exponential function helps us to also hit the plasteel wall goal of 0.25.

/turf/simulated/wall/proc/burn(temperature)
	if(material.combustion_effect(src, temperature, 0.7))
		spawn(2)
			new /obj/structure/girder(src, girder_material.name)
			src.ChangeTurf(/turf/simulated/floor)
			for(var/turf/simulated/wall/W in range(3,src))
				W.burn((temperature/4))
			for(var/obj/machinery/door/airlock/phoron/D in range(3,src))
				D.ignite(temperature/4)

/turf/simulated/wall/rcd_values(mob/living/user, obj/item/rcd/the_rcd, passed_mode)
	if(material.integrity > 1000) // Don't decon things like elevatorium.
		return FALSE
	if(reinf_material && !the_rcd.can_remove_rwalls) // Gotta do it the old fashioned way if your RCD can't.
		return FALSE

	if(passed_mode == RCD_DECONSTRUCT)
		var/delay_to_use = material.integrity / 3 // Steel has 150 integrity, so it'll take five seconds to down a regular wall.
		if(reinf_material)
			delay_to_use += reinf_material.integrity / 3
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
