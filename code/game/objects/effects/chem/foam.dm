// Foam
// Similar to smoke, but spreads out more
// metal foams leave behind a foamed metal wall

/**
 * * reagents are handled in a special manner as it's a shared ref.
 */
/obj/effect/foam
	name = "foam"
	icon = 'icons/effects/effects.dmi'
	icon_state = "foam"
	opacity = 0
	anchored = 1
	density = 0
	layer = OBJ_LAYER + 0.9
	mouse_opacity = 0
	animate_movement = 0
	var/amount = 3
	var/expand = 1
	var/metal = 0
	var/dries = 1
	var/slips = 0

	var/datum/reagent_holder/carried_reagents_shared_ref

/obj/effect/foam/Initialize(mapload, ismetal = FALSE)
	. = ..()
	metal = ismetal
	playsound(src, 'sound/effects/bubbles2.ogg', 80, 1, -3)
	if(dries)
		addtimer(CALLBACK(src, PROC_REF(post_spread)), 3 + metal * 3)
		addtimer(CALLBACK(src, PROC_REF(pre_harden)), 12 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(harden)), 15 SECONDS)

/obj/effect/foam/Destroy()
	if(carried_reagents_shared_ref)
		carried_reagents_shared_ref = null
	return ..()

/obj/effect/foam/proc/post_spread()
	process()
	checkReagents()

/obj/effect/foam/proc/pre_harden()
	return
/obj/effect/foam/proc/harden()
	if(metal)
		var/obj/structure/foamedmetal/M = new(src.loc)
		M.metal = metal
		M.updateicon()
	flick("[icon_state]-disolve", src)
	QDEL_IN(src, 5)

/obj/effect/foam/proc/checkReagents() // transfer any reagents to the floor
	if(!metal && carried_reagents_shared_ref)
		var/turf/T = get_turf(src)
		carried_reagents_shared_ref.perform_uniform_contact(T, 1)

/obj/effect/foam/process()
	if(--amount < 0)
		return

	for(var/direction in GLOB.cardinal)
		var/turf/T = get_step(src, direction)
		if(!T)
			continue

		if(!T.Enter(src))
			continue

		var/obj/effect/foam/F = locate() in T
		if(F)
			continue

		F = new(T, metal)
		F.amount = amount
		F.carried_reagents_shared_ref = carried_reagents_shared_ref

/obj/effect/foam/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume) // foam disolves when heated, except metal foams
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("[icon_state]-disolve", src)

		spawn(5)
			qdel(src)

/obj/effect/foam/Crossed(var/atom/movable/AM)
	. = ..()
	if(AM.is_incorporeal())
		return
	if(metal)
		return
	if(slips && istype(AM, /mob/living) && !AM.is_avoiding_ground())
		var/mob/living/M = AM
		M.slip_act(SLIP_CLASS_FOAM, src, 5, 7.5)

/datum/effect_system/foam_spread
	/// The size of the foam spread.
	var/amount = 5
	/// reagent holder for carried reagents
	var/datum/reagent_holder/carried_reagents
	/// 0 = foam, 1 = metalfoam, 2 = ironfoam.
	var/metal = 0

/datum/effect_system/foam_spread/set_up(amt=5, loca, var/datum/reagent_holder/carry = null, var/metalfoam = 0)
	amount = round(sqrt(amt / 3), 1)
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

	metal = metalfoam

	// bit of a hack here. Foam carries along any reagent also present in the glass it is mixed with (defaults to water if none is present). Rather than actually transfer the reagents, this makes a list of the reagent ids and spawns 1 unit of that reagent when the foam disolves.

	if(!metal)
		if(carry)
			carried_reagents = carry.clone()
		else
			carried_reagents = new
			carried_reagents.add_reagent(/datum/reagent/water::id, 10)

/datum/effect_system/foam_spread/start()
	spawn(0)
		var/obj/effect/foam/F = locate() in location
		if(F)
			F.amount += amount
			return

		F = new /obj/effect/foam(location, metal)
		F.amount = amount

		if(!metal) // don't carry other chemicals if a metal foam
			// directly reference the reagents
			F.carried_reagents_shared_ref = carried_reagents

// wall formed by metal foams, dense and opaque, but easy to break

/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	rad_insulation = RAD_INSULATION_MEDIUM
	rad_stickiness = 0.5
	name = "foamed metal"
	desc = "A lightweight foamed metal wall."
	CanAtmosPass = ATMOS_PASS_DENSITY
	integrity = 20
	integrity_max = 20
	armor_type = /datum/armor/none
	var/metal = 1 // 1 = aluminum, 2 = iron

/obj/structure/foamedmetal/Initialize(mapload)
	. = ..()
	update_nearby_tiles(1)

/obj/structure/foamedmetal/Destroy()
	density = FALSE
	update_nearby_tiles(1)
	return ..()

/obj/structure/foamedmetal/proc/updateicon()
	if(metal == 1)
		icon_state = "metalfoam"
	else
		icon_state = "ironfoam"
