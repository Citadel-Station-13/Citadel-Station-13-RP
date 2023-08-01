//Analyzer, pestkillers, weedkillers, nutrients, hatchets, cutters.

/obj/item/tool/wirecutters/clippers
	name = "plant clippers"
	desc = "A tool used to take samples from plants."
	random_color = FALSE

/obj/item/tool/wirecutters/clippers/bone
	name = "bone plant clippers"
	desc = "A tool used to take samples from plants."
	icon_state = "clippers_bone"

/obj/item/tool/wirecutters/clippers/trimmers
	name = "hedgetrimmers"
	desc = "An old pair of trimmers with a pretty dull blade. You would probably have a hard time cutting anything but plants with it."
	icon_state = "hedget"
	item_state = "hedget"
	damage_force = 7 //One point extra than standard wire cutters.


/datum/seed/proc/get_tgui_analyzer_data(mob/user)
	var/list/data = list()

	data["name"] = seed_name
	data["uid"] = uid
	data["endurance"] = get_trait(TRAIT_ENDURANCE)
	data["yield"] = get_trait(TRAIT_YIELD)
	data["maturation_time"] = get_trait(TRAIT_MATURATION)
	data["production_time"] = get_trait(TRAIT_PRODUCTION)
	data["potency"] = get_trait(TRAIT_POTENCY)

	data["trait_info"] = list()
	if(get_trait(TRAIT_HARVEST_REPEAT))
		data["trait_info"] += "This plant can be harvested repeatedly."

	if(get_trait(TRAIT_IMMUTABLE) == -1)
		data["trait_info"] += "This plant is highly mutable."
	else if(get_trait(TRAIT_IMMUTABLE) > 0)
		data["trait_info"] += "This plant does not possess genetics that are alterable."

	if(get_trait(TRAIT_REQUIRES_NUTRIENTS))
		if(get_trait(TRAIT_NUTRIENT_CONSUMPTION) < 0.05)
			data["trait_info"] += "It consumes a small amount of nutrient fluid."
		else if(get_trait(TRAIT_NUTRIENT_CONSUMPTION) > 0.2)
			data["trait_info"] += "It requires a heavy supply of nutrient fluid."
		else
			data["trait_info"] += "It requires a supply of nutrient fluid."

	if(get_trait(TRAIT_REQUIRES_WATER))
		if(get_trait(TRAIT_WATER_CONSUMPTION) < 1)
			data["trait_info"] += "It requires very little water."
		else if(get_trait(TRAIT_WATER_CONSUMPTION) > 5)
			data["trait_info"] += "It requires a large amount of water."
		else
			data["trait_info"] += "It requires a stable supply of water."

	if(mutants && mutants.len)
		data["trait_info"] += "It exhibits a high degree of potential subspecies shift."

	data["trait_info"] += "It thrives in a temperature of [get_trait(TRAIT_IDEAL_HEAT)] Kelvin."

	if(get_trait(TRAIT_LOWKPA_TOLERANCE) < 20)
		data["trait_info"] += "It is well adapted to low pressure levels."
	if(get_trait(TRAIT_HIGHKPA_TOLERANCE) > 220)
		data["trait_info"] += "It is well adapted to high pressure levels."

	if(get_trait(TRAIT_HEAT_TOLERANCE) > 30)
		data["trait_info"] += "It is well adapted to a range of temperatures."
	else if(get_trait(TRAIT_HEAT_TOLERANCE) < 10)
		data["trait_info"] += "It is very sensitive to temperature shifts."

	data["trait_info"] += "It thrives in a light level of [get_trait(TRAIT_IDEAL_LIGHT)] lumen[get_trait(TRAIT_IDEAL_LIGHT) == 1 ? "" : "s"]."

	if(get_trait(TRAIT_LIGHT_TOLERANCE) > 10)
		data["trait_info"] += "It is well adapted to a range of light levels."
	else if(get_trait(TRAIT_LIGHT_TOLERANCE) < 3)
		data["trait_info"] += "It is very sensitive to light level shifts."

	if(get_trait(TRAIT_TOXINS_TOLERANCE) < 3)
		data["trait_info"] += "It is highly sensitive to toxins."
	else if(get_trait(TRAIT_TOXINS_TOLERANCE) > 6)
		data["trait_info"] += "It is remarkably resistant to toxins."

	if(get_trait(TRAIT_PEST_TOLERANCE) < 3)
		data["trait_info"] += "It is highly sensitive to pests."
	else if(get_trait(TRAIT_PEST_TOLERANCE) > 6)
		data["trait_info"] += "It is remarkably resistant to pests."

	if(get_trait(TRAIT_WEED_TOLERANCE) < 3)
		data["trait_info"] += "It is highly sensitive to weeds."
	else if(get_trait(TRAIT_WEED_TOLERANCE) > 6)
		data["trait_info"] += "It is remarkably resistant to weeds."

	switch(get_trait(TRAIT_SPREAD))
		if(1)
			data["trait_info"] += "It is able to be planted outside of a tray."
		if(2)
			data["trait_info"] += "It is a robust and vigorous vine that will spread rapidly."

	switch(get_trait(TRAIT_CARNIVOROUS))
		if(1)
			data["trait_info"] += "It is carnivorous and will eat tray pests for sustenance."
		if(2)
			data["trait_info"] += "It is carnivorous and poses a significant threat to living things around it."

	if(get_trait(TRAIT_PARASITE))
		data["trait_info"] += "It is capable of parisitizing and gaining sustenance from tray weeds."

/*
	There's currently no code that actually changes the temperature of the local environment, so let's not show it until there is.
	if(get_trait(TRAIT_ALTER_TEMP))
		data["trait_info"] += "It will periodically alter the local temperature by [get_trait(TRAIT_ALTER_TEMP)] degrees Kelvin."
*/

	if(get_trait(TRAIT_BIOLUM))
		data["trait_info"] += "It is [get_trait(TRAIT_BIOLUM_COLOUR)  ? "<font color='[get_trait(TRAIT_BIOLUM_COLOUR)]'>bio-luminescent</font>" : "bio-luminescent"]."

	if(get_trait(TRAIT_PRODUCES_POWER))
		data["trait_info"] += "The fruit will function as a battery if prepared appropriately."

	if(get_trait(TRAIT_STINGS))
		data["trait_info"] += "The fruit is covered in stinging spines."

	if(get_trait(TRAIT_JUICY) == 1)
		data["trait_info"] += "The fruit is soft-skinned and juicy."
	else if(get_trait(TRAIT_JUICY) == 2)
		data["trait_info"] += "The fruit is excessively juicy."

	if(get_trait(TRAIT_EXPLOSIVE))
		data["trait_info"] += "The fruit is internally unstable."

	if(get_trait(TRAIT_TELEPORTING))
		data["trait_info"] += "The fruit is temporal/spatially unstable."

	if(exude_gasses && exude_gasses.len)
		for(var/gas in exude_gasses)
			var/amount = ""
			if(exude_gasses[gas] > 7)
				amount = "large amounts of "
			else if(exude_gasses[gas] < 5)
				amount = "small amounts of "
			data["trait_info"] += "It will release [amount][global.gas_data.names[gas]] into the environment."

	if(consume_gasses && consume_gasses.len)
		for(var/gas in consume_gasses)
			var/amount = ""
			if(consume_gasses[gas] > 7)
				amount = "large amounts of "
			else if(consume_gasses[gas] < 5)
				amount = "small amounts of "
			data["trait_info"] += "It will consume [amount][global.gas_data.names[gas]] from the environment."

	return data
