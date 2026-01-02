// Longer paths should come after shorter ones
GLOBAL_LIST_INIT(fancy_type_replacements, list(
	/datum = "DATUM",
	/area = "AREA",
	/atom/movable = "MOVABLE",
	/obj = "OBJ",
	/turf = "TURF",
	/turf/simulated = "SIMULATED",
	/turf/simulated/floor = "FLOOR",

	/mob = "MOB",
	/mob/living = "LIVING",
	/mob/living/carbon = "CARBON",
	/mob/living/carbon/human = "HUMANOID",
	/mob/living/simple_mob = "SIMPLE",
	/mob/living/silicon = "SILICON",
	/mob/living/silicon/robot = "CYBORG",

	/obj/item = "ITEM",
	/obj/item/organ = "ORGAN",
	/obj/item/gun = "GUN",
	/obj/item/gun/projectile/ballistic = "GUN_BALLISTIC",
	/obj/item/gun/projectile/energy = "GUN_ENERGY",
	/obj/item/gun/projectile/magnetic = "GUN_MAGNETIC",
	/obj/item/ammo_casing = "AMMO",
	/obj/item/ammo_magazine = "MAGAZINE",
	/obj/item/gun_attachment = "GUN_ATTATCHMENT",
	/obj/item/gun_component = "GUN_COMPONENT",
	/obj/item/stack/material = "MATERIAL",
	/obj/item/stack/ore = "ORE",
	/obj/item/aiModule = "AI_LAW_MODULE",
	/obj/item/circuitboard = "CIRCUITBOARD",
	/obj/item/circuitboard/machine = "MACHINE_BOARD",
	/obj/item/circuitboard/computer = "COMPUTER_BOARD",
	/obj/item/reagent_containers = "REAGENT_CONTAINERS",
	/obj/item/reagent_containers/pill = "PILL",
	/obj/item/reagent_containers/pill/patch = "MEDPATCH",
	/obj/item/reagent_containers/food = "FOOD",
	/obj/item/reagent_containers/food/drinks = "DRINK",
	/obj/effect/decal/cleanable = "CLEANABLE",
	/obj/item/radio/headset = "HEADSET",
	/obj/item/clothing = "CLOTHING",
	/obj/item/clothing/accessory = "ACCESSORY",
	/obj/item/clothing/mask/gas = "GASMASK",
	/obj/item/clothing/mask = "MASK",
	/obj/item/clothing/gloves = "GLOVES",
	/obj/item/clothing/shoes = "SHOES",
	/obj/item/clothing/under = "JUMPSUIT",
	/obj/item/clothing/suit/armor = "ARMOR",
	/obj/item/clothing/suit = "SUIT",
	/obj/item/clothing/head/helmet = "HELMET",
	/obj/item/clothing/head = "HEAD",
	/obj/item/storage/backpack = "BACKPACK",
	/obj/item/storage/belt = "BELT",
	/obj/item/storage/pill_bottle = "PILL_BOTTLE",
	/obj/item/book/manual = "MANUAL",

	/obj/vehicle = "VEHICLE",
	/obj/item/vehicle_chassis = "VEHICLE_CHASSIS",
	/obj/item/vehicle_part = "VEHICLE_PART",
	/obj/item/vehicle_component  = "VEHICLE_COMPONENT",
	/obj/item/vehicle_module = "VEHICLE_MODULE",
	/obj/item/vehicle_module/weapon = "VEHICLE_WEAPON",


	/obj/structure = "STRUCTURE",
	/obj/structure/closet = "CLOSET",
	/obj/structure/closet/crate = "CRATE",
	/obj/structure/closet/crate/secure = "LOCKED_CRATE",
	/obj/structure/closet/secure_closet = "LOCKED_CLOSET",

	/obj/machinery = "MACHINERY",
	/obj/machinery/atmospherics = "ATMOS_MECH",
	/obj/machinery/portable_atmospherics = "PORT_ATMOS",
	/obj/machinery/door = "DOOR",
	/obj/machinery/door/airlock = "AIRLOCK",
	/obj/machinery/computer = "COMPUTER",
	/obj/machinery/vending = "VENDING",

	/obj/effect = "EFFECT",
	/obj/effect/debris = "DEBRIS",
	/obj/projectile = "PROJECTILE",
))

/proc/make_types_fancy(list/types)
	if (ispath(types))
		types = list(types)
	var/static/list/types_to_replacement
	var/static/list/replacement_to_text
	if(!types_to_replacement)
		// ignore_root_path so we can draw the root normally
		var/list/fancy_type_cache = GLOB.fancy_type_replacements
		var/list/local_replacements = zebra_typecacheof(fancy_type_cache, ignore_root_path = TRUE)
		var/list/local_texts = list()
		for(var/key in fancy_type_cache)
			local_texts[local_replacements[key]] = "[key]"
		types_to_replacement = local_replacements
		replacement_to_text = local_texts

	. = list()
	var/list/local_replacements = types_to_replacement
	var/list/local_texts = replacement_to_text
	for(var/type in types)
		var/replace_with = local_replacements[type]
		if(!replace_with)
			.["[type]"] = type
			continue
		var/cut_out = local_texts[replace_with]
		// + 1 to account for /
		.[replace_with + copytext("[type]", length(cut_out) + 1)] = type

/proc/get_fancy_list_of_atom_types()
	var/static/list/pre_generated_list
	if (!pre_generated_list) //init
		pre_generated_list = make_types_fancy(typesof(/atom))
	return pre_generated_list

/proc/get_fancy_list_of_datum_types()
	var/static/list/pre_generated_list
	if (!pre_generated_list) //init
		pre_generated_list = make_types_fancy(sortList(typesof(/datum) - typesof(/atom)))
	return pre_generated_list

/proc/filter_fancy_list(list/L, filter as text)
	var/list/matches = new
	var/end_len = -1
	var/list/endcheck = splittext(filter, "!")
	if(endcheck.len > 1)
		filter = endcheck[1]
		end_len = length_char(filter)
	var/endtype = (filter[length(filter)] == "*")
	if (endtype)
		filter = splittext(filter, "*")[1]

	for(var/key in L)
		var/value = L[key]
		if (findtext("[key]", filter, -end_len))
			if (endtype)
				var/list/split_filter = splittext("[key]", filter)
				if (!findtext(split_filter[length(split_filter)], "/"))
					if (value)
						matches[key] = value
					else
						matches += key
					continue
			else
				if (value)
					matches[key] = value
				else
					matches += key
				continue

		if (value && findtext("[value]", filter, -end_len))
			if (endtype)
				var/list/split_filter = splittext("[value]", filter)
				if (findtext(split_filter[length(split_filter)], "/"))
					continue
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
