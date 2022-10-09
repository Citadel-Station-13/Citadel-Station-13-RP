
GLOBAL_LIST_INIT(meta_gas_visibility, meta_gas_visibility_list())
GLOBAL_LIST_INIT(meta_gas_overlays, meta_gas_overlay_list())
/// Typecache of gases with no overlays
GLOBAL_LIST_INIT(meta_gas_typecache_no_overlays, meta_gas_typecache_no_overlays_list())

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

/proc/meta_gas_typecache_no_overlays_list()
	. = list()
	for(var/gastype in subtypesof(/datum/gas))
		var/datum/gas/gasvar = gastype
		if (!initial(gasvar.gas_overlay))
			.[gastype] = TRUE


/*||||||||||||||/----------\||||||||||||||*\
||||||||||||||||[GAS DATUMS]||||||||||||||||
||||||||||||||||\__________/||||||||||||||||
||||These should never be instantiated. ||||
||||They exist only to make it easier   ||||
||||to add a new gas. They are accessed ||||
||||only by meta_gas_list().            ||||
\*||||||||||||||||||||||||||||||||||||||||*/
/datum/gas
	//! Intrinsics
	/// Text ID for things like gas strings. THIS SHOULD NEVER, EVER, BE CHANGED! Pick one and stick with it. Change this and EVERYTHING breaks. The typepath, infact, is more mutable than this!
	var/id = ""
	/// Textual name
	var/name = "Unnamed Gas"
	/// Gas flags. See [code/__DEFINES/atmospherics/flags.dm]
	var/gas_flags = GAS_FLAG_KNOWN
	/// gas group - list support can be added later
	var/gas_group = GAS_GROUP_UNKONWN

	//! physics
	/// Specific heat in J/(mol*K)
	var/specific_heat = 0
	/// Molar mass in kg/mol
	var/molar_mass = 0

	#warn unit test for reagent sanity
	//! reagents
	/// reagent id to apply
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

	//! visuals
	/// icon_state in icons/effects/atmospherics.dmi
	var/gas_overlay = ""
	/// How many moles is required to make this gas visible
	var/moles_visible

	//! reactions
	/// Fusion is not yet implemented : How much the gas accelerates a fusion reaction
	var/fusion_power = 0
	/// Relative rarity compared to other gases, used when setting up the reactions list.
	var/rarity = 0

/datum/gas/oxygen
	id = GAS_ID_OXYGEN
	name = "Oxygen"
	specific_heat = 20
	molar_mass = 0.032
	gas_flags = GAS_FLAG_OXIDIZER

/datum/gas/nitrogen
	id = GAS_ID_NITROGEN
	name = "Nitrogen"
	specific_heat = 20
	molar_mass = 0.028

/datum/gas/carbon_dioxide
	id = GAS_ID_CARBON_DIOXIDE
	name = "Carbon Dioxide"
	specific_heat = 30
	molar_mass = 0.044

/datum/gas/phoron
	id = GAS_ID_PHORON
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
	id = GAS_ID_VOLATILE_FUEL
	name = "Volatile Fuel"
	specific_heat = 253	// J/(mol*K)	C8H18 gasoline. Isobaric, but good enough.
	molar_mass = 0.114	// kg/mol. 		same.

	gas_flags = GAS_FLAG_FUEL

/datum/gas/nitrous_oxide
	id = GAS_ID_NITROUS_OXIDE
	name = "Nitrous Oxide"
	specific_heat = 40
	molar_mass = 0.044

	gas_overlay = "nitrous_oxide"
	moles_visible = 1

	gas_flags = GAS_FLAG_OXIDIZER

//The following is partially stolen from Nebula
//I am not rewriting our handling of air for this, at least for now.
/datum/gas/helium
	id = GAS_ID_HELIUM
	name = "Helium"
	specific_heat = 80
	molar_mass = 0.004

	gas_flags = GAS_FLAG_FUSION_FUEL

/datum/gas/carbon_monoxide
	id = GAS_ID_CARBON_MONOXIDE
	name = "Carbon Monoxide"
	//lore_text = "A highly poisonous gas."
	specific_heat = 30
	molar_mass = 0.028

	//gas_symbol_html = "CO"
	//gas_symbol = "CO"
	//taste_description = "stale air"
	//metabolism = 0.05 // As with helium.

/datum/gas/methyl_bromide
	id = GAS_ID_METHYL_BROMIDE
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
	id = GAS_ID_NITROGEN_DIOXIDE
	name = "Nitrogen Dioxide"
	//color = "#ca6409"
	specific_heat = 37
	molar_mass = 0.054
	gas_flags = GAS_FLAG_OXIDIZER
	//gas_symbol_html = "NO<sub>2</sub>"
	//gas_symbol = "NO2"

/datum/gas/nitricoxide
	id = GAS_ID_NITRIC_OXIDE
	name = "Nitric Oxide"
	specific_heat = 10
	molar_mass = 0.030
	gas_flags = GAS_FLAG_OXIDIZER
	//gas_symbol_html = "NO"
	//gas_symbol = "NO"

/datum/gas/methane
	id = GAS_ID_METHANE
	name = "Methane"
	specific_heat = 30
	molar_mass = 0.016
	gas_flags = GAS_FLAG_FUEL
	//gas_symbol_html = "CH<sub>4</sub>"
	//gas_symbol = "CH4"

/datum/gas/argon
	id = GAS_ID_ARGON
	name = "Argon"
	//lore_text = "Just when you need it, all of your supplies argon."
	specific_heat = 10
	molar_mass = 0.018
	//gas_symbol_html = "Ar"
	//gas_symbol = "Ar"
	//value = 0.25

// If narcosis is ever simulated, krypton has a narcotic potency seven times greater than regular airmix.
/datum/gas/krypton
	id = GAS_ID_KRYPTON
	name = "Krypton"
	specific_heat = 5
	molar_mass = 0.036
	//gas_symbol_html = "Kr"
	//gas_symbol = "Kr"
	//value = 0.25

/datum/gas/neon
	id = GAS_ID_NEON
	name = "Neon"
	specific_heat = 20
	molar_mass = 0.01
	//gas_symbol_html = "Ne"
	//gas_symbol = "Ne"
	//value = 0.25

/datum/gas/ammonia
	id = GAS_ID_AMMONIA
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
	id = GAS_ID_XENON
	name = "xenon"
	specific_heat = 3
	molar_mass = 0.054
	//gas_symbol_html = "Xe"
	//gas_symbol = "Xe"
	//value = 0.25

/datum/gas/chlorine
	id = GAS_ID_CHLORINE
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
	id = GAS_ID_SULFUR_DIOXIDE
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
	id = GAS_ID_HYDROGEN
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
		/decl/material/gas/hydrogen/tritium = 1
	)
	neutron_absorption = 5
	neutron_cross_section = 3*/

//Special gas type that are very powerful and shouldnt be avaiable in large portions
/datum/gas/vimur
	id = GAS_ID_VIMUR
	name = "Vimur"
	specific_heat = 500	// J/(mol*K) //250% the heat capacity of phoron
	molar_mass = 0.054 // Standard Mass of xenon

	gas_overlay = "vimur"
	moles_visible = 0.1
