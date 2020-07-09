/datum/robolimb
	var/includes_tail			//Cyberlimbs dmi includes a tail sprite to wear.
	var/includes_wing			//Cyberlimbs dmi includes a wing sprite to wear.
	var/list/whitelisted_to		//List of ckeys that are allowed to pick this in charsetup.
/* CITADEL CHANGE - Removes these ckey whitelisted special snowflake limbs
//////////////// For-specific-character fluff ones /////////////////
// arokha : Aronai Kadigan
/datum/robolimb/kitsuhana
	company = "Kitsuhana"
	desc = "This limb seems rather vulpine and fuzzy, with realistic-feeling flesh."
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/aronai.dmi'
	blood_color = "#5dd4fc"
	includes_tail = 1
	lifelike = 1
	unavailable_to_build = 1
	suggested_species = "Tajara"
	whitelisted_to = list("arokha")

/obj/item/disk/limb/kitsuhana
	company = "Kitsuhana"

// silencedmp5a5 : Serdykov Antoz
/datum/robolimb/white_kryten
	company = "White Kryten Cybernetics"
	desc = "This limb feels realistic to the touch, with soft fur. Were it not for the bright orange lights embedded in it, you might have trouble telling it from a non synthetic limb!"
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/serdykov.dmi'
	blood_color = "#ff6a00"
	unavailable_to_build = 1
	includes_tail = 1
	whitelisted_to = list("silencedmp5a5")

/obj/item/disk/limb/white_kryten
	company = "White Kryten Cybernetics"
END OF CITADEL CHANGES */
// verkister : Rahwoof Boop
/datum/robolimb/eggnerdltd
	company = "Eggnerd Prototyping Ltd."
	desc = "This limb has a slight salvaged handicraft vibe to it. The CE-marking on it is definitely not the standardized one, it looks more like a hand-written sharpie monogram."
	icon = 'icons/mob/human_races/cyberlimbs/_fluff_vr/rahboop.dmi'
	blood_color = "#5e280d"
	includes_tail = 1
	unavailable_to_build = 1

/obj/item/disk/limb/eggnerdltd
	company = "Eggnerd Prototyping Ltd."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "verkdisk"

//////////////// General VS-only ones /////////////////
/datum/robolimb/talon //They're buildable by default due to being extremely basic.
	company = "Talon LLC"
	desc = "This metallic limb is sleek and featuresless apart from some exposed motors"
	icon = 'icons/mob/human_races/cyberlimbs/talon/talon_main.dmi' //Sprited by: Viveret

/obj/item/disk/limb/talon
	company = "Talon LLC"

/datum/robolimb/zenghu_taj //This wasn't indented. At all. It's a miracle this didn't break literally everything.
	company = "Zeng-Hu - Tajaran"
	desc = "This limb has a rubbery fleshtone covering with visible seams."
	icon = 'icons/mob/human_races/cyberlimbs/zenghu/zenghu_taj.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/datum/robolimb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	desc = "A slightly more refined limb variant from Eggnerd Prototyping. Its got red plating instead of orange."
	icon = 'icons/mob/human_races/cyberlimbs/rahboopred/rahboopred.dmi'
	blood_color = "#5e280d"
	includes_tail = 1
	unavailable_to_build = 1

/obj/item/disk/limb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "verkdisk"


//Darkside Incorperated synthetic augmentation list! Many current most used fuzzy and notsofuzzy races made into synths here.

/datum/robolimb/dsi_tajaran
	company = "DSI - Tajaran"
	desc = "This limb feels soft and fluffy, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSITajaran/dsi_tajaran.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Tajara"

/obj/item/disk/limb/dsi_tajaran
	company = "DSI - Tajaran"

/datum/robolimb/dsi_lizard
	company = "DSI - Lizard"
	desc = "This limb feels smooth and scalie, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSILizard/dsi_lizard.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Unathi"

/obj/item/disk/limb/dsi_lizard
	company = "DSI - Lizard"

/datum/robolimb/dsi_sergal
	company = "DSI - Sergal"
	desc = "This limb feels soft and fluffy, realistic design and toned muscle. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSISergal/dsi_sergal.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Sergal"

/obj/item/disk/limb/dsi_sergal
	company = "DSI - Sergal"

/datum/robolimb/dsi_nevrean
	company = "DSI - Nevrean"
	desc = "This limb feels soft and feathery, lightweight, realistic design and squish. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSINevrean/dsi_nevrean.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Nevrean"

/obj/item/disk/limb/dsi_nevrean
	company = "DSI - Nevrean"

/datum/robolimb/dsi_vulpkanin
	company = "DSI - Vulpkanin"
	desc = "This limb feels soft and fluffy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSIVulpkanin/dsi_vulpkanin.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Vulpkanin"

/obj/item/disk/limb/dsi_vulpkanin
	company = "DSI - Vulpkanin"

/datum/robolimb/dsi_akula
	company = "DSI - Akula"
	desc = "This limb feels soft and fleshy, realistic design and squish. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSIAkula/dsi_akula.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Akula"

/obj/item/disk/limb/dsi_akula
	company = "DSI - Akula"

/datum/robolimb/dsi_spider
	company = "DSI - Vasilissan"
	desc = "This limb feels hard and chitinous, realistic design. Seems a little mischievous. By Darkside Incorperated."
	icon = 'icons/mob/human_races/cyberlimbs/DSISpider/dsi_spider.dmi'
	blood_color = "#ffe2ff"
	lifelike = 1
	unavailable_to_build = 1
	includes_tail = 1
	skin_tone = 1
	suggested_species = "Vasilissan"

/obj/item/disk/limb/dsi_spider
	company = "DSI - Vasilissan"

/datum/robolimb/dsi_teshari
	company = "DSI - Teshari"
	desc = "This limb has a thin synthflesh casing with a few connection ports."
	icon = 'icons/mob/human_races/cyberlimbs/DSITeshari/dsi_teshari.dmi'
	lifelike = 1
	skin_tone = 1
	suggested_species = "Teshari"

/datum/robolimb/dsi_teshari/New()
	species_cannot_use = GLOB.all_species.Copy()
	species_cannot_use -= SPECIES_TESHARI
	..()

/obj/item/disk/limb/dsi_teshari
	company = "DSI - Teshari"


/datum/robolimb/braincase
	company = "cortexCases - MMI"
	desc = "A solid, transparent case to hold your important bits in with style."
	icon = 'icons/mob/human_races/cyberlimbs/cortex/braincase.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/obj/item/disk/limb/braincase
	company = "cortexCases - MMI"

/datum/robolimb/posicase
	company = "cortexCases - Posi"
	desc = "A solid, transparent case to hold your important bits in with style."
	icon = 'icons/mob/human_races/cyberlimbs/cortex/posicase.dmi'
	unavailable_to_build = 1
	parts = list(BP_HEAD)

/obj/item/disk/limb/posicase
	company = "cortexCases - Posi"

/datum/robolimb/antares
	company = "Antares Robotics"
	desc = "Mustard-yellow industrial limb. Heavyset and thick."
	icon = 'icons/mob/human_races/cyberlimbs/antares/antares_main.dmi'
	unavailable_to_build = 1
	monitor_styles = standard_monitor_styles

/obj/item/disk/limb/antares
	company = "Antares Robotics"
