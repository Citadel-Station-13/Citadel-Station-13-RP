
/datum/gear/accessory
	display_name = "Blue Silk Tie"
	slot = slot_tie
	sort_category = "Accessories"
	type_category = /datum/gear/accessory
	path = /obj/item/clothing/accessory
	cost = 1

/datum/gear/accessory/armband
	display_name = "Armband Selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/list/armbands = list()
	for(var/armband in (typesof(/obj/item/clothing/accessory/armband) - typesof(/obj/item/clothing/accessory/armband/med/color)))
		var/obj/item/clothing/accessory/armband_type = armband
		armbands[initial(armband_type.name)] = armband_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(armbands, /proc/cmp_text_asc))

/datum/gear/accessory/armband/colored
	display_name = "Armband - Colorable"
	path = /obj/item/clothing/accessory/armband/med/color

/datum/gear/accessory/armband/colored/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/wallet
	display_name = "Wallet - Orange"
	path = /obj/item/storage/wallet/random

/datum/gear/accessory/wallet_poly
	display_name = "Wallet - Colorable"
	path = /obj/item/storage/wallet/poly
	cost = 0


/datum/gear/accessory/wallet/womens
	display_name = "Wallet - Womens"
	path = /obj/item/storage/wallet/womens
	cost = 0

/datum/gear/accessory/wallet/womens/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/clutch
	display_name = "Clutch Bag"
	path = /obj/item/storage/briefcase/clutch
	cost = 2

/datum/gear/accessory/clutch/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/purse
	display_name = "Purse"
	path = /obj/item/storage/backpack/purse
	cost = 3

/datum/gear/accessory/purse/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/wcoat
	display_name = "Waistcoat - Selection"
	path = /obj/item/clothing/accessory/wcoat
	cost = 1

/datum/gear/accessory/wcoat/New()
	..()
	var/list/wcoats = list()
	for(var/wcoat in typesof(/obj/item/clothing/accessory/wcoat))
		var/obj/item/clothing/accessory/wcoat_type = wcoat
		wcoats[initial(wcoat_type.name)] = wcoat_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(wcoats, /proc/cmp_text_asc))

/datum/gear/accessory/holster
	display_name = "Holster - Selection"
	path = /obj/item/clothing/accessory/holster
	allowed_roles = list("Facility Director","Head of Personnel","Security Officer","Warden","Head of Security","Detective","Field Medic","Explorer","Pathfinder")

/datum/gear/accessory/holster/New()
	..()
	var/list/holsters = list()
	for(var/holster in typesof(/obj/item/clothing/accessory/holster))
		var/obj/item/clothing/accessory/holster_type = holster
		holsters[initial(holster_type.name)] = holster_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(holsters, /proc/cmp_text_asc))

/datum/gear/accessory/tie
	display_name = "Tie - Selection"
	path = /obj/item/clothing/accessory/tie
	cost = 1

/datum/gear/accessory/tie/New()
	..()
	var/list/ties = list()
	for(var/tie in typesof(/obj/item/clothing/accessory/tie))
		var/obj/item/clothing/accessory/tie_type = tie
		ties[initial(tie_type.name)] = tie_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(ties, /proc/cmp_text_asc))

/datum/gear/accessory/scarf
	display_name = "Scarf - Selection"
	path = /obj/item/clothing/accessory/scarf
	cost = 1

/datum/gear/accessory/scarf/New()
	..()
	var/list/scarfs = list()
	for(var/scarf in typesof(/obj/item/clothing/accessory/scarf))
		var/obj/item/clothing/accessory/scarf_type = scarf
		scarfs[initial(scarf_type.name)] = scarf_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(scarfs, /proc/cmp_text_asc))

/datum/gear/accessory/scarfcolor
	display_name = "Scarf Colorable"
	path = /obj/item/clothing/accessory/scarf/white
	cost = 1

/datum/gear/accessory/scarfcolor/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/jacket
	display_name = "Suit Jacket Selection"
	path = /obj/item/clothing/accessory/jacket
	cost = 1

/datum/gear/accessory/jacket/New()
	..()
	var/list/jackets = list()
	for(var/jacket in typesof(/obj/item/clothing/accessory/jacket))
		var/obj/item/clothing/accessory/jacket_type = jacket
		jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(jackets, /proc/cmp_text_asc))

/datum/gear/accessory/suitvest
	display_name = "Suit Vest"
	path = /obj/item/clothing/accessory/vest

/datum/gear/accessory/lifecrystal
	display_name = "Life Crystal"
	path = /obj/item/clothing/accessory/collar/lifecrystal
	description = "A smart medical necklace that pings an offsite recovery facility and acts as a beacon, should you die."

/datum/gear/accessory/brown_vest
	display_name = "Webbing - Brown"
	path = /obj/item/clothing/accessory/storage/brown_vest

/datum/gear/accessory/black_vest
	display_name = "Webbing - Black"
	path = /obj/item/clothing/accessory/storage/black_vest

/datum/gear/accessory/white_vest
	display_name = "Webbing - White"
	path = /obj/item/clothing/accessory/storage/white_vest

/datum/gear/accessory/brown_drop_pouches
	display_name = "Drop Pouches - Brown"
	path = /obj/item/clothing/accessory/storage/brown_drop_pouches

/datum/gear/accessory/black_drop_pouches
	display_name = "Drop Pouches - Black"
	path = /obj/item/clothing/accessory/storage/black_drop_pouches

/datum/gear/accessory/white_drop_pouches
	display_name = "Drop Pouches - White"
	path = /obj/item/clothing/accessory/storage/white_drop_pouches

/datum/gear/accessory/fannypack
	display_name = "Fannypack - Selection"
	cost = 2
	path = /obj/item/storage/belt/fannypack

/datum/gear/accessory/fannypack/New()
	..()
	var/list/fannys = list()
	for(var/fanny in typesof(/obj/item/storage/belt/fannypack))
		var/obj/item/storage/belt/fannypack/fanny_type = fanny
		fannys[initial(fanny_type.name)] = fanny_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(fannys, /proc/cmp_text_asc))

/datum/gear/accessory/webbing
	display_name = "Webbing - Simple"
	path = /obj/item/clothing/accessory/storage/webbing
	cost = 2

/datum/gear/accessory/chaps
	display_name = "Chaps - Brown"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/black
	display_name = "Chaps - Black"
	path = /obj/item/clothing/accessory/chaps/black

/datum/gear/accessory/hawaii
	display_name = "Hawaii Shirt"
	path = /obj/item/clothing/accessory/hawaii

/datum/gear/accessory/hawaii/New()
	..()
	var/list/shirts = list()
	shirts["Blue Hawaii Shirt"] = /obj/item/clothing/accessory/hawaii
	shirts["Red hawaii Shirt"] = /obj/item/clothing/accessory/hawaii/red
	shirts["Random Colored Hawaii Shirt"] = /obj/item/clothing/accessory/hawaii/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)


/datum/gear/accessory/sweater
	display_name = "Sweater - Selection"
	path = /obj/item/clothing/accessory/sweater

/datum/gear/accessory/sweater/New()
	..()
	var/list/sweaters = list()
	for(var/sweater in typesof(/obj/item/clothing/accessory/sweater))
		var/obj/item/clothing/suit/sweater_type = sweater
		sweaters[initial(sweater_type.name)] = sweater_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(sweaters, /proc/cmp_text_asc))

/datum/gear/accessory/bracelet/material
	display_name = "Bracelet - Selection"
	description = "Choose from a number of bracelets."
	path = /obj/item/clothing/accessory/bracelet
	cost = 1

/datum/gear/accessory/bracelet/material/New()
	..()
	var/bracelettype = list()
	bracelettype["Bracelet - Steel"] = /obj/item/clothing/accessory/bracelet/material/steel
	bracelettype["Bracelet - Iron"] = /obj/item/clothing/accessory/bracelet/material/iron
	bracelettype["Bracelet - Silver"] = /obj/item/clothing/accessory/bracelet/material/silver
	bracelettype["Bracelet - Gold"] = /obj/item/clothing/accessory/bracelet/material/gold
	bracelettype["Bracelet - Platinum"] = /obj/item/clothing/accessory/bracelet/material/platinum
	bracelettype["Bracelet - Glass"] = /obj/item/clothing/accessory/bracelet/material/glass
	bracelettype["Bracelet - Wood"] = /obj/item/clothing/accessory/bracelet/material/wood
	bracelettype["Bracelet - Plastic"] = /obj/item/clothing/accessory/bracelet/material/plastic
	gear_tweaks += new/datum/gear_tweak/path(bracelettype)

/datum/gear/accessory/bracelet/friendship
	display_name = "Friendship Bracelet"
	path = /obj/item/clothing/accessory/bracelet/friendship

/datum/gear/accessory/stethoscope
	display_name = "Medical - Stethoscope"
	path = /obj/item/clothing/accessory/stethoscope
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic", "Field Medic")

/datum/gear/accessory/locket
	display_name = "Locket"
	path = /obj/item/clothing/accessory/locket

/datum/gear/accessory/necklace
	display_name = "Customizable Necklace"
	path = /obj/item/clothing/accessory/necklace
	description = "A necklace. You can rename it and change its description in-game."

/datum/gear/accessory/treatbox
	display_name = "Box of Treats"
	path = /obj/item/storage/box/treats
	cost = 2
/datum/gear/accessory/halfcape
	display_name = "Half Cape"
	path = /obj/item/clothing/accessory/halfcape

/datum/gear/accessory/fullcape
	display_name = "Full Cape"
	path = /obj/item/clothing/accessory/fullcape

/datum/gear/accessory/sash
	display_name = "Sash - Colorable"
	path = /obj/item/clothing/accessory/sash

/datum/gear/accessory/sash/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/accessory/asym
	display_name = "Asymmetric Jacket - Selection"
	path = /obj/item/clothing/accessory/asymmetric
	cost = 1

/datum/gear/accessory/asym/New()
	..()
	var/list/asyms = list()
	for(var/asym in typesof(/obj/item/clothing/accessory/asymmetric))
		var/obj/item/clothing/accessory/asymmetric_type = asym
		asyms[initial(asymmetric_type.name)] = asymmetric_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(asyms, /proc/cmp_text_asc))

/datum/gear/accessory/cowledvest
	display_name = "Cowled Vest"
	path = /obj/item/clothing/accessory/cowledvest

/datum/gear/choker	// A colorable choker
	display_name = "Choker - Colorable & Tagless"
	path = /obj/item/clothing/accessory/choker
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/choker/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/collar
	display_name = "Collar - Silver"
	path = /obj/item/clothing/accessory/collar/silver
	slot = slot_tie
	sort_category = "Accessories"

/datum/gear/collar/New()
	..()
	gear_tweaks = list(gear_tweak_collar_tag)

/datum/gear/collar/golden
	display_name = "Collar - Golden"
	path = /obj/item/clothing/accessory/collar/gold

/datum/gear/collar/bell
	display_name = "Collar - Bell"
	path = /obj/item/clothing/accessory/collar/bell

/datum/gear/collar/shock
	display_name = "Collar - Shock"
	path = /obj/item/clothing/accessory/collar/shock

/datum/gear/collar/spike
	display_name = "Collar - Spike"
	path = /obj/item/clothing/accessory/collar/spike

/datum/gear/collar/pink
	display_name = "Collar - Pink"
	path = /obj/item/clothing/accessory/collar/pink

/datum/gear/collar/holo
	display_name = "Collar - Holo"
	path = /obj/item/clothing/accessory/collar/holo

/datum/gear/collar/cow
	display_name = "Collar - Cowbell"
	path = /obj/item/clothing/accessory/collar/cowbell

/datum/gear/collar/holo/indigestible
	display_name = "Collar - Holo - Indigestible"
	path = /obj/item/clothing/accessory/collar/holo/indigestible

/datum/gear/accessory/webbing
	cost = 1

/datum/gear/accessory/stethoscope
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Psychiatrist","Paramedic", "Field Medic")

/datum/gear/accessory/vmcrystal
	display_name = "Life Crystal"
	path = /obj/item/storage/box/vmcrystal
	description = "A small necklace device that will notify an offsite cloning facility should you expire after activating it."

/datum/gear/accessory/tronket
	display_name = "Metal Necklace"
	description = "A shiny steel chain with a vague metallic object dangling off it."
	path = /obj/item/clothing/accessory/tronket

/datum/gear/accessory/pilotpin
	display_name = "Pilot - Qualification Pin"
	description = "An iron pin denoting the qualification to fly SCG spacecraft."
	path = /obj/item/clothing/accessory/solgov/specialty/pilot
	allowed_roles = list("Pathfinder", "Pilot", "Field Medic")

/datum/gear/accessory/flops
	display_name = "Drop Straps"
	description = "Wearing suspenders over shoulders? That's been so out for centuries and you know better."
	path = /obj/item/clothing/accessory/flops

/datum/gear/accessory/flops/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)
