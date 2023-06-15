
/datum/gear/accessory
	name = "Blue Silk Tie"
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory
	sort_category = LOADOUT_CATEGORY_ACCESSORIES
	abstract_type = /datum/gear/accessory
	path = /obj/item/clothing/accessory
	cost = 1

/datum/gear/accessory/armband
	name = "Armband Selection"
	path = /obj/item/clothing/accessory/armband

/datum/gear/accessory/armband/New()
	..()
	var/list/armbands = list()
	for(var/armband in (typesof(/obj/item/clothing/accessory/armband) - typesof(/obj/item/clothing/accessory/armband/med/color)))
		var/obj/item/clothing/accessory/armband_type = armband
		armbands[initial(armband_type.name)] = armband_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(armbands, /proc/cmp_text_asc))

/datum/gear/accessory/armband/colored
	name = "Armband - Colorable"
	path = /obj/item/clothing/accessory/armband/med/color

/datum/gear/accessory/armband/colored/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/accessory/insignia
	name = "Insignia Selection"
	path = /obj/item/clothing/accessory/oricon/department

/datum/gear/accessory/insignia/New()
	..()
	var/insignia = list()
	insignia["Command - Crew"] = /obj/item/clothing/accessory/oricon/department/command/crew
	insignia["Command - Crew Short"] = /obj/item/clothing/accessory/oricon/department/command/service
	insignia["Command - Bands"] = /obj/item/clothing/accessory/oricon/department/command/fleet
	insignia["Command - Echelons"] = /obj/item/clothing/accessory/oricon/department/command/marine
	insignia["Blueshield - Crew"] = /obj/item/clothing/accessory/oricon/department/blueshield/crew
	insignia["Blueshield - Crew Short"] = /obj/item/clothing/accessory/oricon/department/blueshield/service
	insignia["Blueshield - Bands"] = /obj/item/clothing/accessory/oricon/department/blueshield/fleet
	insignia["Blueshield - Echelons"] = /obj/item/clothing/accessory/oricon/department/blueshield/marine
	insignia["Security - Crew"] = /obj/item/clothing/accessory/oricon/department/security/crew
	insignia["Security - Crew Short"] = /obj/item/clothing/accessory/oricon/department/security/service
	insignia["Security - Bands"] = /obj/item/clothing/accessory/oricon/department/security/fleet
	insignia["Security - Echelons"] = /obj/item/clothing/accessory/oricon/department/security/marine
	insignia["Medical - Crew"] = /obj/item/clothing/accessory/oricon/department/medical/crew
	insignia["Medical - Crew Short"] = /obj/item/clothing/accessory/oricon/department/medical/service
	insignia["Medical - Bands"] = /obj/item/clothing/accessory/oricon/department/medical/fleet
	insignia["Medical - Echelons"] = /obj/item/clothing/accessory/oricon/department/medical/marine
	insignia["Science - Crew"] = /obj/item/clothing/accessory/oricon/department/research/crew
	insignia["Science - Crew Short"] = /obj/item/clothing/accessory/oricon/department/research/service
	insignia["Science - Bands"] = /obj/item/clothing/accessory/oricon/department/research/fleet
	insignia["Science - Echelons"] = /obj/item/clothing/accessory/oricon/department/research/marine
	insignia["Engineering - Crew"] = /obj/item/clothing/accessory/oricon/department/engineering/crew
	insignia["Engineering - Crew Short"] = /obj/item/clothing/accessory/oricon/department/engineering/service
	insignia["Engineering - Bands"] = /obj/item/clothing/accessory/oricon/department/engineering/fleet
	insignia["Engineering - Echelons"] = /obj/item/clothing/accessory/oricon/department/engineering/marine
	insignia["Supply - Crew"] = /obj/item/clothing/accessory/oricon/department/supply/crew
	insignia["Supply - Crew Short"] = /obj/item/clothing/accessory/oricon/department/supply/service
	insignia["Supply - Bands"] = /obj/item/clothing/accessory/oricon/department/supply/fleet
	insignia["Supply - Echelons"] = /obj/item/clothing/accessory/oricon/department/supply/marine
	insignia["Service - Crew"] = /obj/item/clothing/accessory/oricon/department/service/crew
	insignia["Service - Crew Short"] = /obj/item/clothing/accessory/oricon/department/service/service
	insignia["Service - Bands"] = /obj/item/clothing/accessory/oricon/department/service/fleet
	insignia["Service - Echelons"] = /obj/item/clothing/accessory/oricon/department/service/marine
	gear_tweaks += new/datum/gear_tweak/path(insignia)

/datum/gear/accessory/insigniacolored
	name = "Insignia - Colorable"
	path = /obj/item/clothing/accessory/oricon/department/colorable

/datum/gear/accessory/insigniacolored/New()
	..()
	var/insignia = list()
	insignia["Colorable - Crew"] = /obj/item/clothing/accessory/oricon/department/colorable
	insignia["Colorable - Crew Short"] = /obj/item/clothing/accessory/oricon/department/colorable/service
	insignia["Colorable - Bands"] = /obj/item/clothing/accessory/oricon/department/colorable/fleet
	insignia["Colorable - Echelons"] = /obj/item/clothing/accessory/oricon/department/colorable/marine
	gear_tweaks += new/datum/gear_tweak/path(insignia)
	gear_tweaks += gear_tweak_free_color_choice


/datum/gear/accessory/wallet
	name = "Wallet - Orange"
	path = /obj/item/storage/wallet/random

/datum/gear/accessory/wallet_poly
	name = "Wallet - Colorable"
	path = /obj/item/storage/wallet/poly
	cost = 0


/datum/gear/accessory/wallet/womens
	name = "Wallet - Womens"
	path = /obj/item/storage/wallet/womens
	cost = 0

/datum/gear/accessory/wallet/womens/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/clutch
	name = "Clutch Bag"
	path = /obj/item/storage/briefcase/clutch
	cost = 2

/datum/gear/accessory/clutch/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/purse
	name = "Purse"
	path = /obj/item/storage/backpack/purse
	cost = 3

/datum/gear/accessory/purse/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/wcoat
	name = "Waistcoat - Selection"
	path = /obj/item/clothing/accessory/wcoat

/datum/gear/accessory/wcoat/New()
	..()
	var/list/wcoats = list()
	for(var/wcoat in typesof(/obj/item/clothing/accessory/wcoat))
		var/obj/item/clothing/accessory/wcoat_type = wcoat
		wcoats[initial(wcoat_type.name)] = wcoat_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(wcoats, /proc/cmp_text_asc))

/datum/gear/accessory/tie
	name = "Tie - Selection"
	path = /obj/item/clothing/accessory/tie

/datum/gear/accessory/tie/New()
	..()
	var/list/ties = list()
	for(var/tie in typesof(/obj/item/clothing/accessory/tie))
		var/obj/item/clothing/accessory/tie_type = tie
		ties[initial(tie_type.name)] = tie_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(ties, /proc/cmp_text_asc))

/datum/gear/accessory/scarf
	name = "Scarf - Selection"
	path = /obj/item/clothing/accessory/scarf

/datum/gear/accessory/scarf/New()
	..()
	var/list/scarfs = list()
	for(var/scarf in typesof(/obj/item/clothing/accessory/scarf))
		var/obj/item/clothing/accessory/scarf_type = scarf
		scarfs[initial(scarf_type.name)] = scarf_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(scarfs, /proc/cmp_text_asc))

/datum/gear/accessory/scarfcolor
	name = "Scarf Colorable"
	path = /obj/item/clothing/accessory/scarf/white

/datum/gear/accessory/scarfcolor/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/jacket
	name = "Suit Jacket Selection"
	path = /obj/item/clothing/accessory/jacket

/datum/gear/accessory/jacket/New()
	..()
	var/list/jackets = list()
	for(var/jacket in typesof(/obj/item/clothing/accessory/jacket))
		var/obj/item/clothing/accessory/jacket_type = jacket
		jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(jackets, /proc/cmp_text_asc))

/datum/gear/accessory/suitvest
	name = "Suit Vest"
	path = /obj/item/clothing/accessory/vest

/datum/gear/accessory/lifecrystal
	name = "Life Crystal"
	path = /obj/item/clothing/accessory/collar/lifecrystal
	description = "A smart medical necklace that pings an offsite recovery facility and acts as a beacon, should you die."

/datum/gear/accessory/brown_drop_pouches
	name = "Drop Pouches - Brown"
	path = /obj/item/clothing/accessory/storage/brown_drop_pouches
	cost = 2

/datum/gear/accessory/black_drop_pouches
	name = "Drop Pouches - Black"
	path = /obj/item/clothing/accessory/storage/black_drop_pouches
	cost = 2

/datum/gear/accessory/white_drop_pouches
	name = "Drop Pouches - White"
	path = /obj/item/clothing/accessory/storage/white_drop_pouches
	cost = 2

/datum/gear/accessory/holster_selection
	name = "Holster - Selection"
	path = /obj/item/clothing/accessory/holster

/datum/gear/accessory/holster_selection/New()
	..()
	var/holstertype = list()
	holstertype["Holster - Shoulder"] = /obj/item/clothing/accessory/holster
	holstertype["Holster - Armpit"] = /obj/item/clothing/accessory/holster/armpit
	holstertype["Holster - Waist"] = /obj/item/clothing/accessory/holster/waist
	holstertype["Holster - Hip"] = /obj/item/clothing/accessory/holster/hip
	holstertype["Holster - Leg"] = /obj/item/clothing/accessory/holster/leg
	holstertype["Holster - Machete"] = /obj/item/clothing/accessory/holster/machete
	gear_tweaks += new/datum/gear_tweak/path(holstertype)

/datum/gear/accessory/fannypack
	name = "Fannypack - Selection"
	cost = 2
	path = /obj/item/storage/belt/fannypack

/datum/gear/accessory/fannypack/New()
	..()
	var/list/fannys = list()
	for(var/fanny in typesof(/obj/item/storage/belt/fannypack))
		var/obj/item/storage/belt/fannypack/fanny_type = fanny
		fannys[initial(fanny_type.name)] = fanny_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(fannys, /proc/cmp_text_asc))

/datum/gear/accessory/chaps
	name = "Chaps - Brown"
	path = /obj/item/clothing/accessory/chaps

/datum/gear/accessory/chaps/black
	name = "Chaps - Black"
	path = /obj/item/clothing/accessory/chaps/black

/datum/gear/accessory/hawaii
	name = "Hawaii Shirt"
	path = /obj/item/clothing/accessory/hawaii

/datum/gear/accessory/hawaii/New()
	..()
	var/list/shirts = list()
	shirts["Blue Hawaii Shirt"] = /obj/item/clothing/accessory/hawaii
	shirts["Red hawaii Shirt"] = /obj/item/clothing/accessory/hawaii/red
	shirts["Random Colored Hawaii Shirt"] = /obj/item/clothing/accessory/hawaii/random
	gear_tweaks += new/datum/gear_tweak/path(shirts)


/datum/gear/accessory/sweater
	name = "Sweater - Selection"
	path = /obj/item/clothing/accessory/sweater

/datum/gear/accessory/sweater/New()
	..()
	var/list/sweaters = list()
	for(var/sweater in typesof(/obj/item/clothing/accessory/sweater))
		var/obj/item/clothing/suit/sweater_type = sweater
		sweaters[initial(sweater_type.name)] = sweater_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(sweaters, /proc/cmp_text_asc))

/datum/gear/accessory/bracelet/material
	name = "Bracelet - Selection"
	description = "Choose from a number of bracelets."
	path = /obj/item/clothing/accessory/bracelet

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
	name = "Friendship Bracelet"
	path = /obj/item/clothing/accessory/bracelet/friendship

/datum/gear/accessory/locket
	name = "Locket"
	path = /obj/item/clothing/accessory/locket

/datum/gear/accessory/necklace
	name = "Customizable Necklace"
	path = /obj/item/clothing/accessory/necklace
	description = "A necklace. You can rename it and change its description in-game."

/datum/gear/accessory/treatbox
	name = "Box of Treats"
	path = /obj/item/storage/box/treats
	cost = 2
/datum/gear/accessory/halfcape
	name = "Half Cape"
	path = /obj/item/clothing/accessory/halfcape

/datum/gear/accessory/fullcape
	name = "Full Cape"
	path = /obj/item/clothing/accessory/fullcape

/datum/gear/accessory/sash
	name = "Sash - Colorable"
	path = /obj/item/clothing/accessory/sash

/datum/gear/accessory/sash/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/asym
	name = "Asymmetric Jacket - Selection"
	path = /obj/item/clothing/accessory/asymmetric

/datum/gear/accessory/asym/New()
	..()
	var/list/asyms = list()
	for(var/asym in typesof(/obj/item/clothing/accessory/asymmetric))
		var/obj/item/clothing/accessory/asymmetric_type = asym
		asyms[initial(asymmetric_type.name)] = asymmetric_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(asyms, /proc/cmp_text_asc))

/datum/gear/accessory/cowledvest
	name = "Cowled Vest"
	path = /obj/item/clothing/accessory/cowledvest

/datum/gear/choker	// A colorable choker
	name = "Choker"
	path = /obj/item/clothing/accessory/choker
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory
	sort_category = LOADOUT_CATEGORY_ACCESSORIES

/datum/gear/choker/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/collar
	name = "Collar - Silver"
	path = /obj/item/clothing/accessory/collar/silver
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory
	sort_category = LOADOUT_CATEGORY_ACCESSORIES

/datum/gear/collar/New()
	..()
	gear_tweaks = list(gear_tweak_collar_tag)

/datum/gear/collar/golden
	name = "Collar - Golden"
	path = /obj/item/clothing/accessory/collar/gold

/datum/gear/collar/bell
	name = "Collar - Bell"
	path = /obj/item/clothing/accessory/collar/bell

/datum/gear/collar/shock
	name = "Collar - Shock"
	path = /obj/item/clothing/accessory/collar/shock

/datum/gear/collar/spike
	name = "Collar - Spike"
	path = /obj/item/clothing/accessory/collar/spike

/datum/gear/collar/pink
	name = "Collar - Pink"
	path = /obj/item/clothing/accessory/collar/pink

/datum/gear/collar/holo
	name = "Collar - Holo"
	path = /obj/item/clothing/accessory/collar/holo

/datum/gear/collar/cow
	name = "Collar - Cowbell"
	path = /obj/item/clothing/accessory/collar/cowbell

/datum/gear/collar/holo/indigestible
	name = "Collar - Holo - Indigestible"
	path = /obj/item/clothing/accessory/collar/holo/indigestible

/datum/gear/accessory/webbing

/datum/gear/accessory/vmcrystal
	name = "Life Crystal"
	path = /obj/item/storage/box/vmcrystal
	description = "A small necklace device that will notify an offsite cloning facility should you expire after activating it."

/datum/gear/accessory/metal_necklace
	name = "Metal Necklace"
	description = "A shiny steel chain with a vague metallic object dangling off it."
	path = /obj/item/clothing/accessory/metal_necklace

/datum/gear/accessory/pilotpin
	name = "Pilot - Qualification Pin"
	description = "An iron pin denoting the qualification to fly OCG voidcraft."
	path = /obj/item/clothing/accessory/oricon/specialty/pilot

/datum/gear/accessory/flops
	name = "Drop Straps"
	description = "Wearing suspenders over shoulders? That's been so out for centuries and you know better."
	path = /obj/item/clothing/accessory/flops

/datum/gear/accessory/flops/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/gaiter
	name = "Neck Gaiter - Selection"
	path = /obj/item/clothing/accessory/gaiter

/datum/gear/accessory/gaiter/New()
	..()
	var/list/gaiters = list()
	for(var/gaiter in typesof(/obj/item/clothing/accessory/gaiter))
		var/obj/item/clothing/accessory/gaiter_type = gaiter
		gaiters[initial(gaiter_type.name)] = gaiter_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(gaiters, /proc/cmp_text_asc))

/datum/gear/accessory/laconic
	name = "Laconic Field Pouch System"
	path = /obj/item/clothing/accessory/storage/laconic

/datum/gear/accessory/buttonup
	name = "Button Up Shirt"
	path = /obj/item/clothing/accessory/buttonup
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/accessory/buttonup/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/accessory/buttonup/untucked
	name = "Button Up Shirt - Untucked"
	path = /obj/item/clothing/accessory/buttonup/untucked
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory

/datum/gear/accessory/antediluvian
	name = "Antediluvian Loincloth"
	path = /obj/item/clothing/accessory/antediluvian

/datum/gear/accessory/antediluvian_gloves
	name = "Antediluvian Bracers"
	path = /obj/item/clothing/accessory/antediluvian_gloves

/datum/gear/accessory/mekkyaku
	name = "Mekkyaku Turtleneck"
	path = /obj/item/clothing/accessory/mekkyaku

/datum/gear/accessory/armsock
	name = "Fingerless Sleeves"
	path = /obj/item/clothing/accessory/armsocks

/datum/gear/accessory/armsock_left
	name = "Fingerless Sleeve (Left)"
	path = /obj/item/clothing/accessory/armsock_left

/datum/gear/accessory/armsock_right
	name = "Fingerless Sleeve (Right)"
	path = /obj/item/clothing/accessory/armsock_right

/datum/gear/accessory/disenchanted_talisman
	name = "Disenchanted Bone Talisman"
	path = /obj/item/clothing/accessory/disenchanted_talisman

/datum/gear/accessory/legwarmers
	name = "Thigh-Length Legwarmers"
	path = /obj/item/clothing/accessory/legwarmers

/datum/gear/accessory/legwarmersmedium
	name = "Legwarmers"
	path = /obj/item/clothing/accessory/legwarmersmedium

/datum/gear/accessory/legwarmersshort
	name = "Short Legwarmers"
	path = /obj/item/clothing/accessory/legwarmersshort

/datum/gear/accessory/halo_projector
	name = "Holographic Halo Projector"
	path = /obj/item/clothing/accessory/halo_projector

/datum/gear/accessory/halo_projector/New()
	..()
	var/list/halos = list()
	for(var/obj/item/clothing/accessory/halo_projector/halo as anything in typesof(/obj/item/clothing/accessory/halo_projector))
		halos[initial(halo.name)] = halo
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(halos, /proc/cmp_text_asc))

//Tajaran wears

/datum/gear/accessory/tajaran/scarf
	name = "Adhomian fur scarf"
	description = "A selection of tajaran colored fur scarfs."
	path = /obj/item/clothing/accessory/tajaran/scarf

/datum/gear/accessory/tajaran/scarf/New()
	..()
	var/list/tscarfs = list()
	for(var/tscarf in (typesof(/obj/item/clothing/accessory/tajaran/scarf)))
		var/obj/item/clothing/accessory/tajaran/scarf/tscarf_type = tscarf
		tscarfs[initial(tscarf_type.name)] = tscarf_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(tscarfs, /proc/cmp_text_asc))
