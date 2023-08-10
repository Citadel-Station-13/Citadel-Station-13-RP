//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/gas/oxygen
	id = GAS_ID_OXYGEN
	name = "O2"

	specific_heat = 21
	molar_mass = 0.032
	gas_flags = GAS_FLAG_OXIDIZER | GAS_FLAG_FILTERABLE | GAS_FLAG_CORE
	gas_groups = GAS_GROUP_CORE

	default_tlv = list(16, 19, 70, 100)

/datum/gas/nitrogen
	id = GAS_ID_NITROGEN
	name = "N2"

	specific_heat = 20.8
	molar_mass = 0.028
	gas_flags = GAS_FLAG_FILTERABLE | GAS_FLAG_CORE
	gas_groups = GAS_GROUP_CORE

	default_tlv = list(0, 0, 135, 140)

/datum/gas/carbon_dioxide
	id = GAS_ID_CARBON_DIOXIDE
	name = "CO2"

	specific_heat = 28.82
	molar_mass = 0.044
	gas_flags = GAS_FLAG_FILTERABLE | GAS_FLAG_CORE
	gas_groups = GAS_GROUP_CORE

/datum/gas/nitrous_oxide
	id = GAS_ID_NITROUS_OXIDE
	name = "N2O"

	visual_overlay = "nitrous_oxide"
	visual_threshold = 1

	specific_heat = 30.36
	molar_mass = 0.044
	gas_flags = GAS_FLAG_OXIDIZER | GAS_FLAG_FILTERABLE | GAS_FLAG_CORE
	gas_groups = GAS_GROUP_CORE

/datum/gas/hydrogen
	id = GAS_ID_HYDROGEN
	name = "H2"

	specific_heat = 20.32
	molar_mass = 0.002
	gas_flags = GAS_FLAG_FUEL | GAS_FLAG_FUSION_FUEL | GAS_FLAG_FILTERABLE | GAS_FLAG_CORE
	gas_groups = GAS_GROUP_CORE

/datum/gas/phoron
	id = GAS_ID_PHORON
	name = "PHR"

	visual_overlay = "phoron"
	visual_threshold = 0.7

	// Hypothetical group 14, period 8 element
	// Atomic number 162
	// Neutron/Proton ratio 1.5
	molar_mass = 0.405
	// wonder scifi carbon-group element
	// we're going to assume it's a polyatomic gas
	// infact while we're at it why not just assume it's some
	// weird magic element that naturally forms complex structures like
	// carbon nanotubes or something lol i'm sure that'll justify this value
	specific_heat = 207.52
	gas_flags = GAS_FLAG_FUEL | GAS_FLAG_FUSION_FUEL | GAS_FLAG_CONTAMINANT | GAS_FLAG_FILTERABLE | GAS_FLAG_CORE
	gas_groups = GAS_GROUP_CORE
