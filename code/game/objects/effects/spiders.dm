//generic procs copied from obj/structure/alien
/obj/effect/spider
	name = "web"
	desc = "it's stringy and sticky"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	density = FALSE
	integrity_enabled = TRUE
	obj_flags = OBJ_MELEE_TARGETABLE | OBJ_RANGE_TARGETABLE
	integrity = 15
	integrity_max = 15
	armor_type = /datum/armor/none

/obj/effect/spider/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(exposed_temperature > 300 + T0C)
		damage_integrity(5)

/obj/effect/spider/melee_act(mob/user, obj/item/weapon, target_zone, mult)
	if(weapon.damtype == BURN)
		mult *= 2
	return ..()

/obj/effect/spider/stickyweb
	icon_state = "stickyweb1"

/obj/effect/spider/stickyweb/Initialize(mapload)
	if(prob(50))
		icon_state = "stickyweb2"
	return ..()

/obj/effect/spider/stickyweb/CanAllowThrough(atom/movable/mover, turf/target)
	. = ..()
	if(istype(mover, /mob/living/simple_mob/animal/giant_spider))
		return TRUE
	else if(istype(mover, /mob/living))
		if(prob(50))
			to_chat(mover, SPAN_WARNING( "You get stuck in \the [src] for a moment."))
			return FALSE
	else if(istype(mover, /obj/projectile))
		return prob(30)
	return TRUE

/obj/effect/spider/eggcluster
	name = "egg cluster"
	desc = "They seem to pulse slightly with an inner life"
	icon_state = "eggs"
	var/amount_grown = 0
	var/spiders_min = 6
	var/spiders_max = 24
	var/spider_type = /obj/effect/spider/spiderling

/obj/effect/spider/eggcluster/Initialize(mapload)
	pixel_x = rand(3,-3)
	pixel_y = rand(3,-3)
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/spider/eggcluster/Initialize(mapload, atom/parent)
	. = ..()
	get_light_and_color(parent)

/obj/effect/spider/eggcluster/Destroy()
	STOP_PROCESSING(SSobj, src)
	if(istype(loc, /obj/item/organ/external))
		var/obj/item/organ/external/O = loc
		O.implants -= src

	return ..()

/obj/effect/spider/eggcluster/process(delta_time)
	amount_grown += rand(0,2)
	if(amount_grown >= 100)
		var/num = rand(spiders_min, spiders_max)
		var/obj/item/organ/external/O = null
		if(istype(loc, /obj/item/organ/external))
			O = loc

		for(var/i=0, i<num, i++)
			var/spiderling = new spider_type(src.loc, src)
			if(O)
				O.implants += spiderling
		qdel(src)

/obj/effect/spider/eggcluster/small
	spiders_min = 1
	spiders_max = 3

/obj/effect/spider/eggcluster/small/frost
	spider_type = /obj/effect/spider/spiderling/frost

/obj/effect/spider/spiderling
	name = "spiderling"
	desc = "It never stays still for long."
	icon_state = "spiderling"
	anchored = 0
	layer = HIDING_LAYER
	integrity = 5
	integrity_max = 5
	var/last_itch = 0
	var/amount_grown = -1
	var/obj/machinery/atmospherics/component/unary/vent_pump/entry_vent
	var/travelling_in_vent = 0
	var/list/grow_as = list(/mob/living/simple_mob/animal/giant_spider, /mob/living/simple_mob/animal/giant_spider/nurse, /mob/living/simple_mob/animal/giant_spider/hunter)

	var/stunted = FALSE

/obj/effect/spider/spiderling/frost
	grow_as = list(/mob/living/simple_mob/animal/giant_spider/frost)

/obj/effect/spider/spiderling/Initialize(mapload, atom/parent)
	. = ..()
	pixel_x = rand(6,-6)
	pixel_y = rand(6,-6)
	START_PROCESSING(SSobj, src)
	//50% chance to grow up
	if(prob(50))
		amount_grown = 1
	get_light_and_color(parent)

/obj/effect/spider/spiderling/Destroy()
	STOP_PROCESSING(SSobj, src)
	walk(src, 0) // Because we might have called walk_to, we must stop the walk loop or BYOND keeps an internal reference to us forever.
	return ..()

/obj/effect/spider/spiderling/Bump(atom/A)
	. = ..()
	if(istype(A, /obj/structure/table))
		var/still_here = loc
		spawn(0)
			// todo: remove this shit
			if(QDELETED(src))
				return
			if(loc == still_here)
				forceMove(A.loc)

/obj/effect/spider/spiderling/atom_destruction()
	visible_message("<span class='alert'>[src] dies!</span>")
	new /obj/effect/debris/cleanable/spiderling_remains(src.loc)
	return ..()

/obj/effect/spider/spiderling/process(delta_time)
	if(travelling_in_vent)
		if(istype(src.loc, /turf))
			travelling_in_vent = 0
			entry_vent = null
	else if(entry_vent)
		if(get_dist(src, entry_vent) <= 1)
			var/obj/machinery/atmospherics/component/unary/vent_pump/exit_vent = get_safe_ventcrawl_target(entry_vent)
			if(!exit_vent)
				return
			spawn(rand(20,60))
				// todo: remove this shit
				if(QDELETED(src))
					return
				loc = exit_vent
				var/travel_time = round(get_dist(loc, exit_vent.loc) / 2)
				spawn(travel_time)
					// todo: remove this shit
					if(QDELETED(src))
						return

					if(!exit_vent || exit_vent.welded)
						loc = entry_vent
						entry_vent = null
						return

					if(prob(50))
						src.visible_message("<span class='notice'>You hear something squeezing through the ventilation ducts.</span>",2)
					sleep(travel_time)
					// todo: remove this shit
					if(QDELETED(src))
						return

					if(!exit_vent || exit_vent.welded)
						loc = entry_vent
						entry_vent = null
						return
					loc = exit_vent.loc
					entry_vent = null
					var/area/new_area = get_area(loc)
					if(new_area)
						new_area.Entered(src)

	if(isturf(loc))
		skitter()

	else if(isorgan(loc))
		if(amount_grown < 0) amount_grown = 1
		var/obj/item/organ/external/O = loc
		if(!O.owner || O.owner.stat == DEAD || amount_grown > 80)
			O.implants -= src
			src.loc = O.owner ? O.owner.loc : O.loc
			src.visible_message("<span class='warning'>\A [src] makes its way out of [O.owner ? "[O.owner]'s [O.name]" : "\the [O]"]!</span>")
			if(O.owner)
				O.owner.apply_damage(1, BRUTE, O.organ_tag)
		else if(prob(1))
			O.owner.apply_damage(1, TOX, O.organ_tag)
			if(world.time > last_itch + 30 SECONDS)
				last_itch = world.time
				to_chat(O.owner, "<span class='notice'>Your [O.name] itches...</span>")
	else if(prob(1))
		src.visible_message("<span class='notice'>\The [src] skitters.</span>")

	if(amount_grown >= 0)
		amount_grown += rand(0,2)

/obj/effect/spider/spiderling/proc/skitter()
	if(isturf(loc))
		if(prob(25))
			var/list/nearby = trange(5, src) - loc
			if(nearby.len)
				var/target_atom = pick(nearby)
				walk_to(src, target_atom, 5)
				if(prob(25))
					src.visible_message("<span class='notice'>\The [src] skitters[pick(" away"," around","")].</span>")
		else if(prob(5))
			//vent crawl!
			for(var/obj/machinery/atmospherics/component/unary/vent_pump/v in view(7,src))
				if(!v.welded)
					entry_vent = v
					walk_to(src, entry_vent, 5)
					break
		if(amount_grown >= 100)
			var/spawn_type = pick(grow_as)
			var/mob/living/simple_mob/animal/giant_spider/GS = new spawn_type(src.loc, src)
			if(stunted)
				spawn(2)
					// todo: remove this shit
					if(QDELETED(src))
						return
					GS.make_spiderling()
			qdel(src)

//Rather than kneecap all spiderlings, I figure I'll just make a spiderling cousin that doesn't have the ability.
/obj/effect/spider/spiderling/no_crawl

/obj/effect/spider/spiderling/no_crawl/skitter()
	if(isturf(loc))
		if(prob(25))
			var/list/nearby = trange(5, src) - loc
			if(nearby.len)
				var/target_atom = pick(nearby)
				walk_to(src, target_atom, 5)
				if(prob(25))
					src.visible_message("<span class='notice'>\The [src] skitters[pick(" away"," around","")].</span>")
		else if(prob(0))
			//vent crawl!
			for(var/obj/machinery/atmospherics/component/unary/vent_pump/v in view(7,src))
				if(!v.welded)
					entry_vent = v
					walk_to(src, entry_vent, 5)
					break
		if(amount_grown >= 100)
			var/spawn_type = pick(grow_as)
			var/mob/living/simple_mob/animal/giant_spider/GS = new spawn_type(src.loc, src)
			if(stunted)
				spawn(2)
					// todo: remove this shit
					if(QDELETED(src))
						return
					GS.make_spiderling()
			qdel(src)


/obj/effect/spider/spiderling/stunted
	stunted = TRUE

	grow_as = list(/mob/living/simple_mob/animal/giant_spider, /mob/living/simple_mob/animal/giant_spider/hunter)

/obj/effect/debris/cleanable/spiderling_remains
	name = "spiderling remains"
	desc = "Green squishy mess."
	icon = 'icons/effects/effects.dmi'
	icon_state = "greenshatter"

/obj/effect/spider/cocoon
	name = "cocoon"
	desc = "Something wrapped in silky spider web"
	icon_state = "cocoon1"
	integrity = 30
	integrity_max = 30

/obj/effect/spider/cocoon/Initialize(mapload)
	. = ..()
	icon_state = pick("cocoon1","cocoon2","cocoon3")

/obj/effect/spider/cocoon/Destroy()
	src.visible_message("<span class='warning'>\The [src] splits open.</span>")
	for(var/atom/movable/A in contents)
		A.loc = src.loc
	return ..()
