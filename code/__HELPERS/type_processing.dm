/**
 * todo: rename this
 *
 * Reformat types to be more readable for admin interfaces.
 *
 * This is done because BYOND is hell and "input in list" is obnoxious.
 */
/proc/make_types_fancy(list/types)
	if (ispath(types))
		types = list(types)
	. = list()
	var/static/list/shortcut_lookup = list(
		/obj/effect/debris = "//debris",
		/obj/item/radio/headset = "//headset",
		/obj/item/reagent_containers/food/drinks = "//drink",
		/obj/item/reagent_containers/food = "//food",
		/obj/machinery/atmospherics = "//atmos",
		/obj/machinery/portable_atmospherics = "//port_atmos",
		/obj/vehicle = "//vehicle",
		/obj/item/vehicle_chassis = "//vehicle_chassis",
		/obj/item/vehicle_part = "//vehicle_part",
		/obj/item/vehicle_component  = "//vehicle_component",
		/obj/item/vehicle_module = "//vehicle_module",
		/obj/item/vehicle_module/weapon = "//vehicle_weapon",
		/obj/item/organ = "//organ",
		/obj/item/gun_attachment = "//gun-attachment",
		/obj/item/gun_component = "//gun-component",
		/obj/item/gun/projectile/ballistic = "//gun-ballistic",
		/obj/item/gun/projectile/energy = "//gun-energy",
		/obj/item/gun/projectile/magnetic = "//gun-magnetic",
		/obj/item/gun = "//gun",
		/obj/item/ammo_casing = "//ammo",
		/obj/item/ammo_magazine = "//magazine",
		/obj/item = "//item",
		/obj/machinery = "//machine",
		/obj/effect = "//effect",
		/turf/simulated/floor = "//floor",
		/turf/simulated = "//simulated",
		/mob/living/carbon = "//carbon",
		/mob/living/simple_mob = "//simple",
		/mob/living = "//living",
		// we must have normal A-T-O-M handled; otherwise weird stuff happens when it falls to /atom/movable
		/obj = "/obj",
		/turf = "/turf",
		/area = "/area",
		/mob = "/mob",
		/atom/movable = "//movable",
	)
	for(var/type in types)
		var/shortcut
		for(var/prefix in shortcut_lookup)
			if(ispath(type, prefix))
				shortcut = "[shortcut_lookup[prefix]][copytext("[type]", length("[prefix]") + 1)]"
				break
		.[shortcut || "[type]"] = type

/proc/get_fancy_list_of_atom_types()
	return make_types_fancy(typesof(/atom))

/proc/get_fancy_list_of_datum_types()
	return make_types_fancy(typesof(/datum) - typesof(/atom))

/proc/filter_fancy_list(list/L, filter as text)
	var/list/matches = new
	for(var/key in L)
		var/value = L[key]
		if(findtext("[key]", filter) || findtext("[value]", filter))
			matches[key] = value
	return matches

/proc/pick_closest_path(value, list/matches = get_fancy_list_of_atom_types())
	if (value == FALSE) //nothing should be calling us with a number, so this is safe
		value = input("Enter type to find (blank for all, cancel to cancel)", "Search for type") as null|text
		if (isnull(value))
			return
	value = trim(value)
	if(!isnull(value) && value != "")
		matches = filter_fancy_list(matches, value)

	if(matches.len==0)
		return

	var/chosen
	if(matches.len==1)
		chosen = matches[1]
	else
		chosen = input("Select a type", "Pick Type", matches[1]) as null|anything in matches
		if(!chosen)
			return
	chosen = matches[chosen]
	return chosen
