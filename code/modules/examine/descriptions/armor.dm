
/obj/item/clothing/get_description_info()
	var/armor_stats = description_info + "\
	<br>"
	var/list/describing = fetch_armor()?.describe_english_list()
	if(length(describing))
		armor_stats += jointext(describing, "<br>")
		armor_stats += "<br>"

	if(atom_flags & ALLOWINTERNALS)
		armor_stats += "It is airtight. <br>"

	if(min_pressure_protection == 0)
		armor_stats += "Wearing this will protect you from the vacuum of space. <br>"
	else if(min_pressure_protection != null)
		armor_stats += "Wearing this will protect you from low pressures, but not the vacuum of space. <br>"

	if(max_pressure_protection != null)
		armor_stats += "Wearing this will protect you from high pressures. <br>"

	if(clothing_flags & CLOTHING_THICK_MATERIAL)
		armor_stats += "The material is exceptionally thick. <br>"

	if(max_heat_protection_temperature == FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE)
		armor_stats += "It provides very good protection against fire and heat. <br>"

	if(min_cold_protection_temperature == SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE)
		armor_stats += "It provides very good protection against very cold temperatures. <br>"

	var/list/covers = list()
	var/list/slots = list()

	for(var/name in string_part_flags)
		if(body_cover_flags & string_part_flags[name])
			covers += name

	for(var/name in string_slot_flags)
		if(slot_flags & string_slot_flags[name])
			slots += name

	if(covers.len)
		armor_stats += "It covers the [english_list(covers)]. <br>"

	if(slots.len)
		armor_stats += "It can be worn on your [english_list(slots)]. <br>"

	return armor_stats
