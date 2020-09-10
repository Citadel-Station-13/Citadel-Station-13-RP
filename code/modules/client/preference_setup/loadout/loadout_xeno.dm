/*
	Xenowear - Clothing that is unique to species besides Humans.
	No slot assigned for the base datum because they could be anything.
*/

/datum/gear/xeno
	sort_category = "Xenowear" // This controls the name of the category in the loadout.
	type_category = /datum/gear/xeno // All subtypes of the geartype declared will be associated with this - practically speaking this controls where the items themselves go.
	cost = 1 // Controls how much an item's "cost" is in the loadout point menu. If re-specified on a different item, that value will override this one. This sets the default value.




//SKRELL
/datum/gear/xeno/skrell_chains
	display_name = "headtail chain selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/chain
	whitelisted = SPECIES_SKRELL

/datum/gear/xeno/skrell_chains/New()
	..()
	var/list/chaintypes = list()
	for(var/chain_style in typesof(/obj/item/clothing/ears/skrell/chain))
		var/obj/item/clothing/ears/skrell/chain/chain = chain_style
		chaintypes[initial(chain.name)] = chain
	gear_tweaks += new/datum/gear_tweak/path(sortTim(chaintypes, /proc/cmp_text_asc, TRUE))

/datum/gear/xeno/skrell_bands
	display_name = "headtail band selection (Skrell)"
	path = /obj/item/clothing/ears/skrell/band
	whitelisted = SPECIES_SKRELL

/datum/gear/xeno/skrell_bands/New()
	..()
	var/list/bandtypes = list()
	for(var/band_style in typesof(/obj/item/clothing/ears/skrell/band))
		var/obj/item/clothing/ears/skrell/band/band = band_style
		bandtypes[initial(band.name)] = band
	gear_tweaks += new/datum/gear_tweak/path(sortTim(bandtypes, /proc/cmp_text_asc, TRUE))


/datum/gear/xeno/skrell_cloth_short
	display_name = "short headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_male/black
	whitelisted = SPECIES_SKRELL

/datum/gear/xeno/skrell_cloth_short/New()
	..()
	var/list/shorttypes = list()
	for(var/short_style in typesof(/obj/item/clothing/ears/skrell/cloth_male))
		var/obj/item/clothing/ears/skrell/cloth_male/short = short_style
		shorttypes[initial(short.name)] = short
	gear_tweaks += new/datum/gear_tweak/path(sortTim(shorttypes, /proc/cmp_text_asc, TRUE))


/datum/gear/xeno/skrell_cloth_long
	display_name = "long headtail cloth (Skrell)"
	path = /obj/item/clothing/ears/skrell/cloth_female/black
	whitelisted = SPECIES_SKRELL

/datum/gear/xeno/skrell_cloth_long/New()
	..()
	var/list/longtypes = list()
	for(var/long_style in typesof(/obj/item/clothing/ears/skrell/cloth_female))
		var/obj/item/clothing/ears/skrell/cloth_female/long = long_style
		longtypes[initial(long.name)] = long
	gear_tweaks += new/datum/gear_tweak/path(sortTim(longtypes, /proc/cmp_text_asc, TRUE))


/datum/gear/xeno/skrell_colored_band
	display_name = "Colored bands (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/band
	whitelisted = SPECIES_SKRELL

/datum/gear/xeno/skrell_colored_band/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)


/datum/gear/ears/skrell_colored_chain
	display_name = "Colored chain (Skrell)"
	path = /obj/item/clothing/ears/skrell/colored/chain
	whitelisted = SPECIES_SKRELL

/datum/gear/ears/skrell_colored_chain/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

//These should probably get a whitelisted species at some point
/datum/gear/xeno/ipc_monitor
	display_name = "display monitor (Full Body Prosthetic)"
	path = /obj/item/clothing/mask/monitor

/datum/gear/xeno/harness
	display_name = "gear harness (Full Body Prosthetic, Diona)"
	path = /obj/item/clothing/under/harness


//Uhhh... move to something outside Xenowear if it doesn't have a species restriction? No idea.
/datum/gear/xeno/loincloth
	display_name = "loincloth"
	path = /obj/item/clothing/suit/storage/fluff/loincloth

//Move to somewhere outside Xenowear if no species restriction, maybe.
/datum/gear/xeno/footwraps
	display_name = "cloth footwraps"
	path = /obj/item/clothing/shoes/footwraps

/datum/gear/xeno/footwraps/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

//This should probably be given the species whitelist tag.
/datum/gear/xeno/cohesionsuits
	display_name = "cohesion suit selection (Promethean)"
	path = /obj/item/clothing/under/cohesion
	sort_category = "Xenowear"

/datum/gear/xeno/cohesionsuits/New()
	..()
	var/list/cohesionsuits = list()
	for(var/cohesionsuit in (typesof(/obj/item/clothing/under/cohesion)))
		var/obj/item/clothing/under/cohesion/cohesion_type = cohesionsuit
		cohesionsuits[initial(cohesion_type.name)] = cohesion_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cohesionsuits, /proc/cmp_text_asc, TRUE))


//TESHARI
/datum/gear/xeno/smock
	display_name = "smock selection (Teshari)"
	path = /obj/item/clothing/under/teshari/smock
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/smock/New()
	..()
	var/list/smocks = list()
	for(var/smock in typesof(/obj/item/clothing/under/teshari/smock))
		var/obj/item/clothing/under/teshari/smock/smock_type = smock
		smocks[initial(smock_type.name)] = smock_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(smocks, /proc/cmp_text_asc, TRUE))


/datum/gear/xeno/dresssmock
	display_name = "department dress selection (Teshari)"
	path = /obj/item/clothing/under/teshari/dresssmock
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/dresssmock/New()
	..()
	var/list/dresssmocks = list()
	for(var/dresssmock in typesof(/obj/item/clothing/under/teshari/dresssmock))
		var/obj/item/clothing/under/teshari/dresssmock/dresssmock_type = dresssmock
		dresssmocks[initial(dresssmock_type.name)] = dresssmock_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(dresssmocks, /proc/cmp_text_asc, TRUE))


/datum/gear/xeno/cloak
	display_name = "cloak selection (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/cloak/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/teshari/cloak/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/standard/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cloaks, /proc/cmp_text_asc, TRUE))


/datum/gear/xeno/undercoat
	display_name = "undercoat selection (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/standard
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/xeno/undercoat/New()
	..()
	var/list/undercoats = list()
	for(var/undercoat in typesof(/obj/item/clothing/under/teshari/undercoat/standard))
		var/obj/item/clothing/under/teshari/undercoat/standard/undercoat_type = undercoat
		undercoats[initial(undercoat_type.name)] = undercoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(undercoats, /proc/cmp_text_asc, TRUE))

/datum/gear/xeno/dept //Lazily ripped from it's previous declaration because it needed a parent declaration.
	display_name = "facility director undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cap
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Facility Director")

/datum/gear/xeno/dept/undercoat //Lazily ripped from it's previous declaration because it needed a parent declaration.
	display_name = "head of personnel undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/hop
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Head of Personnel")

/datum/gear/xeno/dept/undercoat/rd
	display_name = "research director undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/rd
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Research Director")

/datum/gear/xeno/dept/undercoat/hos
	display_name = "head of security undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/hos
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Head of Security")

/datum/gear/xeno/dept/undercoat/ce
	display_name = "chief engineer undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/ce
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Engineer")

/datum/gear/xeno/dept/undercoat/cmo
	display_name = "chief medical officer undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cmo
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Medical Officer")

/datum/gear/xeno/dept/undercoat/qm
	display_name = "quartermaster undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/qm
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Quartermaster")

/datum/gear/xeno/dept/undercoat/cargo
	display_name = "cargo undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/cargo
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/xeno/dept/undercoat/mining
	display_name = "mining undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/mining
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Quartermaster","Shaft Miner")

/datum/gear/xeno/dept/undercoat/security
	display_name = "security undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/sec
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Head of Security","Detective","Warden","Security Officer",)

/datum/gear/xeno/dept/undercoat/service
	display_name = "service undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/service
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Head of Personnel","Bartender","Botanist","Janitor","Chef","Librarian","Chaplain")

/datum/gear/xeno/dept/undercoat/engineer
	display_name = "engineering undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/engineer
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/xeno/dept/undercoat/atmos
	display_name = "atmospherics undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/atmos
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/xeno/dept/undercoat/research
	display_name = "scientist undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/sci
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/xeno/dept/undercoat/robo
	display_name = "roboticist undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/robo
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/xeno/dept/undercoat/medical
	display_name = "medical undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/medical
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Geneticist")

/datum/gear/xeno/dept/undercoat/chemistry
	display_name = "chemist undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/chemistry
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Medical Officer","Chemist")

/datum/gear/xeno/dept/undercoat/virology
	display_name = "virologist undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/viro
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Medical Officer","Medical Doctor")

/datum/gear/xeno/dept/undercoat/psych
	display_name = "psychiatrist undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/psych
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Medical Officer","Psychiatrist")

/datum/gear/xeno/dept/undercoat/paramedic
	display_name = "paramedic undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/para
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Medical Officer","Paramedic")

/datum/gear/xeno/dept/undercoat/iaa
	display_name = "internal affairs undercoat (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/jobs/iaa
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/xeno/dept/cloak //Used as parent declaration.
	display_name = "facility director (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/cap
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Facility Director")

/datum/gear/xeno/dept/cloak/hop
	display_name = "head of personnel cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/hop
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Head of Personnel")

/datum/gear/xeno/dept/cloak/rd
	display_name = "research director cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/rd
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Research Director")

/datum/gear/xeno/dept/cloak/hos
	display_name = "head of security cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/hos
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Head of Security")

/datum/gear/xeno/cloak/dept/ce
	display_name = "chief engineer cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/ce
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Engineer")

/datum/gear/xeno/dept/cloak/cmo
	display_name = "chief medical officer cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/cmo
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Medical Officer")

/datum/gear/xeno/dept/cloak/qm
	display_name = "quartermaster cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/qm
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Quartermaster")

/datum/gear/xeno/dept/cloak/cargo
	display_name = "cargo cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/cargo
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Quartermaster","Shaft Miner" ,"Cargo Technician")

/datum/gear/xeno/dept/cloak/mining
	display_name = "mining cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/mining
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Quartermaster","Shaft Miner" ,"Cargo Technician")

/datum/gear/xeno/dept/cloak/security
	display_name = "security cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/sec
	allowed_roles = list("Head of Security","Detective","Warden","Security Officer",)

/datum/gear/xeno/dept/cloak/service
	display_name = "service cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/service
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Head of Personnel","Bartender","Botanist","Janitor","Chef","Librarian","Chaplain")

/datum/gear/xeno/dept/cloak/engineer
	display_name = "engineering cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/eningeer
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Engineer","Station Engineer")

/datum/gear/xeno/dept/cloak/atmos
	display_name = "atmospherics cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/atmos
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Engineer","Atmospheric Technician")

/datum/gear/xeno/dept/cloak/research
	display_name = "scientist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/sci
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Research Director","Scientist","Xenobiologist")

/datum/gear/xeno/dept/cloak/robo
	display_name = "roboticist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/robo
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Research Director","Roboticist")

/datum/gear/xeno/dept/cloak/medical
	display_name = "medical cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/medical
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Geneticist")

/datum/gear/xeno/dept/cloak/chemistry
	display_name = "chemist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/chemistry
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chemist")

/datum/gear/xeno/dept/cloak/virology
	display_name = "virologist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/viro
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Medical Doctor")

/datum/gear/xeno/dept/cloak/psych
	display_name = "psychiatrist cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/psych
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Medical Officer","Psychiatrist")

/datum/gear/xeno/dept/cloak/paramedic
	display_name = "paramedic cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/para
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Chief Medical Officer","Paramedic")

/datum/gear/xeno/dept/cloak/iaa
	display_name = "internal affairs cloak (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/jobs/iaa
	whitelisted = SPECIES_TESHARI
	allowed_roles = list("Internal Affairs Agent")

/datum/gear/xeno/aerogelgoggles
	display_name = "orange goggles (Teshari)"
	path = /obj/item/clothing/glasses/aerogelgoggles
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/smockcolor
	display_name = "smock, recolorable (Teshari)"
	path = /obj/item/clothing/under/teshari/smock/white
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/smockcolor/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)


/datum/gear/xeno/undercoatcolor
	display_name = "undercoat, recolorable (Teshari)"
	path = /obj/item/clothing/under/teshari/undercoat/standard/white_grey
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/undercoatcolor/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)


/datum/gear/xeno/cloakcolor
	display_name = "cloak, recolorable (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard/white_grey
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/cloakcolor/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)


/datum/gear/xeno/labcoat_tesh
	display_name = "labcoat, colorable (Teshari)"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/teshari
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/labcoat_tesh/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)


/datum/gear/xeno/teshcoat
	display_name = "small black coat, recolorable stripes (Teshari)"
	path = /obj/item/clothing/suit/storage/toggle/tesharicoat
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/teshcoat/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)


/datum/gear/xeno/teshcoatwhite
	display_name = "smallcoat, recolorable (Teshari)"
	path = /obj/item/clothing/suit/storage/toggle/tesharicoatwhite
	whitelisted = SPECIES_TESHARI
	sort_category = "Xenowear"

/datum/gear/xeno/teshcoatwhite/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)


/datum/gear/xeno/teshari_hood
	display_name = "hooded cloak selection (Teshari)"
	path = /obj/item/clothing/suit/storage/teshari/cloak/standard
	whitelisted = SPECIES_TESHARI

/datum/gear/xeno/teshari_hood/New()
	..()
	var/list/cloaks = list()
	for(var/cloak in typesof(/obj/item/clothing/suit/storage/hooded/teshari/standard))
		var/obj/item/clothing/suit/storage/teshari/cloak/cloak_type = cloak
		cloaks[initial(cloak_type.name)] = cloak_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(cloaks, /proc/cmp_text_asc, TRUE))



//VOX
/datum/gear/xeno/voxcivassistant
	display_name = "vox pressure suit (assistant)"
	path = /obj/item/clothing/under/pressuresuit/voxcivassistant
	whitelisted = SPECIES_VOX

/datum/gear/xeno/voxcivbartender
	display_name = "vox pressure suit (bartender)"
	path = /obj/item/clothing/under/pressuresuit/voxcivbartender
	whitelisted = SPECIES_VOX

/datum/gear/xeno/voxcivchef
	display_name = "vox pressure suit (chef)"
	path = /obj/item/clothing/under/pressuresuit/voxcivchef
	whitelisted = SPECIES_VOX

/datum/gear/xeno/voxcivchaplain
	display_name = "vox pressure suit (chaplain)"
	path = /obj/item/clothing/under/pressuresuit/voxcivchaplain
	whitelisted = SPECIES_VOX

/datum/gear/xeno/voxcivlibrarian
	display_name = "vox pressure suit (librarian)"
	path = /obj/item/clothing/under/pressuresuit/voxcivlibrarian
	whitelisted = SPECIES_VOX

/datum/gear/xeno/voxsecofficer
	display_name = "vox pressure suit (security officer)"
	path = /obj/item/clothing/under/pressuresuit/voxcivsecurity
	whitelisted = SPECIES_VOX

/datum/gear/xeno/voxcivmedical
	display_name = "vox pressure suit (medical doctor)"
	path = /obj/item/clothing/under/pressuresuit/voxcivmedical
	whitelisted = SPECIES_VOX

/datum/gear/xeno/voxcivengineer
	display_name = "vox pressure suit (engineer)"
	path = /obj/item/clothing/under/pressuresuit/voxcivengineer
	whitelisted = SPECIES_VOX

/datum/gear/xeno/voxcivscience
	display_name = "vox pressure suit (scientist)"
	path = /obj/item/clothing/under/pressuresuit/voxcivscience
	whitelisted = SPECIES_VOX

/datum/gear/xeno/voxcivrd
	display_name = "vox pressure suit (research director)"
	path = /obj/item/clothing/under/pressuresuit/voxcivrd
	whitelisted = SPECIES_VOX

/datum/gear/xeno/voxcivce
	display_name = "vox pressure suit (chief engineer)"
	path = /obj/item/clothing/under/pressuresuit/voxcivce
	whitelisted = SPECIES_VOX

/datum/gear/xeno/simonpants
	display_name = "simon pants (Vox)"
	path = /obj/item/clothing/under/vox/simonpants
	whitelisted = SPECIES_VOX

/datum/gear/xeno/simonjacket
	display_name = "simon jacket (Vox)"
	path = /obj/item/clothing/suit/simonjacket
	whitelisted = SPECIES_VOX

//Which standard is it?

/datum/gear/xeno/voxcasual
	display_name = "casual wear (Vox)"
	path = /obj/item/clothing/under/vox/vox_casual
	whitelisted = "Vox"

/datum/gear/xeno/voxrobes
	display_name = "comfy robes (Vox)"
	path = /obj/item/clothing/under/vox/vox_robes
	whitelisted = "Vox"

/datum/gear/xeno/vox_vest
	display_name = "storage vest (Vox)"
	path = /obj/item/clothing/accessory/storage/vox
	whitelisted = "Vox"

/datum/gear/xeno/vox_gloves
	display_name = "insulated gauntlets (Vox)"
	path = /obj/item/clothing/gloves/vox
	whitelisted = "Vox"

/datum/gear/xeno/vox_boots
	display_name = "magclaws (Vox)"
	path = /obj/item/clothing/shoes/magboots/vox
	whitelisted = "Vox"

/datum/gear/xeno/vox_mask
	display_name = "alien mask (Vox)"
	path = /obj/item/clothing/mask/gas/swat/vox
	whitelisted = "Vox"



// TAJARAN
/*                                                        WHY WHITELIST REMOVED??????????????????????????????????????????????*/
/datum/gear/eyes/tajblind
	display_name = "embroidered veil"
	path = /obj/item/clothing/glasses/tajblind
	//whitelisted = SPECIES_TAJ

/datum/gear/eyes/medical/tajblind
	display_name = "medical veil (Tajara) (Medical)"
	path = /obj/item/clothing/glasses/hud/health/tajblind
	//whitelisted = SPECIES_TAJ

/datum/gear/eyes/meson/tajblind
	display_name = "industrial veil (Tajara) (Engineering, Science)"
	path = /obj/item/clothing/glasses/meson/prescription/tajblind
	//whitelisted = SPECIES_TAJ

/datum/gear/eyes/material/tajblind
	display_name = "mining veil (Tajara) (Mining)"
	path = /obj/item/clothing/glasses/material/prescription/tajblind
	//whitelisted = SPECIES_TAJ

/datum/gear/eyes/security/tajblind
	display_name = "sleek veil (Tajara) (Security)"
	path = /obj/item/clothing/glasses/sunglasses/sechud/tajblind
	//whitelisted = SPECIES_TAJ

/datum/gear/xeno/zhan_furs
	display_name = "Zhan-Khazan furs (Tajaran)"
	path = /obj/item/clothing/suit/tajaran/furs
	whitelisted = SPECIES_TAJ

/datum/gear/xeno/zhan_scarf
	display_name = "Zhan headscarf"
	path = /obj/item/clothing/head/tajaran/scarf
	whitelisted = SPECIES_TAJ



//PLASMAMAN
/datum/gear/xeno/plas_cap_alt
	display_name = "alternate Facility Director helmet (phoronoid)"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/captain/alt
	whitelisted = SPECIES_PLASMAMAN
	allowed_roles = list("Facility Director")

/datum/gear/xeno/plas_hos_alt1
	display_name = "alternate head of security helmet 1 (phoronoid)"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/hos/alt1
	whitelisted = SPECIES_PLASMAMAN
	allowed_roles = list("Head of Security")

/datum/gear/xeno/plas_hos_alt2
	display_name = "alternate head of security helmet 2 (phoronoid)"
	path = /obj/item/clothing/head/helmet/space/plasman/sec/hos/alt2
	whitelisted = SPECIES_PLASMAMAN
	allowed_roles = list("Head of Security")

/datum/gear/xeno/plas_accessories
	display_name = "containment suit accessory selection (phoronoid)"
	path = /obj/item/clothing/accessory/plasman
	whitelisted = SPECIES_PLASMAMAN

/datum/gear/xeno/plas_accessories/New()
	..()
	var/list/plasaccessories = list()
	for(var/plasman in (typesof(/obj/item/clothing/accessory/plasman)))
		var/obj/item/clothing/accessory/plasman/plasaccessory_type = plasman
		plasaccessories[initial(plasaccessory_type.name)] = plasaccessory_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(plasaccessories, /proc/cmp_text_asc, TRUE))
