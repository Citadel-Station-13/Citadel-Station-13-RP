//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* Get

/**
 * get raw materials remaining in us as list (not reagents)
 * used from everything from economy to lathe recycling
 *
 * for things like stacks, this is amount per sheet.
 *
 * @params
 * * respect_multiplier - respect material_multiplier which is often used to modify atom materials when efficiency is higher in lathes.
 *
 * @return list of id to amount
 */
/atom/proc/get_materials(respect_multiplier)
	return list()
