
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
	company = "Nanotrasen"
	catalogue_data = list(/datum/category_item/catalogue/information/organization/nanotrasen)

/obj/item/disk/limb/eggnerdltd
	company = "Eggnerd Prototyping Ltd."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "verkdisk"

/obj/item/disk/limb/vulkanwrks
	company = "Vulcan Brassworks Inc."
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "datadisk2"

/obj/item/disk/limb/talon
	company = "Talon LLC"

/obj/item/disk/limb/eggnerdltdred
	company = "Eggnerd Prototyping Ltd. (Red)"
	icon = 'icons/obj/items_vr.dmi'
	icon_state = "verkdisk"

/obj/item/disk/limb/dsi_tajaran
	company = "OSS - Tajaran"

/obj/item/disk/limb/dsi_lizard
	company = "OSS - Lizard"

/obj/item/disk/limb/dsi_sergal
	company = "OSS - Naramadi"

/obj/item/disk/limb/dsi_nevrean
	company = "OSS - Nevrean"

/obj/item/disk/limb/dsi_vulpkanin
	company = "OSS - Vulpkanin"

/obj/item/disk/limb/dsi_akula
	company = "OSS - Akula"

/obj/item/disk/limb/dsi_spider
	company = "OSS - Vasilissan"

/obj/item/disk/limb/dsi_teshari
	company = "OSS - Teshari"

/obj/item/disk/limb/braincase
	company = "cortexCases - MMI"

/obj/item/disk/limb/posicase
	company = "cortexCases - Posi"

/obj/item/disk/limb/antares
	company = "Antares Robotics"
