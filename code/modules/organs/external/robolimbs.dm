GLOBAL_LIST_EMPTY(all_robolimbs)
GLOBAL_LIST_EMPTY(robolimb_data)
GLOBAL_LIST_EMPTY(chargen_robolimbs)
GLOBAL_DATUM(basic_robolimb, /datum/robolimb)

// fuck you whoever wrote these vars
// use lists like a normal human
// TODO: REFACTOR
var/const/standard_monitor_styles = "blank=ipc_blank;\
	black=ipc_black;\
	pink=ipc_pink;\
	green=ipc_green;\
	red=ipc_red;\
	blue=ipc_blue;\
	shower=ipc_shower;\
	orange=ipc_orange;\
	nature=ipc_nature;\
	eight=ipc_eight;\
	goggles=ipc_goggles;\
	heart=ipc_heart;\
	monoeye=ipc_monoeye;\
	breakout=ipc_breakout;\
	yellow=ipc_yellow;\
	static=ipc_static;\
	purple=ipc_purple;\
	scroll=ipc_scroll;\
	console=ipc_console;\
	glider=ipc_gol_glider;\
	rainbow=ipc_rainbow;\
	smiley=ipc_smiley;\
	database=ipc_database;\
	doom=ipc_doom"

var/const/cyberbeast_monitor_styles= "blank=cyber_blank;\
	default=cyber_default;\
	eyes=eyes;\
	static=cyber_static;\
	alert=cyber_alert;\
	happy=cyber_happ;\
	unhappy=cyber_unhapp;\
	flat=cyber_flat;\
	sad=cyber_sad;\
	heart=cyber_heart;\
	cross=cyber_cross;\
	wave=cyber_wave;\
	uwu=cyber_uwu;\
	question=cyber_question;\
	lowpower=cyber_lowpower;\
	idle=cyber_idle;\
	catface=cyber_catface;\
	eyes_normal=cyber_eyes_normal;\
	eyes_happy=cyber_eyes_happy;\
	eyes_sad=cyber_eyes_sad;\
	eyes_big=cyber_eyes_big;\
	confounded=cyber_confounded;\
	eyes_confounded=cyber_eyes_confounded;\
	halffrown=cyber_halffrown;\
	angry=cyber_angry"

/proc/populate_robolimb_list()
	GLOB.basic_robolimb = new()
	for(var/limb_type in typesof(/datum/robolimb))
		var/datum/robolimb/R = new limb_type()
		GLOB.all_robolimbs[R.company] = R
		if(!R.unavailable_at_chargen)
			GLOB.chargen_robolimbs[R.company] = R //List only main brands and solo parts.

	for(var/company in GLOB.all_robolimbs)
		var/datum/robolimb/R = GLOB.all_robolimbs[company]
		if(R.species_alternates)
			for(var/species in R.species_alternates)
				var/species_company = R.species_alternates[species]
				if(species_company in GLOB.all_robolimbs)
					R.species_alternates[species] = GLOB.all_robolimbs[species_company]

/datum/prototype/sprite_accessory/tail/legacy_robolimb
	do_colouration = FALSE
	abstract_type = /datum/prototype/sprite_accessory/tail/legacy_robolimb

/datum/robolimb
	/// Shown when selecting the limb.
	var/company = "Unbranded"
	/// Seen when examining a limb.
	var/desc = "A generic unbranded robotic prosthesis."
	/// bodyset to use
	var/datum/prototype/bodyset/bodyset

	/// Where it draws the monitor icon from.
	var/monitor_icon = "icons/mob/monitor_icons.dmi"
	/// If set, not available at character creator.
	var/unavailable_at_chargen
	/// If set, can't be constructed.
	var/unavailable_to_build
	/// If set, appears organic.
	var/lifelike
	/// If set, applies skin tone rather than part color Overrides color.
	var/skin_tone
	/// If set, applies skin color rather than part color.
	var/skin_color
	/// If set, applies the limb's blood color rather than species' blood color.
	var/blood_color = SYNTH_BLOOD_COLOUR
	/// If set, applies the limb's blood name rather than species' blood name.
	var/blood_name = "oil"
	/// If empty, the model of limbs offers a head compatible with monitors.
	var/list/monitor_styles
	/// Defines what parts said brand can replace on a body.
	var/parts = BP_ALL
	/// Intensity modifier for the health GUI indicator.
	var/health_hud_intensity = 1
	/// What icon_state to use for speech bubbles when talking.  Check talk.dmi for all the icons.
	var/speech_bubble_appearance = "synthetic"
	/// Whether or not this limb allows attaching/detaching, and whether or not it checks its parent as well.
	var/modular_bodyparts = MODULAR_BODYPART_CYBERNETIC
	/// Multiplier for incoming brute damage.
	var/robo_brute_mod = 1
	/// Multiplier for incoming burn damage.
	var/robo_burn_mod = 1
	/// If it should make the torso a species
	var/suggested_species = SPECIES_HUMAN
	/// Species in this list cannot take these prosthetics.
	var/list/species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_XENOCHIMERA)
	/// "Species Name" = "Robolimb Company" , List, when initialized, will become "Species Name" = RobolimbDatum, used for alternate species sprites.
	var/list/species_alternates = list(SPECIES_TAJ = "Unbranded - Tajaran", SPECIES_UNATHI = "Unbranded - Unathi")
	/// List of ckeys that are allowed to pick this in charsetup.
	var/list/whitelisted_to

	/// typepath or id of sprite accessory to default for, for tail
	var/datum/prototype/sprite_accessory/legacy_includes_tail

/datum/robolimb/New()
	if(ispath(legacy_includes_tail))
		var/datum/prototype/sprite_accessory/casted = legacy_includes_tail
		legacy_includes_tail = initial(casted.id)
	if(istext(legacy_includes_tail))
		legacy_includes_tail = GLOB.sprite_accessory_tails[legacy_includes_tail]
	if(!istype(bodyset) && bodyset)
		var/datum/prototype/bodyset/casted = bodyset
		if(ispath(casted, /datum/prototype/bodyset))
			bodyset = new casted
		else
			bodyset = RSbodysets.fetch_local_or_throw(casted)
