// Eyes
/datum/gear/eyes
	name = "Eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = SLOT_ID_GLASSES
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/eyepatchwhite
	name = "Eyepatch (Recolorable)"
	path = /obj/item/clothing/glasses/eyepatchwhite

/datum/gear/eyes/eyepatchwhite/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/eyes/glasses/tinted
	display_name = "Tinted Glasses Selection"
	path = /obj/item/clothing/glasses/tinted

/datum/gear/eyes/glasses/tinted/New()
	..()
	var/list/tints = list()
	for(var/tinted in (typesof(/obj/item/clothing/glasses/tinted/color) - typesof(/obj/item/clothing/glasses/tinted/color/purple)))
		var/obj/item/clothing/glasses/tinted_type = tinted
		tints[initial(tinted_type.name)] = tinted_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(tints, /proc/cmp_text_asc))

/datum/gear/eyes/glasses
	name = "Glasses - Prescription"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/green
	name = "Glasses - Green"
	path = /obj/item/clothing/glasses/gglasses

/datum/gear/eyes/glasses/prescriptionhipster
	name = "Glasses - Hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/monocle
	name = "Monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/eyes/goggles
	name = "Plain Goggles"
	path = /obj/item/clothing/glasses/goggles

/datum/gear/eyes/goggles/scanning
	name = "Scanning Goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/goggles/science
	name = "Science Goggles"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/glasses/fakesun
	name = "Sunglasses - Stylish"
	path = /obj/item/clothing/glasses/fakesunglasses

/datum/gear/eyes/glasses/fakeaviator
	name = "Sunglasses - Stylish Aviators"
	path = /obj/item/clothing/glasses/fakesunglasses/aviator

/datum/gear/eyes/circuitry
	name = "goggles, Circuitry (Empty)"
	path = /obj/item/clothing/glasses/circuitry

/datum/gear/eyes/glasses/rimless
	name = "Glasses - Rimless"
	path = /obj/item/clothing/glasses/rimless

/datum/gear/eyes/glasses/prescriptionrimless
	name = "Glasses - Prescription Rimless"
	path = /obj/item/clothing/glasses/regular/rimless

/datum/gear/eyes/glasses/thin
	name = "Glasses - Thin Frame"
	path = /obj/item/clothing/glasses/thin

/datum/gear/eyes/glasses/prescriptionthin
	name = "Glasses - Prescription Thin Frame"
	path = /obj/item/clothing/glasses/regular/thin

/datum/gear/eyes/glasses/thick
	name = "Glasses - Thick Lenses"
	path = /obj/item/clothing/glasses/thick

/datum/gear/eyes/glasses/prescriptionthick
	name = "Glasses - Prescription Thick Lenses"
	path = /obj/item/clothing/glasses/regular/thick

/datum/gear/eyes/glasses/dark
	name = "Glasses - Dark Frame"
	path = /obj/item/clothing/glasses/dark

/datum/gear/eyes/glasses/prescriptiondark
	name = "Glasses - Prescription Dark Frame"
	path = /obj/item/clothing/glasses/regular/dark

/datum/gear/eyes/glasses/scan
	name = "Glasses - Scanner"
	path = /obj/item/clothing/glasses/scan

/datum/gear/eyes/glasses/prescriptionscan
	name = "Glasses - Prescription Scanner"
	path = /obj/item/clothing/glasses/regular/scan

/datum/gear/eyes/jamjar
	name = "Jamjar Glasses"
	path = /obj/item/clothing/glasses/jamjar

/datum/gear/eyes/jensenshades
	name = "Augmented Shades"
	path = /obj/item/clothing/glasses/augmentedshades

/datum/gear/eyes/whiteblindfold
	name = "White Blindfold"
	path = /obj/item/clothing/glasses/sunglasses/blindfold/whiteblindfold

/datum/gear/eyes/redglasses
	name = "Red Glasses"
	path = /obj/item/clothing/glasses/redglasses

/datum/gear/eyes/badglasses
	name = "Poorly Made Glasses"
	path = /obj/item/clothing/glasses/badglasses

/datum/gear/eyes/orangeglasses
	name = "Orange Glasses"
	path = /obj/item/clothing/glasses/orangeglasses

/datum/gear/eyes/glasses/welding
	name = "Welding Goggles"
	path = /obj/item/clothing/glasses/welding

/datum/gear/eyes/arglasses
	name = "AR Glasses"
	path = /obj/item/clothing/glasses/omnihud

/datum/gear/eyes/arglassespres
	name = "AR Glasses, Prescription"
	path = /obj/item/clothing/glasses/omnihud/prescription

/datum/gear/eyes/spiffygogs
	name = "Slick Orange Goggles"
	path = /obj/item/clothing/glasses/fluff/spiffygogs

/datum/gear/eyes/science_proper
	name = "Science Goggles (No Overlay)"
	path = /obj/item/clothing/glasses/fluff/science_proper

/datum/gear/eyes/laconic
	name = "Laconic Goggles"
	path = /obj/item/clothing/glasses/welding/laconic
