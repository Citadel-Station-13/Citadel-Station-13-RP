// Alien clothing.

/datum/gear/suit/zhan_furs
	display_name = "Tajaran - Zhan-Khazan furs"
	path = /obj/item/clothing/suit/tajaran/furs
	sort_category = "Xenowear"

/datum/gear/head/zhan_scarf
	display_name = "Tajaran - Zhan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	whitelisted = SPECIES_TAJ

/datum/gear/suit/unathi_mantle
	display_name = "Unathi - Hide Mantle"
	path = /obj/item/clothing/suit/unathi/mantle
	cost = 1
	sort_category = "Xenowear"

/datum/gear/ears/skrell/chains	//Chains
	display_name = "Skrell - Headtail Chain - Selection"
	path = /obj/item/clothing/ears/skrell/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortTim(chaintypes, /proc/cmp_text_asc))

/datum/gear/ears/skrell/bands
	display_name = "Skrell - Headtail Band - Selection"
	path = /obj/item/clothing/ears/skrell/band
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortTim(bandtypes, /proc/cmp_text_asc))

/datum/gear/ears/skrell/cloth/short
	display_name = "Skrell - Short Headtail cloth - Selection"
	path = /obj/item/clothing/ears/skrell/cloth_male/black
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/cloth/short/New()
	..()
	var/list/shorttypes = list()
	for(var/short_style in typesof(/obj/item/clothing/ears/skrell/cloth_male))
		var/obj/item/clothing/ears/skrell/cloth_male/short = short_style
		shorttypes[initial(short.name)] = short
	gear_tweaks += new/datum/gear_tweak/path(sortTim(shorttypes, /proc/cmp_text_asc))

/datum/gear/ears/skrell/cloth/long
	display_name = "Skrell - Long Headtail Cloth - Selection"
	path = /obj/item/clothing/ears/skrell/cloth_female/black
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/cloth/long/New()
	..()
	var/list/longtypes = list()
	for(var/long_style in typesof(/obj/item/clothing/ears/skrell/cloth_female))
		var/obj/item/clothing/ears/skrell/cloth_female/long = long_style
		longtypes[initial(long.name)] = long
	gear_tweaks += new/datum/gear_tweak/path(sortTim(longtypes, /proc/cmp_text_asc))

/datum/gear/ears/skrell/colored/band
	display_name = "Skrell - Colored Bands"
	path = /obj/item/clothing/ears/skrell/colored/band
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/band/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/ears/skrell/colored/chain
	display_name = "Skrell - Colored Chain"
	path = /obj/item/clothing/ears/skrell/colored/chain
	sort_category = "Xenowear"
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell/colored/chain/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/harness
	display_name = "Full Body Prosthetic / Diona - Gear Harness"
	path = /obj/item/clothing/under/harness
	sort_category = "Xenowear"

/datum/gear/shoes/footwraps
	display_name = "Cloth Footwraps"
	path = /obj/item/clothing/shoes/footwraps
	sort_category = "Xenowear"
	cost = 1

/datum/gear/shoes/footwraps/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/cohesionsuits
	display_name = "Promethean - Cohesion Suit - Selection"
	path = /obj/item/clothing/under/cohesion
	sort_category = "Xenowear"

/datum/gear/uniform/cohesionsuits/New()
	..()
	var/list/cohesionsuits = list()
	for(var/cohesionsuit in (typesof(/obj/item/clothing/under/cohesion)))
		var/obj/item/clothing/under/cohesion/cohesion_type = cohesionsuit
		cohesionsuits[initial(cohesion_type.name)] = cohesion_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cohesionsuits, /proc/cmp_text_asc))

//TESHARI

/datum/gear/uniform/smock
	display_name = "Teshari - Smock - Selection"
	path = /obj/item/clothing/under/teshari/smock
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/smock/New()
	..()
	var/list/smocks = list()
	for(var/smock in typesof(/obj/item/clothing/under/teshari/smock))
		var/obj/item/clothing/under/teshari/smock/smock_type = smock
		smocks[initial(smock_type.name)] = smock_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(smocks, /proc/cmp_text_asc))

/datum/gear/uniform/dresssmock
	display_name = "Teshari - Department Dress - Selection"
	path = /obj/item/clothing/under/teshari/dresssmock
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/dresssmock/New()
	..()
	var/list/dresssmocks = list()
	for(var/dresssmock in typesof(/obj/item/clothing/under/teshari/dresssmock))
		var/obj/item/clothing/under/teshari/dresssmock/dresssmock_type = dresssmock
		dresssmocks[initial(dresssmock_type.name)] = dresssmock_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(dresssmocks, /proc/cmp_text_asc))

/datum/gear/suit/cloak
	display_name = "Teshari Cloak - Selection"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cloaks, /proc/cmp_text_asc))

/datum/gear/uniform/undercoat
	display_name = "Teshari Undercoat - Selection"
	path = /obj/item/clothing/under/teshari/undercoat/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/undercoat/New()
	..()
	var/list/undercoats = list()
	for(var/undercoat in typesof(/obj/item/clothing/under/teshari/undercoat/standard))
		var/obj/item/clothing/under/teshari/undercoat/standard/undercoat_type = undercoat
		undercoats[initial(undercoat_type.name)] = undercoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(undercoats, /proc/cmp_text_asc))

/datum/gear/uniform/dept
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/dept/undercoat/captain
	display_name = "Teshari - Facility Director Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cap
	allowed_roles = list("Facility Director")

/datum/gear/uniform/dept/undercoat/hop
	display_name = "Teshari - Head of Personnel Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/uniform/dept/undercoat/rd
	display_name = "Teshari - Research Director Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/rd
	allowed_roles = list("Research Director")

/datum/gear/uniform/dept/undercoat/hos
	display_name = "Teshari - Head of Security Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/hos
	allowed_roles = list("Head of Security")

/datum/gear/uniform/dept/undercoat/ce
	display_name = "Teshari - Chief Engineer Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/uniform/dept/undercoat/cmo
	display_name = "Teshari - Chief Medical Officer Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/uniform/dept/undercoat/qm
	display_name = "Teshari - Quartermaster Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/qm
	allowed_roles = list("Quartermaster")

/datum/gear/uniform/dept/undercoat/cargo
	display_name = "Teshari - Cargo Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cargo
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/uniform/dept/undercoat/mining
	display_name = "Teshari - Mining Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/mining
	allowed_roles = list("Quartermaster","Shaft Miner")

/datum/gear/uniform/dept/undercoat/security
	display_name = "Teshari - Security Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/sec
	allowed_roles = list("Head of Security","Detective","Warden","Security Officer",)

/datum/gear/uniform/dept/undercoat/service
	display_name = "Teshari - Service Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/service
	allowed_roles = list("Head of Personnel","Bartender","Botanist","Janitor","Chef","Librarian","Chaplain")

/datum/gear/uniform/dept/undercoat/engineer
	display_name = "Teshari - Engineering Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/engineer
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/uniform/dept/undercoat/atmos
	display_name = "Teshari - Atmospherics Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/atmos
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/uniform/dept/undercoat/research
	display_name = "Teshari - Scientist Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/sci
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/uniform/dept/undercoat/robo
	display_name = "Teshari - Roboticist Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/robo
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/uniform/dept/undercoat/medical
	display_name = "Teshari - Medical Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Geneticist")

/datum/gear/uniform/dept/undercoat/chemistry
	display_name = "Teshari - Chemist Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/chemistry
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/uniform/dept/undercoat/virology
	display_name = "Teshari - Virologist Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/viro
	allowed_roles = list("Chief Medical Officer","Medical Doctor")

/datum/gear/uniform/dept/undercoat/psych
	display_name = "Teshari - Psychiatrist Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/psych
	allowed_roles = list("Chief Medical Officer","Psychiatrist")

/datum/gear/uniform/dept/undercoat/paramedic
	display_name = "Teshari - Paramedic Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/para
	allowed_roles = list("Chief Medical Officer","Paramedic")

/datum/gear/uniform/dept/undercoat/iaa
	display_name = "Teshari - Internal Affairs Undercoat"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/iaa
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/suit/dept/cloak/
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/dept/cloak/cap
	display_name = "Teshari - Facility Director Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs
	allowed_roles = list("Facility Director")

/datum/gear/suit/dept/cloak/hop
	display_name = "Teshari - Head of Personnel Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/suit/dept/cloak/rd
	display_name = "Teshari - Research Director Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/rd
	allowed_roles = list("Research Director")

/datum/gear/suit/dept/cloak/hos
	display_name = "Teshari - Head of Security Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/hos
	allowed_roles = list("Head of Security")

/datum/gear/suit/cloak/dept/ce
	display_name = "Teshari - Chief Engineer Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/suit/dept/cloak/cmo
	display_name = "Teshari - Chief Medical Officer Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/suit/dept/cloak/qm
	display_name = "Teshari - Quartermaster Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/qm
	allowed_roles = list("Quartermaster")

/datum/gear/suit/dept/cloak/cargo
	display_name = "Teshari - Cargo Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/cargo
	allowed_roles = list("Quartermaster","Shaft Miner" ,"Cargo Technician")

/datum/gear/suit/dept/cloak/mining
	display_name = "Teshari - Mining Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/mining
	allowed_roles = list("Quartermaster","Shaft Miner" ,"Cargo Technician")

/datum/gear/suit/dept/cloak/security
	display_name = "Teshari - Security Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/sec
	allowed_roles = list("Head of Security","Detective","Warden","Security Officer",)

/datum/gear/suit/dept/cloak/service
	display_name = "Teshari - Service Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/service
	allowed_roles = list("Head of Personnel","Bartender","Botanist","Janitor","Chef","Librarian","Chaplain")

/datum/gear/suit/dept/cloak/engineer
	display_name = "Teshari - Engineering Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/eningeer
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/suit/dept/cloak/atmos
	display_name = "Teshari - Atmospherics Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/atmos
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/suit/dept/cloak/research
	display_name = "Teshari - Scientist Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/sci
	allowed_roles = list("Research Director","Scientist","Xenobiologist")

/datum/gear/suit/dept/cloak/robo
	display_name = "Teshari - Roboticist Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/robo
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/suit/dept/cloak/medical
	display_name = "Teshari - Medical Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/medical
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Geneticist")

/datum/gear/suit/dept/cloak/chemistry
	display_name = "Teshari - Chemist Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/chemistry
	allowed_roles = list("Chemist")

/datum/gear/suit/dept/cloak/virology
	display_name = "Teshari - Virologist Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/viro
	allowed_roles = list("Medical Doctor")

/datum/gear/suit/dept/cloak/psych
	display_name = "Teshari - Psychiatrist Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/psych
	allowed_roles = list("Chief Medical Officer","Psychiatrist")

/datum/gear/suit/dept/cloak/paramedic
	display_name = "Teshari - Paramedic Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/para
	allowed_roles = list("Chief Medical Officer","Paramedic")

/datum/gear/suit/dept/cloak/iaa
	display_name = "Teshari - Internal Affairs Cloak"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/iaa
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/eyes/aerogelgoggles
	display_name = "Teshari - Civilian Orange Goggles"
	path = /obj/item/clothing/glasses/aerogelgoggles
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/smockcolor
	display_name = "Teshari - Civilian Smock - Colorable"
	path = /obj/item/clothing/under/teshari/smock/white
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/smockcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/uniform/undercoatcolor
	display_name = "Teshari - Civilian Undercoat - Colorable"
	path = /obj/item/clothing/under/teshari/undercoat/standard/white_grey
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/uniform/undercoatcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cloakcolor
	display_name = "Teshari - Civilian Cloak - Colorable"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard/white_grey
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/cloakcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/labcoat_tesh
	display_name = "Teshari - Civilian Labcoat - Colorable"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/teshari
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/labcoat_tesh/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/teshcoat
	display_name = "Teshari - Civilian Smallcoatt - Colorable"
	path = /obj/item/clothing/suit/storage/toggle/tesharicoat
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/teshcoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/teshcoatwhite
	display_name = "Teshari - Civilian Smallcoat Alt - Colorable"
	path = /obj/item/clothing/suit/storage/toggle/tesharicoatwhite
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/teshcoatwhite/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/teshneckscarf
	display_name = "Teshari - Neckscarf - Colorable"
	path = /obj/item/clothing/accessory/scarf/teshari/neckscarf
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/accessory/teshneckscarf/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

//VOX

/datum/gear/uniform/voxcivassistant
	display_name = "Vox - Assistant - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivassistant
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxcivbartender
	display_name = "Vox - Bartender - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivbartender
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxcivchef
	display_name = "Vox - Chef - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivchef
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxcivchaplain
	display_name = "Vox - Chaplain - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivchaplain
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxcivlibrarian
	display_name = "Vox - Librarian - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivlibrarian
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxsecofficer
	display_name = "Vox - Security - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivsecurity
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxcivmedical
	display_name = "Vox - Medical - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivmedical
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxcivengineer
	display_name = "Vox - Engineering - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivengineer
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxcivscience
	display_name = "Vox - Scientist - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivscience
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxcivrd
	display_name = "Vox - Research Director - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivrd
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxcivce
	display_name = "Vox - Chief Engineer - Pressure Suit"
	path = /obj/item/clothing/under/pressuresuit/voxcivce
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/simonpants
	display_name = "Vox - Civilian Simon Pants"
	path = /obj/item/clothing/under/vox/simonpants
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/suit/simonjacket
	display_name = "Vox - Civilian Simon jJacket"
	path = /obj/item/clothing/suit/simonjacket
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxcasual
	display_name = "Vox - Civilian Casual Wear"
	path = /obj/item/clothing/under/vox/vox_casual
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/voxrobes
	display_name = "Vox - Civilian Comfy Robes"
	path = /obj/item/clothing/under/vox/vox_robes
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/accessory/vox
	display_name = "Vox - Civilian Storage Vest"
	path = /obj/item/clothing/accessory/storage/vox
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/gloves/vox
	display_name = "Vox - Insulated Gauntlets"
	path = /obj/item/clothing/gloves/vox
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/shoes/vox
	display_name = "Vox - Magclaws"
	path = /obj/item/clothing/shoes/magboots/vox
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/mask/vox
	display_name = "Vox - Civilian Alien Mask"
	path = /obj/item/clothing/mask/gas/swat/vox
	sort_category = "Xenowear"
	whitelisted = SPECIES_VOX

/datum/gear/uniform/loincloth
	display_name = "Civilian Loincloth"
	path = /obj/item/clothing/suit/storage/fluff/loincloth
	sort_category = "Xenowear"

// Taj clothing
/datum/gear/eyes/tajblind
	display_name = "Tajaran - Civilian Embroidered Veil"
	path = /obj/item/clothing/glasses/tajblind
	//whitelisted = SPECIES_TAJ
	sort_category = "Xenowear"

/datum/gear/eyes/medical/tajblind
	display_name = "Tajaran - Medical Veil"
	path = /obj/item/clothing/glasses/hud/health/tajblind
	//whitelisted = SPECIES_TAJ
	sort_category = "Xenowear"

/datum/gear/eyes/meson/tajblind
	display_name = "Tajaran - EngSci Veil"
	path = /obj/item/clothing/glasses/meson/prescription/tajblind
	//whitelisted = SPECIES_TAJ
	sort_category = "Xenowear"

/datum/gear/eyes/material/tajblind
	display_name = "Tajaran - Mining Veil"
	path = /obj/item/clothing/glasses/material/prescription/tajblind
	//whitelisted = SPECIES_TAJ
	sort_category = "Xenowear"

/datum/gear/eyes/security/tajblind
	display_name = "Tajaran - Security Veil Sleek"
	path = /obj/item/clothing/glasses/sunglasses/sechud/tajblind
	//whitelisted = SPECIES_TAJ
	sort_category = "Xenowear"


/datum/gear/uniform/plascapalt
	display_name = "Phoronoid - Alternate Facility Director Helmet"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/captain/alt
	sort_category = "Xenowear"
	whitelisted = SPECIES_PLASMAMAN
	allowed_roles = list("Facility Director")

/datum/gear/uniform/plashosalt1
	display_name = "Phoronoid - Alternate Head of Security Helmet I"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/hos/alt1
	sort_category = "Xenowear"
	whitelisted = SPECIES_PLASMAMAN
	allowed_roles = list("Head of Security")

/datum/gear/uniform/plashosalt2
	display_name = "Phoronoid - Alternate Head of Security Helmet II"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/hos/alt2
	sort_category = "Xenowear"
	whitelisted = SPECIES_PLASMAMAN
	allowed_roles = list("Head of Security")

/datum/gear/uniform/plasaccessories
	display_name = "Phoronoid - Civilian Containment Suit Accessory Selection"
	sort_category = "Xenowear"
	whitelisted = SPECIES_PLASMAMAN

/datum/gear/uniform/plasaccessories/New()
	..()
	var/list/plasaccessories = list()
	for(var/plasman in (typesof(/obj/item/clothing/accessory/plasman)))
		var/obj/item/clothing/accessory/plasman/plasaccessory_type = plasman
		plasaccessories[initial(plasaccessory_type.name)] = plasaccessory_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(plasaccessories, /proc/cmp_text_asc))

/datum/gear/suit/hood
	display_name = "Teshari - Civilian Hooded Cloak Selection"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/suit/hood/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/hooded/teshari/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cloaks, /proc/cmp_text_asc))
