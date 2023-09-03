// Overmap stuff. Main file is under code/modules/maps/overmap/_lythios43c.dm
// Todo, find a way to populate this list automatically without having to do this
/obj/overmap/entity/visitable/sector/lythios43c
	extra_z_levels = list(
		/datum/map_level/rift/plains,
		/datum/map_level/rift/caves,
		/datum/map_level/rift/deep,
		/datum/map_level/rift/base,
	)

/// This is the effect that slams people into the ground upon dropping out of the sky //

/obj/effect/step_trigger/teleporter/planetary_fall/lythios43c
	planet_path = /datum/planet/lythios43c

/// Temporary place for this
// Spawner for lythios animals
/obj/tether_away_spawner/lythios_animals
	name = "Lythios Animal Spawner"
	faction = "lythios"
	atmos_comp = TRUE
	prob_spawn = 100
	mobs_to_pick_from = list(
		/mob/living/simple_mob/animal/icegoat = 2,
		/mob/living/simple_mob/animal/passive/woolie = 3,
		/mob/living/simple_mob/animal/passive/furnacegrub,
		/mob/living/simple_mob/animal/horing = 2
	)


//Ported from YW
//Freezable airlocks!

//Freezable Airlock Door
/obj/machinery/door/airlock/glass_external/lythios43c/freezable
	maxhealth = 600
	var/frozen = 0
	var/freezing = 0 //see process().
	var/deiceTools[0]
	var/nextWeatherCheck

/obj/machinery/door/airlock/glass_external/lythios43c/freezable/New()
	//Associate objects with the number of seconds it would take to de-ice a door.
	//Most items are either more or less effecient at it.
	//For items with very specific cases (like welders using fuel, or needing to be on) see attackby().
	deiceTools[/obj/item/pickaxe/icepick] = 3 //Ice Pick / Axe.
	deiceTools[/obj/item/pickaxe/icepick/plasteel] = 2 //Plasteel Ice pickaxe.
	deiceTools[/obj/item/material/knife/machete] = 4 //Machete
	deiceTools[/obj/item/tool/crowbar] = 5 //Crowbar
	deiceTools[/obj/item/pen] = 30 //Pen
	deiceTools[/obj/item/card] = 35 //Cards. (Mostly ID cards)

	//Generic weapon items. Tools are better then weapons.
	//This is for preventing "Sierra" syndrome that could result from needing very specific objects.
	deiceTools[/obj/item/tool] = 10
	deiceTools[/obj/item] = 12
	..()

/obj/machinery/door/airlock/glass_external/lythios43c/freezable/attackby(obj/item/I, mob/user as mob)
	//Special cases for tools that need more then just a type check.
	var/welderTime = 5 //Welder

	//debug
	//message_admins("[user] has used \the [I] of type [I.type] on [src]", R_DEBUG)

	if(frozen)

		//the welding tool is a special snowflake.
		if(istype(I, /obj/item/weldingtool))
			var/obj/item/weldingtool/welder = I
			if(welder.remove_fuel(0,user) && welder && welder.isOn())
				to_chat(user, "<span class='notice'>You start to melt the ice off \the [src]</span>")
				playsound(src, welder.tool_sound, 50, 1)
				if(do_after(user, welderTime SECONDS))
					to_chat(user, "<span class='notice'>You finish melting the ice off \the [src]</span>")
					unFreeze()
					return

		if(istype(I, /obj/item/pen/crayon))
			to_chat(user, "<span class='notice'>You try to use \the [I] to clear the ice, but it crumbles away!</span>")
			qdel(I)
			return

		//Most items will be checked in this for loop using the list in New().
		//Code for objects with specific checks (Like the welder) should be inserted above.
		for(var/IT in deiceTools)
			if(istype(I, IT))
				handleRemoveIce(I, user, deiceTools[IT])
				return

		//if we can't de-ice the door tell them what's wrong.
		to_chat(user, "<span class='notice'>\the [src] is frozen shut!</span>")
		return
	..()

/obj/machinery/door/airlock/glass_external/lythios43c/freezable/proc/handleRemoveIce(obj/item/weapon/W as obj, mob/user as mob, var/time = 15 as num)
	to_chat(user, "<span class='notice'>You start to chip at the ice covering \the [src]</span>")
	if(do_after(user, text2num(time SECONDS)))
		unFreeze()
		to_chat(user, "<span class='notice'>You finish chipping the ice off \the [src]</span>")

/obj/machinery/door/airlock/glass_external/lythios43c/freezable/proc/unFreeze()
	frozen = 0
	update_icon()
	return

/obj/machinery/door/airlock/glass_external/lythios43c/freezable/proc/freeze()
	frozen = 1
	update_icon()
	return

/obj/machinery/door/airlock/glass_external/lythios43c/freezable/update_icon()
	..()
	if(frozen)
		add_overlay(image('icons/turf/overlays.dmi', "snowairlock"))
	return

/obj/machinery/door/airlock/glass_external/lythios43c/freezable/proc/handleFreezeUnfreeze()

	for(var/datum/planet/lythios43c/P in SSplanets.planets)
		if(istype(P.weather_holder.current_weather, /datum/weather/lythios43c/blizzard))
			if(!frozen && density && prob(25))
				freeze()
		else if(!istype(P.weather_holder.current_weather, /datum/weather/lythios43c/blizzard))
			if(frozen && prob(50))
				unFreeze()
	return
/obj/machinery/door/airlock/glass_external/lythios43c/freezable/process()
	if(world.time >= nextWeatherCheck && !freezing)  //don't do the thing if i'm already doing it.
		freezing = 1
		var/random = rand(2,7)
		nextWeatherCheck = (world.time + ((random + 13) SECONDS))
		handleFreezeUnfreeze()
		freezing = 0
	..()

/obj/machinery/door/airlock/glass_external/lythios43c/freezable/examine(mob/user)
	. = ..()
	if(frozen)
		to_chat(user, "it's frozen shut!")

/obj/machinery/door/airlock/glass_external/lythios43c/freezable/open(var/forced = 0)
	//Frozen airlocks can't open.
	if(frozen && !forced)
		return
	else if(frozen && forced)
		unFreeze()
		return ..()
	else
		..()

/obj/machinery/door/airlock/glass_external/lythios43c/freezable/close(var/forced = 0)
	//Frozen airlocks can't shut either. (Though they shouldn't be able to freeze open)
	if(frozen && !forced)
		return
	else if(frozen && forced)
		unFreeze()
		return ..()
	else
		..()
//end of freezable airlock stuff.
