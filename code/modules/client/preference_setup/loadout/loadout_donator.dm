/datum/gear/donator
	sort_category = "Donator"
	cost = 0 // If they went out of their way to PAY for a custom item, given our no-gameplay-advantage-granting-items rule, it's only right that they aren't penalized and need to re-adjust their loadout to compensate for their new item's cost.
	display_name = "If this item can be chosen or seen, ping a coder immediately!"
	path = /obj/item/bikehorn
	ckeywhitelist = list("This entry should never be choosable with this variable set.") //If it does, then that means somebody fucked up the whitelist system pretty hard

/*
/datum/gear/donator/testhorn
	display_name = "Airhorn - Example Item"
	path = /obj/item/bikehorn
	ckeywhitelist = list("realdonaldtrump")
*/

/datum/gear/donator/gladiator
	display_name = "Gladiator Armor"
	slot = slot_wear_suit
	path = /obj/item/clothing/under/gladiator
	ckeywhitelist = list("aroche")

/datum/gear/donator/stool
	display_name = "Faiza's Stool"
	slot = slot_wear_suit
	path = /obj/item/melee/stool/faiza
	ckeywhitelist = list("crystal9156")

/datum/gear/donator/chayse
	display_name = "NTSC Naval Uniform"
	slot = slot_w_uniform
	path = /obj/item/clothing/under/donator/chayse
	ckeywhitelist = list("realdonaldtrump", "aaronskywalker")

/datum/gear/donator/labredblack
	display_name = "Black and Red Coat"
	slot = slot_wear_suit
	path = /obj/item/clothing/suit/storage/toggle/labcoat/donator/labredblack
	ckeywhitelist = list("blakeryan", "durandalphor")

/datum/gear/donator/carrotsatchel
	display_name = "Carrot Satchel"
	slot = slot_back
	path = /obj/item/storage/backpack/satchel/donator/carrot
	ckeywhitelist = list("improvedname")

/datum/gear/donator/stripedcollar
	display_name = "Striped collar"
	slot = slot_tie
	path = /obj/item/clothing/accessory/collar/donator/striped
	ckeywhitelist = list("jademanique")

/datum/gear/donator/cameronbackpack
	display_name = "Brig Physician's Backpack"
	slot = slot_back
	path = /obj/item/storage/backpack/satchel/donator/cameron
	ckeywhitelist = list("cameronlancaster")

/datum/gear/donator/cameronarmor
	display_name = "Brig Physician's Armor Vest"
	slot = slot_wear_suit
	path = /obj/item/clothing/suit/armor/vest/donator/cameron
	ckeywhitelist = list("cameronlancaster")

/datum/gear/donator/crown
	display_name = "Crown"
	slot = slot_head
	path = /obj/item/clothing/accessory/collar/donator/crown
	ckeywhitelist = list("grayrachnid")

/datum/gear/donator/beesuit
	display_name = "Bee Suit"
	slot = slot_head
	path = /obj/item/clothing/suit/storage/hooded/donator/bee_costume
	ckeywhitelist = list("beeskee")

/datum/gear/donator/rarehat
	display_name = "Ultra Rare Hat"
	slot = slot_head
	path = /obj/item/clothing/head/collectable/petehat
	ckeywhitelist = list("risingstarslash")

/datum/gear/donator/holotags
	display_name = "USDF Holotags"
	description = "United Sol Defense Force issued ID, Belonging to Nikolai Volkov, DOB 12/12/2537, Blood Type O+"
	path = /obj/item/clothing/accessory/collar/donator/holotags
	ckeywhitelist = list("certifiedhyena")

/datum/gear/donator/silverhelmet
	display_name = "Silver's Helmet"
	slot = slot_head
	path = /obj/item/reskin_kit/jenna
	ckeywhitelist = list("jennasilver")

/datum/gear/donator/izzyball
	display_name = "Katlin's Ball"
	path = /obj/item/toy/tennis/rainbow/izzy
	ckeywhitelist = list("izzyinbox")


/datum/gear/donator/pduni
	display_name = "Olympius PD Service Uniform"
	path = /obj/item/clothing/under/donator/opd
	ckeywhitelist = list("hungrycricket")

/datum/gear/donator/mewchild
	display_name = "Bone Signet Ring"
	path = /obj/item/clothing/gloves/ring/seal/signet/fluff/vietsi
	ckeywhitelist = list("mewchild")

/datum/gear/donator/stunsword
	display_name = "Stunsword kit"
	path = /obj/item/reskin_kit/stunsword
	ckeywhitelist = list("phillip458")

/datum/gear/donator/redlensmask
	display_name = "Red-Lensed Gas Mask"
	path = /obj/item/clothing/mask/red_mask
	ckeywhitelist = list("figneugen")

/datum/gear/donator/blackredgold
	display_name = "Black, Red, and Gold Coat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/donator/blackredgold
	ckeywhitelist = list("ttbnc")

/datum/gear/donator/hoodedlcoak
	display_name = "Project: Zul-E"
	path = /obj/item/clothing/suit/storage/hooded/donator/hooded_cloak
	ckeywhitelist = list("asky")

/datum/gear/donator/pinklatex
	display_name = "Pink Latex"
	path = /obj/item/clothing/under/donator/pinksuit
	ckeywhitelist = list("tippler")

/datum/gear/donator/peltcloak
	display_name = "Pelt Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/peltcloak
	ckeywhitelist = list("irkallaepsilon")

/datum/gear/donator/doubleglasses
	display_name = "Double Sunglasses"
	path = /obj/item/clothing/glasses/sunglasses/double
	ckeywhitelist = list("jglitch")

/datum/gear/donator/huni
	display_name = "KHI Uniform"
	path = /obj/item/clothing/under/donator/huni
	ckeywhitelist = list("certifiedhyena")

/datum/gear/donator/hberet
	display_name = "USDF Beret"
	path = /obj/item/clothing/head/donator/hberet
	ckeywhitelist = list("certifiedhyena")

/datum/gear/donator/woolhat
	display_name = "Army Garrison Cap"
	path = /obj/item/clothing/head/donator/woolhat
	ckeywhitelist = list("vfivesix")

/datum/gear/donator/carcharodon
	display_name = "Carcharodon Suit"
	path = /obj/item/clothing/under/carcharodon
	ckeywhitelist = list("desucake")

/datum/gear/donator/mantleofheaven
	display_name = "Mantle of the Heavens"
	path = /obj/item/clothing/under/mantleofheaven
	ckeywhitelist = list("hjorthorn")

/datum/gear/donator/kepytw
	display_name = "Teshari Hatchling Care Kit"
	path = /obj/item/toy/kepytw
	ckeywhitelist = list("kepytw")

/datum/gear/donator/chaoterobe
	display_name = "Chaote Robe"
	path = /obj/item/clothing/suit/storage/hooded/techpriest/chaos
	ckeywhitelist = list("loburd")

/datum/gear/donator/veterancargoarmband
	display_name = "Veteran's Cargo Armband"
	path = /obj/item/clothing/accessory/armband/veterancargo
	ckeywhitelist = list("yourdoom9898")

/datum/gear/donator/customcamcorder
	display_name = "Prop Video Recorder"
	path = /obj/item/faketvcamera
	ckeywhitelist = list("fauxmagician")

/datum/gear/donator/hueyskirt
	display_name = "High-Waisted Business Skirt"
	slot = slot_wear_suit
	path = /obj/item/clothing/under/skirt/donator/doopytoots
	ckeywhitelist = list("doopytoots")

/datum/gear/donator/mikubikini
	display_name = "starlight singer bikini"
	path = /obj/item/clothing/under/donator/mikubikini
	ckeywhitelist = list("grandvegeta")

/datum/gear/donator/mikujacket
	display_name = "starlight singer jacket"
	path = /obj/item/clothing/suit/donator/mikujacket
	ckeywhitelist = list("grandvegeta")

/datum/gear/donator/mikuhair
	display_name = "starlight singer hair"
	path = /obj/item/clothing/head/donator/mikuhair
	ckeywhitelist = list("grandvegeta")

/datum/gear/donator/mikugloves
	display_name = "starlight singer gloves"
	path = /obj/item/clothing/gloves/donator/mikugloves
	ckeywhitelist = list("grandvegeta")

/datum/gear/donator/mikuleggings
	display_name = "starlight singer leggings"
	path = /obj/item/clothing/shoes/donator/mikuleggings
	ckeywhitelist = list("grandvegeta")

/datum/gear/donator/iaccmask
	display_name = "orchid's mask"
	path = /obj/item/clothing/mask/gas/orchid
	ckeywhitelist = list("iamcrystalclear")

/datum/gear/donator/vicase
	display_name = "VI's secure briefcase"
	path = /obj/item/storage/secure/briefcase/vicase
	ckeywhitelist = list("capesh")

/datum/gear/donator/aura
	display_name = "KNIGHT-brand Melodic headset"
	path = /obj/item/clothing/ears/earmuffs/headphones/aura
	ckeywhitelist = list("theknightofaura")
