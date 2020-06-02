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
GLOBAL_LIST_INIT(meta_gas_by_lag, meta_gas_by_flag_list())

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
				.[gas_path][i] = new /obj/effect/overlay/gas(initial(gas.gas_overlay), i * 255 / FACTOR_GAS_VISIBLE_MAX)

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
		.[gas_path] = initial(gas.flags)

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

// Visual overlay
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

/datum/gas/oxygen
	id = "o2"
	name = "Oxygen"
	specific_heat = 20
	molar_mass = 0.032
	flags = GAS_FLAG_OXIDIZER

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

	flags = GAS_FLAG_FUEL | GAS_FLAG_FUSION_FUEL | GAS_FLAG_CONTAMINANT

/datum/gas/volatile_fuel
	id = "volatile_fuel"
	name = "Volatile Fuel"
	specific_heat = 253	// J/(mol*K)	C8H18 gasoline. Isobaric, but good enough.
	molar_mass = 0.114	// kg/mol. 		same.

	flags = GAS_FLAG_FUEL

/datum/gas/nitrous_oxide
	id = "n2o"
	name = "Nitrous Oxide"
	specific_heat = 40
	molar_mass = 0.044

	gas_overlay = "nitrous_oxide"
	moles_visible = 1

	gas_flags = GAS_FLAG_OXIDIZER
