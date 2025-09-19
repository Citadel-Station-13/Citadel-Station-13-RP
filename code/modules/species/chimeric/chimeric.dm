//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

// todo: get rid of /shapeshifter
// todo: /datum/species/custon should have all of this rolled in,
//       this is just a biology holder, not a real species.
/datum/species/shapeshifter/chimeric
	abstract_type = /datum/species/shapeshifter/chimeric
	uid = "chimeric"
	id = "chimeric"

#warn adaptation node, core, etc

	max_age = 500

	// TODO: make this an adaptation instead
	virus_immune = TRUE

	// TODO: proper shapeshift handling
	valid_transform_species = list(
		SPECIES_HUMAN,
		SPECIES_UNATHI,
		SPECIES_UNATHI_DIGI,
		SPECIES_TAJ,
		SPECIES_SKRELL,
		SPECIES_DIONA,
		SPECIES_TESHARI,
		SPECIES_MONKEY,SPECIES_SERGAL,
		SPECIES_AKULA,SPECIES_NEVREAN,SPECIES_ZORREN_HIGH,
		SPECIES_ZORREN_FLAT,
		SPECIES_VULPKANIN,
		SPECIES_VASILISSAN,
		SPECIES_RAPALA,
		SPECIES_MONKEY_SKRELL,
		SPECIES_MONKEY_UNATHI,
		SPECIES_MONKEY_TAJ,
		SPECIES_MONKEY_AKULA,
		SPECIES_MONKEY_VULPKANIN,
		SPECIES_MONKEY_SERGAL,
		SPECIES_MONKEY_NEVREAN,
		SPECIES_VOX,
	)
