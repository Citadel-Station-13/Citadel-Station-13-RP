/turf/simulated
	name = "station"
	turf_spawn_flags = TURF_SPAWN_FLAGS_ALLOW_ALL
	var/wet = 0
	var/image/wet_overlay = null

	//Mining resources (for the large drills).
	var/has_resources
	var/list/resources

	var/thermite = 0
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/can_dirty = TRUE	// If false, tile never gets dirty
	var/can_start_dirty = FALSE	// If false, cannot start dirty roundstart
	// todo: don't do this because peresistence
	var/dirty_prob = 0	// Chance of being dirty roundstart
	var/dirt = 0

	// If greater than 0, this turf will apply edge overlays on top of other turfs cardinally adjacent to it, if those adjacent turfs are of a different icon_state,
	// and if those adjacent turfs have a lower edge_blending_priority.
	// this is on /simulated even though only floors give borders because floors can render onto other simulated tiles like openspace.
	var/edge_blending_priority = 0
	/// edge icon state, overrides icon_state if set
	var/edge_icon_state

/turf/simulated/Initialize(mapload)
	. = ..()
	if(outdoors)
		SSplanets.addTurf(src)

/turf/simulated/Destroy()
	if(outdoors)
		SSplanets.removeTurf(src)
	return ..()

// This is not great.
// todo: this is shit, rework wet floors to be component, element, or just a goddamn cached datum at this point
/turf/simulated/proc/wet_floor(var/wet_val = 1)
	if(wet > 2)	//Can't mop up ice
		return
	spawn(0)
		wet = wet_val
		if(wet_overlay)
			cut_overlay(wet_overlay)
		wet_overlay = image('icons/effects/water.dmi', icon_state = "wet_floor")
		add_overlay(wet_overlay)
		sleep(1 MINUTES + 20 SECONDS)
		if(wet == 2)
			sleep(5 MINUTES + 20 SECONDS)
		wet = 0
		if(wet_overlay)
			cut_overlay(wet_overlay)
			wet_overlay = null

/turf/simulated/proc/freeze_floor()
	if(!wet) // Water is required for it to freeze.
		return
	wet = 3 // icy
	if(wet_overlay)
		cut_overlay(wet_overlay)
		wet_overlay = null
	wet_overlay = image('icons/turf/overlays.dmi',src,"snowfloor")
	add_overlay(wet_overlay)
	spawn(5 MINUTES)
		wet = 0
		if(wet_overlay)
			cut_overlay(wet_overlay)
			wet_overlay = null

/turf/simulated/clean_blood()
	for(var/obj/effect/debris/cleanable/blood/B in contents)
		B.clean_blood()
	..()

/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodcolor="#A10808")
	var/obj/effect/debris/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)

/turf/simulated/proc/update_dirt(increment = 1)
	if(can_dirty)
		dirt += increment
		if(dirt >= 100)
			set_dirt_object((dirt - 50) * 5)

/turf/simulated/Entered(atom/movable/AM, atom/oldLoc)
	..()
	if(AM.rad_insulation != 1)
		rad_insulation_contents *= AM.rad_insulation
		if(isturf(oldLoc))
			var/turf/T = oldLoc
			T.rad_insulation_contents /= AM.rad_insulation

	if (istype(AM, /mob/living))
		var/mob/living/M = AM
		if(M.lying)
			return

		if(M.dirties_floor())
			// Dirt overlays.
			// todo: currently nerfed
			update_dirt(0.8)

		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			// Tracking blood
			var/list/bloodDNA = null
			var/bloodcolor=""
			if(H.shoes)
				var/obj/item/clothing/shoes/S = H.shoes
				if(istype(S))
					S.handle_movement(src,(H.m_intent == "run" ? 1 : 0))
					if(S.track_blood && S.blood_DNA)
						bloodDNA = S.blood_DNA
						bloodcolor=S.blood_color
						S.track_blood--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					bloodcolor = H.feet_blood_color
					H.track_blood--

			if (bloodDNA)
				src.AddTracks(H.species.get_move_trail(H),bloodDNA,H.dir,0,bloodcolor) // Coming
				var/turf/simulated/from = get_step(H,global.reverse_dir[H.dir])
				if(istype(from) && from)
					from.AddTracks(H.species.get_move_trail(H),bloodDNA,0,H.dir,bloodcolor) // Going

				bloodDNA = null

		if(src.wet)
			process_slip(M)

/turf/simulated/proc/process_slip(mob/living/M)
	if(M.buckled || (src.wet == 1 && M.m_intent == "walk"))
		return

	var/slip_dist = 1
	var/slip_stun = 6
	var/class = SLIP_CLASS_WATER

	switch(src.wet)
		if(2) // Lube
			slip_dist = 4
			slip_stun = 10
			class = SLIP_CLASS_LUBRICANT
		if(3) // Ice
			slip_stun = 4
			slip_dist = 2
			class = SLIP_CLASS_ICE

	if(M.slip_act(class, src, slip_stun, slip_stun) > 0)
		for(var/i = 1 to slip_dist)
			step(M, M.dir)
			sleep(1)

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/effect/debris/cleanable/blood/B in contents)
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
				B.virus2 = virus_copylist(M.virus2)
			return 1 //we bloodied the floor
		blood_splatter_legacy(src, M.get_blood_mixture(), TRUE)
		return 1 //we bloodied the floor
	return 0

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/debris/cleanable/blood/xeno/this = new /obj/effect/debris/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"
	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/debris/cleanable/blood/oil(src)
	else if(ishuman(M))
		add_blood(M)

//? Radiation

/turf/simulated/update_rad_insulation()
	. = ..()
	for(var/atom/movable/AM as anything in contents)
		rad_insulation_contents *= AM.rad_insulation

//? Shuttle Movement

/turf/simulated/CopyTurf(turf/T, change_flags)
	if(!(change_flags & CHANGETURF_INHERIT_AIR))
		return ..()
	// invalidate zone
	if(has_valid_zone())
		if(can_safely_remove_from_zone())
			zone.remove(src)
			queue_zone_update()
		else
			zone.rebuild()
	// store air
	var/datum/gas_mixture/old_air = remove_cell_volume()
	. = ..()
	// restore air
	if(istype(., /turf/simulated))
		var/turf/simulated/casted = .
		if(casted.has_valid_zone())
			stack_trace("zone rebuilt too fast")
		casted.air = old_air
