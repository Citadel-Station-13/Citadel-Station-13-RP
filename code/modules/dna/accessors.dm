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
 * sets hair to new datum
 */
/datum/dna/proc/set_sprite_accessory_hair(datum/sprite_accessory_data/D)
	if(!istype(D))
		var/datum/sprite_accessory_meta/M = resolve_sprite_accessory(D)
		if(!istype(M, /datum/sprite_accessory_meta/hair))
			CRASH("invalid resolution")
		D = new(M)
	#warn carry through color from old hair datum for above
	#warn do the same for every other setter
	hair = D

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
 * sets facial_hair to new datum
 */
/datum/dna/proc/set_sprite_accessory_facial_hair(datum/sprite_accessory_data/D)
	D = resolve_sprite_accessory(D)
	facial_hair = D

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
 * sets ears_1 to new datum
 */
/datum/dna/proc/set_sprite_accessory_ears_1(datum/sprite_accessory_data/D)
	D = resolve_sprite_accessory(D)
	ears_1 = D

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
 * sets ears_2 to new datum
 */
/datum/dna/proc/set_sprite_accessory_ears_2(datum/sprite_accessory_data/D)
	D = resolve_sprite_accessory(D)
	ears_2 = D

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
 * sets tail to new datum
 */
/datum/dna/proc/set_sprite_accessory_tail(datum/sprite_accessory_data/D)
	D = resolve_sprite_accessory(D)
	tail = D

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
 * sets wings to new datum
 */
/datum/dna/proc/set_sprite_accessory_wings(datum/sprite_accessory_data/D)
	D = resolve_sprite_accessory(D)
	wings = D

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

/**
 * adds a marking
 */
/datum/dna/proc/add_marking(datum/sprite_accessory_data/D)
	D = resolve_sprite_accessory(D)
	#warn impl

/**
 * removes a marking
 */
/datum/dna/proc/remove_marking(datum/sprite_accessory_data/D)
	#warn impl

/**
 * directly sets markings to a new list
 */
/datum/dna/proc/set_markings(list/datum/sprite_accessory_data/D)
	#warn impl
	#warn allow ids in list with resolve_sprite_accessory

/**
 * directly clones markings from another DNA
 */
/datum/dna/proc/clone_markings_from_dna(datum/dna/other)
	return set_markings(other.markings)

//! more normal, synchronized getters/setters.

/**
 * get body color
 */
/datum/dna/proc/get_body_color()
	return skin_color

/**
 * set body color
 */
/datum/dna/proc/set_body_color(str)
	skin_color = str

/**
 * get gender
 */
/datum/dna/proc/get_gender()
	return gender

/**
 * set gender
 */
/datum/dna/proc/set_gender(e)
	gender = e

/**
 * get eye color
 */
/datum/dna/proc/get_eye_color()
	return eye_color

/**
 * set eye color
 */
/datum/dna/proc/set_eye_color(str)
	eye_color = str
