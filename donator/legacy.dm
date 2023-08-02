/datum/loadout_entry/donator
	category = LOADOUT_CATEGORY_DONATOR
	cost = 0 // If they went out of their way to PAY for a custom item, given our no-gameplay-advantage-granting-items rule, it's only right that they aren't penalized and need to re-adjust their loadout to compensate for their new item's cost.
	name = "If this item can be chosen or seen, ping a coder immediately!"
	path = /obj/item/bikehorn
	ckeywhitelist = list("This entry should never be choosable with this variable set.") //If it does, then that means somebody fucked up the whitelist system pretty hard

/*
/datum/loadout_entry/donator/testhorn
	name = "Airhorn - Example Item"
	path = /obj/item/bikehorn
	ckeywhitelist = list("realdonaldtrump")
*/

/datum/loadout_entry/donator/gladiator
	name = "Gladiator Armor"
	slot = SLOT_ID_SUIT
	path = /obj/item/clothing/under/gladiator
	ckeywhitelist = list("aroche")

/datum/loadout_entry/donator/stool
	name = "Faiza's Stool"
	slot = SLOT_ID_SUIT
	path = /obj/item/melee/stool/faiza
	ckeywhitelist = list("crystal9156")

/datum/loadout_entry/donator/chayse
	name = "NTSC Naval Uniform"
	slot = SLOT_ID_UNIFORM
	path = /obj/item/clothing/under/donator/chayse
	ckeywhitelist = list("realdonaldtrump", "aaronskywalker")

/datum/loadout_entry/donator/labredblack
	name = "Black and Red Coat"
	slot = SLOT_ID_SUIT
	path = /obj/item/clothing/suit/storage/toggle/labcoat/donator/labredblack
	ckeywhitelist = list("blakeryan", "durandalphor")

/datum/loadout_entry/donator/carrotsatchel
	name = "Carrot Satchel"
	slot = SLOT_ID_BACK
	path = /obj/item/storage/backpack/satchel/donator/carrot
	ckeywhitelist = list("improvedname")

/datum/loadout_entry/donator/stripedcollar
	name = "Striped collar"
	slot = /datum/inventory_slot_meta/abstract/attach_as_accessory
	path = /obj/item/clothing/accessory/collar/donator/striped
	ckeywhitelist = list("jademanique")

/datum/loadout_entry/donator/cameronbackpack
	name = "Brig Physician's Backpack"
	slot = SLOT_ID_BACK
	path = /obj/item/storage/backpack/satchel/donator/cameron
	ckeywhitelist = list("cameronlancaster")

/datum/loadout_entry/donator/cameronarmor
	name = "Brig Physician's Armor Vest"
	slot = SLOT_ID_SUIT
	path = /obj/item/clothing/suit/armor/vest/donator/cameron
	ckeywhitelist = list("cameronlancaster")

/datum/loadout_entry/donator/crown
	name = "Crown"
	slot = SLOT_ID_HEAD
	path = /obj/item/clothing/accessory/collar/donator/crown
	ckeywhitelist = list("grayrachnid")

/datum/loadout_entry/donator/beesuit
	name = "Bee Suit"
	slot = SLOT_ID_HEAD
	path = /obj/item/clothing/suit/storage/hooded/donator/bee_costume
	ckeywhitelist = list("beeskee")

/datum/loadout_entry/donator/rarehat
	name = "Ultra Rare Hat"
	slot = SLOT_ID_HEAD
	path = /obj/item/clothing/head/collectable/petehat
	ckeywhitelist = list("risingstarslash")

/datum/loadout_entry/donator/holotags
	name = "USDF Holotags"
	description = "United Sol Defense Force issued ID, Belonging to Nikolai Volkov, DOB 12/12/2537, Blood Type O+"
	path = /obj/item/clothing/accessory/collar/donator/holotags
	ckeywhitelist = list("certifiedhyena")

/datum/loadout_entry/donator/silverhelmet
	name = "Silver's Helmet"
	slot = SLOT_ID_HEAD
	path = /obj/item/reskin_kit/jenna
	ckeywhitelist = list("jennasilver")

/datum/loadout_entry/donator/izzyball
	name = "Katlin's Ball"
	path = /obj/item/toy/tennis/rainbow/izzy
	ckeywhitelist = list("izzyinbox")


/datum/loadout_entry/donator/pduni
	name = "Olympius PD Service Uniform"
	path = /obj/item/clothing/under/donator/opd
	ckeywhitelist = list("hungrycricket")

/datum/loadout_entry/donator/mewchild
	name = "Bone Signet Ring"
	path = /obj/item/clothing/gloves/ring/seal/signet/fluff/vietsi
	ckeywhitelist = list("mewchild")

/datum/loadout_entry/donator/stunsword
	name = "Stunsword kit"
	path = /obj/item/reskin_kit/stunsword
	ckeywhitelist = list("phillip458")

/datum/loadout_entry/donator/redlensmask
	name = "Red-Lensed Gas Mask"
	path = /obj/item/clothing/mask/red_mask
	ckeywhitelist = list("figneugen")

/datum/loadout_entry/donator/blackredgold
	name = "Black, Red, and Gold Coat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/donator/blackredgold
	ckeywhitelist = list("ttbnc")

/datum/loadout_entry/donator/hoodedlcoak
	name = "Project: Zul-E"
	path = /obj/item/clothing/suit/storage/hooded/donator/hooded_cloak
	ckeywhitelist = list("asky")

/datum/loadout_entry/donator/pinklatex
	name = "Pink Latex"
	path = /obj/item/clothing/under/donator/pinksuit
	ckeywhitelist = list("tippler")

/datum/loadout_entry/donator/peltcloak
	name = "Pelt Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/peltcloak
	ckeywhitelist = list("irkallaepsilon")

/datum/loadout_entry/donator/doubleglasses
	name = "Double Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses/double
	ckeywhitelist = list("jglitch")

/datum/loadout_entry/donator/huni
	name = "KHI Uniform"
	path = /obj/item/clothing/under/donator/huni
	ckeywhitelist = list("certifiedhyena")

/datum/loadout_entry/donator/hberet
	name = "USDF Beret"
	path = /obj/item/clothing/head/donator/hberet
	ckeywhitelist = list("certifiedhyena")

/datum/loadout_entry/donator/jacksonb
	name = "Granite Gear Aid Bag"
	path = /obj/item/storage/backpack/satchel/donator/jacksonbackpack
	ckeywhitelist = list("vfivesix")

/datum/loadout_entry/donator/carcharodon
	name = "Carcharodon Suit"
	path = /obj/item/clothing/under/carcharodon
	ckeywhitelist = list("desucake")

/datum/loadout_entry/donator/mantleofheaven
	name = "Mantle of the Heavens"
	path = /obj/item/clothing/under/mantleofheaven
	ckeywhitelist = list("hjorthorn")

/datum/loadout_entry/donator/kepytw
	name = "Teshari Hatchling Care Kit"
	path = /obj/item/toy/kepytw
	ckeywhitelist = list("kepytw")

/datum/loadout_entry/donator/chaoterobe
	name = "Chaote Robe"
	path = /obj/item/clothing/suit/storage/hooded/techpriest/chaos
	ckeywhitelist = list("loburd")

/datum/loadout_entry/donator/veterancargoarmband
	name = "Veteran's Cargo Armband"
	path = /obj/item/clothing/accessory/armband/veterancargo
	ckeywhitelist = list("yourdoom9898")

/datum/loadout_entry/donator/customcamcorder
	name = "Prop Video Recorder"
	path = /obj/item/faketvcamera
	ckeywhitelist = list("fauxmagician")

/datum/loadout_entry/donator/mikubikini
	name = "starlight singer bikini"
	path = /obj/item/clothing/under/donator/mikubikini
	ckeywhitelist = list("grandvegeta")

/datum/loadout_entry/donator/mikujacket
	name = "starlight singer jacket"
	path = /obj/item/clothing/suit/donator/mikujacket
	ckeywhitelist = list("grandvegeta")

/datum/loadout_entry/donator/mikuhair
	name = "starlight singer hair"
	path = /obj/item/clothing/head/donator/mikuhair
	ckeywhitelist = list("grandvegeta")

/datum/loadout_entry/donator/mikugloves
	name = "starlight singer gloves"
	path = /obj/item/clothing/gloves/donator/mikugloves
	ckeywhitelist = list("grandvegeta")

/datum/loadout_entry/donator/mikuleggings
	name = "starlight singer leggings"
	path = /obj/item/clothing/shoes/donator/mikuleggings
	ckeywhitelist = list("grandvegeta")

/datum/loadout_entry/donator/iaccmask
	name = "orchid's mask"
	path = /obj/item/clothing/mask/gas/orchid
	ckeywhitelist = list("iamcrystalclear")

/datum/loadout_entry/donator/vicase
	name = "VI's secure briefcase"
	path = /obj/item/storage/secure/briefcase/vicase
	ckeywhitelist = list("capesh")

/datum/loadout_entry/donator/aura
	name = "KNIGHT-brand Melodic headset"
	path = /obj/item/radio/headset/speak_n_rock/aura
	ckeywhitelist = list("theknightofaura")

/datum/loadout_entry/donator/dancer_scarf
	name = "belly dancer headscarf"
	path = /obj/item/clothing/head/donator/dancer
	ckeywhitelist = list("phishman")

/datum/loadout_entry/donator/dancer_veil
	name = "belly dancer veil"
	path = /obj/item/clothing/mask/donator/dancer
	ckeywhitelist = list("phishman")

/datum/loadout_entry/donator/dancer_gloves
	name = "belly dancer sleeves"
	path = /obj/item/clothing/gloves/donator/dancer
	ckeywhitelist = list("phishman")

/datum/loadout_entry/donator/dancer_costume
	name = "belly dancer costume"
	path = /obj/item/clothing/under/donator/dancer
	ckeywhitelist = list("phishman")

/datum/loadout_entry/donator/dancer_wraps
	name = "belly dancer footwraps"
	path = /obj/item/clothing/shoes/donator/dancer
	ckeywhitelist = list("phishman")

/datum/loadout_entry/donator/iacccoat
	name = "connor's coat"
	path = /obj/item/clothing/suit/storage/umbral
	ckeywhitelist = list("iamcrystalclear")

/datum/loadout_entry/suit/pariah
	name = "springtime pariah moto jacket"
	path = /obj/item/clothing/suit/storage/toggle/heated/pariah
	ckeywhitelist = list("rezbit")

/datum/loadout_entry/suit/mindelectric
	name = "「 The Mind Electric 」"
	path = /obj/item/clothing/suit/storage/mindelectric
	ckeywhitelist = list("lectronyx")

/datum/loadout_entry/donator/tajcigarcase
	name = "S'rendarr's Hand case"
	path = /obj/item/storage/fancy/cigar/taj
	ckeywhitelist = list("vailthewolf")

/datum/loadout_entry/donator/noahcloak
	name = "Noah's Cloak"
	path = /obj/item/clothing/suit/storage/hooded/donatornoahcloak
	ckeywhitelist = list("rainbyplays")
