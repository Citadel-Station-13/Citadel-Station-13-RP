//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/**
 * Checks if we're a stack of a specific material.
 * Subtypes are not included.
 *
 * @params
 * * material_like - material instance, type, or id. If left out, this proc returns TRUE if we are a material stack of any kind.
 */
/obj/item/proc/is_material_stack_of(datum/material/material_like)
	return FALSE

/obj/item/stack/material/is_material_stack_of(datum/material/material_like)
	if(istype(material_like))
		return material == material_like
	else if(ispath(material_like))
		return material.type == material_like
	else if(istext(material_like))
		return material.id == material_like
	else
		return TRUE

/**
 * Checks if we're a stack of a specific material.
 * Subtypes are included.
 *
 * @params
 * * material_like - material instance, type, or id. If left out, this proc returns TRUE if we are a material stack of any kind.
 */
/obj/item/proc/is_material_stack_of_fuzzy(datum/material/material_like)
	return FALSE

/obj/item/stack/material/is_material_stack_of_fuzzy(datum/material/material_like)
	if(istype(material_like))
		return material == material_like
	else if(ispath(material_like))
		return istype(material, material_like)
	else if(istext(material_like))
		return material.id == material_like
	else
		return TRUE
