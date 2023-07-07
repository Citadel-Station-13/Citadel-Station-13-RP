// Eyes
/datum/loadout_entry/eyes
	name = "Eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = SLOT_ID_GLASSES
	sort_category = LOADOUT_CATEGORY_GLASSES

/datum/loadout_entry/eyes/eyepatchwhite
	name = "Eyepatch (Recolorable)"
	path = /obj/item/clothing/glasses/eyepatchwhite

/datum/loadout_entry/eyes/eyepatchwhite/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/loadout_entry/eyes/glasses/tinted
	display_name = "Tinted Glasses Selection"
	path = /obj/item/clothing/glasses/tinted

/datum/loadout_entry/eyes/glasses/tinted/New()
	..()
	var/list/tints = list()
	for(var/tinted in (typesof(/obj/item/clothing/glasses/tinted/color) - typesof(/obj/item/clothing/glasses/tinted/color/purple)))
		var/obj/item/clothing/glasses/tinted_type = tinted
		tints[initial(tinted_type.name)] = tinted_type
	gear_tweaks += new/datum/loadout_entry_tweak/path(tim_sort(tints, /proc/cmp_text_asc))

/datum/loadout_entry/eyes/glasses/regular
	name = "Glasses - Prescription"
	path = /obj/item/clothing/glasses/regular

/datum/loadout_entry/eyes/glasses/green
	name = "Glasses - Green"
	path = /obj/item/clothing/glasses/gglasses

/datum/loadout_entry/eyes/glasses/prescriptionhipster
	name = "Glasses - Hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/loadout_entry/eyes/glasses/monocle
	name = "Monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/loadout_entry/eyes/goggles
	name = "Plain Goggles"
	path = /obj/item/clothing/glasses/goggles

/datum/loadout_entry/eyes/goggles/scanning
	name = "Scanning Goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/loadout_entry/eyes/goggles/science
	name = "Science Goggles"
	path = /obj/item/clothing/glasses/science

/datum/loadout_entry/eyes/glasses/fakesun
	name = "Sunglasses - Stylish"
	path = /obj/item/clothing/glasses/fakesunglasses

/datum/loadout_entry/eyes/glasses/fakeaviator
	name = "Sunglasses - Stylish Aviators"
	path = /obj/item/clothing/glasses/fakesunglasses/aviator

/datum/loadout_entry/eyes/circuitry
	name = "goggles, Circuitry (Empty)"
	path = /obj/item/clothing/glasses/circuitry

/datum/loadout_entry/eyes/glasses/rimless
	name = "Glasses - Rimless"
	path = /obj/item/clothing/glasses/rimless

/datum/loadout_entry/eyes/glasses/prescriptionrimless
	name = "Glasses - Prescription Rimless"
	path = /obj/item/clothing/glasses/regular/rimless

/datum/loadout_entry/eyes/glasses/thin
	name = "Glasses - Thin Frame"
	path = /obj/item/clothing/glasses/thin

/datum/loadout_entry/eyes/glasses/prescriptionthin
	name = "Glasses - Prescription Thin Frame"
	path = /obj/item/clothing/glasses/regular/thin

/datum/loadout_entry/eyes/glasses/thick
	name = "Glasses - Thick Lenses"
	path = /obj/item/clothing/glasses/thick

/datum/loadout_entry/eyes/glasses/prescriptionthick
	name = "Glasses - Prescription Thick Lenses"
	path = /obj/item/clothing/glasses/regular/thick

/datum/loadout_entry/eyes/glasses/dark
	name = "Glasses - Dark Frame"
	path = /obj/item/clothing/glasses/dark

/datum/loadout_entry/eyes/glasses/prescriptiondark
	name = "Glasses - Prescription Dark Frame"
	path = /obj/item/clothing/glasses/regular/dark

/datum/loadout_entry/eyes/glasses/scan
	name = "Glasses - Scanner"
	path = /obj/item/clothing/glasses/scan

/datum/loadout_entry/eyes/glasses/prescriptionscan
	name = "Glasses - Prescription Scanner"
	path = /obj/item/clothing/glasses/regular/scan

/datum/loadout_entry/eyes/jamjar
	name = "Jamjar Glasses"
	path = /obj/item/clothing/glasses/jamjar

/datum/loadout_entry/eyes/jensenshades
	name = "Augmented Shades"
	path = /obj/item/clothing/glasses/augmentedshades

/datum/loadout_entry/eyes/whiteblindfold
	name = "White Blindfold"
	path = /obj/item/clothing/glasses/sunglasses/blindfold/whiteblindfold

/datum/loadout_entry/eyes/whiteblindfoldfake
	name = "White Blindfold (Fake)"
	path = /obj/item/clothing/glasses/sunglasses/fakeblindfold/whiteblindfold

/datum/loadout_entry/eyes/redglasses
	name = "Red Glasses"
	path = /obj/item/clothing/glasses/redglasses

/datum/loadout_entry/eyes/badglasses
	name = "Poorly Made Glasses"
	path = /obj/item/clothing/glasses/badglasses

/datum/loadout_entry/eyes/orangeglasses
	name = "Orange Glasses"
	path = /obj/item/clothing/glasses/orangeglasses

/datum/loadout_entry/eyes/glasses/welding
	name = "Welding Goggles"
	path = /obj/item/clothing/glasses/welding

/datum/loadout_entry/eyes/arglasses
	name = "AR Glasses"
	path = /obj/item/clothing/glasses/omnihud

/datum/loadout_entry/eyes/arglassespres
	name = "AR Glasses, Prescription"
	path = /obj/item/clothing/glasses/omnihud/prescription

/datum/loadout_entry/eyes/spiffygogs
	name = "Slick Orange Goggles"
	path = /obj/item/clothing/glasses/fluff/spiffygogs

/datum/loadout_entry/eyes/science_proper
	name = "Science Goggles (No Overlay)"
	path = /obj/item/clothing/glasses/fluff/science_proper

/datum/loadout_entry/eyes/laconic
	name = "Laconic Goggles"
	path = /obj/item/clothing/glasses/welding/laconic
