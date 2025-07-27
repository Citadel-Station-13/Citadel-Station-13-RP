//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/**
 * holds fabricator training matrix data
 */
/datum/research_data_fabricator
	/// training status for using specific material **training tags** (not ids!)
	/// * goes up when using the material at all, not specifically high/low amounts.
	///   we assume we're dealing with 3d printers, not cnc lathes
	/// * the general formula use is that this goes up by using the material per cm3, altered
	///   by the material's training difficulty.
	var/list/trained_material_tags = list()
	/// training status for specific design **training tags** (not ids!)
	/// * goes up per unit printed, not by cm3 used.
	/// * this serves to allow training very well on specific kinds of components
	///   without necessarily being able to do it just by using the materials a lot.
	var/list/trained_design_tags = list()

/datum/research_data_fabricator/clone()
	var/datum/research_data_fabricator/cloned = new
	trained_material_tags = cloned.trained_material_tags.Copy()
	trained_design_tags = cloned.trained_design_tags.Copy()
	return cloned

/datum/research_data_fabricator/serialize()
	. = list()
	.["trained-material-tags"] = trained_material_tags
	.["trained-design-tags"] = trained_design_tags

/datum/research_data_fabricator/deserialize(list/data)
	trained_material_tags = data["trained-material-tags"] || list()
	trained_design_tags = data["trained-design-tags"] || list()
