/* This is an attempt to make some easily reusable "particle" type effect, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the trail_follow/ion system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/


/obj/effect/effect
	name = "particle_effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pass_flags = PASSTABLE | PASSGRILLE
	anchored = TRUE
	unacidable = TRUE //So effect are not targeted by alien acid.

/datum/effect_system
	var/number = 3
	var/cardinals = FALSE
	var/turf/location
	var/atom/holder
	var/effect_type
	var/total_effects = 0
	var/autocleanup = FALSE //will delete itself after use

/datum/effect_system/Destroy()
	holder = null
	location = null
	return ..()

/datum/effect_system/proc/set_up(n = 3, c = FALSE, loca)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)

/datum/effect_system/proc/attach(atom/atom)
	holder = atom

/datum/effect_system/proc/start()
	if(QDELETED(src))
		return
	for(var/i in 1 to number)
		if(total_effects > 20)
			return
		INVOKE_ASYNC(src, .proc/generate_effect)

/datum/effect_system/proc/generate_effect()
	if(holder)
		location = get_turf(holder)
	if(location.contents.len > 200)		//Bandaid to prevent server crash exploit
		return
	var/obj/effect/E = new effect_type(location)
	total_effects++
	var/direction
	if(cardinals)
		direction = pick(GLOB.cardinals)
	else
		direction = pick(GLOB.alldirs)
	var/steps_amt = pick(1,2,3)
	for(var/j in 1 to steps_amt)
		addtimer(CALLBACK(GLOBAL_PROC, .proc/_step, E, direction), 5)  //kev said it works

	if(!QDELETED(src))
		addtimer(CALLBACK(src, .proc/decrement_total_effect), 2 SECONDS)

/datum/effect_system/proc/decrement_total_effect()
	total_effects--
	if(autocleanup && total_effects <= 0)
		qdel(src)


/////////////////////////////////////////////
// GENERIC STEAM SPREAD SYSTEM

//Usage: set_up(number of bits of steam, use North/South/East/West only, spawn location)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like a smoking beaker, so then you can just call start() and the steam
// will always spawn at the items location, even if it's moved.

/* Example:
var/datum/effect/system/steam_spread/steam = new /datum/effect/system/steam_spread() -- creates new system
steam.set_up(5, 0, mob.loc) -- sets up variables
OPTIONAL: steam.attach(mob)
steam.start() -- spawns the effect
*/
/////////////////////////////////////////////
/obj/effect/effect/steam
	name = "steam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	layer = FLY_LAYER
	density = FALSE

/datum/effect_system/steam_spread
	autocleanup = TRUE //maybe? because it calls qdel on itself within 2 SECONDS
	effect_type = /obj/effect/effect/steam

// no need for those other ones, parent proc already handles it

/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////
/*
 *  n - number of sparks
 *  c - cardinals, bool, do the sparks only move in cardinal directions?
 *  source - source of the sparks.
 */
/proc/do_sparks(n, c, source)
	var/datum/effect_system/spark_spread/sparks = new
	sparks.set_up(n, c, source)
	sparks.autocleanup = TRUE
	sparks.start()

/obj/effect/effect/sparks
	name = "sparks"
	icon_state = "sparks"
	light_power = 1.3
	light_range = 2//MINIMUM_USEFUL_LIGHT_RANGE
	light_color = LIGHT_COLOR_FIRE

/obj/effect/effect/sparks/Initialize()
	. = ..()
	flick(icon_state, src) // replay the animation
	playsound(src, "sparks", 100, TRUE)
	var/turf/T = loc
	if(isturf(T))
		T.hotspot_expose(1000, 100) //tg numbers are '700, 5'
	QDEL_IN(src, 2 SECONDS)

/obj/effect/effect/sparks/Destroy()
	var/turf/T = loc
	if(isturf(T))
		T.hotspot_expose(1000, 100) //same with here, but arg 2 is 1
	return ..()

/obj/effect/effect/sparks/Move()
	..()
	var/turf/T = loc
	if(isturf(T))
		T.hotspot_expose(1000, 100) //ditto
	return

/datum/effect_system/spark_spread
	effect_type = /obj/effect/effect/sparks

/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////

/obj/effect/effect/smoke
	name = "smoke"
	icon = 'icons/effects/96x96.dmi' //Remove this bit to use the old smoke
	icon_state = "smoke"
	pixel_x = -32
	pixel_y = -32
	opacity = TRUE
	//anchored = FALSE //uhh, why?
	layer = FLY_LAYER
	animate_movement = 0
	var/amount = 6 // it was 6
	var/lifetime = 5 // old ttl => var/time_to_live = 100
	var/opaque = TRUE //whether the smoke can block the view when in enough amount

/obj/effect/effect/smoke/proc/fade_out(frames = 16)
	if(alpha == 0) //Handle already transparent case
		return
	if(frames == 0)
		frames = 1 //We will just assume that by 0 frames, the coder meant "during one frame".
	var/step = alpha / frames
	for(var/i = 0, i < frames, i++)
		alpha -= step
		if(alpha < 160)
			set_opacity(FALSE) //if we were blocking view, we aren't now because we're fading out
		stoplag() //stops the lag (no it does not)

/obj/effect/effect/smoke/Initialize()
	. = ..()
	//create_reagents(500, NONE, NO_REAGENTS_VALUE)
	START_PROCESSING(SSobj, src)

/obj/effect/effect/smoke/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/effect/smoke/proc/kill_smoke()
	STOP_PROCESSING(SSobj, src)
	INVOKE_ASYNC(src, .proc/fade_out)
	QDEL_IN(src, 1 SECONDS)

/obj/effect/effect/smoke/process()
	lifetime--
	if(lifetime < 1)
		kill_smoke()
		return FALSE
	for(var/mob/living/carbon/L in range(0, src)) //mob in smoke?
		smoke_mob(L) //dump it
	return TRUE

/obj/effect/effect/smoke/proc/smoke_mob(mob/living/carbon/C)
	if(!istype(C))
		return FALSE
	if(lifetime < 1)
		return FALSE
	if(C.internal != null)// || C.has_smoke_protection())
		return FALSE
	if(C.wear_mask && CHECK_BITFIELD(C.wear_mask.item_flags, AIRTIGHT)) //basicaly 'has_smoke_protection'
		return FALSE
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(H.head && CHECK_BITFIELD(H.head.item_flags, AIRTIGHT))
			return FALSE
	//if(C.smoke_delay)
	//	return FALSE
	//C.smoke_delay++
	//addtimer(CALLBACK(src, .proc/remove_smoke_delay, C), 10) // Not implemented
	return TRUE

/obj/effect/effect/smoke/proc/spread_smoke() //proper smoke spread
	var/turf/t_loc = get_turf(src)
	if(!t_loc)
		return
	var/list/newsmokes = list()
	for(var/turf/simulated/T in orange(1, t_loc)) //*scream
		var/obj/effect/effect/smoke/foundsmoke = locate() in T //Don't spread smoke where there's already smoke!
		if(foundsmoke)
			continue
		for(var/mob/living/L in T)
			smoke_mob(L)
		var/obj/effect/effect/smoke/S = new type(T)
		//reagents.copy_to(S, reagents.total_volume)
		S.setDir(pick(GLOB.cardinals))
		S.amount = amount - 1 //the range!
		S.add_atom_colour(color, FIXED_COLOUR_PRIORITY)
		S.lifetime = lifetime
		if(S.amount > 0)
			if(opaque)
				S.set_opacity(TRUE)
			newsmokes.Add(S)

	if(newsmokes.len)
		spawn(1) //the smoke spreads rapidly but not instantly
			for(var/obj/effect/effect/smoke/SM in newsmokes)
				SM.spread_smoke()
/* th datum*/
/datum/effect_system/smoke_spread
	var/amount = 10
	effect_type = /obj/effect/effect/smoke

/datum/effect_system/smoke_spread/set_up(radius = 5, c = FALSE, loca, direct)
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)
	amount = radius
	cardinals = c

/datum/effect_system/smoke_spread/start()
	if(holder)
		location = get_turf(holder)
	var/obj/effect/effect/smoke/S = new effect_type(location)
	S.amount = amount
	if(S.amount)
		S.spread_smoke()

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/bad
	lifetime = 30 // 600 ttl, 8 in tg (600/10/2)

/obj/effect/effect/smoke/bad/smoke_mob(mob/living/carbon/M)
	if(..())
		if(M.needs_to_breathe())
			M.adjustOxyLoss(1)
			if(prob(25)) //no timeout yet, so this is needed
				M.emote("cough")

/obj/effect/effect/smoke/bad/CanPass(atom/movable/mover, turf/target) //Crossed()
	if(istype(mover, /obj/item/projectile/beam))
		var/obj/item/projectile/beam/B = mover
		B.damage = (B.damage / 2)
	return TRUE

/datum/effect_system/smoke_spread/bad
	effect_type = /obj/effect/effect/smoke/bad

/////////////////////////////////////////////
// 'Elemental' smoke
/////////////////////////////////////////////

/obj/effect/effect/smoke/elemental
	name = "cloud"
	desc = "A cloud of some kind that seems really generic and boring."
	opacity = FALSE
	var/strength = 5 // How much damage to do inside each affect()

/obj/effect/effect/smoke/elemental/fire
	name = "burning cloud"
	desc = "A cloud of something that is on fire."
	color = "#FF9933"
	light_color = "#FF0000"
	light_range = 2
	light_power = 5

/obj/effect/effect/smoke/elemental/fire/smoke_mob(mob/living/carbon/M)
	if(..())
		M.inflict_heat_damage(strength)
		M.add_modifier(/datum/modifier/fire, 6 SECONDS) // Around 15 damage per stack.

/datum/effect_system/smoke_spread/fire
	effect_type = /obj/effect/effect/smoke/elemental/fire

/obj/effect/effect/smoke/elemental/frost
	name = "freezing cloud"
	desc = "A cloud filled with brutally cold mist."
	color = "#00CCFF"

/obj/effect/effect/smoke/elemental/frost/smoke_mob(mob/living/carbon/M)
	if(..())
		M.inflict_cold_damage(strength)

/datum/effect_system/smoke_spread/frost
	effect_type = /obj/effect/effect/smoke/elemental/frost

/obj/effect/effect/smoke/elemental/shock
	name = "charged cloud"
	desc = "A cloud charged with electricity."
	color = "#4D4D4D"

/obj/effect/effect/smoke/elemental/shock/smoke_mob(mob/living/carbon/M)
	if(..())
		M.inflict_shock_damage(strength)

/datum/effect_system/smoke_spread/shock
	effect_type = /obj/effect/effect/smoke/elemental/shock

/obj/effect/effect/smoke/elemental/mist
	name = "misty cloud"
	desc = "A cloud filled with water vapor."
	color = "#CCFFFF"
	alpha = 128
	strength = 1

/obj/effect/effect/smoke/elemental/mist/smoke_mob(mob/living/carbon/M)
	if(..())
		M.water_act(strength)

/datum/effect_system/smoke_spread/mist
	effect_type = /obj/effect/effect/smoke/elemental/mist

/////////////////////////////////////////////
// Illumination
// Whyy??
/////////////////////////////////////////////

/obj/effect/effect/smoke/illumination
	name = "illumination"
	opacity = 0
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"

/obj/effect/effect/smoke/illumination/Initialize(locparam, lifetime = 10, range = null, power = null, color = null)
	src.lifetime = lifetime
	..()
	set_light(range, power, color)

/////////////////////////////////////////////
//////// Attach a trail to any object, that spawns when it moves (like for the jetpack)
/// just pass in the object to attach it to in set_up
/// Then do start() to start it and stop() to stop it, obviously
/// and don't call start() in a loop that will be repeated otherwise it'll get spammed!
/////////////////////////////////////////////

/datum/effect_system/trail_follow
	var/turf/oldposition
	var/active = FALSE
	var/allow_overlap = FALSE
	var/auto_process = TRUE
	var/qdel_in_time = 10
	var/fadetype = "ion_fade"
	var/fade = TRUE
	var/nograv_required = FALSE

/datum/effect_system/trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect_system/trail_follow/Destroy()
	oldposition = null
	stop()
	return ..()

/datum/effect_system/trail_follow/proc/stop()
	oldposition = null
	STOP_PROCESSING(SSfastprocess, src)
	active = FALSE
	return TRUE

/datum/effect_system/trail_follow/start()
	oldposition = get_turf(holder)
	if(!check_conditions())
		return FALSE
	if(auto_process)
		START_PROCESSING(SSfastprocess, src)
	active = TRUE
	return TRUE

/datum/effect_system/trail_follow/process()
	generate_effect()

/datum/effect_system/trail_follow/generate_effect()
	if(!check_conditions())
		return stop()
	if(oldposition && !(oldposition == get_turf(holder)))
		if(!oldposition.has_gravity() || !nograv_required) // it does exist.
			var/obj/effect/effect/E = new effect_type(oldposition)
			set_dir(E)
			if(fade)
				flick(fadetype, E)
				E.icon_state = ""
			if(qdel_in_time)
				QDEL_IN(E, qdel_in_time)
	oldposition = get_turf(holder)

/datum/effect_system/trail_follow/proc/check_conditions()
	if(!get_turf(holder))
		return FALSE
	return TRUE

/datum/effect_system/trail_follow/proc/set_dir(obj/effect/effect/ion_trails/I)
	I.setDir(holder.dir)

/obj/effect/effect/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = TRUE

/datum/effect_system/trail_follow/ion
	effect_type = /obj/effect/effect/ion_trails
	//nograv_required = TRUE
	qdel_in_time = 20

/////////////////////////////////////////////
//////// Attach a steam trail to an object (eg. a reacting beaker) that will follow it
// even if it's carried of thrown.
/////////////////////////////////////////////

/datum/effect_system/trail_follow/steam
	effect_type = /obj/effect/effect/steam


/*
/obj/effect/effect/ion_trails/flight
	icon_state = "ion_trails_flight"
*/
//Reagent-based explosion effect

/datum/effect_system/reagents_explosion
	var/amount 						// TNT equivalent
	var/flashing = FALSE				// does explosion creates flash effect?
	var/flashing_factor = 0			// factor of how powerful the flash effect relatively to the explosion
	var/explosion_message = TRUE	//whether we show a message to mobs.

/datum/effect_system/reagents_explosion/set_up(amt, loca, flash = FALSE, flash_fact = 0, message = TRUE)
	amount = amt
	explosion_message = message
	if(isturf(loca))
		location = loca
	else
		location = get_turf(loca)

	flashing = flash
	flashing_factor = flash_fact

/datum/effect_system/reagents_explosion/start()
	if(explosion_message)
		location.visible_message("<span class='danger'>The solution violently explodes!</span>", \
								"<span class='italics'>You hear an explosion!</span>")

	if(amount <= 2)
		do_sparks(2, 1, location)

		for(var/mob/M in viewers(1, location))
			if(prob(50 * amount))
				to_chat(M, "<span class='warning'>The explosion knocks you down.</span>")
				M.Weaken(rand(1, 5))
		return

	else
		var/devst = -1
		var/heavy = -1
		var/light = -1
		var/flash = -1

		// Clamp all values to fractions of max_explosion_range, following the same pattern as for tank transfer bombs
		if(round(amount / 12) > 0)
			devst = devst + (amount / 12)
		if(round(amount / 6) > 0)
			heavy = heavy + (amount / 6)
		if(round(amount / 3) > 0)
			light = light + (amount / 3)
		if(flashing && flashing_factor)
			flash = (amount / 4) * flashing_factor

		explosion(location, 
			round(min(devst, BOMBCAP_DVSTN_RADIUS)), round(min(heavy, BOMBCAP_HEAVY_RADIUS)),
			round(min(light, BOMBCAP_LIGHT_RADIUS)), round(min(flash, BOMBCAP_FLASH_RADIUS))
		)
	//dyn_explosion(location, amount, flashing_factor)
