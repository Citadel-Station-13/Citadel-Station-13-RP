/* This is an attempt to make some easily reusable "particle" type effect, to stop the code
constantly having to be rewritten. An item like the jetpack that uses the ion_trail_follow system, just has one
defined, then set up when it is created with New(). Then this same system can just be reused each time
it needs to create more trails.A beaker could have a steam_trail_follow system set up, then the steam
would spawn and follow the beaker, even if it is carried or thrown.
*/


/obj/effect/particle_effect
	name = "effect"
	icon = 'icons/effects/effects.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	unacidable = TRUE //So effect are not targeted by alien acid.
	pass_flags = ATOM_PASS_TABLE | ATOM_PASS_GRILLE

/datum/effect_system
	var/number = 3
	var/cardinals = 0
	var/turf/location
	var/atom/holder
	var/setup = 0

/datum/effect_system/proc/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc
	setup = 1

/datum/effect_system/proc/attach(atom/atom)
	holder = atom

/datum/effect_system/proc/start()


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
/obj/effect/particle_effect/steam
	name = "steam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "extinguish"
	density = 0

/datum/effect_system/steam_spread

/datum/effect_system/steam_spread/set_up(n = 3, c = 0, turf/loc)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	location = loc

/datum/effect_system/steam_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/particle_effect/steam/steam = new /obj/effect/particle_effect/steam(src.location)
			var/direction
			if(src.cardinals)
				direction = pick(GLOB.cardinal)
			else
				direction = pick(GLOB.alldirs)
			for(i=0, i<pick(1,2,3), i++)
				sleep(5)
				step(steam,direction)
			spawn(20)
				qdel(steam)

/////////////////////////////////////////////
//SPARK SYSTEM (like steam system)
// The attach(atom/atom) proc is optional, and can be called to attach the effect
// to something, like the RCD, so then you can just call start() and the sparks
// will always spawn at the items location.
/////////////////////////////////////////////

/obj/effect/particle_effect/sparks
	name = "sparks"
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"
	var/amount = 6.0
	anchored = 1.0
	mouse_opacity = 0

/obj/effect/particle_effect/sparks/Initialize(mapload)
	. = ..()
	playsound(src, "sparks", 100, 1)
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)
	QDEL_IN(src, 5 SECONDS)

/obj/effect/particle_effect/sparks/Destroy()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)
	return ..()

/obj/effect/particle_effect/sparks/Move()
	..()
	var/turf/T = src.loc
	if (istype(T, /turf))
		T.hotspot_expose(1000,100)
	return

/datum/effect_system/spark_spread
	var/total_sparks = 0 // To stop it being spammed and lagging!

/datum/effect_system/spark_spread/set_up(n = 3, c = 0, loca)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

/datum/effect_system/spark_spread/start()
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_sparks > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/particle_effect/sparks/sparks = new /obj/effect/particle_effect/sparks(src.location)
			src.total_sparks++
			var/direction
			if(src.cardinals)
				direction = pick(GLOB.cardinal)
			else
				direction = pick(GLOB.alldirs)
			for(i=0, i<pick(1,2,3), i++)
				sleep(5)
				step(sparks,direction)
			spawn(20)
				src.total_sparks--



/////////////////////////////////////////////
//// SMOKE SYSTEMS
// direct can be optinally added when set_up, to make the smoke always travel in one direction
// in case you wanted a vent to always smoke north for example
/////////////////////////////////////////////


/obj/effect/particle_effect/smoke
	name = "smoke"
	icon_state = "smoke"
	opacity = 1
	anchored = 0.0
	mouse_opacity = 0
	var/amount = 6.0
	var/time_to_live = 100

	//Remove this bit to use the old smoke
	icon = 'icons/effects/96x96.dmi'
	pixel_x = -32
	pixel_y = -32

/obj/effect/particle_effect/smoke/Initialize(mapload)
	. = ..()
	if(time_to_live)
		QDEL_IN(src, time_to_live)

/obj/effect/particle_effect/smoke/Crossed(mob/living/carbon/M as mob )
	if(M.is_incorporeal())
		return
	..()
	if(istype(M))
		affect(M)

/obj/effect/particle_effect/smoke/proc/affect(var/mob/living/carbon/M)
	if (!istype(M))
		return 0
	if(M.wear_mask && (M.wear_mask.clothing_flags & ALLOWINTERNALS))
		return 0
	if(istype(M,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		if(H.head && (H.head.clothing_flags & ALLOWINTERNALS))
			return 0
	return 1

/////////////////////////////////////////////
// Illumination
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/illumination
	name = "illumination"
	opacity = 0
	icon = 'icons/effects/effects.dmi'
	icon_state = "sparks"

/obj/effect/particle_effect/smoke/illumination/Initialize(mapload, lifetime = 10, range, power, color)
	time_to_live=lifetime
	. = ..(mapload)
	set_light(range, power, color)

/////////////////////////////////////////////
// Bad smoke
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/bad
	time_to_live = 600
	//var/list/projectiles

/obj/effect/particle_effect/smoke/bad/Move()
	..()
	for(var/mob/living/L in get_turf(src))
		affect(L)

/obj/effect/particle_effect/smoke/bad/affect(var/mob/living/L)
	if (!..())
		return 0
	if(L.needs_to_breathe())
		L.adjustOxyLoss(1)
		if(prob(25))
			L.emote("cough")

/* Not feasile until a later date
/obj/effect/particle_effect/smoke/bad/Crossed(atom/movable/M as mob|obj)
	..()
	if(istype(M, /obj/item/projectile/beam))
		var/obj/item/projectile/beam/B = M
		if(!(B in projectiles))
			B.damage = (B.damage/2)
			projectiles += B
			destroyed_event.register(B, src, /obj/effect/particle_effect/smoke/bad/proc/on_projectile_delete)
		to_chat(world, "Damage is: [B.damage]")
	return 1

/obj/effect/particle_effect/smoke/bad/proc/on_projectile_delete(obj/item/projectile/beam/proj)
	projectiles -= proj
*/

/////////////////////////////////////////////
// 'Elemental' smoke
/////////////////////////////////////////////

/obj/effect/particle_effect/smoke/elemental
	name = "cloud"
	desc = "A cloud of some kind that seems really generic and boring."
	opacity = FALSE
	var/strength = 5 // How much damage to do inside each affect()

/obj/effect/particle_effect/smoke/elemental/Initialize(mapload)
	START_PROCESSING(SSobj, src)
	return ..()

/obj/effect/particle_effect/smoke/elemental/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/particle_effect/smoke/elemental/Move()
	..()
	for(var/mob/living/L in range(1, src))
		affect(L)

/obj/effect/particle_effect/smoke/elemental/process(delta_time)
	for(var/mob/living/L in range(1, src))
		affect(L)


/obj/effect/particle_effect/smoke/elemental/fire
	name = "burning cloud"
	desc = "A cloud of something that is on fire."
	color = "#FF9933"
	light_color = "#FF0000"
	light_range = 2
	light_power = 5

/obj/effect/particle_effect/smoke/elemental/fire/affect(mob/living/L)
	L.inflict_heat_damage(strength)
	L.add_modifier(/datum/modifier/fire, 6 SECONDS) // Around 15 damage per stack.

/obj/effect/particle_effect/smoke/elemental/frost
	name = "freezing cloud"
	desc = "A cloud filled with brutally cold mist."
	color = "#00CCFF"

/obj/effect/particle_effect/smoke/elemental/frost/affect(mob/living/L)
	L.inflict_cold_damage(strength)

/obj/effect/particle_effect/smoke/elemental/shock
	name = "charged cloud"
	desc = "A cloud charged with electricity."
	color = "#4D4D4D"

/obj/effect/particle_effect/smoke/elemental/shock/affect(mob/living/L)
	L.inflict_shock_damage(strength)

/obj/effect/particle_effect/smoke/elemental/mist
	name = "misty cloud"
	desc = "A cloud filled with water vapor."
	color = "#CCFFFF"
	alpha = 128
	strength = 1

/obj/effect/particle_effect/smoke/elemental/mist/affect(mob/living/L)
	L.water_act(strength)

/////////////////////////////////////////////
// Smoke spread
/////////////////////////////////////////////

/datum/effect_system/smoke_spread
	var/total_smoke = 0 // To stop it being spammed and lagging!
	var/direction
	var/smoke_type = /obj/effect/particle_effect/smoke

/datum/effect_system/smoke_spread/set_up(n = 5, c = 0, loca, direct)
	if(n > 10)
		n = 10
	number = n
	cardinals = c
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	if(direct)
		direction = direct

/datum/effect_system/smoke_spread/start(var/I)
	var/i = 0
	for(i=0, i<src.number, i++)
		if(src.total_smoke > 20)
			return
		spawn(0)
			if(holder)
				src.location = get_turf(holder)
			var/obj/effect/particle_effect/smoke/smoke = new smoke_type(src.location)
			src.total_smoke++
			if(I)
				smoke.color = I
			var/direction = src.direction
			if(!direction)
				if(src.cardinals)
					direction = pick(GLOB.cardinal)
				else
					direction = pick(GLOB.alldirs)
			for(i=0, i<pick(0,1,1,1,2,2,2,3), i++)
				sleep(10)
				step(smoke,direction)
			spawn(smoke.time_to_live*0.75+rand(10,30))
				if (smoke) qdel(smoke)
				src.total_smoke--

/datum/effect_system/smoke_spread/bad
	smoke_type = /obj/effect/particle_effect/smoke/bad

/datum/effect_system/smoke_spread/fire
	smoke_type = /obj/effect/particle_effect/smoke/elemental/fire

/datum/effect_system/smoke_spread/frost
	smoke_type = /obj/effect/particle_effect/smoke/elemental/frost

/datum/effect_system/smoke_spread/shock
	smoke_type = /obj/effect/particle_effect/smoke/elemental/shock

/datum/effect_system/smoke_spread/mist
	smoke_type = /obj/effect/particle_effect/smoke/elemental/mist

/////////////////////////////////////////////
//////// Attach an Ion trail to any object, that spawns when it moves (like for the jetpack)
/// just pass in the object to attach it to in set_up
/// Then do start() to start it and stop() to stop it, obviously
/// and don't call start() in a loop that will be repeated otherwise it'll get spammed!
/////////////////////////////////////////////

/obj/effect/particle_effect/ion_trails
	name = "ion trails"
	icon_state = "ion_trails"
	anchored = 1.0

/datum/effect_system/ion_trail_follow
	var/turf/oldposition
	var/on = TRUE

/datum/effect_system/ion_trail_follow/Destroy()
	stop()
	return ..()

/datum/effect_system/ion_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect_system/ion_trail_follow/start()
	if(on)
		return
	if(!ismovable(holder))
		return
	START_PROCESSING(SSfastprocess, src)
	on = TRUE

/datum/effect_system/ion_trail_follow/process(wait)
	var/turf/current = get_turf(holder)
	if(current != oldposition)
		if(isturf(current))
			var/obj/effect/particle_effect/ion_trails/I = new /obj/effect/particle_effect/ion_trails(oldposition)
			oldposition = current
			I.setDir(src.holder.dir)
			flick("ion_fade", I)
			I.icon_state = null
			QDEL_IN(I, 20)

/datum/effect_system/ion_trail_follow/proc/stop()
	if(!on)
		return
	oldposition = null
	on = FALSE
	STOP_PROCESSING(SSfastprocess, src)

/////////////////////////////////////////////
//////// Attach a steam trail to an object (eg. a reacting beaker) that will follow it
// even if it's carried of thrown.
/////////////////////////////////////////////

/datum/effect_system/steam_trail_follow
	var/turf/oldposition
	var/processing = 1
	var/on = 1

/datum/effect_system/steam_trail_follow/set_up(atom/atom)
	attach(atom)
	oldposition = get_turf(atom)

/datum/effect_system/steam_trail_follow/start()
	if(!src.on)
		src.on = 1
		src.processing = 1
	if(src.processing)
		src.processing = 0
		spawn(0)
			if(src.number < 3)
				var/obj/effect/particle_effect/steam/I = new /obj/effect/particle_effect/steam(src.oldposition)
				src.number++
				src.oldposition = get_turf(holder)
				I.setDir(src.holder.dir)
				spawn(10)
					qdel(I)
					src.number--
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()
			else
				spawn(2)
					if(src.on)
						src.processing = 1
						src.start()

/datum/effect_system/steam_trail_follow/proc/stop()
	src.processing = 0
	src.on = 0

/datum/effect_system/reagents_explosion
	/// TNT equivalent.
	var/amount
	/// Does explosion creates flash effect?
	var/flashing = 0
	/// Factor of how powerful the flash effect relatively to the explosion.
	var/flashing_factor = 0

/datum/effect_system/reagents_explosion/set_up (amt, loc, flash = 0, flash_fact = 0)
	amount = amt
	if(istype(loc, /turf/))
		location = loc
	else
		location = get_turf(loc)

	flashing = flash
	flashing_factor = flash_fact

	return

/datum/effect_system/reagents_explosion/start()
	if (amount <= 2)
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread()
		s.set_up(2, 1, location)
		s.start()

		for(var/mob/M in viewers(5, location))
			to_chat(M, "<span class='warning'>The solution violently explodes.</span>")
		for(var/mob/M in viewers(1, location))
			if (prob (50 * amount))
				to_chat(M, "<span class='warning'>The explosion knocks you down.</span>")
				M.Weaken(rand(1,5))
		return
	else
		var/devst = -1
		var/heavy = -1
		var/light = -1
		var/flash = -1

		// Clamp all values to fractions of max_explosion_range, following the same pattern as for tank transfer bombs
		if (round(amount/12) > 0)
			devst = devst + amount/12

		if (round(amount/6) > 0)
			heavy = heavy + amount/6

		if (round(amount/3) > 0)
			light = light + amount/3

		if (flashing && flashing_factor)
			flash = (amount/4) * flashing_factor

		for(var/mob/M in viewers(8, location))
			to_chat(M, "<span class='warning'>The solution violently explodes.</span>")

		explosion(
			location,
			round(min(devst, BOMBCAP_DVSTN_RADIUS)),
			round(min(heavy, BOMBCAP_HEAVY_RADIUS)),
			round(min(light, BOMBCAP_LIGHT_RADIUS)),
			round(min(flash, BOMBCAP_FLASH_RADIUS)),
		)

/obj/effect/teleport_greyscale
	name = "teleportation"
	icon_state = "teleport_greyscale"
	anchored = 1
	mouse_opacity = 0
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER

/obj/effect/teleport_greyscale/Initialize(mapload)
	. = ..()
	QDEL_IN(src, 2 SECONDS)

/datum/effect_system/teleport_greyscale
	var/color = "#FFFFFF"

/datum/effect_system/teleport_greyscale/set_up(cl, loca)
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)
	color = cl

/datum/effect_system/teleport_greyscale/start()
	var/obj/effect/teleport_greyscale/tele = new /obj/effect/teleport_greyscale(src.location)
	tele.color = color
