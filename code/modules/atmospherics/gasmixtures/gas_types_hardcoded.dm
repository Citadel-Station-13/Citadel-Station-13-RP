// todo: eithre rename or remove this and overhaul its uses, fucks sakes.
/datum/gas/volatile_fuel
	id = GAS_ID_VOLATILE_FUEL
	name = "Volatile Fuel"
	specific_heat = 253	// J/(mol*K)	C8H18 gasoline. Isobaric, but good enough.
	molar_mass = 1000 * 0.114	// kg/mol. 		same.

	gas_flags = GAS_FLAG_FUEL

//The following is partially stolen from Nebula
//I am not rewriting our handling of air for this, at least for now.
/datum/gas/helium
	id = GAS_ID_HELIUM
	name = "Helium"
	specific_heat = 80
	molar_mass = 1000 * 0.004

	gas_flags = GAS_FLAG_FUSION_FUEL

/datum/gas/carbon_monoxide
	id = GAS_ID_CARBON_MONOXIDE
	name = "Carbon Monoxide"
	//lore_text = "A highly poisonous gas."
	specific_heat = 30
	molar_mass = 1000 * 0.028

	//gas_symbol_html = "CO"
	//gas_symbol = "CO"
	//taste_description = "stale air"
	//metabolism = 0.05 // As with helium.

/datum/gas/methyl_bromide
	id = GAS_ID_METHYL_BROMIDE
	name = "Methyl Bromide"
	//lore_text = "A once-popular fumigant and weedkiller."
	specific_heat = 42.59
	molar_mass = 1000 * 0.095
	//gas_symbol_html = "CH<sub>3</sub>Br"
	//gas_symbol = "CH3Br"
	//taste_description = "pestkiller"
	/*vapor_products = list(
		/singleton/material/gas/methyl_bromide = 1
	)
	value = 0.25*/

/datum/gas/nitrodioxide
	id = GAS_ID_NITROGEN_DIOXIDE
	name = "Nitrogen Dioxide"
	//color = "#ca6409"
	specific_heat = 37
	molar_mass = 1000 * 0.054
	gas_flags = GAS_FLAG_OXIDIZER
	//gas_symbol_html = "NO<sub>2</sub>"
	//gas_symbol = "NO2"

/datum/gas/nitricoxide
	id = GAS_ID_NITRIC_OXIDE
	name = "Nitric Oxide"
	specific_heat = 10
	molar_mass = 1000 * 0.030
	gas_flags = GAS_FLAG_OXIDIZER
	//gas_symbol_html = "NO"
	//gas_symbol = "NO"

/datum/gas/methane
	id = GAS_ID_METHANE
	name = "Methane"
	specific_heat = 30
	molar_mass = 1000 * 0.016
	gas_flags = GAS_FLAG_FUEL
	//gas_symbol_html = "CH<sub>4</sub>"
	//gas_symbol = "CH4"

/datum/gas/argon
	id = GAS_ID_ARGON
	name = "Argon"
	//lore_text = "Just when you need it, all of your supplies argon."
	specific_heat = 10
	molar_mass = 1000 * 0.018
	//gas_symbol_html = "Ar"
	//gas_symbol = "Ar"
	//value = 0.25

// If narcosis is ever simulated, krypton has a narcotic potency seven times greater than regular airmix.
/datum/gas/krypton
	id = GAS_ID_KRYPTON
	name = "Krypton"
	specific_heat = 5
	molar_mass = 1000 * 0.036
	//gas_symbol_html = "Kr"
	//gas_symbol = "Kr"
	//value = 0.25

/datum/gas/neon
	id = GAS_ID_NEON
	name = "Neon"
	specific_heat = 20
	molar_mass = 1000 * 0.01
	//gas_symbol_html = "Ne"
	//gas_symbol = "Ne"
	//value = 0.25

/datum/gas/ammonia
	id = GAS_ID_AMMONIA
	name = "Ammonia"
	specific_heat = 20
	molar_mass = 1000 * 0.017
	//gas_symbol_html = "NH<sub>3</sub>"
	//gas_symbol = "NH3"
	//metabolism = 0.05 // So that low dosages have a chance to build up in the body.
	//taste_description = "mordant"
	//taste_mult = 2
	//lore_text = "A caustic substance commonly used in fertilizer or household cleaners."
	//color = "#404030"
	//metabolism = REM * 0.5
	//overdose = 5

/datum/gas/xenon
	id = GAS_ID_XENON
	name = "Xenon"
	specific_heat = 3
	molar_mass = 1000 * 0.054
	//gas_symbol_html = "Xe"
	//gas_symbol = "Xe"
	//value = 0.25

/datum/gas/chlorine
	id = GAS_ID_CHLORINE
	name = "Chlorine"
	//color = "#c5f72d"
	//visual_overlay_limit = 0.5
	specific_heat = 5
	molar_mass = 1000 * 0.017
	gas_flags = GAS_FLAG_CONTAMINANT
	/*gas_symbol_html = "Cl"
	gas_symbol = "Cl"
	taste_description = "bleach"
	metabolism = REM
	heating_point = null
	heating_products = null
	toxicity = 15*/
	visual_overlay = "chlorine"
	visual_threshold = 1

	gas_reagent_id = "sacid"
	gas_reagent_amount = 10


/datum/gas/sulfur_dioxide
	id = GAS_ID_SULFUR_DIOXIDE
	name = "Sulfur Dioxide"
	specific_heat = 30
	molar_mass = 1000 * 0.044
	/*gas_symbol_html = "SO<sub>2</sub>"
	gas_symbol = "SO2"
	dissolves_into = list(
		/singleton/material/solid/sulfur = 0.5,
		/singleton/material/gas/oxygen = 0.5
	)*/

/datum/gas/tritium
	id = GAS_ID_TRITIUM
	name = "Tritium"
	/*lore_text = "A radioactive isotope of hydrogen. Useful as a fusion reactor fuel material."
	mechanics_text = "Tritium is useable as a fuel in some forms of portable generator. It can also be converted into a fuel rod suitable for a R-UST fusion plant injector by using a fuel compressor. It fuses hotter than deuterium but is correspondingly more unstable."
	color = "#777777"
	stack_origin_tech = "{'materials':5}"
	value = 0.45
	gas_symbol_html = "T"
	gas_symbol = "T"*/

/datum/gas/deuterium
	id = GAS_ID_DEUTERIUM
	name = "Deuterium"
	/*lore_text = "One of the two stable isotopes of hydrogen; also known as heavy hydrogen. Useful as a chemically synthesised fusion reactor fuel material."
	mechanics_text = "Deuterium can be converted into a fuel rod suitable for a R-UST fusion plant injector by using a fuel compressor. It is the most 'basic' fusion fuel."
	flags = MAT_FLAG_FUSION_FUEL | MAT_FLAG_FISSIBLE
	color = "#999999"
	stack_origin_tech = "{'materials':3}"
	gas_symbol_html = "D"
	gas_symbol = "D"
	value = 0.5

	neutron_interactions = list(
		INTERACTION_ABSORPTION = 1250
	)
	absorption_products = list(
		/singleton/material/gas/hydrogen/tritium = 1
	)
	neutron_absorption = 5
	neutron_cross_section = 3*/

//Special gas type that are very powerful and shouldnt be avaiable in large portions
/datum/gas/vimur
	id = GAS_ID_VIMUR
	name = "Vimur"
	specific_heat = 500	// J/(mol*K) //250% the heat capacity of phoron
	molar_mass = 1000 * 0.054 // Standard Mass of xenon

	visual_overlay = "vimur"
	visual_threshold = 0.1
