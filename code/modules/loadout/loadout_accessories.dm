
/datum/loadout_entry/accessory
	slot = /datum/inventory_slot/abstract/attach_as_accessory
	category = LOADOUT_CATEGORY_ACCESSORIES
	abstract_type = /datum/loadout_entry/accessory
	path = /obj/item/clothing/accessory
	cost = 1

/datum/loadout_entry/accessory/wallet
	name = "Wallet - Orange"
	path = /obj/item/storage/wallet/random

/datum/loadout_entry/accessory/wallet_poly
	name = "Wallet - Colorable"
	path = /obj/item/storage/wallet/poly
	cost = 0


/datum/loadout_entry/accessory/wallet/womens
	name = "Wallet - Womens"
	path = /obj/item/storage/wallet/womens
	cost = 0

/datum/loadout_entry/accessory/clutch
	name = "Clutch Bag"
	path = /obj/item/storage/briefcase/clutch
	cost = 2

/datum/loadout_entry/accessory/purse
	name = "Purse"
	path = /obj/item/storage/backpack/purse
	cost = 3

/datum/loadout_entry/accessory/wcoat
	name = "Waistcoat - Selection"
	path = /obj/item/clothing/accessory/wcoat

/datum/loadout_entry/accessory/wcoat/New()
	..()
	var/list/wcoats = list()
	for(var/wcoat in typesof(/obj/item/clothing/accessory/wcoat))
		var/obj/item/clothing/accessory/wcoat_type = wcoat
		wcoats[initial(wcoat_type.name)] = wcoat_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(wcoats, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/accessory/tie
	name = "Tie - Selection"
	path = /obj/item/clothing/accessory/tie

/datum/loadout_entry/accessory/tie/New()
	..()
	var/list/ties = list()
	for(var/tie in typesof(/obj/item/clothing/accessory/tie))
		var/obj/item/clothing/accessory/tie_type = tie
		ties[initial(tie_type.name)] = tie_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(ties, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/accessory/scarf
	name = "Scarf - Selection"
	path = /obj/item/clothing/accessory/scarf

/datum/loadout_entry/accessory/scarf/New()
	..()
	var/list/scarfs = list()
	for(var/scarf in typesof(/obj/item/clothing/accessory/scarf))
		var/obj/item/clothing/accessory/scarf_type = scarf
		scarfs[initial(scarf_type.name)] = scarf_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(scarfs, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/accessory/scarfcolor
	name = "Scarf Colorable"
	path = /obj/item/clothing/accessory/scarf/white

/datum/loadout_entry/accessory/jacket
	name = "Suit Jacket Selection"
	path = /obj/item/clothing/accessory/jacket

/datum/loadout_entry/accessory/jacket/New()
	..()
	var/list/jackets = list()
	for(var/jacket in typesof(/obj/item/clothing/accessory/jacket))
		var/obj/item/clothing/accessory/jacket_type = jacket
		jackets[initial(jacket_type.name)] = jacket_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(jackets, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/accessory/suitvest
	name = "Suit Vest"
	path = /obj/item/clothing/accessory/vest

/datum/loadout_entry/accessory/lifecrystal
	name = "Life Crystal"
	path = /obj/item/clothing/accessory/collar/lifecrystal
	description = "A smart medical necklace that pings an offsite recovery facility and acts as a beacon, should you die."

/datum/loadout_entry/accessory/fannypack
	name = "Fannypack - Selection"
	cost = 2
	path = /obj/item/storage/belt/fannypack

/datum/loadout_entry/accessory/fannypack/New()
	..()
	var/list/fannys = list()
	for(var/fanny in typesof(/obj/item/storage/belt/fannypack))
		var/obj/item/storage/belt/fannypack/fanny_type = fanny
		fannys[initial(fanny_type.name)] = fanny_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(fannys, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/accessory/chaps
	name = "Chaps - Brown"
	path = /obj/item/clothing/accessory/chaps

/datum/loadout_entry/accessory/chaps/black
	name = "Chaps - Black"
	path = /obj/item/clothing/accessory/chaps/black

/datum/loadout_entry/accessory/chaps/unchaps
	name = "Unchaps - Black"
	path = /obj/item/clothing/accessory/chaps/unchaps

/datum/loadout_entry/accessory/hawaii
	name = "Hawaii Shirt"
	path = /obj/item/clothing/accessory/hawaii

/datum/loadout_entry/accessory/hawaii/New()
	..()
	var/list/shirts = list()
	shirts["Blue Hawaii Shirt"] = /obj/item/clothing/accessory/hawaii
	shirts["Red hawaii Shirt"] = /obj/item/clothing/accessory/hawaii/red
	shirts["Random Colored Hawaii Shirt"] = /obj/item/clothing/accessory/hawaii/random
	tweaks += new/datum/loadout_tweak/path(shirts)


/datum/loadout_entry/accessory/sweater
	name = "Sweater - Selection"
	path = /obj/item/clothing/accessory/sweater

/datum/loadout_entry/accessory/sweater/New()
	..()
	var/list/sweaters = list()
	for(var/sweater in typesof(/obj/item/clothing/accessory/sweater))
		var/obj/item/clothing/suit/sweater_type = sweater
		sweaters[initial(sweater_type.name)] = sweater_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(sweaters, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/accessory/bracelet
	abstract_type = /datum/loadout_entry/accessory/bracelet

/datum/loadout_entry/accessory/bracelet/material
	name = "Bracelet - Selection"
	description = "Choose from a number of bracelets."
	path = /obj/item/clothing/accessory/bracelet

/datum/loadout_entry/accessory/bracelet/material/New()
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
	tweaks += new/datum/loadout_tweak/path(bracelettype)

/datum/loadout_entry/accessory/bracelet/friendship
	name = "Friendship Bracelet"
	path = /obj/item/clothing/accessory/bracelet/friendship

/datum/loadout_entry/accessory/locket
	name = "Locket"
	path = /obj/item/clothing/accessory/locket

/datum/loadout_entry/accessory/necklace
	name = "Customizable Necklace"
	path = /obj/item/clothing/accessory/necklace
	description = "A necklace. You can rename it and change its description in-game."

/datum/loadout_entry/accessory/treatbox
	name = "Box of Treats"
	path = /obj/item/storage/box/treats
	cost = 2

/datum/loadout_entry/accessory/asym
	name = "Asymmetric Jacket - Selection"
	path = /obj/item/clothing/accessory/asymmetric

/datum/loadout_entry/accessory/asym/New()
	..()
	var/list/asyms = list()
	for(var/asym in typesof(/obj/item/clothing/accessory/asymmetric))
		var/obj/item/clothing/accessory/asymmetric_type = asym
		asyms[initial(asymmetric_type.name)] = asymmetric_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(asyms, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/accessory/cowledvest
	name = "Cowled Vest"
	path = /obj/item/clothing/accessory/cowledvest

/datum/loadout_entry/accessory/vmcrystal
	name = "Life Crystal"
	path = /obj/item/storage/box/vmcrystal
	description = "A small necklace device that will notify an offsite cloning facility should you expire after activating it."

/datum/loadout_entry/accessory/metal_necklace
	name = "Metal Necklace"
	description = "A shiny steel chain with a vague metallic object dangling off it."
	path = /obj/item/clothing/accessory/metal_necklace

/datum/loadout_entry/accessory/pilotpin
	name = "Pilot - Qualification Pin"
	description = "An iron pin denoting the qualification to fly OCG voidcraft."
	path = /obj/item/clothing/accessory/oricon/specialty/pilot

/datum/loadout_entry/accessory/flops
	name = "Drop Straps"
	description = "Wearing suspenders over shoulders? That's been so out for centuries and you know better."
	path = /obj/item/clothing/accessory/flops

/datum/loadout_entry/accessory/gaiter
	name = "Neck Gaiter - Selection"
	path = /obj/item/clothing/accessory/gaiter

/datum/loadout_entry/accessory/gaiter/New()
	..()
	var/list/gaiters = list()
	for(var/gaiter in typesof(/obj/item/clothing/accessory/gaiter))
		var/obj/item/clothing/accessory/gaiter_type = gaiter
		gaiters[initial(gaiter_type.name)] = gaiter_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(gaiters, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/accessory/laconic
	name = "Laconic Field Pouch System"
	path = /obj/item/clothing/accessory/storage/laconic

/datum/loadout_entry/accessory/buttonup
	name = "Button Up Shirt"
	path = /obj/item/clothing/accessory/buttonup
	slot = /datum/inventory_slot/abstract/attach_as_accessory

/datum/loadout_entry/accessory/buttonup/untucked
	name = "Button Up Shirt - Untucked"
	path = /obj/item/clothing/accessory/buttonup/untucked
	slot = /datum/inventory_slot/abstract/attach_as_accessory

/datum/loadout_entry/accessory/antediluvian
	name = "Antediluvian Loincloth"
	path = /obj/item/clothing/accessory/antediluvian

/datum/loadout_entry/accessory/antediluvian_gloves
	name = "Antediluvian Bracers"
	path = /obj/item/clothing/accessory/antediluvian_gloves

/datum/loadout_entry/accessory/mekkyaku
	name = "Mekkyaku Turtleneck"
	path = /obj/item/clothing/accessory/mekkyaku

/datum/loadout_entry/accessory/armsock
	name = "Fingerless Sleeves"
	path = /obj/item/clothing/accessory/armsocks

/datum/loadout_entry/accessory/armsock_left
	name = "Fingerless Sleeve (Left)"
	path = /obj/item/clothing/accessory/armsock_left

/datum/loadout_entry/accessory/armsock_right
	name = "Fingerless Sleeve (Right)"
	path = /obj/item/clothing/accessory/armsock_right

/datum/loadout_entry/accessory/disenchanted_talisman
	name = "Disenchanted Bone Talisman"
	path = /obj/item/clothing/accessory/disenchanted_talisman

/datum/loadout_entry/accessory/legwarmers
	name = "Thigh-Length Legwarmers"
	path = /obj/item/clothing/accessory/legwarmers

/datum/loadout_entry/accessory/legwarmersmedium
	name = "Legwarmers"
	path = /obj/item/clothing/accessory/legwarmersmedium

/datum/loadout_entry/accessory/legwarmersshort
	name = "Short Legwarmers"
	path = /obj/item/clothing/accessory/legwarmersshort

/datum/loadout_entry/accessory/sleekjacket
	name = "Sleek Uniform Jacket"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom/gestaltjacket

/datum/loadout_entry/accessory/sleekpatch
	name = "Sleek Uniform Patch"
	path = /obj/item/clothing/accessory/sleekpatch

/datum/loadout_entry/accessory/halo_projector
	name = "Holographic Halo Projector"
	path = /obj/item/clothing/accessory/halo_projector

/datum/loadout_entry/accessory/halo_projector/New()
	..()
	var/list/halos = list()
	for(var/obj/item/clothing/accessory/halo_projector/halo as anything in typesof(/obj/item/clothing/accessory/halo_projector))
		halos[initial(halo.name)] = halo
	tweaks += new/datum/loadout_tweak/path(tim_sort(halos, GLOBAL_PROC_REF(cmp_text_asc)))

//Tajaran wears

/datum/loadout_entry/accessory/tajaran
	abstract_type = /datum/loadout_entry/accessory/tajaran

/datum/loadout_entry/accessory/tajaran/scarf
	name = "Adhomian fur scarf"
	description = "A selection of tajaran colored fur scarfs."
	path = /obj/item/clothing/accessory/tajaran/scarf

/datum/loadout_entry/accessory/tajaran/scarf/New()
	..()
	var/list/tscarfs = list()
	for(var/tscarf in (typesof(/obj/item/clothing/accessory/tajaran/scarf)))
		var/obj/item/clothing/accessory/tajaran/scarf/tscarf_type = tscarf
		tscarfs[initial(tscarf_type.name)] = tscarf_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(tscarfs, GLOBAL_PROC_REF(cmp_text_asc)))

/datum/loadout_entry/accessory/civ_exos_mob
	name = "medical exoframe"
	description = "A cheap medical exoframe mass-produced by Nanotrasen and provided to employees who cannot function in gravity without assistance. (This is cosmetic, and does not actually do anything.)"
	path = /obj/item/clothing/accessory/civ_exos_mob

/datum/loadout_entry/accessory/ante_armband
	name = "antediluvian armband"
	description = "A small, fake blue gem placed neatly into an otherwise cloth armband with thin metal outlines."
	path = /obj/item/clothing/accessory/ante_armband

/datum/loadout_entry/accessory/beachwear
	name = "modern draped beachwear selection"
	path = /obj/item/clothing/accessory/draped_beachwear

/datum/loadout_entry/accessory/beachwear/New()
	..()
	var/list/wearables = list()
	for(var/wear in typesof(/obj/item/clothing/accessory/draped_beachwear))
		var/obj/item/clothing/accessory/wear_type = wear
		var/wear_string = (initial(wear_type.name) + "(" + initial(wear_type.icon_state) + ")")
		wearables[wear_string] = wear_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(wearables, GLOBAL_PROC_REF(cmp_text_asc)))


