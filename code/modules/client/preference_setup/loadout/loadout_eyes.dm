// Eyes
/datum/gear/eyes
	display_name = "eyepatch"
	path = /obj/item/clothing/glasses/eyepatch
	slot = slot_glasses
	sort_category = "Glasses and Eyewear"

/datum/gear/eyes/glasses
	display_name = "Glasses, prescription"
	path = /obj/item/clothing/glasses/regular

/datum/gear/eyes/glasses/green
	display_name = "Glasses, green"
	path = /obj/item/clothing/glasses/gglasses

/datum/gear/eyes/glasses/prescriptionhipster
	display_name = "Glasses, hipster"
	path = /obj/item/clothing/glasses/regular/hipster

/datum/gear/eyes/glasses/monocle
	display_name = "monocle"
	path = /obj/item/clothing/glasses/monocle

/datum/gear/eyes/goggles
	display_name = "plain goggles"
	path = /obj/item/clothing/glasses/goggles

/datum/gear/eyes/goggles/scanning
	display_name = "scanning goggles"
	path = /obj/item/clothing/glasses/regular/scanners

/datum/gear/eyes/goggles/science
	display_name = "Science Goggles"
	path = /obj/item/clothing/glasses/science

/datum/gear/eyes/security
	display_name = "Security HUD (Security)"
	path = /obj/item/clothing/glasses/hud/security
	allowed_roles = list("Security Officer","Head of Security","Warden", "Detective")

/datum/gear/eyes/security/prescriptionsec
	display_name = "Security HUD, prescription (Security)"
	path = /obj/item/clothing/glasses/hud/security/prescription

/datum/gear/eyes/security/sunglasshud
	display_name = "Security HUD, sunglasses (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud

/datum/gear/eyes/security/aviator
	display_name = "Security HUD Aviators (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator

/datum/gear/eyes/security/aviator/prescription
	display_name = "Security HUD Aviators, prescription (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud/aviator/prescription

/datum/gear/eyes/medical
	display_name = "Medical HUD (Medical)"
	path = /obj/item/clothing/glasses/hud/health
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/eyes/medical/prescriptionmed
	display_name = "Medical HUD, prescription (Medical)"
	path = /obj/item/clothing/glasses/hud/health/prescription

/datum/gear/eyes/medical/aviator
	display_name = "Medical HUD Aviators (Medical)"
	path = /obj/item/clothing/glasses/hud/health/aviator

/datum/gear/eyes/medical/aviator/prescription
	display_name = "Medical HUD Aviators, prescription (Medical)"
	path = /obj/item/clothing/glasses/hud/health/aviator/prescription

/datum/gear/eyes/meson
	display_name = "Optical Meson Scanners (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician", "Scientist", "Research Director", "Shaft Miner")

/datum/gear/eyes/meson/prescription
	display_name = "Optical Meson Scanners, prescription (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson/prescription

/datum/gear/eyes/material
	display_name = "Optical Material Scanners (Mining)"
	path = /obj/item/clothing/glasses/material
	allowed_roles = list("Shaft Miner")

/datum/gear/eyes/material/prescription
	display_name = "Prescription Optical Material Scanners (Mining)"
	path = /obj/item/clothing/glasses/material/prescription

/datum/gear/eyes/meson/aviator
	display_name = "Optical Meson Aviators, (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson/aviator

/datum/gear/eyes/meson/aviator/prescription
	display_name = "Optical Meson Aviators, prescription (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/meson/aviator/prescription

/datum/gear/eyes/glasses/fakesun
	display_name = "Sunglasses, stylish"
	path = /obj/item/clothing/glasses/fakesunglasses

/datum/gear/eyes/glasses/fakeaviator
	display_name = "Sunglasses, stylish aviators"
	path = /obj/item/clothing/glasses/fakesunglasses/aviator

/datum/gear/eyes/sun
	display_name = "Sunglasses (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses
	allowed_roles = list("Security Officer","Head of Security","Warden","Facility Director","Head of Personnel","Quartermaster","Internal Affairs Agent","Detective")

/datum/gear/eyes/sun/shades
	display_name = "Sunglasses, fat (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/big

/datum/gear/eyes/sun/aviators
	display_name = "Sunglasses, aviators (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/aviator

/datum/gear/eyes/sun/prescriptionsun
	display_name = "sunglasses, presciption (Security/Command)"
	path = /obj/item/clothing/glasses/sunglasses/prescription

/datum/gear/eyes/circuitry
	display_name = "goggles, circuitry (empty)"
	path = /obj/item/clothing/glasses/circuitry

/datum/gear/eyes/glasses/rimless
	display_name = "Glasses, rimless"
	path = /obj/item/clothing/glasses/rimless

/datum/gear/eyes/glasses/prescriptionrimless
	display_name = "Glasses, prescription rimless"
	path = /obj/item/clothing/glasses/regular/rimless

/datum/gear/eyes/glasses/thin
	display_name = "Glasses, thin frame"
	path = /obj/item/clothing/glasses/thin

/datum/gear/eyes/glasses/prescriptionthin
	display_name = "Glasses, prescription thin frame"
	path = /obj/item/clothing/glasses/regular/thin

// July 2020 Werewolf additions
/datum/gear/eyes/glasses/thick
	display_name = "Glasses, thick lenses"
	path = /obj/item/clothing/glasses/thick

/datum/gear/eyes/glasses/prescriptionthick
	display_name = "Glasses, prescription thick lenses"
	path = /obj/item/clothing/glasses/regular/thick

/datum/gear/eyes/glasses/dark
	display_name = "Glasses, dark frame"
	path = /obj/item/clothing/glasses/dark

/datum/gear/eyes/glasses/prescriptiondark
	display_name = "Glasses, prescription dark frame"
	path = /obj/item/clothing/glasses/regular/dark

/datum/gear/eyes/glasses/scan
	display_name = "Glasses, scanner"
	path = /obj/item/clothing/glasses/scan

/datum/gear/eyes/glasses/prescriptionscan
	display_name = "Glasses, prescription scanner"
	path = /obj/item/clothing/glasses/regular/scan

// April 2020 Drof's Additions Begin Below
/datum/gear/eyes/jamjar
	display_name = "jamjar glasses"
	path = /obj/item/clothing/glasses/jamjar

/datum/gear/eyes/jensenshades
	display_name = "augmented shades"
	path = /obj/item/clothing/glasses/augmentedshades

/datum/gear/eyes/whiteblindfold
	display_name = "white blindfold"
	path = /obj/item/clothing/glasses/sunglasses/blindfold/whiteblindfold

/datum/gear/eyes/redglasses
	display_name = "red glasses"
	path = /obj/item/clothing/glasses/redglasses

/datum/gear/eyes/badglasses
	display_name = "poorly made glasses"
	path = /obj/item/clothing/glasses/badglasses

/datum/gear/eyes/orangeglasses
	display_name = "orange glasses"
	path = /obj/item/clothing/glasses/orangeglasses

/datum/gear/eyes/medical/eyepatch
	display_name = "Medical HUD Eyepatch"
	path = /obj/item/clothing/glasses/hud/health/eyepatch
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/eyes/meson/eyepatch
	display_name = "Optical Meson Eyepatch (Engineering, Science, Mining)"
	path = /obj/item/clothing/glasses/hud/health/eyepatch
	allowed_roles = list("Station Engineer","Chief Engineer","Atmospheric Technician", "Scientist", "Research Director", "Shaft Miner")
