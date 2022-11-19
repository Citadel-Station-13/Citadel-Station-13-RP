//! YOU MUST USE THE CORRECT PROC.
//? If you are just referencing to say, render an icon, use peek.
//? If you're getting a mutable copy for editing, USE GET.
//! FAILURE TO DO SO WILL RESULT IN CORRUPTION.

/**
 * gets hair for reading
 */
/datum/dna/proc/peek_sprite_accessory_hair()
	RETURN_TYPE(/datum/sprite_accessory_data)
	return hair

/**
 * gets hair for writing
 */
/datum/dna/proc/get_sprite_accessory_hair()
	RETURN_TYPE(/datum/sprite_accessory_data)
	if(hair.is_shared_datum)
		hair = hair.clone()
	return hair

/**
 * gets facial_hair for reading
 */
/datum/dna/proc/peek_sprite_accessory_facial_hair()
	RETURN_TYPE(/datum/sprite_accessory_data)
	return facial_hair

/**
 * gets facial_hair for writing
 */
/datum/dna/proc/get_sprite_accessory_facial_hair()
	RETURN_TYPE(/datum/sprite_accessory_data)
	if(facial_hair.is_shared_datum)
		facial_hair = facial_hair.clone()
	return facial_hair

/**
 * gets ears_1 for reading
 */
/datum/dna/proc/peek_sprite_accessory_ears_1()
	RETURN_TYPE(/datum/sprite_accessory_data)
	return ears_1

/**
 * gets ears_1 for writing
 */
/datum/dna/proc/get_sprite_accessory_ears_1()
	RETURN_TYPE(/datum/sprite_accessory_data)
	if(ears_1.is_shared_datum)
		ears_1 = ears_1.clone()
	return ears_1

/**
 * gets ears_2 for reading
 */
/datum/dna/proc/peek_sprite_accessory_ears_2()
	RETURN_TYPE(/datum/sprite_accessory_data)
	return ears_2

/**
 * gets ears_2 for writing
 */
/datum/dna/proc/get_sprite_accessory_ears_2()
	RETURN_TYPE(/datum/sprite_accessory_data)
	if(ears_2.is_shared_datum)
		ears_2 = ears_2.clone()
	return ears_2

/**
 * gets tail for reading
 */
/datum/dna/proc/peek_sprite_accessory_tail()
	RETURN_TYPE(/datum/sprite_accessory_data)
	return tail

/**
 * gets tail for writing
 */
/datum/dna/proc/get_sprite_accessory_tail()
	RETURN_TYPE(/datum/sprite_accessory_data)
	if(tail.is_shared_datum)
		tail = tail.clone()
	return tail

/**
 * gets wings for reading
 */
/datum/dna/proc/peek_sprite_accessory_wings()
	RETURN_TYPE(/datum/sprite_accessory_data)
	return wings

/**
 * gets wings for writing
 */
/datum/dna/proc/get_sprite_accessory_wings()
	RETURN_TYPE(/datum/sprite_accessory_data)
	if(wings.is_shared_datum)
		wings = wings.clone()
	return wings

/**
 * gets markings for reading
 */
/datum/dna/proc/peek_sprite_accessory_markings()
	RETURN_TYPE(/list)
	return markings

/**
 * gets markings for writing
 */
/datum/dna/proc/get_sprite_accessory_markings()
	RETURN_TYPE(/list)
	for(var/i in 1 to markings.len)
		var/datum/sprite_accessory_data/D = markings[i]
		if(D.is_shared_datum)
			markings[i] = D.clone()
	return markings
