/datum/robolimb/antares
	company = "Antares Robotics"
	desc = "Mustard-yellow industrial limb. Heavyset and thick."
	unavailable_to_build = TRUE
	monitor_styles = standard_monitor_styles
	bodyset = /datum/prototype/bodyset/synthetic/antares

/datum/robolimb/bishop
	company = "Bishop"
	desc = "This limb has a white polymer casing with blue holo-displays."
	unavailable_to_build = TRUE
	bodyset = /datum/prototype/bodyset/synthetic/bishop

/datum/robolimb/bishop_alt1
	company = "Bishop - Glyph"
	desc = "This limb has a white polymer casing with blue holo-displays."
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	bodyset = /datum/prototype/bodyset/synthetic/bishop/alt_2

/datum/robolimb/bishop_alt2
	company = "Bishop - Rook"
	desc = "This limb has a solid plastic casing with blue lights along it."
	unavailable_to_build = TRUE
	bodyset = /datum/prototype/bodyset/synthetic/bishop/alt_1

/datum/robolimb/bishop_monitor
	company = "Bishop Monitor"
	desc = "Bishop Cybernetics' unique spin on a popular prosthetic head model. The themes conflict in an intriguing way."
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles
	bodyset = /datum/prototype/bodyset/synthetic/bishop/alt_3

// todo: /cortex/brain_case
/datum/robolimb/braincase
	company = "cortexCases - MMI"
	desc = "A solid, transparent case to hold your important bits in with style."
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	bodyset = /datum/prototype/bodyset/synthetic/cortex/brain

// todo: /cortex/posi_case
/datum/robolimb/posicase
	company = "cortexCases - Posi"
	desc = "A solid, transparent case to hold your important bits in with style."
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	bodyset = /datum/prototype/bodyset/synthetic/cortex/posi

/datum/robolimb/nanotrasen
	company = "Nanotrasen"
	desc = "A simple but efficient robotic limb, created by Nanotrasen."
	species_alternates = list(SPECIES_TAJ = "Nanotrasen - Tajaran", SPECIES_UNATHI = "Nanotrasen - Unathi")
	bodyset = /datum/prototype/bodyset/synthetic/nanotrasen

// todo: oss_vulpkanin
/datum/robolimb/dsi_vulpkanin
	company = "OSS - Vulpkanin"
	desc = "This limb feels soft and fluffy, realistic design and squish. Seems a little mischievous. By Onkhera Synthetic Solutions."
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	skin_tone = 1
	suggested_species = SPECIES_VULPKANIN
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID
	bodyset = /datum/prototype/bodyset/synthetic/oss_vulpkanin

/datum/robolimb/insect
	company = "Psyche - Insect"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	bodyset = /datum/prototype/bodyset/organic/insect
	blood_color = "#808000"
	lifelike = 1
	skin_tone = TRUE
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/moth
	company = "Psyche - Moth"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	bodyset = /datum/prototype/bodyset/organic/moth
	blood_color = "#808000"
	lifelike = 1
	skin_tone = TRUE
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/veymed
	company = "Vey-Med"
	desc = "This high quality limb is nearly indistinguishable from an organic one."
	bodyset = /datum/prototype/bodyset/synthetic/veymed
	unavailable_to_build = TRUE
	lifelike = 1
	skin_tone = 1
	species_alternates = list(SPECIES_SKRELL = "Vey-Med - Skrell")
	blood_color = "#CCCCCC"
	blood_name = "coolant"
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/veymed/skrell
	company = "Vey-Med - Skrell"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_TAJ, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_DIONA, SPECIES_ZADDAT)
	bodyset = /datum/prototype/bodyset/synthetic/veymed/skrell
	blood_color = "#4451cf"
	speech_bubble_appearance = "normal"

/datum/robolimb/unbranded_monitor
	company = "Unbranded Monitor"
	desc = "A generic unbranded interpretation of a popular prosthetic head model. It looks rudimentary and cheaply constructed."
	bodyset = /datum/prototype/bodyset/unbranded/monitor
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_alt1
	company = "Unbranded - Protez"
	desc = "A simple robotic limb with retro design. Seems rather stiff."
	bodyset = /datum/prototype/bodyset/unbranded/protez
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_alt2
	company = "Unbranded - Mantis Prosis"
	desc = "This limb has a casing of sleek black metal and repulsive insectile design."
	bodyset = /datum/prototype/bodyset/unbranded/mantis
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_tajaran
	company = "Unbranded - Tajaran"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_UNATHI, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_TAJ
	desc = "A simple robotic limb with feline design. Seems rather stiff."
	bodyset = /datum/prototype/bodyset/unbranded/tajaran
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_unathi
	company = "Unbranded - Unathi"
	species_cannot_use = list(SPECIES_TESHARI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_UNATHI
	desc = "A simple robotic limb with reptilian design. Seems rather stiff."
	bodyset = /datum/prototype/bodyset/unbranded/unathi
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_teshari
	company = "Unbranded - Teshari"
	species_cannot_use = list(SPECIES_UNATHI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	suggested_species = SPECIES_TESHARI
	desc = "A simple robotic limb with a small, raptor-like design. Seems rather stiff."
	bodyset = /datum/prototype/bodyset/unbranded/teshari
	unavailable_to_build = TRUE

/datum/robolimb/unbranded_digitigrade
	company = "Unbranded - Generic Digitigrade"
	desc = "A digitigrade robotic leg of a fairly generic design."
	bodyset = /datum/prototype/bodyset/unbranded/digitigrade
	parts = list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)

#warn below

/datum/robolimb/mpc
	company = "Moghes Prosthetics Company"
	desc = "A simple robotic limb with a lizard-like design."
	icon = 'icons/mob/cyberlimbs/mpc/mpc.dmi'

/datum/robolimb/cenilimicybernetics_teshari
	company = "Cenilimi Cybernetics"
	desc = "Made by a Teshari-owned company, for Teshari."
	icon = 'icons/mob/cyberlimbs/cenilimicybernetics/cenilimicybernetics_teshari.dmi'
	suggested_species = SPECIES_TESHARI
	species_cannot_use = list(SPECIES_UNATHI, SPECIES_PROMETHEAN, SPECIES_DIONA, SPECIES_HUMAN, SPECIES_VOX, SPECIES_HUMAN_VATBORN, SPECIES_TAJ, SPECIES_SKRELL, SPECIES_ZADDAT)
	species_alternates = list(SPECIES_HUMAN = "Nanotrasen")
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
	bodyset = /datum/prototype/bodyset/synthetic/cybersolutions/standard
	unavailable_to_build = TRUE

/datum/robolimb/cybersolutions_alt1
	company = "Cyber Solutions - Wight"
	desc = "This limb has cheap plastic panels mounted on grey metal."
	bodyset = /datum/prototype/bodyset/synthetic/cybersolutions/wight
	unavailable_to_build = TRUE

/datum/robolimb/cybersolutions_alt2
	company = "Cyber Solutions - Outdated"
	desc = "This limb is of severely outdated design; there's no way it's comfortable or very functional to use."
	bodyset = /datum/prototype/bodyset/synthetic/cybersolutions/outdated
	unavailable_to_build = TRUE

/datum/robolimb/cybersolutions_alt3
	company = "Cyber Solutions - Array"
	desc = "This limb is simple and functional; array of sensors on a featureless case."
	bodyset = /datum/prototype/bodyset/synthetic/cybersolutions/array
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
	bodyset = /datum/prototype/bodyset/synthetic/grayson/standard
	unavailable_to_build = TRUE
	monitor_styles = "blank=grayson_off;\
		red=grayson_red;\
		green=grayson_green;\
		blue=grayson_blue;\
		rgb=grayson_rgb"

/datum/robolimb/grayson_alt1
	company = "Grayson - Reinforced"
	desc = "This limb has a sturdy and heavy build to it."
	bodyset = /datum/prototype/bodyset/synthetic/grayson/reinforced
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
	bodyset = /datum/prototype/bodyset/synthetic/grayson/monitor
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/hephaestus
	company = "Hephaestus"
	desc = "This limb has a militaristic black and green casing with gold stripes."
	bodyset = /datum/prototype/bodyset/synthetic/hephaestus/standard
	unavailable_to_build = TRUE

/datum/robolimb/hephaestus_alt1
	company = "Hephaestus - Frontier"
	desc = "A rugged prosthetic head featuring the standard Hephaestus theme, a visor and an external display."
	bodyset = /datum/prototype/bodyset/synthetic/hephaestus/frontier
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
	bodyset = /datum/prototype/bodyset/synthetic/hephaestus/athena
	unavailable_to_build = TRUE
	monitor_styles = "red=athena_red;\
		blank=athena_off"

/datum/robolimb/hephaestus_monitor
	company = "Hephaestus Monitor"
	desc = "Hephaestus' unique spin on a popular prosthetic head model. It looks rugged and sturdy."
	bodyset = /datum/prototype/bodyset/synthetic/hephaestus/monitor
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/morpheus
	company = "Morpheus"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	bodyset = /datum/prototype/bodyset/synthetic/morpheus/standard
	unavailable_to_build = TRUE
	monitor_styles = standard_monitor_styles

/datum/robolimb/morpheus_alt1
	company = "Morpheus - Zenith"
	desc = "This limb is simple and functional; no effort has been made to make it look human."
	bodyset = /datum/prototype/bodyset/synthetic/morpheus/zenith
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/morpheus_alt2
	company = "Morpheus - Skeleton Crew"
	desc = "This limb is simple and functional; it's basically just a case for a brain."
	bodyset = /datum/prototype/bodyset/synthetic/morpheus/skeleton_crew
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/wardtakahashi
	company = "Ward-Takahashi"
	desc = "This limb features sleek black and white polymers."
	bodyset = /datum/prototype/bodyset/synthetic/ward_takashi/standard
	unavailable_to_build = TRUE

/datum/robolimb/wardtakahashi_alt1
	company = "Ward-Takahashi - Shroud"
	desc = "This limb features sleek black and white polymers. This one looks more like a helmet of some sort."
	bodyset = /datum/prototype/bodyset/synthetic/ward_takashi/shroud
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/wardtakahashi_alt2
	company = "Ward-Takahashi - Spirit"
	desc = "This limb has white and purple features, with a heavier casing."
	bodyset = /datum/prototype/bodyset/synthetic/ward_takashi/spirit
	unavailable_to_build = TRUE

/datum/robolimb/wardtakahashi_monitor
	company = "Ward-Takahashi Monitor"
	desc = "Ward-Takahashi's unique spin on a popular prosthetic head model. It looks sleek and modern."
	bodyset = /datum/prototype/bodyset/synthetic/ward_takashi/monitor
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/xion
	company = "Xion"
	desc = "This limb has a minimalist black and red casing."
	bodyset = /datum/prototype/bdoyset/synthetic/xion/standard
	unavailable_to_build = TRUE

/datum/robolimb/xion_alt1
	company = "Xion - Breach"
	desc = "This limb has a minimalist black and red casing. Looks a bit menacing."
	bodyset = /datum/prototype/bdoyset/synthetic/xion/breach
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/xion_alt2
	company = "Xion - Hull"
	desc = "This limb has a thick orange casing with steel plating."
	bodyset = /datum/prototype/bdoyset/synthetic/xion/hull
	unavailable_to_build = TRUE
	monitor_styles = "blank=xion_off;\
		red=xion_red;\
		green=xion_green;\
		blue=xion_blue;\
		rgb=xion_rgb"

/datum/robolimb/xion_alt3
	company = "Xion - Whiteout"
	desc = "This limb has a minimalist black and white casing."
	bodyset = /datum/prototype/bdoyset/synthetic/xion/whiteout
	unavailable_to_build = TRUE

/datum/robolimb/xion_alt4
	company = "Xion - Breach - Whiteout"
	desc = "This limb has a minimalist black and white casing. Looks a bit menacing."
	bodyset = /datum/prototype/bdoyset/synthetic/xion/breach/whiteout
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/xion_monitor
	company = "Xion Monitor"
	desc = "Xion Mfg.'s unique spin on a popular prosthetic head model. It looks and minimalist and utilitarian."
	bodyset = /datum/prototype/bdoyset/synthetic/xion/monitor
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = standard_monitor_styles

/datum/robolimb/zenghu
	company = "Zeng-Hu"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	bodyset = /datum/prototype/bodyset/synthetic/zenghu
	species_alternates = list(SPECIES_TAJ = "Zeng-Hu - Tajaran")
	unavailable_to_build = TRUE
	skin_tone = TRUE

/datum/robolimb/zenghu_taj //This wasn't indented. At all. It's a miracle this didn't break literally everything.
	company = "Zeng-Hu - Tajaran"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	bodyset = /datum/prototype/bodyset/synthetic/zenghu_tajaran
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)

/datum/robolimb/cyber_beast
	company = "Cyber Tech"
	desc = "Adjusted for deep space the material is durable, and heavy."
	icon = 'icons/mob/cyberlimbs/c-tech/c_beast.dmi'
	unavailable_to_build = TRUE
	parts = list(BP_HEAD)
	monitor_styles = cyberbeast_monitor_styles

/datum/robolimb/cyber_beast/flat
	company = "Cyber Tech (Flat)"
	icon = 'icons/mob/cyberlimbs/c-tech/c_beast_flat.dmi'

/datum/robolimb/wooden
	company = "Morgan Trading Co"
	desc = "A simplistic, metal-banded, wood-panelled prosthetic."
	icon = 'icons/mob/cyberlimbs/prosthesis/wooden.dmi'
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC
	parts = list(BP_L_ARM, BP_R_ARM, BP_L_HAND, BP_R_HAND, BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)

/datum/robolimb/replika
	company = "Replikant"
	desc = "An advanced biomechanical prosthetic with pegs for feet."
	bodyset = /datum/prototype/bodyset/replika/gen_1
	lifelike = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC
	parts = list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)

/datum/robolimb/replika2
	company = "Replikant - 2nd Gen"
	desc = "Modern, second-generation biomechanical prosthetics with pegs for feet."
	bodyset = /datum/prototype/bodyset/replika/gen_2
	lifelike = 1
	modular_bodyparts = MODULAR_BODYPART_PROSTHETIC
	parts = list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT)

/datum/robolimb/eggnerdltd
	company = "Eggnerd Prototyping Ltd."
	desc = "This limb has a slight salvaged handicraft vibe to it. The CE-marking on it is definitely not the standardized one, it looks more like a hand-written sharpie monogram."
	bodyset = /datum/prototype/bodyset/synthetic/eggnerd
	blood_color = "#5e280d"
	legacy_includes_tail = /datum/prototype/sprite_accessory/tail/bodyset/eggnerd
	unavailable_to_build = TRUE

//Brass Variant of Eggnerd
/datum/robolimb/vulkanwrks
	company = "Vulkan Brassworks Inc."
	desc = "This limb is crafted out of hammered brass. Unlike other prosthetics, the internals of this device run off of a complex system of clockwork gears and arms, with a wired superstructure layered on top. This level of craftsmanship is incredibly atypical."
	bodyset = /datum/prototype/bodyset/synthetic/vulkan_brassworks
	blood_color = "#1F2631"
	unavailable_to_build = TRUE

/datum/robolimb/spectre
	company = "Hoffman Tech - RACS Spectre "
	desc = "A simple robotic limb design used for the Hoffman Tech RASC Spectre. A lightweight robotic chassis ideal for exploration and security duties."
	bodyset = /datum/prototype/bodyset/synthetic/spectre
	unavailable_to_build = TRUE


//////////////// General VS-only ones /////////////////
/datum/robolimb/talon //They're buildable by default due to being extremely basic.
	company = "Talon LLC"
	desc = "This metallic limb is sleek and featuresless apart from some exposed motors"
	bodyset = /datum/prototype/bodyset/synthetic/talon

/datum/robolimb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	desc = "A slightly more refined limb variant from Eggnerd Prototyping. Its got red plating instead of orange."
	bodyset = /datum/prototype/bodyset/synthetic/eggnerd_red
	blood_color = "#5e280d"
	legacy_includes_tail = /datum/prototype/sprite_accessory/tail/bodyset/eggnerd_red
	unavailable_to_build = TRUE


//Darkside Incorperated synthetic augmentation list! Many current most used fuzzy and notsofuzzy races made into synths here.

/datum/robolimb/dsi_tajaran
	company = "OSS - Tajaran"
	desc = "This limb feels soft and fluffy, realistic design and squish. By Onkhera Synthetic Solutions."
	bodyset = /datum/prototype/bodyset/synthetic/oss_tajaran
	blood_color = "#ffe2ff"
	lifelike = 1
	legacy_includes_tail = /datum/prototype/sprite_accessory/tail/bodyset/oss_tajaran
	unavailable_to_build = TRUE
	skin_tone = 1
	suggested_species = SPECIES_TAJ
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/dsi_lizard
	company = "OSS - Lizard"
	desc = "This limb feels smooth and scalie, realistic design and squish. By Onkhera Synthetic Solutions."
	bodyset = /datum/prototype/bodyset/synthetic/oss_lizard
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	legacy_includes_tail = /datum/prototype/sprite_accessory/tail/bodyset/oss_lizard
	skin_tone = 1
	suggested_species = SPECIES_UNATHI
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/dsi_sergal
	company = "OSS - Naramadi"
	desc = "This limb feels soft and fluffy, realistic design and toned muscle. By Onkhera Synthetic Solutions."
	bodyset = /datum/prototype/bodyset/synthetic/oss_naramadi
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	legacy_includes_tail = /datum/prototype/sprite_accessory/tail/bodyset/oss_naramadi
	skin_tone = 1
	suggested_species = SPECIES_SERGAL
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/dsi_nevrean
	company = "OSS - Nevrean"
	desc = "This limb feels soft and feathery, lightweight, realistic design and squish. By Onkhera Synthetic Solutions."
	bodyset = /datum/prototype/bodyset/synthetic/oss_tajaran
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	legacy_includes_tail = /datum/prototype/sprite_accessory/tail/bodyset/oss_nevrean
	skin_tone = 1
	suggested_species = SPECIES_NEVREAN
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/dsi_akula
	company = "OSS - Akula"
	desc = "This limb feels soft and fleshy, realistic design and squish. Seems a little mischievous. By Onkhera Synthetic Solutions."
	bodyset = /datum/prototype/bodyset/synthetic/oss_akula
	blood_color = "#ffe2ff"
	lifelike = 1
	legacy_includes_tail = /datum/prototype/sprite_accessory/tail/bodyset/oss_akula
	unavailable_to_build = TRUE
	skin_tone = 1
	suggested_species = SPECIES_AKULA
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/dsi_spider
	company = "OSS - Vasilissan"
	desc = "This limb feels hard and chitinous, realistic design. Seems a little mischievous. By Onkhera Synthetic Solutions."
	bodyset = /datum/prototype/bodyset/synthetic/oss_vasilissan
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = TRUE
	legacy_includes_tail = /datum/prototype/sprite_accessory/tail/bodyset/oss_spider
	skin_tone = 1
	suggested_species = SPECIES_VASILISSAN
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/dsi_teshari
	company = "OSS - Teshari"
	desc = "This limb has a thin synthflesh casing with a few connection ports. By Onkhera Synthetic Solutions."
	bodyset = /datum/prototype/bodyset/oss_teshari
	lifelike = 1
	unavailable_to_build = TRUE
	skin_tone = 1
	suggested_species = SPECIES_TESHARI
	speech_bubble_appearance = "normal"
	modular_bodyparts = MODULAR_BODYPART_INVALID

/datum/robolimb/dsi_teshari/New()
	species_cannot_use = SScharacters.all_species_names() - SPECIES_TESHARI
	..()

/datum/robolimb/adherent
	company = "Unbranded - Adherent"
	desc    = "A simple robotic limb with retro design. Seems rather stiff."
	bodyset = /datum/prototype/bodyset/special/adherent
	unavailable_to_build = TRUE
	suggested_species = SPECIES_ADHERENT

/datum/robolimb/adherent/New()
	species_cannot_use = SScharacters.all_species_names() - SPECIES_ADHERENT
	..()
