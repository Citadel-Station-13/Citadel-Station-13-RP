GLOBAL_LIST_INIT(hardcoded_gases, list(/datum/gas/oxygen, /datum/gas/nitrogen, /datum/gas/carbon_dioxide, /datum/gas/plasma)) //the main four gases, which were at one time hardcoded
GLOBAL_LIST_INIT(nonreactive_gases, typecacheof(list(/datum/gas/oxygen, /datum/gas/nitrogen, /datum/gas/carbon_dioxide, /datum/gas/pluoxium, /datum/gas/stimulum, /datum/gas/nitryl))) //unable to react amongst themselves

/proc/gas_id2path(id)
	var/list/meta_gas = GLOB.meta_gas_ids
	if(id in meta_gas)
		return id
	for(var/path in meta_gas)
		if(meta_gas[path] == id)
			return path
	return ""

//Unomos - oh god oh fuck oh shit oh lord have mercy this is messy as fuck oh god
//my addiction to seeing better performance numbers isn't healthy, kids
//you see this shit, children?
//i am not a good idol. don't take after me.
//this is literally worse than my alcohol addiction
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

#warn implement everything above

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
