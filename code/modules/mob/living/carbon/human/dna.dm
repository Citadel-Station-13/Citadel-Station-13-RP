//! DNA Procs
/**
 * sets our DNA to something
 * make sure this is a CLONE if another thing is already using this!
 */
/mob/living/carbon/human/proc/set_dna(datum/dna/D)
	#warn impl ; have to updat everything too

	#warn dna should do the application; we do the rendering

/**
 * copies our DNA from something
 */
/mob/living/carbon/human/proc/copy_dna_from(dna_or_human)

/**
 * returns a clone of our dna
 */
/mob/living/carbon/human/proc/clone_dna()
	return dna.clone()

/**
 * initializes our dna
 */
/mob/living/carbon/human/proc/init_dna()

/**
 * updates all visuals/whatnot for dna
 */
/mob/living/carbon/human/proc/update_dna()

//! DNA setters/getters
#warn update icons for these!
//? hair
/**
 * gets sprite accessory data of our hair accessory
 * do NOT edit the returned datum
 * if you need to edit, use get_sprite_accessory_hair().
 */
/mob/living/carbon/human/proc/peek_sprite_accessory_hair()
	return dna.peek_sprite_accessory_hair()

/**
 * gets sprite accessory data of our hair accessory
 */
/mob/living/carbon/human/proc/get_sprite_accessory_hair()
	return dna.get_sprite_accessory_hair()

/**
 * sets our hair accessory
 * accepts either:
 * - id of sprite accessory
 * - path of sprite accessory
 * - full sprite accessory datum
 * - sprite accessory data datum
 */
/mob/living/carbon/human/proc/set_sprite_accessory_hair(datum/sprite_accessory_data/accessorylike)
	return dna.set_sprite_accessory_hair(accessorylike)

/**
 * sets our hair accessory to another datum that is likely shared
 *
 * accepts a sprite_accessory_data datum
 */
/mob/living/carbon/human/proc/copy_sprite_accessory_hair(datum/sprite_accessory_data/data)
	data.is_shared_datum = TRUE
	return dna.set_sprite_accessory_hair(data)

//? facial_hair
/**
 * gets sprite accessory data of our facial_hair accessory
 * do NOT edit the returned datum
 * if you need to edit, use get_sprite_accessory_facial_hair().
 */
/mob/living/carbon/human/proc/peek_sprite_accessory_facial_hair()
	return dna.peek_sprite_accessory_facial_hair()

/**
 * gets sprite accessory data of our facial_hair accessory
 */
/mob/living/carbon/human/proc/get_sprite_accessory_facial_hair()
	return dna.get_sprite_accessory_facial_hair()

/**
 * sets our facial_hair accessory
 * accepts either:
 * - id of sprite accessory
 * - path of sprite accessory
 * - full sprite accessory datum
 * - sprite accessory data datum
 */
/mob/living/carbon/human/proc/set_sprite_accessory_facial_hair(datum/sprite_accessory_data/accessorylike)
	return dna.set_sprite_accessory_facial_hair(accessorylike)

/**
 * sets our facial_hair accessory to another datum that is likely shared
 *
 * accepts a sprite_accessory_data datum
 */
/mob/living/carbon/human/proc/copy_sprite_accessory_facial_hair(datum/sprite_accessory_data/data)
	data.is_shared_datum = TRUE
	return dna.set_sprite_accessory_facial_hair(data)

//? ears_1
/**
 * gets sprite accessory data of our ears_1 accessory
 * do NOT edit the returned datum
 * if you need to edit, use get_sprite_accessory_ears_1().
 */
/mob/living/carbon/human/proc/peek_sprite_accessory_ears_1()
	return dna.peek_sprite_accessory_ears_1()

/**
 * gets sprite accessory data of our ears_1 accessory
 */
/mob/living/carbon/human/proc/get_sprite_accessory_ears_1()
	return dna.get_sprite_accessory_ears_1()

/**
 * sets our ears_1 accessory
 * accepts either:
 * - id of sprite accessory
 * - path of sprite accessory
 * - full sprite accessory datum
 * - sprite accessory data datum
 */
/mob/living/carbon/human/proc/set_sprite_accessory_ears_1(datum/sprite_accessory_data/accessorylike)
	return dna.set_sprite_accessory_ears_1(accessorylike)

/**
 * sets our ears_1 accessory to another datum that is likely shared
 *
 * accepts a sprite_accessory_data datum
 */
/mob/living/carbon/human/proc/copy_sprite_accessory_ears_1(datum/sprite_accessory_data/data)
	data.is_shared_datum = TRUE
	return dna.set_sprite_accessory_ears_1(data)

//? ears_2
/**
 * gets sprite accessory data of our ears_2 accessory
 * do NOT edit the returned datum
 * if you need to edit, use get_sprite_accessory_ears_2().
 */
/mob/living/carbon/human/proc/peek_sprite_accessory_ears_2()
	return dna.peek_sprite_accessory_ears_2()

/**
 * gets sprite accessory data of our ears_2 accessory
 */
/mob/living/carbon/human/proc/get_sprite_accessory_ears_2()
	return dna.get_sprite_accessory_ears_2()

/**
 * sets our ears_2 accessory
 * accepts either:
 * - id of sprite accessory
 * - path of sprite accessory
 * - full sprite accessory datum
 * - sprite accessory data datum
 */
/mob/living/carbon/human/proc/set_sprite_accessory_ears_2(datum/sprite_accessory_data/accessorylike)
	return dna.set_sprite_accessory_ears_2(accessorylike)

/**
 * sets our ears_2 accessory to another datum that is likely shared
 *
 * accepts a sprite_accessory_data datum
 */
/mob/living/carbon/human/proc/copy_sprite_accessory_ears_2(datum/sprite_accessory_data/data)
	data.is_shared_datum = TRUE
	return dna.set_sprite_accessory_ears_2(data)

//? tail
/**
 * gets sprite accessory data of our tail accessory
 * do NOT edit the returned datum
 * if you need to edit, use get_sprite_accessory_tail().
 */
/mob/living/carbon/human/proc/peek_sprite_accessory_tail()
	return dna.peek_sprite_accessory_tail()

/**
 * gets sprite accessory data of our tail accessory
 */
/mob/living/carbon/human/proc/get_sprite_accessory_tail()
	return dna.get_sprite_accessory_tail()

/**
 * sets our tail accessory
 * accepts either:
 * - id of sprite accessory
 * - path of sprite accessory
 * - full sprite accessory datum
 * - sprite accessory data datum
 */
/mob/living/carbon/human/proc/set_sprite_accessory_tail(datum/sprite_accessory_data/accessorylike)
	return dna.set_sprite_accessory_tail(accessorylike)

/**
 * sets our tail accessory to another datum that is likely shared
 *
 * accepts a sprite_accessory_data datum
 */
/mob/living/carbon/human/proc/copy_sprite_accessory_tail(datum/sprite_accessory_data/data)
	data.is_shared_datum = TRUE
	return dna.set_sprite_accessory_tail(data)

//? wings
/**
 * gets sprite accessory data of our wings accessory
 * do NOT edit the returned datum
 * if you need to edit, use get_sprite_accessory_wings().
 */
/mob/living/carbon/human/proc/peek_sprite_accessory_wings()
	return dna.peek_sprite_accessory_wings()

/**
 * gets sprite accessory data of our wings accessory
 */
/mob/living/carbon/human/proc/get_sprite_accessory_wings()
	return dna.get_sprite_accessory_wings()

/**
 * sets our wings accessory
 * accepts either:
 * - id of sprite accessory
 * - path of sprite accessory
 * - full sprite accessory datum
 * - sprite accessory data datum
 */
/mob/living/carbon/human/proc/set_sprite_accessory_wings(datum/sprite_accessory_data/accessorylike)
	return dna.set_sprite_accessory_wings(accessorylike)

/**
 * sets our wings accessory to another datum that is likely shared
 *
 * accepts a sprite_accessory_data datum
 */
/mob/living/carbon/human/proc/copy_sprite_accessory_wings(datum/sprite_accessory_data/data)
	data.is_shared_datum = TRUE
	return dna.set_sprite_accessory_wings(data)
