/// List of gases that can't react amongst themselves. KEEP THIS UP TO DATE!
GLOBAL_LIST_INIT(nonreactive_gases, typecacheof(list(/datum/gas/oxygen, /datum/gas/nitrogen, /datum/gas/carbon_dioxide)))

/**
  * Converts a gas ID to typepath
  */
/proc/gas_id2path(id)
	return GLOB.meta_gas_id_lookup[id]

//Unomos - global list inits for all of the meta gas lists.
//This setup allows procs to only look at one list instead of trying to dig around in lists-within-lists
GLOBAL_LIST_INIT(meta_gas_specific_heats, meta_gas_heat_list())
GLOBAL_LIST_INIT(meta_gas_names, meta_gas_name_list())
GLOBAL_LIST_INIT(meta_gas_visibility, meta_gas_visibility_list())
GLOBAL_LIST_INIT(meta_gas_overlays, meta_gas_overlay_list())
GLOBAL_LIST_INIT(meta_gas_dangers, meta_gas_danger_list())
GLOBAL_LIST_INIT(meta_gas_ids, meta_gas_id_list())
GLOBAL_LIST_INIT(meta_gas_fusions, meta_gas_fusion_list())
/// Gas ID to typepath conversion lookup for optimal speed.
GLOBAL_LIST_INIT(meta_gas_id_lookup, meta_gas_id_lookup_list())
/// Gas flags by gas
GLOBAL_LIST_INIT(meta_gas_flags, meta_gas_flag_list())
/// Gases by gas flag
GLOBAL_LIST_INIT(meta_gas_by_flag, meta_gas_by_flag_list())
/// Gas molar mass by gas
GLOBAL_LIST_INIT(meta_gas_molar_mass, meta_gas_molar_mass_list())
/// Typecache of gases with no overlays
GLOBAL_LIST_INIT(meta_gas_typecache_no_overlays, meta_gas_typecache_no_overlays_list())
/// The reagents gases give mobs when breathed
GLOBAL_LIST_INIT(meta_gas_reagent_id, meta_gas_reagent_id_list())
/// The amount of the reagents gases give mobs
GLOBAL_LIST_INIT(meta_gas_reagent_amount, meta_gas_reagent_amount_list())


/proc/meta_gas_heat_list()
	. = subtypesof(/datum/gas)
	for(var/gas_path in .)
		var/datum/gas/gas = gas_path
		.[gas_path] = initial(gas.specific_heat)

/proc/meta_gas_name_list()
	. = subtypesof(/datum/gas)
	for(var/gas_path in .)
		var/datum/gas/gas = gas_path
		.[gas_path] = initial(gas.name)

/proc/meta_gas_visibility_list()
	. = subtypesof(/datum/gas)
	for(var/gas_path in .)
		var/datum/gas/gas = gas_path
		.[gas_path] = initial(gas.moles_visible)

/proc/meta_gas_overlay_list()
	. = subtypesof(/datum/gas)
	for(var/gas_path in .)
		var/datum/gas/gas = gas_path
		.[gas_path] = 0 //gotta make sure if(GLOB.meta_gas_overlays[gaspath]) doesn't break
		if(initial(gas.moles_visible) != null)
			.[gas_path] = new /list(FACTOR_GAS_VISIBLE_MAX)
			for(var/i in 1 to FACTOR_GAS_VISIBLE_MAX)
				var/image/I = image('icons/effects/atmospherics.dmi', icon_state = initial(gas.gas_overlay), layer = FLOAT_LAYER + i)
				I.plane = FLOAT_PLANE
				I.alpha = i * 255 / FACTOR_GAS_VISIBLE_MAX
				I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
				I.appearance_flags = RESET_TRANSFORM | RESET_COLOR | RESET_ALPHA | KEEP_APART
				.[gas_path][i] = I

/proc/meta_gas_danger_list()
	. = subtypesof(/datum/gas)
	for(var/gas_path in .)
		var/datum/gas/gas = gas_path
		.[gas_path] = initial(gas.dangerous)

/proc/meta_gas_id_list()
	. = subtypesof(/datum/gas)
	for(var/gas_path in .)
		var/datum/gas/gas = gas_path
		.[gas_path] = initial(gas.id)

/proc/meta_gas_fusion_list()
	. = subtypesof(/datum/gas)
	for(var/gas_path in .)
		var/datum/gas/gas = gas_path
		.[gas_path] = initial(gas.fusion_power)

/proc/meta_gas_id_lookup_list()
	var/list/gases = subtypesof(/datum/gas)
	. = list()
	for(var/gas_path in gases)
		var/datum/gas/gas = gas_path
		.[initial(gas.id)] = gas_path

/proc/meta_gas_flag_list()
	. = subtypesof(/datum/gas)
	for(var/gas_path in .)
		var/datum/gas/gas = gas_path
		.[gas_path] = initial(gas.gas_flags)

/proc/meta_gas_by_flag_list()
	. = list()
	// slightly more tricky
	var/list/gases = subtypesof(/datum/gas)
	// for each gas
	for(var/gas_path in gases)
		var/datum/gas/gas = gas_path
		// cache flags
		var/gas_flags = initial(gas.gas_flags)
		// for each bitfield
		for(var/i in GLOB.bitflags)
			// if we have it
			if(gas_flags & i)
				// add to list
				LAZYADD(.["[i]"], gas_path)

/proc/meta_gas_molar_mass_list()
	. = list()
	var/list/gases = subtypesof(/datum/gas)
	for(var/gas_path in gases)
		var/datum/gas/G = gas_path
		.[gas_path] = initial(G.molar_mass)

/proc/meta_gas_typecache_no_overlays_list()
	. = list()
	for(var/gastype in subtypesof(/datum/gas))
		var/datum/gas/gasvar = gastype
		if (!initial(gasvar.gas_overlay))
			.[gastype] = TRUE

/proc/meta_gas_reagent_id_list()
	. = list()
	for(var/gastype in subtypesof(/datum/gas))
		var/datum/gas/gasvar = gastype
		if(initial(gasvar.gas_reagent_id))
			.[gastype] = initial(gasvar.gas_reagent_id)

/proc/meta_gas_reagent_amount_list()
	. = list()
	for(var/gastype in subtypesof(/datum/gas))
		var/datum/gas/gasvar = gastype
		if(initial(gasvar.gas_reagent_amount))
			.[gastype] = initial(gasvar.gas_reagent_amount)
// Visual overlay
/*
/obj/effect/overlay/gas
	icon = 'icons/effects/atmospherics.dmi'
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE  // should only appear in vis_contents, but to be safe
	layer = FLY_LAYER
	appearance_flags = TILE_BOUND
	vis_flags = NONE

/obj/effect/overlay/gas/New(state, alph)
	. = ..()
	icon_state = state
	alpha = alph
*/

/*||||||||||||||/----------\||||||||||||||*\
||||||||||||||||[GAS DATUMS]||||||||||||||||
||||||||||||||||\__________/||||||||||||||||
||||These should never be instantiated. ||||
||||They exist only to make it easier   ||||
||||to add a new gas. They are accessed ||||
||||only by meta_gas_list().            ||||
\*||||||||||||||||||||||||||||||||||||||||*/
/datum/gas
	/// Text ID for things like gas strings. THIS SHOULD NEVER, EVER, BE CHANGED! Pick one and stick with it. Change this and EVERYTHING breaks. The typepath, infact, is more mutable than this!
	var/id = ""
	/// Specific heat in J/(mol*K)
	var/specific_heat = 0
	/// Textual name
	var/name = "Unnamed Gas"
	/// icon_state in icons/effects/atmospherics.dmi
	var/gas_overlay = ""
	/// How many moles is required to make this gas visible
	var/moles_visible
	/// Is this gas considered dangerous? Used by canister and admin logging in general.
	var/dangerous = FALSE
	/// Fusion is not yet implemented : How much the gas accelerates a fusion reaction
	var/fusion_power = 0
	/// Relative rarity compared to other gases, used when setting up the reactions list.
	var/rarity = 0
	/// Molar mass in kg/mol
	var/molar_mass = 0
	/// Gas flags. See [code/__DEFINES/atmospherics/flags.dm]
	var/gas_flags

	var/gas_reagent_id //What is the ID of the reagent we want to apply
	var/gas_reagent_amount = 0//How much of the reagent is applied 
	//For a gas that makes up 21% of the atmos you need to be above 1.39, for it to instill any reagents, for lower percentages the number needs to be higher,and viceversa

/datum/gas/oxygen
	id = "o2"
	name = "Oxygen"
	specific_heat = 20
	molar_mass = 0.032
	gas_flags = GAS_FLAG_OXIDIZER

/datum/gas/nitrogen
	id = "n2"
	name = "Nitrogen"
	specific_heat = 20
	molar_mass = 0.028

/datum/gas/carbon_dioxide
	id = "co2"
	name = "Carbon Dioxide"
	specific_heat = 30
	molar_mass = 0.044

/datum/gas/phoron
	id = "phoron"
	name = "Phoron"
	//Note that this has a significant impact on TTV yield.
	//Because it is so high, any leftover phoron soaks up a lot of heat and drops the yield pressure.
	specific_heat = 200	// J/(mol*K)

	//Hypothetical group 14 (same as carbon), period 8 element.
	//Using multiplicity rule, it's atomic number is 162
	//and following a N/Z ratio of 1.5, the molar mass of a monatomic gas is:
	molar_mass = 0.405	// kg/mol

	gas_overlay = "phoron"

	moles_visible = 0.7

	gas_flags = GAS_FLAG_FUEL | GAS_FLAG_FUSION_FUEL | GAS_FLAG_CONTAMINANT

/datum/gas/volatile_fuel
	id = "volatile_fuel"
	name = "Volatile Fuel"
	specific_heat = 253	// J/(mol*K)	C8H18 gasoline. Isobaric, but good enough.
	molar_mass = 0.114	// kg/mol. 		same.

	gas_flags = GAS_FLAG_FUEL

/datum/gas/nitrous_oxide
	id = "n2o"
	name = "Nitrous Oxide"
	specific_heat = 40
	molar_mass = 0.044

	gas_overlay = "nitrous_oxide"
	moles_visible = 1

	gas_flags = GAS_FLAG_OXIDIZER

//The following is partially stolen from Nebula
//I am not rewriting our handling of air for this, at least for now.
/datum/gas/helium
	id = "helium"
	name = "Helium"
	specific_heat = 80
	molar_mass = 0.004

	gas_flags = GAS_FLAG_FUSION_FUEL

/datum/gas/carbon_monoxide
	id = "carbon monoxide"
	name = "Carbon Monoxide"
	//lore_text = "A highly poisonous gas."
	specific_heat = 30
	molar_mass = 0.028

	//gas_symbol_html = "CO"
	//gas_symbol = "CO"
	//taste_description = "stale air"
	//metabolism = 0.05 // As with helium.

/datum/gas/methyl_bromide
	id = "methyl bromide"
	name = "Methyl Bromide"
	//lore_text = "A once-popular fumigant and weedkiller."
	specific_heat = 42.59
	molar_mass = 0.095
	//gas_symbol_html = "CH<sub>3</sub>Br"
	//gas_symbol = "CH3Br"
	//taste_description = "pestkiller"
	/*vapor_products = list(
		/decl/material/gas/methyl_bromide = 1
	)
	value = 0.25*/

/datum/gas/nitrodioxide
	id = "nitrogen dioxide"
	name = "Nitrogen Dioxide"
	//color = "#ca6409"
	specific_heat = 37
	molar_mass = 0.054
	gas_flags = GAS_FLAG_OXIDIZER
	//gas_symbol_html = "NO<sub>2</sub>"
	//gas_symbol = "NO2"

/datum/gas/nitricoxide
	id = "nitric oxide"
	name = "Nitric Oxide"
	specific_heat = 10
	molar_mass = 0.030
	gas_flags = GAS_FLAG_OXIDIZER
	//gas_symbol_html = "NO"
	//gas_symbol = "NO"

/datum/gas/methane
	id = "methane"
	name = "Methane"
	specific_heat = 30
	molar_mass = 0.016
	gas_flags = GAS_FLAG_FUEL
	//gas_symbol_html = "CH<sub>4</sub>"
	//gas_symbol = "CH4"

/datum/gas/argon
	id = "argon"
	name = "Argon"
	//lore_text = "Just when you need it, all of your supplies argon."
	specific_heat = 10
	molar_mass = 0.018
	//gas_symbol_html = "Ar"
	//gas_symbol = "Ar"
	//value = 0.25

// If narcosis is ever simulated, krypton has a narcotic potency seven times greater than regular airmix.
/datum/gas/krypton
	id = "krypton"
	name = "Krypton"
	specific_heat = 5
	molar_mass = 0.036
	//gas_symbol_html = "Kr"
	//gas_symbol = "Kr"
	//value = 0.25

/datum/gas/neon
	id = "neon"
	name = "Neon"
	specific_heat = 20
	molar_mass = 0.01
	//gas_symbol_html = "Ne"
	//gas_symbol = "Ne"
	//value = 0.25

/datum/gas/ammonia
	id = "Ammonia"
	name = "ammonia"
	specific_heat = 20
	molar_mass = 0.017
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
	id = "Xenon"
	name = "xenon"
	specific_heat = 3
	molar_mass = 0.054
	//gas_symbol_html = "Xe"
	//gas_symbol = "Xe"
	//value = 0.25

/datum/gas/chlorine
	id = "chlorine"
	name = "Chlorine"
	//color = "#c5f72d"
	//gas_overlay_limit = 0.5
	specific_heat = 5
	molar_mass = 0.017
	gas_flags = GAS_FLAG_CONTAMINANT
	/*gas_symbol_html = "Cl"
	gas_symbol = "Cl"
	taste_description = "bleach"
	metabolism = REM
	heating_point = null
	heating_products = null
	toxicity = 15*/
	gas_overlay = "chlorine"
	moles_visible = 1
	
	gas_reagent_id = "sacid"
	gas_reagent_amount = 10


/datum/gas/sulfur_dioxide
	id = "sulfur dioxide"
	name = "Sulfur Dioxide"
	specific_heat = 30
	molar_mass = 0.044
	/*gas_symbol_html = "SO<sub>2</sub>"
	gas_symbol = "SO2"
	dissolves_into = list(
		/decl/material/solid/sulfur = 0.5,
		/decl/material/gas/oxygen = 0.5
	)*/

/datum/gas/hydrogen
	id = "hydrogen"
	name = "Hydrogen"
	//lore_text = "A colorless, flammable gas."
	//flags = MAT_FLAG_FUSION_FUEL
	//wall_name = "bulkhead"
	//construction_difficulty = MAT_VALUE_HARD_DIY
	specific_heat = 100
	molar_mass = 0.002
	gas_flags = GAS_FLAG_FUEL | GAS_FLAG_FUSION_FUEL
	/*burn_product = /decl/material/liquid/water
	gas_symbol_html = "H<sub>2</sub>"
	gas_symbol = "H2"
	dissolves_into = list(
		/decl/material/liquid/fuel/hydrazine = 1
	)
	value = 0.4*/

/datum/gas/hydrogen/tritium
	id = "tritium"
	name = "Tritium"
	/*lore_text = "A radioactive isotope of hydrogen. Useful as a fusion reactor fuel material."
	mechanics_text = "Tritium is useable as a fuel in some forms of portable generator. It can also be converted into a fuel rod suitable for a R-UST fusion plant injector by using a fuel compressor. It fuses hotter than deuterium but is correspondingly more unstable."
	color = "#777777"
	stack_origin_tech = "{'materials':5}"
	value = 0.45
	gas_symbol_html = "T"
	gas_symbol = "T"*/

/datum/gas/hydrogen/deuterium
	id = "Deuterium"
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
		/decl/material/gas/hydrogen/tritium = 1
	)
	neutron_absorption = 5
	neutron_cross_section = 3*/

//Special gas type that are very powerful and shouldnt be avaiable in large portions
/datum/gas/vimur
	id = "vimur"
	name = "Vimur"
	specific_heat = 500	// J/(mol*K) //250% the heat capacity of phoron
	molar_mass = 0.054 // Standard Mass of xenon

	gas_overlay = "vimur"
	moles_visible = 0.1
