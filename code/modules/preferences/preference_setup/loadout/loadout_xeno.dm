//Anything species-restricted to non-human species should be declared here.
/******************************************************************************/
//*Initial Datum Declarations to Reduce Redundancy
/datum/gear/xeno
	name = "Generic - Loincloth"
	path = /obj/item/clothing/suit/storage/fluff/loincloth
	slot = null
	allowed_roles = null //Since 99.99% of all items in this file are going to be species-locked, we should keep the role-locked species items here, rather than in the role_restricted.dm file.
	sort_category = "Xenowear"

/datum/gear/xeno/accessories
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/xeno/shoes
	slot = SLOT_ID_SHOES

/datum/gear/xeno/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/xeno/suit
	slot = SLOT_ID_SUIT

/datum/gear/xeno/head
	slot = SLOT_ID_HEAD

/datum/gear/xeno/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/xeno/back
	slot = SLOT_ID_BACK

/datum/gear/xeno/mask
	slot = SLOT_ID_MASK

/datum/gear/xeno/gloves
	slot = SLOT_ID_GLOVES
/******************************************************************************/
//**Species-Specific Datum Declarations
//*Tajaran
/datum/gear/xeno/tajaran
	whitelisted = SPECIES_TAJ

/datum/gear/xeno/tajaran/accessories
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/xeno/tajaran/shoes
	slot = SLOT_ID_SHOES

/datum/gear/xeno/tajaran/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/xeno/tajaran/suit
	slot = SLOT_ID_SUIT

/datum/gear/xeno/tajaran/head
	slot = SLOT_ID_HEAD

/datum/gear/xeno/tajaran/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/xeno/tajaran/back
	slot = SLOT_ID_BACK

//*Promethean
/datum/gear/xeno/promethean
	whitelisted = SPECIES_PROMETHEAN

/datum/gear/xeno/promethean/accessories
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/xeno/promethean/shoes
	slot = SLOT_ID_SHOES

/datum/gear/xeno/promethean/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/xeno/promethean/suit
	slot = SLOT_ID_SUIT

/datum/gear/xeno/promethean/head
	slot = SLOT_ID_HEAD

/datum/gear/xeno/promethean/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/xeno/promethean/back
	slot = SLOT_ID_BACK

//*Teshari
/datum/gear/xeno/teshari
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/teshari/accessories
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/xeno/teshari/shoes
	slot = SLOT_ID_SHOES

/datum/gear/xeno/teshari/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/xeno/teshari/suit
	slot = SLOT_ID_SUIT

/datum/gear/xeno/teshari/head
	slot = SLOT_ID_HEAD

/datum/gear/xeno/teshari/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/xeno/teshari/back
	slot = SLOT_ID_BACK

/datum/gear/xeno/teshari/mask
	slot = SLOT_ID_MASK

/datum/gear/xeno/teshari/gloves
	slot = SLOT_ID_GLOVES


//*Phoronoid
/datum/gear/xeno/phoronoid
	whitelisted = SPECIES_PHORONOID

/datum/gear/xeno/phoronoid/accessories
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/xeno/phoronoid/shoes
	slot = SLOT_ID_SHOES

/datum/gear/xeno/phoronoid/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/xeno/phoronoid/suit
	slot = SLOT_ID_SUIT

/datum/gear/xeno/phoronoid/head
	slot = SLOT_ID_HEAD

/datum/gear/xeno/phoronoid/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/xeno/phoronoid/back
	slot = SLOT_ID_BACK

/datum/gear/xeno/phoronoid/mask
	slot = SLOT_ID_MASK

/datum/gear/xeno/phoronoid/gloves
	slot = SLOT_ID_GLOVES



//*Skrell
/datum/gear/xeno/skrell
	whitelisted = SPECIES_SKRELL

/datum/gear/xeno/skrell/accessories
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/xeno/skrell/shoes
	slot = SLOT_ID_SHOES

/datum/gear/xeno/skrell/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/xeno/skrell/suit
	slot = SLOT_ID_SUIT

/datum/gear/xeno/skrell/head
	slot = SLOT_ID_HEAD

/datum/gear/xeno/skrell/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/xeno/skrell/back
	slot = SLOT_ID_BACK

/datum/gear/xeno/skrell/mask
	slot = SLOT_ID_MASK

/datum/gear/xeno/skrell/gloves
	slot = SLOT_ID_GLOVES



//*Unathi
/datum/gear/xeno/unathi
	whitelisted = SPECIES_UNATHI

/datum/gear/xeno/unathi/accessories
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/xeno/unathi/shoes
	slot = SLOT_ID_SHOES

/datum/gear/xeno/unathi/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/xeno/unathi/suit
	slot = SLOT_ID_SUIT

/datum/gear/xeno/unathi/head
	slot = SLOT_ID_HEAD

/datum/gear/xeno/unathi/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/xeno/unathi/back
	slot = SLOT_ID_BACK

/datum/gear/xeno/unathi/mask
	slot = SLOT_ID_MASK

/datum/gear/xeno/unathi/gloves
	slot = SLOT_ID_GLOVES



//*Vox
/datum/gear/xeno/vox
	whitelisted = SPECIES_VOX

/datum/gear/xeno/vox/accessories
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/xeno/vox/shoes
	slot = SLOT_ID_SHOES

/datum/gear/xeno/vox/uniform
	slot = SLOT_ID_UNIFORM

/datum/gear/xeno/vox/suit
	slot = SLOT_ID_SUIT

/datum/gear/xeno/vox/head
	slot = SLOT_ID_HEAD

/datum/gear/xeno/vox/eyes
	slot = SLOT_ID_GLASSES

/datum/gear/xeno/vox/back
	slot = SLOT_ID_BACK

/datum/gear/xeno/vox/mask
	slot = SLOT_ID_MASK

/datum/gear/xeno/vox/gloves
	slot = SLOT_ID_GLOVES
/******************************************************************************/
//**Actual Item Declarations
//*Tajaran
//Eyes
/datum/gear/xeno/tajaran/eyes/veil
	name = "Tajaran - Embroidered Veil"
	path = /obj/item/clothing/glasses/tajblind

/datum/gear/xeno/tajaran/eyes/veil/medical
	name = "Tajaran - Medical Veil"
	path = /obj/item/clothing/glasses/hud/health/tajblind
	allowed_roles = list("Medical Doctor", "Chief Medical Officer", "Chemist", "Paramedic", "Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/xeno/tajaran/eyes/veil/mesons
	name = "Tajaran - Optical Meson Veil"
	path = /obj/item/clothing/glasses/meson/prescription/tajblind
	allowed_roles = list("Station Engineer", "Chief Engineer", "Atmospheric Technician", "Research Director", "Scientist", "Roboticist", "Xenobiologist", "Explorer", "Pathfinder")

/datum/gear/xeno/tajaran/eyes/veil/material_scanners
	name = "Tajaran - Material Scanning Veil"
	path = /obj/item/clothing/glasses/material/prescription/tajblind
	allowed_roles = list("Shaft Miner", "Cargo Technician", "Quartermaster")

/datum/gear/xeno/tajaran/eyes/veil/security
	name = "Tajaran - Security Veil Sleek"
	path = /obj/item/clothing/glasses/sunglasses/sechud/tajblind
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

//Suits
/datum/gear/xeno/tajaran/suit/zk_furs
	name = "Tajaran - Zhan-Khazan Furs"
	path = /obj/item/clothing/suit/tajaran/furs

//Headwear
/datum/gear/xeno/tajaran/head/zhan_headscarf
	name = "Tajaran - Zhan Headscarf"
	path = /obj/item/clothing/head/tajaran/scarf



//*Promethean
/datum/gear/xeno/promethean/uniform/cohesion_suit
	name = "Promethean - Cohesion Suit - Selection"
	path = /obj/item/clothing/under/cohesion

/datum/gear/xeno/promethean/uniform/cohesion_suit/New()
	..()
	var/list/cohesionsuits = list()
	for(var/cohesionsuit in (typesof(/obj/item/clothing/under/cohesion)))
		var/obj/item/clothing/under/cohesion/cohesion_type = cohesionsuit
		cohesionsuits[initial(cohesion_type.name)] = cohesion_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cohesionsuits, /proc/cmp_text_asc))


//*Vox
//Uniforms
/datum/gear/xeno/vox/uniform/assistant
	name = "Vox - Assistant - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivassistant

/datum/gear/xeno/vox/uniform/bartender
	name = "Vox - Bartender - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivbartender
	allowed_roles = list("Bartender")

/datum/gear/xeno/vox/uniform/chef
	name = "Vox - Chef - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivchef
	allowed_roles = list("Chef")

/datum/gear/xeno/vox/uniform/chaplain
	name = "Vox - Chaplain - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivchaplain
	allowed_roles = list("Chaplain")

/datum/gear/xeno/vox/uniform/librarian
	name = "Vox - Librarian - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivlibrarian
	allowed_roles = list("Librarian")

/datum/gear/xeno/vox/uniform/security
	name = "Vox - Security - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivsecurity
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

/datum/gear/xeno/vox/uniform/medical
	name = "Vox - Medical - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivmedical
	allowed_roles = list("Medical Doctor", "Chief Medical Officer", "Chemist", "Paramedic", "Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/xeno/vox/uniform/engineer
	name = "Vox - Engineering - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivengineer
	allowed_roles = list("Station Engineer", "Chief Engineer", "Atmospheric Technician")

/datum/gear/xeno/vox/uniform/engineer/ce
	name = "Vox - Chief Engineer - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivce
	allowed_roles = list("Chief Engineer")

/datum/gear/xeno/vox/uniform/science
	name = "Vox - Scientist - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivscience
	allowed_roles = list("Research Director", "Scientist", "Xenobiologist", "Roboticist", "Explorer", "Pathfinder")

/datum/gear/xeno/vox/uniform/science/rd
	name = "Vox - Research Director - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivrd
	allowed_roles = list("Research Director")

/datum/gear/xeno/vox/uniform/simon_pants
	name = "Vox - Simon Pants"
	path = /obj/item/clothing/under/vox/simonpants

/datum/gear/xeno/vox/uniform/voxcasual
	name = "Vox - Casual Wear"
	path = /obj/item/clothing/under/vox/vox_casual

/datum/gear/xeno/vox/uniform/voxrobes
	name = "Vox - Comfy Robes"
	path = /obj/item/clothing/under/vox/vox_robes

//Suit
/datum/gear/xeno/vox/suit/simon_jacket
	name = "Vox - Simon Jacket"
	path = /obj/item/clothing/suit/simonjacket

//Accessories
/datum/gear/xeno/vox/accessories/storage_vest
	name = "Vox - Storage Vest"
	path = /obj/item/clothing/accessory/storage/vox

//Gloves
/datum/gear/xeno/vox/gloves/insulated_gauntlets
	name = "Vox - Insulated Gauntlets"
	path = /obj/item/clothing/gloves/vox

//Shoes
/datum/gear/xeno/vox/shoes/magclaws
	name = "Vox - Magclaws"
	path = /obj/item/clothing/shoes/magboots/vox

//Mask
/datum/gear/xeno/vox/mask
	name = "Vox - Alien Mask"
	path = /obj/item/clothing/mask/gas/swat/vox





//*Unathi
//Suits
/datum/gear/xeno/unathi/suit/mantle
	name = "Unathi - Hide Mantle"
	path = /obj/item/clothing/suit/unathi/mantle

/datum/gear/xeno/unathi/suit/roughspun_robe
	name = "Unathi - Roughspun Robe"
	path = /obj/item/clothing/suit/unathi/robe



//*Phoronoids
//Head
/datum/gear/xeno/phoronoid/head/captain_helmet_alt
	name = "Phoronoid - Alternate Facility Director Helmet"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/captain/alt
	allowed_roles = list("Facility Director")

/datum/gear/xeno/phoronoid/head/hos_helmet_alt
	name = "Phoronoid - Alternate Head of Security Helmet I"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/hos/alt1
	allowed_roles = list("Head of Security")

/datum/gear/xeno/phoronoid/head/hos_helmet_alt_2
	name = "Phoronoid - Alternate Head of Security Helmet II"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/hos/alt2
	allowed_roles = list("Head of Security")

//Accessories
/datum/gear/xeno/phoronoid/accessories/suit_accessories
	name = "Phoronoid - Containment Suit Accessory Selection"

/datum/gear/xeno/phoronoid/accessories/suit_accessories/New()
	..()
	var/list/plasaccessories = list()
	for(var/plasman in (typesof(/obj/item/clothing/accessory/plasman)))
		var/obj/item/clothing/accessory/plasman/plasaccessory_type = plasman
		plasaccessories[initial(plasaccessory_type.name)] = plasaccessory_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(plasaccessories, /proc/cmp_text_asc))




//*Skrell
//Special Case items because Skrell are weird and I'm too lazy to go find out whether or not there's even a slot you need to specify for ear-wear.
/datum/gear/xeno/skrell/chains
	name = "Skrell - Headtail Chain - Selection"
	path = /obj/item/clothing/ears/skrell/chain

/datum/gear/xeno/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortTim(chaintypes, /proc/cmp_text_asc))


/datum/gear/xeno/skrell/bands
	name = "Skrell - Headtail Band - Selection"
	path = /obj/item/clothing/ears/skrell/band

/datum/gear/xeno/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortTim(bandtypes, /proc/cmp_text_asc))


/datum/gear/xeno/skrell/cloth/short
	name = "Skrell - Short Headtail cloth - Selection"
	path = /obj/item/clothing/ears/skrell/cloth_male/black

/datum/gear/xeno/skrell/cloth/short/New()
	..()
	var/list/shorttypes = list()
	for(var/short_style in typesof(/obj/item/clothing/ears/skrell/cloth_male))
		var/obj/item/clothing/ears/skrell/cloth_male/short = short_style
		shorttypes[initial(short.name)] = short
	gear_tweaks += new/datum/gear_tweak/path(sortTim(shorttypes, /proc/cmp_text_asc))


/datum/gear/xeno/skrell/cloth/long
	name = "Skrell - Long Headtail Cloth - Selection"
	path = /obj/item/clothing/ears/skrell/cloth_female/black

/datum/gear/xeno/skrell/cloth/long/New()
	..()
	var/list/longtypes = list()
	for(var/long_style in typesof(/obj/item/clothing/ears/skrell/cloth_female))
		var/obj/item/clothing/ears/skrell/cloth_female/long = long_style
		longtypes[initial(long.name)] = long
	gear_tweaks += new/datum/gear_tweak/path(sortTim(longtypes, /proc/cmp_text_asc))


/datum/gear/xeno/skrell/colored/band
	name = "Skrell - Colored Bands"
	path = /obj/item/clothing/ears/skrell/colored/band

/datum/gear/xeno/skrell/colored/band/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/xeno/skrell/colored/chain
	name = "Skrell - Colored Chain"
	path = /obj/item/clothing/ears/skrell/colored/chain

/datum/gear/xeno/skrell/colored/chain/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice



//*Teshari
//Uniform
/datum/gear/xeno/teshari/uniform/smock_selection
	name = "Teshari - Smock Selection"
	path = /obj/item/clothing/under/teshari/smock

/datum/gear/xeno/teshari/uniform/smock_selection/New()
	..()
	var/list/smocks = list()
	for(var/smock in typesof(/obj/item/clothing/under/teshari/smock))
		var/obj/item/clothing/under/teshari/smock/smock_type = smock
		smocks[initial(smock_type.name)] = smock_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(smocks, /proc/cmp_text_asc))

/datum/gear/xeno/teshari/uniform/standard_undercoat_selection
	name = "Teshari - Standard Undercoat Selection"
	path = /obj/item/clothing/under/teshari/undercoat/standard

/datum/gear/xeno/teshari/uniform/standard_undercoat_selection/New()
	..()
	var/list/undercoats = list()
	for(var/undercoat in typesof(/obj/item/clothing/under/teshari/undercoat/standard))
		var/obj/item/clothing/under/teshari/undercoat/standard/undercoat_type = undercoat
		undercoats[initial(undercoat_type.name)] = undercoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(undercoats, /proc/cmp_text_asc))


/datum/gear/xeno/teshari/uniform/dress_smock_selection
	name = "Teshari - Department Dress Selection"
	path = /obj/item/clothing/under/teshari/dresssmock

/datum/gear/xeno/teshari/uniform/dress_smock_selection/New()
	..()
	var/list/dresssmocks = list()
	for(var/dresssmock in typesof(/obj/item/clothing/under/teshari/dresssmock))
		var/obj/item/clothing/under/teshari/dresssmock/dresssmock_type = dresssmock
		dresssmocks[initial(dresssmock_type.name)] = dresssmock_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(dresssmocks, /proc/cmp_text_asc))

/datum/gear/xeno/teshari/uniform/role_undercoat
	name = "Teshari - Facility Director Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cap
	allowed_roles = list("Facility Director")

/datum/gear/xeno/teshari/uniform/role_undercoat/hop
	name = "Teshari - Head of Personnel Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/xeno/teshari/uniform/role_undercoat/rd
	name = "Teshari - Research Director Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/rd
	allowed_roles = list("Research Director")

/datum/gear/xeno/teshari/uniform/role_undercoat/hos
	name = "Teshari - Head of Security Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/hos
	allowed_roles = list("Head of Security")

/datum/gear/xeno/teshari/uniform/role_undercoat/ce
	name = "Teshari - Chief Engineer Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/xeno/teshari/uniform/role_undercoat/cmo
	name = "Teshari - Chief Medical Officer Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/xeno/teshari/uniform/role_undercoat/qm
	name = "Teshari - Quartermaster Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/qm
	allowed_roles = list("Quartermaster")

/datum/gear/xeno/teshari/uniform/role_undercoat/cargo
	name = "Teshari - Cargo Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cargo
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/xeno/teshari/uniform/role_undercoat/mining
	name = "Teshari - Mining Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/mining
	allowed_roles = list("Quartermaster","Shaft Miner")

/datum/gear/xeno/teshari/uniform/role_undercoat/security
	name = "Teshari - Security Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/sec
	allowed_roles = list("Head of Security","Detective","Warden","Security Officer",)

/datum/gear/xeno/teshari/uniform/role_undercoat/service
	name = "Teshari - Service Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/service
	allowed_roles = list("Head of Personnel", "Bartender", "Botanist", "Janitor", "Chef", "Librarian", "Chaplain")

/datum/gear/xeno/teshari/uniform/role_undercoat/engineer
	name = "Teshari - Engineering Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/engineer
	allowed_roles = list("Chief Engineer", "Station Engineer")

/datum/gear/xeno/teshari/uniform/role_undercoat/atmos
	name = "Teshari - Atmospherics Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/atmos
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/xeno/teshari/uniform/role_undercoat/research
	name = "Teshari - Scientist Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/sci
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/xeno/teshari/uniform/role_undercoat/robo
	name = "Teshari - Roboticist Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/robo
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/xeno/teshari/uniform/role_undercoat/medical
	name = "Teshari - Medical Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Geneticist")

/datum/gear/xeno/teshari/uniform/role_undercoat/chemistry
	name = "Teshari - Chemist Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/chemistry
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/xeno/teshari/uniform/role_undercoat/virology
	name = "Teshari - Virologist Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/viro
	allowed_roles = list("Chief Medical Officer","Medical Doctor")

/datum/gear/xeno/teshari/uniform/role_undercoat/psych
	name = "Teshari - Psychiatrist Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/psych
	allowed_roles = list("Chief Medical Officer","Psychiatrist")

/datum/gear/xeno/teshari/uniform/role_undercoat/paramedic
	name = "Teshari - Paramedic Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/para
	allowed_roles = list("Chief Medical Officer","Paramedic")

/datum/gear/xeno/teshari/uniform/role_undercoat/iaa
	name = "Teshari - Internal Affairs Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/iaa
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/xeno/teshari/uniform/smock_colorable
	name = "Teshari - Smock (Colorable)"
	path = /obj/item/clothing/under/teshari/smock/white

/datum/gear/xeno/teshari/uniform/smock_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/xeno/teshari/uniform/undercoat_colorable
	name = "Teshari - Undercoat (Colorable)"
	path = /obj/item/clothing/under/teshari/undercoat/standard/white_grey

/datum/gear/xeno/teshari/uniform/undercoat_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


//Suit
/datum/gear/xeno/teshari/suit/standard_cloak_selection
	name = "Teshari - Standard Cloak Selection"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard

/datum/gear/xeno/teshari/suit/standard_cloak_selection/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cloaks, /proc/cmp_text_asc))


/datum/gear/xeno/teshari/suit/role_cloak
	name = "Teshari - Facility Director Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs
	allowed_roles = list("Facility Director")

/datum/gear/xeno/teshari/suit/role_cloak/hop
	name = "Teshari - Head of Personnel Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/xeno/teshari/suit/role_cloak/rd
	name = "Teshari - Research Director Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/rd
	allowed_roles = list("Research Director")

/datum/gear/xeno/teshari/suit/role_cloak/hos
	name = "Teshari - Head of Security Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/hos
	allowed_roles = list("Head of Security")

/datum/gear/xeno/teshari/suit/role_cloak/ce
	name = "Teshari - Chief Engineer Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/xeno/teshari/suit/role_cloak/cmo
	name = "Teshari - Chief Medical Officer Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/xeno/teshari/suit/role_cloak/qm
	name = "Teshari - Quartermaster Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/qm
	allowed_roles = list("Quartermaster")

/datum/gear/xeno/teshari/suit/role_cloak/cargo
	name = "Teshari - Cargo Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/cargo
	allowed_roles = list("Quartermaster","Shaft Miner" ,"Cargo Technician")

/datum/gear/xeno/teshari/suit/role_cloak/mining
	name = "Teshari - Mining Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/mining
	allowed_roles = list("Quartermaster","Shaft Miner" ,"Cargo Technician")

/datum/gear/xeno/teshari/suit/role_cloak/security
	name = "Teshari - Security Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/sec
	allowed_roles = list("Head of Security","Detective","Warden","Security Officer",)

/datum/gear/xeno/teshari/suit/role_cloak/service
	name = "Teshari - Service Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/service
	allowed_roles = list("Head of Personnel","Bartender","Botanist","Janitor","Chef","Librarian","Chaplain")

/datum/gear/xeno/teshari/suit/role_cloak/engineer
	name = "Teshari - Engineering Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/eningeer
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/xeno/teshari/suit/role_cloak/atmos
	name = "Teshari - Atmospherics Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/atmos
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/xeno/teshari/suit/role_cloak/research
	name = "Teshari - Scientist Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/sci
	allowed_roles = list("Research Director","Scientist","Xenobiologist")

/datum/gear/xeno/teshari/suit/role_cloak/robo
	name = "Teshari - Roboticist Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/robo
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/xeno/teshari/suit/role_cloak/medical
	name = "Teshari - Medical Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Geneticist")

/datum/gear/xeno/teshari/suit/role_cloak/chemistry
	name = "Teshari - Chemist Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/chemistry
	allowed_roles = list("Chemist")

/datum/gear/xeno/teshari/suit/role_cloak/virology
	name = "Teshari - Virologist Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/viro
	allowed_roles = list("Medical Doctor")

/datum/gear/xeno/teshari/suit/role_cloak/psych
	name = "Teshari - Psychiatrist Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/psych
	allowed_roles = list("Chief Medical Officer","Psychiatrist")

/datum/gear/xeno/teshari/suit/role_cloak/paramedic
	name = "Teshari - Paramedic Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/para
	allowed_roles = list("Chief Medical Officer","Paramedic")

/datum/gear/xeno/teshari/suit/role_cloak/iaa
	name = "Teshari - Internal Affairs Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/iaa
	allowed_roles = list("Internal Affairs Agent")


/datum/gear/xeno/teshari/suit/hooded_cloak_selection
	name = "Teshari - Hooded Cloak Selection"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard

/datum/gear/xeno/teshari/suit/hooded_cloak_selection/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/hooded/teshari/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cloaks, /proc/cmp_text_asc))



/datum/gear/xeno/teshari/suit/cloak_colorable
	name = "Teshari - Cloak (Colorable)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard/white_grey

/datum/gear/xeno/teshari/suit/cloak_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/xeno/teshari/suit/labcoat_colorable
	name = "Teshari - Labcoat (Colorable)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/teshari

/datum/gear/xeno/teshari/suit/labcoat_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/xeno/teshari/suit/smallcoat
	name = "Teshari - Smallcoat (Colorable)"
	path = /obj/item/clothing/suit/storage/toggle/tesharicoat

/datum/gear/xeno/teshari/suit/smallcoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/xeno/teshari/suit/smallcoat_alt
	name = "Teshari - Smallcoat Alt (Colorable)"
	path = /obj/item/clothing/suit/storage/toggle/tesharicoatwhite

/datum/gear/xeno/teshari/suit/smallcoat_alt/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice



//Eyes
/datum/gear/xeno/teshari/eyes/aerogelgoggles
	name = "Teshari - Orange Goggles"
	path = /obj/item/clothing/glasses/aerogelgoggles

//Accessory
/datum/gear/xeno/teshari/accessories/neckscarf_colorable
	name = "Teshari - Neckscarf (Colorable)"
	path = /obj/item/clothing/accessory/scarf/teshari/neckscarf


/datum/gear/xeno/teshari/accessories/neckscarf_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


//*Moth
// Will be restricted in the future, when moths have a separate species. For now, rely on the sprites looking goofy as fuck on anything other than moths to keep people away. - WrongEnd

/datum/gear/xeno/uniform/puffy_pants
	name = "Moth - Puffy Pants Selection"
	description = "Selection of Puffy Moth Pants."

/datum/gear/xeno/uniform/puffy_pants/New()
	..()
	var/list/puffy_pants = list()
	for(var/puffy_pant in typesof(/obj/item/clothing/under/moth/puffy_pants))
		var/obj/item/clothing/under/moth/puffy_pants/puffy_pant_type = puffy_pant
		puffy_pants[initial(puffy_pant_type.name)] = puffy_pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(puffy_pants, /proc/cmp_text_asc))

/datum/gear/xeno/uniform/tight_pants
	name = "Moth - Pants Selection"
	description = "Selection of Moth Pants."

/datum/gear/xeno/uniform/tight_pants/New()
	..()
	var/list/tight_pants = list()
	for(var/tight_pant in typesof(/obj/item/clothing/under/moth/tight_pants))
		var/obj/item/clothing/under/moth/tight_pants/tight_pant_type = tight_pant
		tight_pants[initial(tight_pant_type.name)] = tight_pant_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(tight_pants, /proc/cmp_text_asc))

/datum/gear/xeno/uniform/moth_skirt
	name = "Moth - Skirt Selection"
	description = "Selection of Moth Skirts."

/datum/gear/xeno/uniform/moth_skirt/New()
	..()
	var/list/moth_skirt = list()
	for(var/moth_skirts in typesof(/obj/item/clothing/under/moth/moth_skirt))
		var/obj/item/clothing/under/moth/moth_skirt/moth_skirts_type = moth_skirts
		moth_skirt[initial(moth_skirts_type.name)] = moth_skirts_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(moth_skirt, /proc/cmp_text_asc))

/datum/gear/xeno/accessories/abdomen_guard
	name = "Moth - Abdomen Guards Selection"
	description = "Selection of Abdomen Guards."

/datum/gear/xeno/accessories/abdomen_guard/New()
	..()
	var/list/abdomen_guard = list()
	for(var/abdomen_guards in typesof(/obj/item/clothing/accessory/vest/moth/abdomen_guard))
		var/obj/item/clothing/accessory/vest/moth/abdomen_guard/abdomen_guards_type = abdomen_guards
		abdomen_guard[initial(abdomen_guards_type.name)] = abdomen_guards_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(abdomen_guard, /proc/cmp_text_asc))

/datum/gear/xeno/accessories/tunic_top
	name = "Moth - Tunic Tops Selection"
	description = "Selection of Moth Tunic Tops."

/datum/gear/xeno/accessories/tunic_top/New()
	..()
	var/list/tunic_top = list()
	for(var/tunic_tops in typesof(/obj/item/clothing/accessory/vest/moth/tunic_top))
		var/obj/item/clothing/accessory/vest/moth/tunic_top/tunic_tops_type = tunic_tops
		tunic_top[initial(tunic_tops_type.name)] = tunic_tops_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(tunic_top, /proc/cmp_text_asc))

/datum/gear/xeno/accessories/cloth_strap_top
	name = "Moth - Cloth Strap Tops Selection"
	description = "Selection of Moth Cloth Strap Tops."

/datum/gear/xeno/accessories/cloth_strap_top/New()
	..()
	var/list/cloth_strap_top = list()
	for(var/cloth_strap_tops in typesof(/obj/item/clothing/accessory/vest/moth/cloth_strap_top))
		var/obj/item/clothing/accessory/vest/moth/cloth_strap_top/cloth_strap_tops_type = cloth_strap_tops
		cloth_strap_top[initial(cloth_strap_tops_type.name)] = cloth_strap_tops_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cloth_strap_top, /proc/cmp_text_asc))

/datum/gear/xeno/accessories/shoulder_pad_right
	name = "Moth - Right Shoulder Pads Selection"
	description = "Selection of Moth Right Shoulder Pads."

/datum/gear/xeno/accessories/shoulder_pad_right/New()
	..()
	var/list/shoulder_pad_right = list()
	for(var/shoulder_pad_rights in typesof(/obj/item/clothing/accessory/vest/moth/shoulder_pad_right))
		var/obj/item/clothing/accessory/vest/moth/shoulder_pad_right/shoulder_pad_rights_type = shoulder_pad_rights
		shoulder_pad_right[initial(shoulder_pad_rights_type.name)] = shoulder_pad_rights_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(shoulder_pad_right, /proc/cmp_text_asc))

/datum/gear/xeno/accessories/shoulder_pad_left
	name = "Moth - Left Shoulder Pads Selection"
	description = "Selection of Moth Left Shoulder Pads."

/datum/gear/xeno/accessories/shoulder_pad_left/New()
	..()
	var/list/shoulder_pad_left = list()
	for(var/shoulder_pad_lefts in typesof(/obj/item/clothing/accessory/vest/moth/shoulder_pad_left))
		var/obj/item/clothing/accessory/vest/moth/shoulder_pad_left/shoulder_pad_lefts_type = shoulder_pad_lefts
		shoulder_pad_left[initial(shoulder_pad_lefts_type.name)] = shoulder_pad_lefts_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(shoulder_pad_left, /proc/cmp_text_asc))

/datum/gear/xeno/accessories/front_tunic
	name = "Moth - Front Tunics Selection"
	description = "Selection of Moth Front Tunics."

/datum/gear/xeno/accessories/front_tunic/New()
	..()
	var/list/front_tunic = list()
	for(var/front_tunics in typesof(/obj/item/clothing/accessory/vest/moth/front_tunic))
		var/obj/item/clothing/accessory/vest/moth/front_tunic/front_tunics_type = front_tunics
		front_tunic[initial(front_tunics_type.name)] = front_tunics_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(front_tunic, /proc/cmp_text_asc))

/datum/gear/xeno/accessories/gaiter
	name = "Moth - Gaiters Selection"
	description = "Selection of Moth Gaiters."

/datum/gear/xeno/accessories/gaiter/New()
	..()
	var/list/gaiter = list()
	for(var/gaiters in typesof(/obj/item/clothing/accessory/vest/moth/gaiter))
		var/obj/item/clothing/accessory/vest/moth/gaiter/gaiters_type = gaiters
		gaiter[initial(gaiters_type.name)] = gaiters_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(gaiter, /proc/cmp_text_asc))

/datum/gear/xeno/shoes/legwrap
	name = "Moth - Legwraps Selection"
	description = "Selection of Moth Legwraps."

/datum/gear/xeno/shoes/legwrap/New()
	..()
	var/list/legwrap = list()
	for(var/legwraps in typesof(/obj/item/clothing/shoes/moth/legwrap))
		var/obj/item/clothing/shoes/moth/legwrap/legwraps_type = legwraps
		legwrap[initial(legwraps_type.name)] = legwraps_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(legwrap, /proc/cmp_text_asc))

/datum/gear/xeno/shoes/moth/jackboots
	name = "Moth - Jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots/moth
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

/datum/gear/xeno/shoes/moth/workboots
	name = "Moth - Workboots"
	path = /obj/item/clothing/shoes/boots/moth
	allowed_roles = list("Station Engineer", "Chief Engineer", "Atmospheric Technician", "Research Director", "Scientist", "Roboticist", "Xenobiologist", "Explorer", "Pathfinder")



//*Non-Restricted Items (THIS SHOULD BE KEPT MINIMAL. IF IT HAS A SPECIFIC SPECIES, PLACE IT THERE.)
/datum/gear/xeno/back/saddlebag
	name = "Generic - Saddle Bag, Horse"
	path = /obj/item/storage/backpack/saddlebag
	cost = 2

/datum/gear/xeno/back/saddlebag/common
	name = "Generic - Saddle Bag, Common"
	path = /obj/item/storage/backpack/saddlebag_common

/datum/gear/xeno/back/saddlebag/robust
	name = "Generic - Saddle Bag, Robust"
	path = /obj/item/storage/backpack/saddlebag_common/robust

/datum/gear/xeno/back/taur_vest
	name = "Generic - Taur Duty Vest, Backpack"
	path = /obj/item/storage/backpack/saddlebag_common/vest

/datum/gear/xeno/uniform
	name = "Generic - Gear Harness"
	path = /obj/item/clothing/under/harness
