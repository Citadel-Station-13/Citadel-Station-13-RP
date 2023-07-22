//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

#warn port in rest from gas_types_hardcoded and audit heats/masses.

/datum/gas/oxygen
	id = GAS_ID_OXYGEN
	name = "O2"

	gas_flags = GAS_FLAG_OXIDIZER | GAS_FLAG_FILTERABLE | GAS_FLAG_CORE
	gas_groups = GAS_GROUP_CORE

/datum/gas/nitrogen
	id = GAS_ID_NITROGEN
	name = "N2"

	gas_groups = GAS_GROUP_CORE

/datum/gas/carbon_dioxide
	id = GAS_ID_CARBON_DIOXIDE
	name = "CO2"

	gas_groups = GAS_GROUP_CORE

/datum/gas/nitrous_oxide
	id = GAS_ID_NITROUS_OXIDE
	name = "N2O"

	visual_overlay = "nitrous_oxide"
	visual_threshold = 1

	gas_flags = GAS_FLAG_OXIDIZER | GAS_FLAG_FILTERABLE | GAS_FLAG_CORE
	gas_groups = GAS_GROUP_CORE

/datum/gas/hydrogen
	id = GAS_ID_HYDROGEN
	name = "H"

	gas_flags = GAS_FLAG_FUEL | GAS_FLAG_FUSION_FUEL | GAS_FLAG_FILTERABLE | GAS_FLAG_CORE
	gas_groups = GAS_GROUP_CORE

/datum/gas/phoron
	id = GAS_ID_PHORON
	name = "PHR"

	visual_overlay = "phoron"
	visual_threshold = 0.7

	gas_flags = GAS_FLAG_FUEL | GAS_FLAG_FUSION_FUEL | GAS_FLAG_CONTAMINANT | GAS_FLAG_FILTERABLE | GAS_FLAG_CORE
	gas_groups = GAS_GROUP_CORE
