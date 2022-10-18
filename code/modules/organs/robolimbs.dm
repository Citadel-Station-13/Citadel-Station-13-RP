GLOBAL_LIST_EMPTY(all_robolimbs)
GLOBAL_LIST_EMPTY(robolimb_data)
GLOBAL_LIST_EMPTY(chargen_robolimbs)
GLOBAL_DATUM(basic_robolimb, /datum/robolimb)

// fuck you whoever wrote these vars
// use lists like a normal human
// TODO: REFACTOR
var/const/standard_monitor_styles = "blank=ipc_blank;\
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
	database=ipc_database"

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
	idle=cyber_idle"

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

/datum/robolimb
	/// Shown when selecting the limb.
	var/company = "Unbranded"
	/// Seen when examining a limb.
	var/desc = "A generic unbranded robotic prosthesis."
	/// Icon base to draw from.
	var/icon = 'icons/mob/cyberlimbs/robotic.dmi'
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
	/// Cyberlimbs dmi includes a tail sprite to wear.
	var/includes_tail
	/// Cyberlimbs dmi includes a wing sprite to wear.
	var/includes_wing
	/// If it should make the torso a species
	var/suggested_species = SPECIES_HUMAN
	/// Species in this list cannot take these prosthetics.
	var/list/species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_XENOCHIMERA)
	/// "Species Name" = "Robolimb Company" , List, when initialized, will become "Species Name" = RobolimbDatum, used for alternate species sprites.
	var/list/species_alternates = list(SPECIES_TAJ = "Unbranded - Tajaran", SPECIES_UNATHI = "Unbranded - Unathi")
	/// List of ckeys that are allowed to pick this in charsetup.
	var/list/whitelisted_to

/datum/robolimb/unbranded_monitor
	company = "Unbranded Monitor"
	desc = "A generic unbranded interpretation of a popular prosthetic head model. It looks rudimentary and cheaply constructed."
	icon = 'icons/mob/cyberlimbs/unbranded/unbranded_monitor.dmi'
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_alt1
	company = "Unbranded - Protez"
	desc = "A simple robotic limb with retro design. Seems rather stiff."
	icon = 'icons/mob/cyberlimbs/unbranded/unbranded_alt1.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_alt2
	company = "Unbranded - Mantis Prosis"
	desc = "This limb has a casing of sleek black metal and repulsive insectile design."
	icon = 'icons/mob/cyberlimbs/unbranded/unbranded_alt2.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_tajaran
	company = "Unbranded - Tajaran"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_TAJ
	desc = "A simple robotic limb with feline design. Seems rather stiff."
	icon = 'icons/mob/cyberlimbs/unbranded/unbranded_tajaran.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_unathi
	company = "Unbranded - Unathi"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_UNATHI
	desc = "A simple robotic limb with reptilian design. Seems rather stiff."
	icon = 'icons/mob/cyberlimbs/unbranded/unbranded_unathi.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_teshari
	company = "Unbranded - Teshari"
	species_cannot_use = list(SPECIES_UNATHI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_TESHARI
	desc = "A simple robotic limb with a small, raptor-like design. Seems rather stiff."
	icon = 'icons/mob/cyberlimbs/unbranded/unbranded_teshari.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/nanotrasen
	company = "NanoTrasen"
	desc = "A simple but efficient robotic limb, created by NanoTrasen."
	icon = 'icons/mob/cyberlimbs/nanotrasen/nanotrasen_main.dmi'
	species_alternates = list(SPECIES_TAJ = "NanoTrasen - Tajaran", SPECIES_UNATHI = "NanoTrasen - Unathi")

/datum/robolimb/nanotrasen_tajaran
	company = "NanoTrasen - Tajaran"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "NanoTrasen")
	suggested_species = SPECIES_TAJ
	desc = "A simple but efficient robotic limb, created by NanoTrasen."
	icon = 'icons/mob/cyberlimbs/nanotrasen/nanotrasen_tajaran.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/nanotrasen_unathi
	company = "NanoTrasen - Unathi"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "NanoTrasen")
	suggested_species = SPECIES_UNATHI
	desc = "A simple but efficient robotic limb, created by NanoTrasen."
	icon = 'icons/mob/cyberlimbs/nanotrasen/nanotrasen_unathi.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/bishop
	company = "Bishop"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon = 'icons/mob/cyberlimbs/bishop/bishop_main.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/bishop_alt1
	company = "Bishop - Glyph"
	desc = "This limb has a white polymer casing with blue holo-displays."
	icon = 'icons/mob/cyberlimbs/bishop/bishop_alt1.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/bishop_alt2
	company = "Bishop - Rook"
	desc = "This limb has a solid plastic casing with blue lights along it."
	icon = 'icons/mob/cyberlimbs/bishop/bishop_alt2.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/bishop_monitor
	company = "Bishop Monitor"
	desc = "Bishop Cybernetics' unique spin on a popular prosthetic head model. The themes conflict in an intriguing way."
	icon = 'icons/mob/cyberlimbs/bishop/bishop_monitor.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/cenilimicybernetics_teshari
	company = "Cenilimi Cybernetics"
	desc = "Made by a Teshari-owned company, for Teshari."
	icon = 'icons/mob/cyberlimbs/cenilimicybernetics/cenilimicybernetics_teshari.dmi'
	suggested_species = SPECIES_TESHARI
	species_cannot_use = list(SPECIES_UNATHI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "NanoTrasen")
	unavailable_to_build = TRUE

/datum/robolimb/gestaltframe
	company = "Skrellian Exoskeleton"
	desc = "This limb looks to be more like a strange.. puppet, than a prosthetic."
	icon = 'icons/mob/cyberlimbs/veymed/dionaea/skrellian.dmi'
	blood_color = "#63b521"
	blood_name = "synthetic ichor"
	speech_bubble_appearance = "machine"
	unavailable_to_build = TRUE
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_TAJ, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_DIONA
	// Dionaea are naturally very tanky, so the robotic limbs are actually far weaker than their normal bodies.
	robo_brute_mod = 1.3
	robo_burn_mod = 1.3

/datum/robolimb/cybersolutions
	company = "Cyber Solutions"
	desc = "This limb is grey and rough, with little in the way of aesthetic."
	icon = 'icons/mob/cyberlimbs/cybersolutions/cybersolutions_main.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/cybersolutions_alt1
	company = "Cyber Solutions - Wight"
	desc = "This limb has cheap plastic panels mounted on grey metal."
	icon = 'icons/mob/cyberlimbs/cybersolutions/cybersolutions_alt1.dmi'
	unavailable_to_build = TRUE
/datum/robolimb/cybersolutions_alt2
	company = "Cyber Solutions - Outdated"
	desc = "This limb is of severely outdated design; there's no way it's comfortable or very functional to use."
	icon = 'icons/mob/cyberlimbs/cybersolutions/cybersolutions_alt2.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/cybersolutions_alt3
	company = "Cyber Solutions - Array"
	desc = "This limb is simple and functional; array of sensors on a featureless case."
	icon = 'icons/mob/cyberlimbs/cybersolutions/cybersolutions_alt3.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/datum/robolimb/einstein
	company = "Einstein Engines"
	desc = "This limb is lightweight with a sleek design."
	icon = 'icons/mob/cyberlimbs/einstein/einstein_main.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/grayson
	company = "Grayson"
	desc = "This limb has a sturdy and heavy build to it."
	icon = 'icons/mob/cyberlimbs/grayson/grayson_main.dmi'
	unavailable_to_build = TRUE
	monitor_styles = "blank=grayson_off;\
		red=grayson_red;\
		green=grayson_green;\
		blue=grayson_blue;\
		rgb=grayson_rgb"

/datum/robolimb/grayson_alt1
	company = "Grayson - Reinforced"
	desc = "This limb has a sturdy and heavy build to it."
	icon = 'icons/mob/cyberlimbs/grayson/grayson_alt1.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = "blank=grayson_alt_off;\
		green=grayson_alt_green;\
		scroll=grayson_alt_scroll;\
		rgb=grayson_alt_rgb;\
		rainbow=grayson_alt_rainbow"

/datum/robolimb/grayson_monitor
	company = "Grayson Monitor"
	desc = "This limb has a sturdy and heavy build to it, and uses plastics in the place of glass for the monitor."
	icon = 'icons/mob/cyberlimbs/grayson/grayson_monitor.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/hephaestus
	company = "Hephaestus"
	desc = "This limb has a militaristic black and green casing with gold stripes."
	icon = 'icons/mob/cyberlimbs/hephaestus/hephaestus_main.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/hephaestus_alt1
	company = "Hephaestus - Frontier"
	desc = "A rugged prosthetic head featuring the standard Hephaestus theme, a visor and an external display."
	icon = 'icons/mob/cyberlimbs/hephaestus/hephaestus_alt1.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = "blank=hephaestus_alt_off;\
		pink=hephaestus_alt_pink;\
		orange=hephaestus_alt_orange;\
		goggles=hephaestus_alt_goggles;\
		scroll=hephaestus_alt_scroll;\
		rgb=hephaestus_alt_rgb;\
		rainbow=hephaestus_alt_rainbow"

/datum/robolimb/hephaestus_alt2
	company = "Hephaestus - Athena"
	desc = "This rather thick limb has a militaristic green plating."
	icon = 'icons/mob/cyberlimbs/hephaestus/hephaestus_alt2.dmi'
	unavailable_to_build = TRUE
	monitor_styles = "red=athena_red;\
		blank=athena_off"

/datum/robolimb/hephaestus_monitor
	company = "Hephaestus Monitor"
	desc = "Hephaestus' unique spin on a popular prosthetic head model. It looks rugged and sturdy."
	icon = 'icons/mob/cyberlimbs/hephaestus/hephaestus_monitor.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/morpheus
	company = "Morpheus"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/cyberlimbs/morpheus/morpheus_main.dmi'
	unavailable_to_build = TRUE
	monitor_styles = standard_monitor_styles

/datum/robolimb/morpheus_alt1
	company = "Morpheus - Zenith"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	icon = 'icons/mob/cyberlimbs/morpheus/morpheus_alt1.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/morpheus_alt2
	company = "Morpheus - Skeleton Crew"
	desc = "This limb is simple and functional; it's basically just a case for a brain."
	icon = 'icons/mob/cyberlimbs/morpheus/morpheus_alt2.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/veymed
	company = "Vey-Med"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon = 'icons/mob/cyberlimbs/veymed/veymed_main.dmi'
	unavailable_to_build = TRUE
	lifelike = 1
	skin_tone = 1
	species_alternates = list(SPECIES_SKRELL = "Vey-Med - Skrell")
	blood_color = "#CCCCCC"
	blood_name = "coolant"
	speech_bubble_appearance = "normal"
	robo_brute_mod = 1.1
	robo_burn_mod = 1.1
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/veymed/skrell
	company = "Vey-Med - Skrell"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_TAJ, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_ZADDAT)
	blood_color = "#4451cf"
	speech_bubble_appearance = "normal"
	robo_brute_mod = 1.05
	robo_burn_mod = 1.05

// thanks kraso
/datum/robolimb/moth
	company = "Psyche - Moth"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon = 'icons/mob/cyberlimbs/psyche/moth.dmi'
	blood_color = "#808000"
	lifelike = 1
	skin_tone = TRUE
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/insect
	company = "Psyche - Insect"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	icon = 'icons/mob/cyberlimbs/psyche/insect.dmi'
	blood_color = "#808000"
	lifelike = 1
	skin_tone = TRUE
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID


/datum/robolimb/wardtakahashi
	company = "Ward-Takahashi"
	desc = "This limb features sleek black and white polymers."
	icon = 'icons/mob/cyberlimbs/wardtakahashi/wardtakahashi_main.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/wardtakahashi_alt1
	company = "Ward-Takahashi - Shroud"
	desc = "This limb features sleek black and white polymers. This one looks more like a helmet of some sort."
	icon = 'icons/mob/cyberlimbs/wardtakahashi/wardtakahashi_alt1.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/wardtakahashi_alt2
	company = "Ward-Takahashi - Spirit"
	desc = "This limb has white and purple features, with a heavier casing."
	icon = 'icons/mob/cyberlimbs/wardtakahashi/wardtakahashi_alt2.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/wardtakahashi_monitor
	company = "Ward-Takahashi Monitor"
	desc = "Ward-Takahashi's unique spin on a popular prosthetic head model. It looks sleek and modern."
	icon = 'icons/mob/cyberlimbs/wardtakahashi/wardtakahashi_monitor.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/xion
	company = "Xion"
	desc = "This limb has a minimalist black and red casing."
	icon = 'icons/mob/cyberlimbs/xion/xion_main.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/xion_alt1
	company = "Xion - Breach"
	desc = "This limb has a minimalist black and red casing. Looks a bit menacing."
	icon = 'icons/mob/cyberlimbs/xion/xion_alt1.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/xion_alt2
	company = "Xion - Hull"
	desc = "This limb has a thick orange casing with steel plating."
	icon = 'icons/mob/cyberlimbs/xion/xion_alt2.dmi'
	unavailable_to_build = TRUE
	monitor_styles = "blank=xion_off;\
		red=xion_red;\
		green=xion_green;\
		blue=xion_blue;\
		rgb=xion_rgb"

/datum/robolimb/xion_alt3
	company = "Xion - Whiteout"
	desc = "This limb has a minimalist black and white casing."
	icon = 'icons/mob/cyberlimbs/xion/xion_alt3.dmi'
	unavailable_to_build = TRUE

/datum/robolimb/xion_alt4
	company = "Xion - Breach - Whiteout"
	desc = "This limb has a minimalist black and white casing. Looks a bit menacing."
	icon = 'icons/mob/cyberlimbs/xion/xion_alt4.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)


/datum/robolimb/xion_monitor
	company = "Xion Monitor"
	desc = "Xion Mfg.'s unique spin on a popular prosthetic head model. It looks and minimalist and utilitarian."
	icon = 'icons/mob/cyberlimbs/xion/xion_monitor.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles



/datum/robolimb/zenghu
	company = "Zeng-Hu"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	icon = 'icons/mob/cyberlimbs/zenghu/zenghu_main.dmi'
	species_alternates = list(SPECIES_TAJ = "Zeng-Hu - Tajaran")
	unavailable_to_build = TRUE
	skin_tone = TRUE



/datum/robolimb/cyber_beast
	company = "Cyber Tech"
	desc = "Adjusted for deep space the material is durable, and heavy."
	icon = 'icons/mob/cyberlimbs/c-tech/c_beast.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = cyberbeast_monitor_styles

/datum/robolimb/wooden
	company = "Morgan Trading Co"
	desc = "A simplistic, metal-banded, wood-panelled prosthetic."
	icon = 'icons/mob/cyberlimbs/prosthesis/wooden.dmi'
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC
	parts = list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)

/obj/item/disk/limb
	name = "Limb Blueprints"
	desc = "A disk containing the blueprints for prosthetics."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	var/company = ""

/obj/item/disk/limb/Initialize(mapload)
	. = ..()
	if(company)
		name = "[company] [initial(name)]"

/obj/item/disk/limb/bishop
	company = "Bishop"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/bishop)

/obj/item/disk/limb/cenilimicybernetics
	company = "Cenilimi Cybernetics"

/obj/item/disk/limb/cybersolutions
	company = "Cyber Solutions"

/obj/item/disk/limb/grayson
	company = "Grayson"

/obj/item/disk/limb/hephaestus
	company = "Hephaestus"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/hephaestus)

/obj/item/disk/limb/morpheus
	company = "Morpheus"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/morpheus)

/obj/item/disk/limb/veymed
	company = "Vey-Med"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/vey_med)

// Bus disk for Diona mech parts.
/obj/item/disk/limb/veymed/diona
	company = "Skrellian Exoskeleton"

/obj/item/disk/limb/wardtakahashi
	company = "Ward-Takahashi"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/ward_takahashi)

/obj/item/disk/limb/xion
	company = "Xion"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/xion)

/obj/item/disk/limb/zenghu
	company = "Zeng-Hu"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/zeng_hu)

/obj/item/disk/limb/nanotrasen
	company = "NanoTrasen"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)


/obj/item/disk/species
	name = "Species Bioprints"
	desc = "A disk containing the blueprints for species-specific prosthetics."
	icon = 'icons/obj/cloning.dmi'
	icon_state = "datadisk2"
	var/species = SPECIES_HUMAN

/obj/item/disk/species/Initialize(mapload)
	. = ..()
	if(species)
		name = "[species] [initial(name)]"

/obj/item/disk/species/skrell
	species = SPECIES_SKRELL

/obj/item/disk/species/unathi
	species = SPECIES_UNATHI

/obj/item/disk/species/tajaran
	species = SPECIES_TAJ

/obj/item/disk/species/teshari
	species = SPECIES_TESHARI

// In case of bus, presently.
/obj/item/disk/species/diona
	species = SPECIES_DIONA

/obj/item/disk/species/zaddat
	species = SPECIES_ZADDAT

/datum/robolimb/eggnerdltd
	company = "Eggnerd Prototyping Ltd."
	desc = "This limb has a slight salvaged handicraft vibe to it. The CE-marking on it is definitely not the standardized one, it looks more like a hand-written sharpie monogram."
	icon = 'icons/mob/cyberlimbs/_fluff_vr/rahboop.dmi'
	blood_color = "#5e280d"
	includes_tail = 1
	unavailable_to_build = TRUE

/obj/item/disk/limb/eggnerdltd
	company = "Eggnerd Prototyping Ltd."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "verkdisk"

//Brass Variant of Eggnerd
/datum/robolimb/vulkanwrks
	company = "Vulkan Brassworks Inc."
	desc = "This limb is crafted out of hammered brass. Unlike other prosthetics, the internals of this device run off of a complex system of clockwork gears and arms, with a wired superstructure layered on top. This level of craftsmanship is incredibly atypical."
	icon = 'icons/mob/cyberlimbs/_fluff_vr/brassworks.dmi'
	blood_color = "#1F2631"
	unavailable_to_build = TRUE

/obj/item/disk/limb/vulkanwrks
	company = "Vulcan Brassworks Inc."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "datadisk2"


//////////////// General VS-only ones /////////////////
/datum/robolimb/talon //They're buildable by default due to being extremely basic.
	company = "Talon LLC"
	desc = "This metallic limb is sleek and featuresless apart from some exposed motors"
	icon = 'icons/mob/cyberlimbs/talon/talon_main.dmi' //Sprited by: Viveret

/obj/item/disk/limb/talon
	company = "Talon LLC"

/datum/robolimb/zenghu_taj //This wasn't indented. At all. It's a miracle this didn't break literally everything.
	company = "Zeng-Hu - Tajaran"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	icon = 'icons/mob/cyberlimbs/zenghu/zenghu_taj.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	desc = "A slightly more refined limb variant from Eggnerd Prototyping. Its got red plating instead of orange."
	icon = 'icons/mob/cyberlimbs/rahboopred/rahboopred.dmi'
	blood_color = "#5e280d"
	includes_tail = 1
	unavailable_to_build = TRUE

/obj/item/disk/limb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "verkdisk"


//Darkside Incorperated synthetic augmentation list! Many current most used fuzzy and notsofuzzy races made into synths here.

/datum/robolimb/dsi_tajaran
	company = "DSI - Tajaran"
	desc = "This limb feels soft and fluffy, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/cyberlimbs/DSITajaran/dsi_tajaran.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_TAJ
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/obj/item/disk/limb/dsi_tajaran
	company = "DSI - Tajaran"

/datum/robolimb/dsi_lizard
	company = "DSI - Lizard"
	desc = "This limb feels smooth and scalie, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/cyberlimbs/DSILizard/dsi_lizard.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_UNATHI
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/obj/item/disk/limb/dsi_lizard
	company = "DSI - Lizard"

/datum/robolimb/dsi_sergal
	company = "DSI - Sergal"
	desc = "This limb feels soft and fluffy, realistic design and toned muscle. By Darkside Incorperated."
	icon = 'icons/mob/cyberlimbs/DSISergal/dsi_sergal.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_SERGAL
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/obj/item/disk/limb/dsi_sergal
	company = "DSI - Sergal"

/datum/robolimb/dsi_nevrean
	company = "DSI - Nevrean"
	desc = "This limb feels soft and feathery, lightweight, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/cyberlimbs/DSINevrean/dsi_nevrean.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_NEVREAN
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/obj/item/disk/limb/dsi_nevrean
	company = "DSI - Nevrean"

/datum/robolimb/dsi_vulpkanin
	company = "DSI - Vulpkanin"
	desc = "This limb feels soft and fluffy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/cyberlimbs/DSIVulpkanin/dsi_vulpkanin.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_VULPKANIN
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/obj/item/disk/limb/dsi_vulpkanin
	company = "DSI - Vulpkanin"

/datum/robolimb/dsi_akula
	company = "DSI - Akula"
	desc = "This limb feels soft and fleshy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/cyberlimbs/DSIAkula/dsi_akula.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_AKULA
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/obj/item/disk/limb/dsi_akula
	company = "DSI - Akula"

/datum/robolimb/dsi_spider
	company = "DSI - Vasilissan"
	desc = "This limb feels hard and chitinous, realistic design. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/cyberlimbs/DSISpider/dsi_spider.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	includes_tail = 1
	skin_tone = 1
	suggested_species = SPECIES_VASILISSAN
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/obj/item/disk/limb/dsi_spider
	company = "DSI - Vasilissan"

/datum/robolimb/dsi_teshari
	company = "DSI - Teshari"
	desc = "This limb has a thin synthflesh casing with a few connection ports."
	icon = 'icons/mob/cyberlimbs/DSITeshari/dsi_teshari.dmi'
	lifelike = 1
	unavailable_to_build = TRUE
	skin_tone = 1
	suggested_species = SPECIES_TESHARI
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/dsi_teshari/New()
	species_cannot_use = SScharacters.all_species_names() - SPECIES_TESHARI
	..()

/obj/item/disk/limb/dsi_teshari
	company = "DSI - Teshari"


/datum/robolimb/braincase
	company = "cortexCases - MMI"
	desc = "A solid, transparent case to hold your important bits in with style."
	icon = 'icons/mob/cyberlimbs/cortex/braincase.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/obj/item/disk/limb/braincase
	company = "cortexCases - MMI"

/datum/robolimb/posicase
	company = "cortexCases - Posi"
	desc = "A solid, transparent case to hold your important bits in with style."
	icon = 'icons/mob/cyberlimbs/cortex/posicase.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/obj/item/disk/limb/posicase
	company = "cortexCases - Posi"

/datum/robolimb/antares
	company = "Antares Robotics"
	desc = "Mustard-yellow industrial limb. Heavyset and thick."
	icon = 'icons/mob/cyberlimbs/antares/antares_main.dmi'
	unavailable_to_build = TRUE
	monitor_styles = standard_monitor_styles

/obj/item/disk/limb/antares
	company = "Antares Robotics"

/datum/robolimb/adherent
	company = "Unbranded - Adherent"
	desc    = "A simple robotic limb with retro design. Seems rather stiff."
	icon    = 'icons/mob/species/adherent/body.dmi'
	unavailable_to_build = TRUE
	suggested_species = SPECIES_ADHERENT

/datum/robolimb/adherent/New()
	species_cannot_use = SScharacters.all_species_names() - SPECIES_ADHERENT
	..()
