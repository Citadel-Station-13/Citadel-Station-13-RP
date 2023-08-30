//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

/datum/gas
	//* Intrinsics
	/// Text ID for things like gas strings. THIS SHOULD NEVER, EVER, BE CHANGED! Pick one and stick with it. Change this and EVERYTHING breaks. The typepath, infact, is more mutable than this!
	var/id = ""
	/// Textual name
	var/name = "Unnamed Gas"
	/// Gas flags. See [code/__DEFINES/atmospherics/flags.dm]
	var/gas_flags = GAS_FLAG_FILTERABLE
	/// gas group - flag
	var/gas_groups = GAS_GROUP_OTHER

	//* physics
	/// Specific heat in J/(mol*K).
	/// For chemicals that exist in real life this is the specific heat value under constant volume.
	var/specific_heat = 1
	/// Molar mass in kg/mol
	var/molar_mass = 1

	//* reagents
	/// reagent id to apply. set to typepath at compile time ; it will be automatically converted to ID if detected in New().
	var/gas_reagent_id
	/// reagent amount to add to someone breathing it at minimum moles
	var/gas_reagent_amount = 0
	/// minimum moles to affect
	var/gas_reagent_threshold = 0
	/// reagent amount to additionally add per mole
	var/gas_reagent_factor = 0
	/// reagent amount to not exceed in them
	var/gas_reagent_max = 10
	/// reserved for chemgas - how many moles of this gas corrospond to 1 unit; should always be inverse of reagent's side of this lookup
	var/gas_reagent_moles = 0.1

	//* visuals
	// todo: visual cache gen should be a proc on /datum/gas so we can do custom colors
	/// visual overlay color if any
	var/visual_color
	/// icon_state in icons/modules/atmospherics/gas.dmi; invisible if null
	var/visual_overlay
	/// minimum moles to see gas
	var/visual_threshold = 0.25
	/// index addition per mole for cache list
	var/visual_factor = 1

	//* reactions
	/// Fusion is not yet implemented : How much the gas accelerates a fusion reaction
	var/fusion_power = 0
	/// Relative rarity compared to other gases, used when setting up the reactions list.
	var/rarity = 0

	//* fluff
	/// default TLV values for air alarms in format of list(danger low, warning low, warning high, danger high)
	/// null to have air alarms ignore this gas entirely
	var/list/default_tlv

	// todo: combustion enthalpies / oxidizer powers
	// todo: combustion product gases

/datum/gas/New()
	if(ispath(gas_reagent_id))
		var/datum/reagent/R = gas_reagent_id
		gas_reagent_id = initial(R.id)
