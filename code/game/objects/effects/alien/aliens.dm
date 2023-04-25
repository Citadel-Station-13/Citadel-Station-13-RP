/* Alien Effects!
 * Contains:
 *		effect/alien
 *		Resin
 *		Weeds
 *		Acid
 *		Egg
 */

/*
 * effect/alien
 */
/obj/structure/alien
	name = "alien thing"
	desc = "theres something alien about this"
	icon = 'icons/mob/alien.dmi'
	hit_sound = 'sound/effects/attackblob.ogg'

/*
 * Resin
 */
/obj/structure/alien/resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "resin"

	density = TRUE
	opacity = TRUE
	anchored = TRUE
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
	integrity = 200
	integrity_max = 200
	//var/mob/living/affecting = null

/obj/structure/alien/resin/wall
	name = "resin wall"
	desc = "Purple slime solidified into a wall."
	icon_state = "resinwall" //same as resin, but consistency ho!

/obj/structure/alien/resin/membrane
	name = "resin membrane"
	desc = "Purple slime just thin enough to let light pass through."
	icon_state = "resinmembrane"
	opacity = FALSE
	integrity = 120
	integrity_max = 120

/obj/structure/alien/resin/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

/obj/structure/alien/resin/Destroy()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = initial(T.thermal_conductivity)
	..()

/obj/structure/alien/resin/attack_hand(mob/user, list/params)
	if(iscarbon(user))
		var/mob/living/carbon/C = user
		if(locate(/obj/item/organ/internal/xenos/hivenode) in C.internal_organs)
			visible_message(SPAN_WARNING("[C] strokes the [name], and it melts away!"))
			qdel(src)
			return CLICKCHAIN_DID_SOMETHING | CLICKCHAIN_DO_NOT_PROPAGATE
	return ..()

/*
 * Weeds
 */
#define NODERANGE 3
#define WEED_NORTH_EDGING "north"
#define WEED_SOUTH_EDGING "south"
#define WEED_EAST_EDGING "east"
#define WEED_WEST_EDGING "west"
#define WEED_NODE_GLOW "glow"
#define WEED_NODE_BASE "nodebase"

/obj/structure/alien/weeds
	name = "weeds"
	desc = "Weird purple weeds."
	icon_state = "weeds"

	anchored = 1
	density = 0
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	integrity = 20
	integrity_max = 20
	var/obj/structure/alien/weeds/node/linked_node = null
	var/static/list/weedImageCache
	color = "#332342"

/obj/structure/alien/weeds/Destroy()
	var/turf/T = get_turf(src)
	// To not mess up the overlay updates.
	loc = null

	for (var/obj/structure/alien/weeds/W in range(1,T))
		W.updateWeedOverlays()

	linked_node = null
	..()

/obj/structure/alien/weeds/node
	icon_state = "weednode"
	name = "purple sac"
	desc = "Weird purple octopus-like thing."
	layer = ABOVE_TURF_LAYER+0.01
	light_range = NODERANGE
	var/node_range = NODERANGE

	var/set_color = null

/obj/structure/alien/weeds/node/Initialize(mapload)
	. = ..(mapload, src)
	START_PROCESSING(SSobj, src)
	if(color)
		set_color = color

/obj/structure/alien/weeds/node/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/structure/alien/weeds/Initialize(mapload, node)
	. = ..()
	if(istype(loc, /turf/space))
		qdel(src)
		return
	linked_node = node
	if(icon_state == "weeds")
		icon_state = pick("weeds", "weeds1", "weeds2")

	fullUpdateWeedOverlays()

/obj/structure/alien/weeds/proc/updateWeedOverlays()

	cut_overlays()
	var/list/overlays_to_add = list()

	if(!weedImageCache || !weedImageCache.len)
		weedImageCache = list()
//		weedImageCache.len = 4
		weedImageCache[WEED_NORTH_EDGING] = image('icons/mob/alien.dmi', "weeds_side_n", layer=2.11, pixel_y = -32)
		weedImageCache[WEED_SOUTH_EDGING] = image('icons/mob/alien.dmi', "weeds_side_s", layer=2.11, pixel_y = 32)
		weedImageCache[WEED_EAST_EDGING] = image('icons/mob/alien.dmi', "weeds_side_e", layer=2.11, pixel_x = -32)
		weedImageCache[WEED_WEST_EDGING] = image('icons/mob/alien.dmi', "weeds_side_w", layer=2.11, pixel_x = 32)

	var/turf/N = get_step(src, NORTH)
	var/turf/S = get_step(src, SOUTH)
	var/turf/E = get_step(src, EAST)
	var/turf/W = get_step(src, WEST)
	if(!locate(/obj/structure/alien) in N.contents)
		if(istype(N, /turf/simulated/floor))
			overlays_to_add += weedImageCache[WEED_SOUTH_EDGING]
	if(!locate(/obj/structure/alien) in S.contents)
		if(istype(S, /turf/simulated/floor))
			overlays_to_add += weedImageCache[WEED_NORTH_EDGING]
	if(!locate(/obj/structure/alien) in E.contents)
		if(istype(E, /turf/simulated/floor))
			overlays_to_add += weedImageCache[WEED_WEST_EDGING]
	if(!locate(/obj/structure/alien) in W.contents)
		if(istype(W, /turf/simulated/floor))
			overlays_to_add += weedImageCache[WEED_EAST_EDGING]

	add_overlay(overlays_to_add)

/obj/structure/alien/weeds/proc/fullUpdateWeedOverlays()
	for (var/obj/structure/alien/weeds/W in range(1,src))
		W.updateWeedOverlays()

	return

/obj/structure/alien/weeds/process(delta_time)
	set background = 1
	var/turf/U = get_turf(src)
/*
	if (locate(/obj/movable, U))
		U = locate(/obj/movable, U)
		if(U.density == 1)
			qdel(src)
			return
Alien plants should do something if theres a lot of poison
	if(U.poison> 200000)
		health -= round(U.poison/200000)
		update()
		return
*/
	if (istype(U, /turf/space))
		qdel(src)
		return

	if(!linked_node || (get_dist(linked_node, src) > linked_node.node_range) )
		return

	if(linked_node != src)
		color = linked_node.set_color

	for(var/dirn in GLOB.cardinal)
		var/turf/T = get_step(src, dirn)

		if (!istype(T) || T.density || locate(/obj/structure/alien/weeds) in T || istype(T.loc, /area/arrival) || istype(T, /turf/space))
			continue

		if(U.CheckAirBlock(T) == ATMOS_PASS_AIR_BLOCKED)
			continue

		var/obj/effect/E = new /obj/structure/alien/weeds(T, linked_node)

		E.color = color

	if(istype(src, /obj/structure/alien/weeds/node))
		var/obj/structure/alien/weeds/node/N = src
		var/list/nearby_weeds = list()
		for(var/obj/structure/alien/weeds/W in range(N.node_range,src))
			nearby_weeds |= W

		for(var/obj/structure/alien/weeds/W in nearby_weeds)
			if(!W)
				continue

			if(!W.linked_node)
				W.linked_node = src

			W.color = W.linked_node.set_color

			if(W == src)
				continue

			if(prob(max(10, 40 - (5 * nearby_weeds.len))))
				W.process()


/obj/structure/alien/weeds/legacy_ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
		if(2.0)
			if (prob(50))
				qdel(src)
		if(3.0)
			if (prob(5))
				qdel(src)
	return

/obj/structure/alien/weeds/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		damage_integrity(5, TRUE)

#undef NODERANGE
#undef WEED_NORTH_EDGING
#undef WEED_SOUTH_EDGING
#undef WEED_EAST_EDGING
#undef WEED_WEST_EDGING
#undef WEED_NODE_GLOW
#undef WEED_NODE_BASE

/*
 * Acid
 */
/obj/structure/alien/acid
	name = "acid"
	desc = "Burbling corrossive stuff. I wouldn't want to touch it."
	icon_state = "acid"

	density = 0
	opacity = 0
	anchored = 1

	var/atom/target
	var/ticks = 0
	var/target_strength = 0

/obj/structure/alien/acid/Initialize(mapload, target)
	. = ..()
	src.target = target

	if(isturf(target)) // Turf take twice as long to take down.
		target_strength = 8
	else
		target_strength = 4
	tick()

/obj/structure/alien/acid/proc/tick()
	if(!target)
		qdel(src)

	ticks += 1

	if(ticks >= target_strength)

		for(var/mob/O in hearers(src, null))
			O.show_message("<span class='green'>[src.target] collapses under its own weight into a puddle of goop and undigested debris!</span>", 1)

		if(istype(target, /turf/simulated/wall)) // I hate turf code.
			var/turf/simulated/wall/W = target
			W.dismantle_wall(1)
		else
			qdel(target)
		qdel(src)
		return

	switch(target_strength - ticks)
		if(6)
			visible_message("<span class='green'>[src.target] is holding up against the acid!</span>")
		if(4)
			visible_message("<span class='green'>[src.target]\s structure is being melted by the acid!</span>")
		if(2)
			visible_message("<span class='green'>[src.target] is struggling to withstand the acid!</span>")
		if(0 to 1)
			visible_message("<span class='green'>[src.target] begins to crumble under the acid!</span>")
	spawn(rand(150, 200)) tick()

/*
 * Egg
 */
/var/const //for the status var
	BURST = 0
	BURSTING = 1
	GROWING = 2
	GROWN = 3

	MIN_GROWTH_TIME = 1800 //time it takes to grow a hugger
	MAX_GROWTH_TIME = 3000

/obj/structure/alien/egg
	desc = "It looks like a weird egg"
	name = "egg"
//	icon_state = "egg_growing" // So the egg looks 'grown', even though it's not.
	icon_state = "egg_growing"
	density = 0
	anchored = 1

	integrity = 140
	integrity_max = 140
	integrity_failure = 40

	var/status = GROWING //can be GROWING, GROWN or BURST; all mutually exclusive

/obj/structure/alien/egg/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	new /datum/proxfield/basic/square(src, 1)
	spawn(rand(MIN_GROWTH_TIME,MAX_GROWTH_TIME))
		if((status == GROWING) && (BURST == 0))
			Grow()

/obj/structure/alien/egg/attack_hand(mob/user, list/params)

	var/mob/living/carbon/M = user
	if(!istype(M) || !(locate(/obj/item/organ/internal/xenos/hivenode) in M.internal_organs))
		return attack_hand(user)

	switch(status)
		if(BURST)
			to_chat(user, "<span class='warning'>You clear the hatched egg.</span>")
			qdel(src)
			return
		if(GROWING)
			to_chat(user, "<span class='warning'>The child is not developed yet.</span>")
			return
		if(GROWN)
			to_chat(user, "<span class='warning'>You retrieve the child.</span>")
			Burst(0)
			return

/obj/structure/alien/egg/proc/GetFacehugger()
	return locate(/obj/item/clothing/mask/facehugger) in contents

/obj/structure/alien/egg/proc/Grow()
	icon_state = "egg"
	status = GROWN
	new /obj/item/clothing/mask/facehugger(src)
	return

/obj/structure/alien/egg/proc/Burst(var/kill = 1) //drops and kills the hugger if any is remaining
	if(status == GROWN || status == GROWING)
		var/obj/item/clothing/mask/facehugger/child = GetFacehugger()
		icon_state = "egg_opened"
		flick("egg_opening", src)
		status = BURSTING
		spawn(15)
			status = BURST
			icon_state = "egg_opened"
			child.loc = get_turf(src)

			if(kill && istype(child))
				child.Die()
			else
				for(var/mob/M in range(1,src))
					if(CanHug(M))
						child.Attach(M)
						break
		return 1

/obj/structure/alien/egg/atom_break()
	. = ..()
	Burst(TRUE)

/obj/structure/alien/egg/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 500 + T0C)
		damage_integrity(5, TRUE)

/*/obj/structure/alien/egg/HasProximity(atom/movable/AM as mob|obj)

	if(status == GROWN)
		if(!CanHug(AM))
			return

		var/mob/living/carbon/C = AM
		if(C.stat == CONSCIOUS && C.status_flags & TRAIT_XENO_HOST)
			return

		Burst(0)*/

/obj/structure/alien/egg/process()
	if(GROWN)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/A in range(3,mainloc))
			if (CanHug(A))
				Burst(0)
