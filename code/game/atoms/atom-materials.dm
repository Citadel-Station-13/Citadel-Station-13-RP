//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station Developers           *//

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

/// ensure this is called once and only once when a material is added to an atom
/// alternatively, don't call this at all if you don't want to register traits.
/// this should null-check, as null is a valid material.
/atom/proc/register_material(datum/prototype/material/mat, primary)
	if(!isnull(mat?.material_traits))
		for(var/datum/prototype/material_trait/trait as anything in mat.material_traits)
			if(islist(material_traits))
				var/old_data = material_traits[trait]
				material_traits[trait] = trait.on_add(src, old_data, mat.material_traits[trait])
				material_trait_flags |= trait.material_trait_flags
			else if(isnull(material_traits))
				material_traits = trait
				material_traits_data = trait.on_add(src, null, mat.material_traits[trait])
				material_trait_flags = trait.material_trait_flags
			else
				var/datum/prototype/material_trait/other = material_traits
				var/old_data = material_traits_data
				if(other == trait)
					material_traits_data = trait.on_add(src, old_data, mat.material_traits[trait])
				else
					// we wrap other, trait in ()'s so byond's list() syntax doesn't turn them into strings rather than the actual referneces.
					material_traits = list((other) = old_data, (trait) = trait.on_add(old_data, mat.material_traits[trait]))
					material_traits_data = null
					material_trait_flags = other.material_trait_flags | trait.material_trait_flags

/// ensure this is called once and only once when a material is deleted from an atom
/// this is only to be used if the material was registered. if it was never registered, DO NOT call this.
/// this should null-check, as null is a valid material.
/atom/proc/unregister_material(datum/prototype/material/mat, primary)
	if(!mat) //null checking
		return
	if(!isnull(mat?.material_traits))
		for(var/datum/prototype/material_trait/trait as anything in mat.material_traits)
			if(islist(material_traits))
				var/old_data = material_traits[trait]
				var/new_data = trait.on_remove(src, old_data, mat.material_traits[trait])
				if(isnull(new_data))
					material_traits -= trait
					if(length(material_traits) == 1)
						var/datum/prototype/material_trait/other = material_traits[1]
						material_traits_data = material_traits[other]
						material_traits = other
						material_trait_flags = other.material_trait_flags
					else
						material_trait_flags = NONE
						for(var/datum/prototype/material_trait/other as anything in material_traits)
							material_trait_flags |= other.material_trait_flags
				else
					material_traits[trait] = new_data
			else
				ASSERT(material_traits == trait)
				var/new_data = trait.on_remove(src, material_traits_data, mat.material_traits[trait])
				if(isnull(new_data))
					material_traits = null
					material_traits_data = null
					material_trait_flags = NONE
				else
					material_traits_data = new_data
