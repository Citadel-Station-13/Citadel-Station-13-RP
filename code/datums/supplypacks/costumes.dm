/*
*	Here is where any supply packs
*	related to weapons live.
*/


/datum/supply_pack/costumes
	group = "Costumes"

/datum/supply_pack/randomised/costumes
	group = "Costumes"

/datum/supply_pack/costumes/wizard
	name = "Wizard costume"
	contains = list(
			/obj/item/staff,
			/obj/item/clothing/suit/wizrobe/fake,
			/obj/item/clothing/shoes/sandal,
			/obj/item/clothing/head/wizard/fake
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Wizard costume crate"

/datum/supply_pack/costumes/techpriest
	name = "Tech Priest robes"
	contains = list(
		/obj/item/clothing/suit/storage/hooded/techpriest = 2)
	cost = 150
	containertype = /obj/structure/closet/crate
	containername = "Tech Priest crate"

/datum/supply_pack/randomised/costumes/hats
	num_contained = 4
	contains = list(
			/obj/item/clothing/head/collectable/chef,
			/obj/item/clothing/head/collectable/paper,
			/obj/item/clothing/head/collectable/tophat,
			/obj/item/clothing/head/collectable/captain,
			/obj/item/clothing/head/collectable/beret,
			/obj/item/clothing/head/collectable/welding,
			/obj/item/clothing/head/collectable/flatcap,
			/obj/item/clothing/head/collectable/pirate,
			/obj/item/clothing/head/collectable/kitty,
			/obj/item/clothing/head/collectable/rabbitears,
			/obj/item/clothing/head/collectable/wizard,
			/obj/item/clothing/head/collectable/hardhat,
			/obj/item/clothing/head/collectable/HoS,
			/obj/item/clothing/head/collectable/thunderdome,
			/obj/item/clothing/head/collectable/swat,
			/obj/item/clothing/head/collectable/slime,
			/obj/item/clothing/head/collectable/police,
			/obj/item/clothing/head/collectable/slime,
			/obj/item/clothing/head/collectable/xenom,
			/obj/item/clothing/head/collectable/petehat
			)
	name = "Collectable hat crate!"
	cost = 200
	containertype = /obj/structure/closet/crate
	containername = "Collectable hats crate! Brought to you by Bass.inc!"

/datum/supply_pack/randomised/costumes/costume
	num_contained = 3
	contains = list(
			/obj/item/clothing/suit/pirate,
			/obj/item/clothing/suit/judgerobe,
			/obj/item/clothing/accessory/wcoat,
			/obj/item/clothing/suit/hastur,
			/obj/item/clothing/suit/holidaypriest,
			/obj/item/clothing/suit/nun,
			/obj/item/clothing/suit/imperium_monk,
			/obj/item/clothing/suit/ianshirt,
			/obj/item/clothing/under/gimmick/rank/captain/suit,
			/obj/item/clothing/under/gimmick/rank/head_of_personnel/suit,
			/obj/item/clothing/under/lawyer/purpsuit,
			/obj/item/clothing/under/rank/mailman,
			/obj/item/clothing/under/dress/dress_saloon,
			/obj/item/clothing/suit/suspenders,
			/obj/item/clothing/suit/storage/toggle/labcoat/mad,
			/obj/item/clothing/suit/bio_suit/plaguedoctorsuit,
			/obj/item/clothing/under/schoolgirl,
			/obj/item/clothing/under/owl,
			/obj/item/clothing/under/waiter,
			/obj/item/clothing/under/gladiator,
			/obj/item/clothing/under/soviet,
			/obj/item/clothing/under/scratch,
			/obj/item/clothing/under/wedding/bride_white,
			/obj/item/clothing/suit/chef,
			/obj/item/clothing/suit/storage/apron/overalls,
			/obj/item/clothing/under/redcoat,
			/obj/item/clothing/under/kilt,
			/obj/item/clothing/suit/storage/hooded/techpriest
			)
	name = "Costumes crate"
	cost = 10
	containertype = /obj/structure/closet/crate
	containername = "Actor Costumes"

/datum/supply_pack/costumes/formal_wear
	contains = list(
			/obj/item/clothing/head/bowler,
			/obj/item/clothing/head/that,
			/obj/item/clothing/suit/storage/toggle/internalaffairs,
			/obj/item/clothing/suit/storage/toggle/lawyer/bluejacket,
			/obj/item/clothing/suit/storage/toggle/lawyer/purpjacket,
			/obj/item/clothing/under/suit_jacket,
			/obj/item/clothing/under/suit_jacket/female,
			/obj/item/clothing/under/suit_jacket/really_black,
			/obj/item/clothing/under/suit_jacket/red,
			/obj/item/clothing/under/lawyer/bluesuit,
			/obj/item/clothing/under/lawyer/purpsuit,
			/obj/item/clothing/shoes/black = 2,
			/obj/item/clothing/shoes/laceup/brown,
			/obj/item/clothing/accessory/wcoat
			)
	name = "Formalwear closet"
	cost = 30
	containertype = /obj/structure/closet
	containername = "Formalwear for the best occasions."

datum/supply_pack/costumes/witch
	name = "Witch costume"
	containername = "Witch costume"
	containertype = /obj/structure/closet
	cost = 20
	contains = list(
			/obj/item/clothing/suit/wizrobe/marisa/fake,
			/obj/item/clothing/shoes/sandal,
			/obj/item/clothing/head/wizard/marisa/fake,
			/obj/item/staff/broom
			)

/datum/supply_pack/randomised/costumes/costume_hats
	name = "Costume hats"
	containername = "Actor hats crate"
	containertype = /obj/structure/closet/crate
	cost = 10
	num_contained = 3
	contains = list(
			/obj/item/clothing/head/redcoat,
			/obj/item/clothing/head/mailman,
			/obj/item/clothing/head/plaguedoctorhat,
			/obj/item/clothing/head/pirate,
			/obj/item/clothing/head/hasturhood,
			/obj/item/clothing/head/powdered_wig,
			/obj/item/clothing/head/pin/flower,
			/obj/item/clothing/head/pin/flower/yellow,
			/obj/item/clothing/head/pin/flower/blue,
			/obj/item/clothing/head/pin/flower/pink,
			/obj/item/clothing/head/pin/clover,
			/obj/item/clothing/head/pin/butterfly,
			/obj/item/clothing/mask/gas/owl_mask,
			/obj/item/clothing/mask/gas/monkeymask,
			/obj/item/clothing/head/helmet/gladiator,
			/obj/item/clothing/head/ushanka
			)

/datum/supply_pack/randomised/costumes/dresses
	name = "Womens formal dress locker"
	containername = "Pretty dress locker"
	containertype = /obj/structure/closet
	cost = 15
	num_contained = 3
	contains = list(
			/obj/item/clothing/under/wedding/bride_orange,
			/obj/item/clothing/under/wedding/bride_purple,
			/obj/item/clothing/under/wedding/bride_blue,
			/obj/item/clothing/under/wedding/bride_red,
			/obj/item/clothing/under/wedding/bride_white,
			/obj/item/clothing/under/sundress,
			/obj/item/clothing/under/dress/dress_green,
			/obj/item/clothing/under/dress/dress_pink,
			/obj/item/clothing/under/dress/dress_orange,
			/obj/item/clothing/under/dress/dress_yellow,
			/obj/item/clothing/under/dress/dress_saloon
			)

/datum/supply_pack/costumes/xenowear
	name = "Xenowear crate"
	contains = list(
			/obj/item/clothing/shoes/footwraps,
			/obj/item/clothing/shoes/boots/jackboots/toeless,
			/obj/item/clothing/shoes/boots/workboots/toeless,
			/obj/item/clothing/suit/tajaran/furs,
			/obj/item/clothing/head/tajaran/scarf,
			/obj/item/clothing/suit/unathi/robe,
			/obj/item/clothing/suit/unathi/mantle,
			/obj/item/clothing/under/permit,
			/obj/item/clothing/under/vox/vox_casual,
			/obj/item/clothing/under/vox/vox_robes,
			/obj/item/clothing/under/harness,
			/obj/item/clothing/under/skirt/loincloth,
			/obj/item/clothing/gloves/vox
			)
	cost = 100
	containertype = /obj/structure/closet/crate
	containername = "Xenowear crate"

/datum/supply_pack/costumes/tesh_smocks
	name = "Teshari smocks"
	contains = list(
			/obj/item/clothing/under/teshari/smock,
			/obj/item/clothing/under/teshari/smock/rainbow,
			/obj/item/clothing/under/teshari/smock/red,
			/obj/item/clothing/under/teshari/smock/white,
			/obj/item/clothing/under/teshari/smock/yellow
			)
	cost = 25
	containertype = /obj/structure/closet/crate
	containername = "Teshari smocks crate"

/datum/supply_pack/randomised/costumes/tesh_coats
	name = "Teshari undercoats"
	num_contained = 4
	contains = list(
			/obj/item/clothing/under/teshari/undercoat/standard/blue_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/brown_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/green_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/lightgrey_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/orange,
			/obj/item/clothing/under/teshari/undercoat/standard/orange_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/pink_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/purple_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/rainbow,
			/obj/item/clothing/under/teshari/undercoat/standard/red_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/white_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/yellow_grey
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Teshari undercoats crate"

/datum/supply_pack/randomised/costumes/tesh_coats_b
	name = "Teshari undercoats (black)"
	num_contained = 4
	contains = list(
			/obj/item/clothing/under/teshari/undercoat/standard/black,
			/obj/item/clothing/under/teshari/undercoat/standard/black_blue,
			/obj/item/clothing/under/teshari/undercoat/standard/black_brown,
			/obj/item/clothing/under/teshari/undercoat/standard/black_green,
			/obj/item/clothing/under/teshari/undercoat/standard/black_grey,
			/obj/item/clothing/under/teshari/undercoat/standard/black_orange,
			/obj/item/clothing/under/teshari/undercoat/standard/black_pink,
			/obj/item/clothing/under/teshari/undercoat/standard/black_purple,
			/obj/item/clothing/under/teshari/undercoat/standard/black_red,
			/obj/item/clothing/under/teshari/undercoat/standard/black_white,
			/obj/item/clothing/under/teshari/undercoat/standard/black_yellow
			)
	cost = 20
	containertype = /obj/structure/closet/crate
	containername = "Teshari undercoats crate"

/datum/supply_pack/randomised/costumes/tesh_cloaks
	name = "Teshari cloaks"
	num_contained = 4
	contains = list(
			/obj/item/clothing/suit/storage/teshari/cloak/standard/blue_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/brown_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/green_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/orange,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/orange_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/pink_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/purple_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/rainbow,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/red_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/white_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/yellow_grey
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Teshari cloaks crate"

/datum/supply_pack/randomised/costumes/tesh_cloaks_b
	name = "Teshari cloaks (black)"
	num_contained = 4
	contains = list(
			/obj/item/clothing/suit/storage/teshari/cloak,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_blue,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_brown,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_green,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_grey,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_orange,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_pink,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_purple,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_red,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_white,
			/obj/item/clothing/suit/storage/teshari/cloak/standard/black_yellow
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Teshari cloaks crate"

/datum/supply_pack/costumes/utility
	name = "Utility uniforms"
	contains = list(
			/obj/item/clothing/under/utility,
			/obj/item/clothing/under/utility/blue,
			/obj/item/clothing/under/utility/grey
			)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "Utility uniforms crate"

/datum/supply_pack/costumes/skirts
	name = "Skirts crate"
	contains = list(
			/obj/item/clothing/under/skirt,
			/obj/item/clothing/under/skirt/blue,
			/obj/item/clothing/under/skirt/denim,
			/obj/item/clothing/under/skirt/khaki,
			/obj/item/clothing/under/skirt/outfit,
			/obj/item/clothing/under/skirt/red,
			/obj/item/clothing/under/skirt/swept,
			/obj/item/clothing/under/skirt/outfit/plaid_blue,
			/obj/item/clothing/under/skirt/outfit/plaid_purple,
			/obj/item/clothing/under/skirt/outfit/plaid_red
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Skirts crate"

/datum/supply_pack/costumes/varsity
	name = "Varsity jackets"
	contains = list(
			/obj/item/clothing/suit/varsity,
			/obj/item/clothing/suit/varsity/blue,
			/obj/item/clothing/suit/varsity/brown,
			/obj/item/clothing/suit/varsity/green,
			/obj/item/clothing/suit/varsity/purple,
			/obj/item/clothing/suit/varsity/red
			)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "Varsity jackets crate"

/datum/supply_pack/randomised/costumes/leathergear
	name = "Leather gear"
	num_contained = 5
	contains = list(
			/obj/item/clothing/suit/leathercoat,
			/obj/item/clothing/suit/storage/leather_jacket_alt,
			/obj/item/clothing/suit/storage/toggle/leather_jacket,
			/obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless,
			/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen,
			/obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless,
			/obj/item/clothing/under/pants/chaps,
			/obj/item/clothing/under/pants/chaps/black,
			/obj/item/clothing/under/harness,
			/obj/item/clothing/shoes/leather,
			/obj/item/clothing/shoes/boots/jungle,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/shoes/boots/cowboy,
			/obj/item/clothing/shoes/boots/cowboy/classic,
			/obj/item/clothing/shoes/boots/cowboy/snakeskin,
			/obj/item/clothing/accessory/chaps,
			/obj/item/clothing/accessory/chaps/black,
			/obj/item/clothing/accessory/collar/spike,
			/obj/item/clothing/gloves/fingerless,
			/obj/item/clothing/gloves/botanic_leather,
			/obj/item/clothing/head/cowboy_hat,
			/obj/item/clothing/head/cowboy_hat/black
			)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "Leather gear crate"

/datum/supply_pack/costumes/eyewear
	name = "Eyewear crate"
	contains = list(
			/obj/item/clothing/glasses/eyepatch,
			/obj/item/clothing/glasses/fakesunglasses,
			/obj/item/clothing/glasses/fakesunglasses/aviator,
			/obj/item/clothing/glasses/fluff/science_proper,
			/obj/item/clothing/glasses/fluff/spiffygogs,
			/obj/item/clothing/glasses/gglasses,
			/obj/item/clothing/glasses/monocle,
			/obj/item/clothing/glasses/regular,
			/obj/item/clothing/glasses/regular/hipster,
			/obj/item/clothing/glasses/regular/scanners,
			/obj/item/clothing/glasses/threedglasses
			)
	cost = 50
	containertype = /obj/structure/closet/crate
	containername = "Eyewear crate"

/datum/supply_pack/randomised/costumes/gloves
	name = "Gloves crate"
	num_contained = 4
	contains = list(
			/obj/item/clothing/gloves/black,
			/obj/item/clothing/gloves/blue,
			/obj/item/clothing/gloves/botanic_leather,
			/obj/item/clothing/gloves/brown,
			/obj/item/clothing/gloves/evening,
			/obj/item/clothing/gloves/fingerless,
			/obj/item/clothing/gloves/fyellow,
			/obj/item/clothing/gloves/green,
			/obj/item/clothing/gloves/grey,
			/obj/item/clothing/gloves/light_brown,
			/obj/item/clothing/gloves/orange,
			/obj/item/clothing/gloves/purple,
			/obj/item/clothing/gloves/rainbow,
			/obj/item/clothing/gloves/red,
			/obj/item/clothing/gloves/white
			)
	cost = 40
	containertype = /obj/structure/closet/crate
	containername = "Gloves crate"

/datum/supply_pack/randomised/costumes/boots
	name = "Boots crate"
	num_contained = 3
	contains = list(
			/obj/item/clothing/shoes/boots/workboots,
			/obj/item/clothing/shoes/boots/cowboy,
			/obj/item/clothing/shoes/boots/cowboy/classic,
			/obj/item/clothing/shoes/boots/cowboy/snakeskin,
			/obj/item/clothing/shoes/boots/duty,
			/obj/item/clothing/shoes/boots/jackboots,
			/obj/item/clothing/shoes/boots/jungle,
			/obj/item/clothing/shoes/boots/winter
			)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "Boots crate"

/datum/supply_pack/costumes/taurbags
	name = "Saddlebags crate"
	contains = list(
			/obj/item/storage/backpack/saddlebag_common,
			/obj/item/storage/backpack/saddlebag_common/robust,
			/obj/item/storage/backpack/saddlebag_common/vest
			)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "Saddlebags crate"

/datum/supply_pack/costumes/larp
	name = "Knight cosplay crate"
	contains = list(
			/obj/item/clothing/head/medievalfake/red = 1,
			/obj/item/clothing/head/medievalfake/green = 1,
			/obj/item/clothing/head/medievalfake/blue = 1,
			/obj/item/clothing/head/medievalfake/orange = 1,
			/obj/item/clothing/suit/medievalfake/red = 1,
			/obj/item/clothing/suit/medievalfake/green = 1,
			/obj/item/clothing/suit/medievalfake/blue = 1,
			/obj/item/clothing/suit/medievalfake/orange = 1
			)
	cost = 60
	containertype = /obj/structure/closet/crate
	containername = "knight cosplay crate"

/datum/supply_pack/costumes/situlavult_templar
	name = "Templar cosplay crate"
	contains = list(
			/obj/item/clothing/head/medievalfake/crusader/templar,
			/obj/item/clothing/suit/medievalfake/crusader/cross/templar,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/templar
			)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "templar cosplay crate"

/datum/supply_pack/costumes/situlavult_hospitaller
	name = "Hospitaller cosplay crate"
	contains = list(
			/obj/item/clothing/head/medievalfake/crusader,
			/obj/item/clothing/suit/medievalfake/crusader/cross/hospitaller,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/hospitaller
			)
	cost = 15
	containertype = /obj/structure/closet/crate
	containername = "hospitaller cosplay crate"

/datum/supply_pack/costumes/situlavult_teutonic
	name = "Teutonic cosplay crate"
	contains = list(
			/obj/item/clothing/head/medievalfake/crusader/horned,
			/obj/item/clothing/head/medievalfake/crusader/winged,
			/obj/item/clothing/suit/medievalfake/crusader/cross,
			/obj/item/clothing/suit/medievalfake/crusader/cross/teutonic,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade,
			/obj/item/clothing/accessory/poncho/roles/cloak/custom/crusade/teutonic
			)
	cost = 30
	containertype = /obj/structure/closet/crate
	containername = "teutonic cosplay crate"