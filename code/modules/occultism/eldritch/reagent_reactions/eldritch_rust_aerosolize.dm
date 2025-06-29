//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2025 Citadel Station Developers           *//

/datum/chemical_reaction/eldritch_rust_aerosolize
	id = "eldritch-rust-aerosolize"
	holder_flags_start_require = REAGENT_HOLDER_FLAG_BEING_JOSTLED | REAGENT_HOLDER_FLAG_OPEN_CONTAINER
	required_reagents = list(
		/datum/reagent/eldritch_rust::id = 1,
	)

/datum/chemical_reaction/eldritch_rust_aerosolize/on_reaction_instant(datum/reagent_holder/holder, multiplier)

#warn impl
