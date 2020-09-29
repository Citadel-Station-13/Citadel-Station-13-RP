
// This doesn't inherit from /outdoors/ so that the pool can use it as well.
/turf/simulated/floor/water
	name = "shallow water"
	desc = "A body of water.  It seems shallow enough to walk through, if needed."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "seashallow" // So it shows up in the map editor as water.
	var/water_state = "water_shallow"
	var/under_state = "rock"
	edge_blending_priority = -1
	movement_cost = 4
	outdoors = TRUE

	layer = WATER_FLOOR_LAYER

	can_dirty = FALSE	// It's water

	var/depth = 1 // Higher numbers indicates deeper water.

/turf/simulated/floor/water/Initialize()
	. = ..()
	update_icon()
	handle_fish()

/turf/simulated/floor/water/update_icon()
	..() // To get the edges.

	icon_state = under_state // This isn't set at compile time in order for it to show as water in the map editor.
	var/image/water_sprite = image(icon = 'icons/turf/outdoors.dmi', icon_state = water_state, layer = WATER_LAYER)
	add_overlay(water_sprite)

	update_icon_edge()

/turf/simulated/floor/water/get_edge_icon_state()
	return "water_shallow"

/turf/simulated/floor/water/return_air_for_internal_lifeform(var/mob/living/L)
	if(L && L.lying)
		if(L.can_breathe_water()) // For squid.
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			var/amount = 300
			water_breath.adjust_gas(/datum/gas/oxygen, amount) // Assuming water breathes just extract the oxygen directly from the water.
			water_breath.temperature = above_air.temperature
			return water_breath
		else
			var/gasid = /datum/gas/carbon_dioxide
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.species && H.species.exhale_type)
					gasid = H.species.exhale_type
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			water_breath.adjust_gas(gasid, BREATH_MOLES) // They have no oxygen, but non-zero moles and temp
			water_breath.temperature = above_air.temperature
			return water_breath
	return return_air() // Otherwise their head is above the water, so get the air from the atmosphere instead.

/turf/simulated/floor/water/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(oldloc, /turf/simulated/floor/water))
			to_chat(L, "<span class='warning'>You get drenched in water from entering \the [src]!</span>")
	AM.water_act(5)
	..()

/turf/simulated/floor/water/Exited(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_water()
		if(L.check_submerged() <= 0)
			return
		if(!istype(newloc, /turf/simulated/floor/water))
			to_chat(L, "<span class='warning'>You climb out of \the [src].</span>")
	..()

/turf/simulated/floor/water/deep
	name = "deep water"
	desc = "A body of water.  It seems quite deep."
	icon_state = "seadeep" // So it shows up in the map editor as water.
	under_state = "abyss"
	edge_blending_priority = -2
	movement_cost = 8
	depth = 2

/turf/simulated/floor/water/pool
	name = "pool"
	desc = "Don't worry, it's not closed."
	under_state = "pool"
	outdoors = FALSE

/turf/simulated/floor/water/deep/pool
	name = "deep pool"
	desc = "Don't worry, it's not closed."
	outdoors = FALSE

/mob/living/proc/can_breathe_water()
	return FALSE

/mob/living/carbon/human/can_breathe_water()
	if(species)
		return species.can_breathe_water()
	return ..()

/mob/living/proc/check_submerged()
	if(buckled)
		return 0
	if(hovering)
		return 0
	if(locate(/obj/structure/catwalk) in loc)
		return 0
	var/turf/simulated/floor/water/T = loc
	if(istype(T))
		return T.depth
	return 0

// Use this to have things react to having water applied to them.
/atom/movable/proc/water_act(amount)
	return

/mob/living/water_act(amount)
	adjust_fire_stacks(-amount * 5)
	for(var/atom/movable/AM in contents)
		AM.water_act(amount)
	remove_modifiers_of_type(/datum/modifier/fire)
	inflict_water_damage(20 * amount) // Only things vulnerable to water will actually be harmed (slimes/prommies).

var/list/shoreline_icon_cache = list()

/turf/simulated/floor/water/shoreline
	name = "shoreline"
	desc = "The waves look calm and inviting."
	icon_state = "shoreline"
	water_state = "rock" // Water gets generated as an overlay in update_icon()
	depth = 0

/turf/simulated/floor/water/shoreline/corner
	icon_state = "shorelinecorner"

// Water sprites are really annoying, so let BYOND sort it out.
/turf/simulated/floor/water/shoreline/update_icon()
	underlays.Cut()
	cut_overlays()
	..() // Get the underlay first.
	var/cache_string = "[initial(icon_state)]_[water_state]_[dir]"
	if(cache_string in shoreline_icon_cache) // Check to see if an icon already exists.
		add_overlay(shoreline_icon_cache[cache_string])
	else // If not, make one, but only once.
		var/icon/shoreline_water = icon(src.icon, "shoreline_water", src.dir)
		var/icon/shoreline_subtract = icon(src.icon, "[initial(icon_state)]_subtract", src.dir)
		shoreline_water.Blend(shoreline_subtract,ICON_SUBTRACT)
		var/image/final = image(shoreline_water)
		final.layer = WATER_LAYER

		shoreline_icon_cache[cache_string] = final
		add_overlay(shoreline_icon_cache[cache_string])

/turf/simulated/floor/water/is_safe_to_enter(mob/living/L)
	if(L.get_water_protection() < 1)
		return FALSE
	return ..()

//Supernatural/Horror Pool Turfs

/turf/simulated/floor/acid
	name = "hissing pool"
	desc = "A sickly green liquid. It emanates an acrid stench. It seems shallow enough to walk through, if needed."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "acid_shallow"
	var/acid_state = "acid_shallow"
	var/under_state = "rock"
	edge_blending_priority = 0
	movement_cost = 4
	outdoors = TRUE

	layer = WATER_FLOOR_LAYER

	can_dirty = FALSE	// It's acid

	var/depth = 1 // Higher numbers indicates deeper water.

/turf/simulated/floor/acid/Initialize()
	. = ..()
	update_icon()

/turf/simulated/floor/acid/update_icon()
	..() // To get the edges.

	icon_state = under_state // This isn't set at compile time in order for it to show as water in the map editor.
	var/image/acid_sprite = image(icon = 'icons/turf/outdoors.dmi', icon_state = acid_state, layer = WATER_LAYER)
	add_overlay(acid_sprite)

	update_icon_edge()

/turf/simulated/floor/acid/get_edge_icon_state()
	return "acid_shallow"

/turf/simulated/floor/acid/return_air_for_internal_lifeform(var/mob/living/L)
	if(L && L.lying)
		if(L.can_breathe_water()) // For squid.
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			var/amount = 300
			water_breath.adjust_gas(/datum/gas/oxygen, amount) // Assuming water breathes just extract the oxygen directly from the water.
			water_breath.temperature = above_air.temperature
			return water_breath
		else
			var/gasid = /datum/gas/carbon_dioxide
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.species && H.species.exhale_type)
					gasid = H.species.exhale_type
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			water_breath.adjust_gas(gasid, BREATH_MOLES) // They have no oxygen, but non-zero moles and temp
			water_breath.temperature = above_air.temperature
			return water_breath
	return return_air() // Otherwise their head is above the water, so get the air from the atmosphere instead.

/turf/simulated/floor/acid/Entered(atom/movable/AM)
	..()
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/floor/acid/hitby(atom/movable/AM)
	if(burn_stuff(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/floor/acid/process()
	if(!burn_stuff())
		STOP_PROCESSING(SSobj, src)

/turf/simulated/floor/acid/proc/burn_stuff(atom/movable/AM)
	. = FALSE

	var/thing_to_check = src
	if(AM)
		thing_to_check = list(AM)

	for(var/thing in thing_to_check)
		if(isobj(thing))
			var/obj/O = thing
			if(O.throwing)
				continue
			. = TRUE
			O.acid_act()

		else if(isliving(thing))
			var/mob/living/L = thing
			if(L.hovering || L.throwing)
				continue
			. = TRUE
			L.acid_act()

// Tells AI mobs to not suicide by pathing into lava if it would hurt them.
/turf/simulated/floor/acid/is_safe_to_enter(mob/living/L)
	if(!L.hovering)
		return FALSE
	return ..()

/turf/simulated/floor/acid/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_acidsub()
		if(L.check_submerged() <= 0)
			return
		if(!istype(oldloc, /turf/simulated/floor/acid))
			to_chat(L, "<span class='warning'>You get soaked in acid from entering \the [src]!</span>")
	AM.water_act(5)
	..()

/turf/simulated/floor/acid/Exited(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_acidsub()
		if(L.check_submerged() <= 0)
			return
		if(!istype(newloc, /turf/simulated/floor/acid))
			to_chat(L, "<span class='warning'>You climb out of \the [src].</span>")
	..()

/turf/simulated/floor/acid/deep
	name = "deep hissing pool"
	desc = "A body of sickly green liquid. It emanates an acrid stench.  It seems quite deep."
	icon_state = "acid_deep"
	under_state = "abyss"
	edge_blending_priority = -2
	movement_cost = 8
	depth = 2

//Blood
/turf/simulated/floor/blood
	name = "coagulating pool"
	desc = "A body of boiling crimson fluid. It smells like pennies and gasoline. It seems shallow enough to walk through, if needed."
	icon = 'icons/turf/outdoors.dmi'
	icon_state = "acidb_shallow"
	var/blood_state = "acidb_shallow"
	var/under_state = "rock"
	edge_blending_priority = -1
	movement_cost = 4
	outdoors = TRUE

	layer = WATER_FLOOR_LAYER

	can_dirty = FALSE	// It's blood

	var/depth = 1 // Higher numbers indicates deeper water.

/turf/simulated/floor/blood/Initialize()
	. = ..()
	update_icon()

/turf/simulated/floor/blood/update_icon()
	..() // To get the edges.

	icon_state = under_state // This isn't set at compile time in order for it to show as water in the map editor.
	var/image/blood_sprite = image(icon = 'icons/turf/outdoors.dmi', icon_state = blood_state, layer = WATER_LAYER)
	add_overlay(blood_sprite)

	update_icon_edge()

/turf/simulated/floor/water/get_edge_icon_state()
	return "acidb_shallow"

/turf/simulated/floor/blood/return_air_for_internal_lifeform(var/mob/living/L)
	if(L && L.lying)
		if(L.can_breathe_water()) // For squid.
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			var/amount = 300
			water_breath.adjust_gas(/datum/gas/oxygen, amount) // Assuming water breathes just extract the oxygen directly from the water.
			water_breath.temperature = above_air.temperature
			return water_breath
		else
			var/gasid = /datum/gas/carbon_dioxide
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(H.species && H.species.exhale_type)
					gasid = H.species.exhale_type
			var/datum/gas_mixture/water_breath = new()
			var/datum/gas_mixture/above_air = return_air()
			water_breath.adjust_gas(gasid, BREATH_MOLES) // They have no oxygen, but non-zero moles and temp
			water_breath.temperature = above_air.temperature
			return water_breath
	return return_air() // Otherwise their head is above the water, so get the air from the atmosphere instead.

/turf/simulated/floor/blood/Entered(atom/movable/AM)
	..()
	if(blood_wade(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/floor/blood/hitby(atom/movable/AM)
	if(blood_wade(AM))
		START_PROCESSING(SSobj, src)

/turf/simulated/floor/blood/process()
	if(!blood_wade())
		STOP_PROCESSING(SSobj, src)

/turf/simulated/floor/blood/proc/blood_wade(var/mob/living/carbon/human/L, atom/movable/AM)
	. = FALSE

	if(ishuman(L))
		L.bloody_body(src)
		L.bloody_hands(src)

// Tells AI mobs to not suicide by pathing into lava if it would hurt them.
/turf/simulated/floor/blood/is_safe_to_enter(mob/living/L)
	if(!L.hovering)
		return FALSE
	return ..()

/turf/simulated/floor/blood/Entered(atom/movable/AM, atom/oldloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_bloodsub()
		if(L.check_submerged() <= 0)
			return
		if(!istype(oldloc, /turf/simulated/floor/blood))
			to_chat(L, "<span class='warning'>You get covered in blood from entering \the [src]!</span>")
	AM.water_act(5)
	..()

/turf/simulated/floor/blood/Exited(atom/movable/AM, atom/newloc)
	if(istype(AM, /mob/living))
		var/mob/living/L = AM
		L.update_bloodsub()
		if(L.check_submerged() <= 0)
			return
		if(!istype(newloc, /turf/simulated/floor/blood))
			to_chat(L, "<span class='warning'>You climb out of \the [src].</span>")
	..()

/turf/simulated/floor/blood/deep
	name = "deep coagulating pool"
	desc = "A body of crimson fluid. It smells like pennies and gasoline.  It seems quite deep."
	icon_state = "acidb_deep"
	under_state = "abyss"
	edge_blending_priority = -2
	movement_cost = 8
	depth = 2

/turf/simulated/floor/water/indoors //because it's nice to be able to use these indoors without having a blizzard ignore walls and areas.
	outdoors = FALSE

/turf/simulated/floor/water/deep/indoors
	outdoors = FALSE
