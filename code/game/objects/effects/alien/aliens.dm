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
/obj/effect/alien
	name = "alien thing"
	desc = "theres something alien about this"
	icon = 'icons/mob/alien.dmi'

/*
 * Resin
 */
/obj/effect/alien/resin
	name = "resin"
	desc = "Looks like some kind of slimy growth."
	icon_state = "resin"

	density = TRUE
	opacity = TRUE
	anchored = TRUE
	CanAtmosPass = ATMOS_PASS_AIR_BLOCKED
	var/health = 200
	//var/mob/living/affecting = null

/obj/effect/alien/resin/wall
	name = "resin wall"
	desc = "Purple slime solidified into a wall."
	icon_state = "resinwall" //same as resin, but consistency ho!

/obj/effect/alien/resin/membrane
	name = "resin membrane"
	desc = "Purple slime just thin enough to let light pass through."
	icon_state = "resinmembrane"
	opacity = FALSE
	health = 120

/obj/effect/alien/resin/Initialize(mapload)
	. = ..()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = WALL_HEAT_TRANSFER_COEFFICIENT

/obj/effect/alien/resin/Destroy()
	var/turf/T = get_turf(src)
	T.thermal_conductivity = initial(T.thermal_conductivity)
	..()

/obj/effect/alien/resin/proc/healthcheck()
	if(health <=0)
		density = 0
		qdel(src)
	return

/obj/effect/alien/resin/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/effect/alien/resin/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	user.do_attack_animation(src)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/resin/take_damage(var/damage)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/resin/legacy_ex_act(severity)
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

/obj/effect/alien/resin/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	for(var/mob/O in viewers(src, null))
		O.show_message("<span class='danger'>[src] was hit by [AM].</span>", 1)
	var/tforce = 0
	if(ismob(AM))
		tforce = 10
	else
		tforce = AM:throw_force
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	health = max(0, health - tforce)
	healthcheck()

/obj/effect/alien/resin/attack_hand()
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

/obj/effect/alien/resin/attackby(obj/item/W as obj, mob/user as mob)

	user.setClickCooldown(user.get_attack_speed(W))
	var/aforce = W.force
	health = max(0, health - aforce)
	playsound(loc, 'sound/effects/attackblob.ogg', 100, 1)
	healthcheck()
	..()
	return

/obj/effect/alien/resin/CanAllowThrough(atom/movable/mover, turf/target)
	if(!opacity && mover.check_pass_flags(ATOM_PASS_GLASS))
		return TRUE
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

/obj/effect/alien/weeds
	name = "weeds"
	desc = "Weird purple weeds."
	icon_state = "weeds"

	anchored = 1
	density = 0
	plane = TURF_PLANE
	layer = ABOVE_TURF_LAYER
	var/health = 15
	var/obj/effect/alien/weeds/node/linked_node = null
	var/static/list/weedImageCache
	color = "#332342"

/obj/effect/alien/weeds/Destroy()
	var/turf/T = get_turf(src)
	// To not mess up the overlay updates.
	loc = null

	for (var/obj/effect/alien/weeds/W in range(1,T))
		W.updateWeedOverlays()

	linked_node = null
	..()

/obj/effect/alien/weeds/node
	icon_state = "weednode"
	name = "purple sac"
	desc = "Weird purple octopus-like thing."
	layer = ABOVE_TURF_LAYER+0.01
	light_range = NODERANGE
	var/node_range = NODERANGE

	var/set_color = null

/obj/effect/alien/weeds/node/Initialize(mapload)
	. = ..(mapload, src)
	START_PROCESSING(SSobj, src)
	if(color)
		set_color = color

/obj/effect/alien/weeds/node/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/effect/alien/weeds/Initialize(mapload, node)
	. = ..()
	if(istype(loc, /turf/space))
		qdel(src)
		return
	linked_node = node
	if(icon_state == "weeds")
		icon_state = pick("weeds", "weeds1", "weeds2")

	fullUpdateWeedOverlays()

/obj/effect/alien/weeds/proc/updateWeedOverlays()

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
	if(!locate(/obj/effect/alien) in N.contents)
		if(istype(N, /turf/simulated/floor))
			overlays_to_add += weedImageCache[WEED_SOUTH_EDGING]
	if(!locate(/obj/effect/alien) in S.contents)
		if(istype(S, /turf/simulated/floor))
			overlays_to_add += weedImageCache[WEED_NORTH_EDGING]
	if(!locate(/obj/effect/alien) in E.contents)
		if(istype(E, /turf/simulated/floor))
			overlays_to_add += weedImageCache[WEED_WEST_EDGING]
	if(!locate(/obj/effect/alien) in W.contents)
		if(istype(W, /turf/simulated/floor))
			overlays_to_add += weedImageCache[WEED_EAST_EDGING]

	add_overlay(overlays_to_add)

/obj/effect/alien/weeds/proc/fullUpdateWeedOverlays()
	for (var/obj/effect/alien/weeds/W in range(1,src))
		W.updateWeedOverlays()

	return

/obj/effect/alien/weeds/process(delta_time)
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

		if (!istype(T) || T.density || locate(/obj/effect/alien/weeds) in T || istype(T.loc, /area/arrival) || istype(T, /turf/space))
			continue

		if(U.CheckAirBlock(T) == ATMOS_PASS_AIR_BLOCKED)
			continue

		var/obj/effect/E = new /obj/effect/alien/weeds(T, linked_node)

		E.color = color

	if(istype(src, /obj/effect/alien/weeds/node))
		var/obj/effect/alien/weeds/node/N = src
		var/list/nearby_weeds = list()
		for(var/obj/effect/alien/weeds/W in range(N.node_range,src))
			nearby_weeds |= W

		for(var/obj/effect/alien/weeds/W in nearby_weeds)
			if(!W)
				continue

			if(!W.linked_node)
				W.linked_node = src

			W.color = W.linked_node.set_color

			if(W == src)
				continue

			if(prob(max(10, 40 - (5 * nearby_weeds.len))))
				W.process()


/obj/effect/alien/weeds/legacy_ex_act(severity)
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

/obj/effect/alien/weeds/attackby(var/obj/item/W, var/mob/user)
	user.setClickCooldown(user.get_attack_speed(W))
	visible_message("<span class='danger'>\The [src] have been [W.get_attack_verb(src, user)] with \the [W][(user ? " by [user]." : ".")]</span>")

	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(loc, 'sound/items/Welder.ogg', 100, 1)

	health -= damage
	healthcheck()

/obj/effect/alien/weeds/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	user.do_attack_animation(src)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/weeds/take_damage(var/damage)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/weeds/proc/healthcheck()
	if(health <= 0)
		qdel(src)


/obj/effect/alien/weeds/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		health -= 5
		healthcheck()

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
/obj/effect/alien/acid
	name = "acid"
	desc = "Burbling corrossive stuff. I wouldn't want to touch it."
	icon_state = "acid"

	density = 0
	opacity = 0
	anchored = 1

	var/atom/target
	var/ticks = 0
	var/target_strength = 0

/obj/effect/alien/acid/Initialize(mapload, target)
	. = ..()
	src.target = target

	if(isturf(target)) // Turf take twice as long to take down.
		target_strength = 8
	else
		target_strength = 4
	tick()

/obj/effect/alien/acid/proc/tick()
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

/obj/effect/alien/egg
	desc = "It looks like a weird egg"
	name = "egg"
//	icon_state = "egg_growing" // So the egg looks 'grown', even though it's not.
	icon_state = "egg_growing"
	density = 0
	anchored = 1

	var/health = 100
	var/status = GROWING //can be GROWING, GROWN or BURST; all mutually exclusive
/obj/effect/alien/egg/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)
	new /datum/proxfield/basic/square(src, 1)
	spawn(rand(MIN_GROWTH_TIME,MAX_GROWTH_TIME))
		if((status == GROWING) && (BURST == 0))
			Grow()

/obj/effect/alien/egg/attack_hand(user as mob)

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

/obj/effect/alien/egg/proc/GetFacehugger()
	return locate(/obj/item/clothing/mask/facehugger) in contents

/obj/effect/alien/egg/proc/Grow()
	icon_state = "egg"
	status = GROWN
	new /obj/item/clothing/mask/facehugger(src)
	return

/obj/effect/alien/egg/proc/Burst(var/kill = 1) //drops and kills the hugger if any is remaining
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

/obj/effect/alien/egg/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.damage
	..()
	healthcheck()
	return

/obj/effect/alien/egg/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	playsound(src.loc, 'sound/effects/attackblob.ogg', 100, 1)
	user.do_attack_animation(src)
	health -= damage
	healthcheck()
	return

/obj/effect/alien/egg/take_damage(var/damage)
	health -= damage
	healthcheck()
	return


/obj/effect/alien/egg/attackby(var/obj/item/W, var/mob/user)
	if((health <= 0) && (BURST == 0))
		Burst()
		return
	visible_message("<span class='danger'>\The [src] has been [W.get_attack_verb(src, user)] with \the [W][(user ? " by [user]." : ".")]</span>")
	var/damage = W.force / 4.0

	if(istype(W, /obj/item/weldingtool))
		var/obj/item/weldingtool/WT = W

		if(WT.remove_fuel(0, user))
			damage = 15
			playsound(src.loc, 'sound/items/Welder.ogg', 100, 1)

	src.health -= damage
	healthcheck()


/obj/effect/alien/egg/proc/healthcheck()
	if((health <= 0) && (BURST == 0))
		Burst()

/obj/effect/alien/egg/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 500 + T0C)
		health -= 5
		healthcheck()

/*/obj/effect/alien/egg/HasProximity(atom/movable/AM as mob|obj)

	if(status == GROWN)
		if(!CanHug(AM))
			return

		var/mob/living/carbon/C = AM
		if(C.stat == CONSCIOUS && C.status_flags & TRAIT_XENO_HOST)
			return

		Burst(0)*/

/obj/effect/alien/egg/process()
	if(GROWN)
		var/turf/mainloc = get_turf(src)
		for(var/mob/living/A in range(3,mainloc))
			if (CanHug(A))
				Burst(0)
