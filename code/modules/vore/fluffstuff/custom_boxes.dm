// ToDo: Alphabetize by ckey.
// Also these things might be mildly obsolete considering the update to inventory.

// BEGIN - DO NOT EDIT PROTOTYPE
/obj/item/storage/box/fluff
	name = "Undefined Fluff Box"
	desc = "This should have a description. Tell an admin."
	storage_slots = 7
	var/list/has_items = list()

/obj/item/storage/box/fluff/PopulateContents()
	. = ..()
	storage_slots = has_items.len
	allowed = list()
	for(var/P in has_items)
		allowed += P
		new P(src)
// END - DO NOT EDIT PROTOTYPE


/* TEMPLATE
// ckey:Character Name
/obj/item/storage/box/fluff/charactername
	name = ""
	desc = ""
	has_items = list(
		/obj/item/clothing/head/thing1,
		/obj/item/clothing/shoes/thing2,
		/obj/item/clothing/suit/thing3,
		/obj/item/clothing/under/thing4)
*/
/* CITADEL CHANGES - Removes Virgo Fluff
// BeyondMyLife:Cassandra Selones Spawn Kit
/obj/item/storage/box/fluff/cassandra
	name = "Cassandra Selone's Spawn Kit"
	desc = "A spawn Kit, holding Cassandra Selone's Item's"
	has_items = list(
		/obj/item/clothing/gloves/fluff/kilano/purple,
		/obj/item/clothing/under/fluff/kilanosuit/purple,
		/obj/item/clothing/shoes/boots/fluff/kilano/purple)

// bwoincognito:Tasald Corlethian
/obj/item/storage/box/fluff/tasald
	name = "Tasald's Kit"
	desc = "A kit containing Talsald's equipment."
	has_items = list(
		/obj/item/clothing/suit/storage/det_suit/fluff/tasald,
		/obj/item/clothing/suit/storage/det_suit/fluff/tas_coat,
		/obj/item/clothing/under/det/fluff/tasald,
		/obj/item/clothing/accessory/permit/gun/fluff/tasald_corlethian,
		/obj/item/gun/ballistic/revolver/mateba/fluff/tasald_corlethian,
		/obj/item/implanter/loyalty)

//bwoincognito:Octavious Ward
/obj/item/storage/box/fluff/octavious
	name = "Octavious's Kit"
	desc = "A kit containing Octavious's work clothes."
	has_items = list(
		/obj/item/clothing/suit/storage/trench/fluff/octaviouscoat,
		/obj/item/clothing/under/det/fluff/octavious,
		/obj/item/clothing/mask/gas/plaguedoctor/fluff/octaviousmask,
		/obj/item/clothing/head/fedora/fluff/bowler,
		/obj/item/clothing/shoes/black/cuffs/octavious,
		/obj/item/cane/fluff/tasald,
		/obj/item/clothing/glasses/hud/health/octaviousmonicle
		)

// jemli:Cirra Mayhem
/obj/item/storage/box/fluff/cirra
	name = "Instant Pirate Kit"
	desc = "Just add Akula!"
	has_items = list(
		/obj/item/clothing/head/pirate,
		/obj/item/clothing/glasses/eyepatch,
		/obj/item/clothing/suit/pirate,
		/obj/item/clothing/under/pirate)

// joey4298:Emoticon
/obj/item/storage/box/fluff/emoticon
	name = "Emoticon's Mime Kit"
	desc = "Specially packaged for the hungry catgirl mime with a taste for clown."
	has_items = list(
		/obj/item/fluff/id_kit_mime,
		/obj/item/clothing/gloves/white,
		/obj/item/clothing/head/beret,
		/obj/item/reagent_containers/food/drinks/bottle/bottleofnothing,
		/obj/item/clothing/shoes/black,
		/obj/item/toy/crayon/mime) //Need to track down the code for crayons before adding this back in

//joanrisu:Joan Risu
/obj/item/storage/backpack/dufflebag/sec/fluff/joanrisu
	name = "Joan's Workbag"
	desc = "A bag Joan uses to carry her work equipment. It has the 82nd Battle Group Insignia on it."
	icon_state = "joanbag"
	icon = 'icons/vore/custom_items_vr.dmi'
	item_state = "duffle-med"
	slowdown = 0

	New()
		..()
		new /obj/item/clothing/accessory/holster/hip(src)
		new /obj/item/clothing/suit/storage/fluff/modernfedcoat(src)
		new /obj/item/clothing/head/caphat/formal/fedcover(src)
		new /obj/item/card/id/centcom/station/fluff/joanbadge(src)
//		new /obj/item/gun/energy/gun/fluff/dominator(src)
		new /obj/item/clothing/suit/armor/det_suit(src)
//		new /obj/item/clothing/accessory/permit/gun/fluff/joanrisu(src)
//		new /obj/item/sword/fluff/joanaria(src)
		new /obj/item/flame/lighter/zippo/fluff/joan(src)
		new /obj/item/clothing/under/rank/internalaffairs/fluff/joan(src)
		new /obj/item/clothing/head/helmet/space/fluff/joan(src)
		new /obj/item/clothing/suit/space/fluff/joan(src)

//joanrisu:Katarina Eine
/obj/item/storage/backpack/dufflebag/sec/fluff/katarina
	name = "Katarina's Workbag"
	desc = "A duffle bag Katarina uses to carry her tools."
	slowdown = 0

	New()
		..()
		new /obj/item/clothing/accessory/holster/hip(src)
		new /obj/item/clothing/suit/storage/fluff/fedcoat(src)
//		new /obj/item/gun/energy/gun/fluff/dominator(src)
		new /obj/item/clothing/suit/armor/det_suit(src)
		new /obj/item/clothing/accessory/storage/black_vest(src)
		new /obj/item/material/knife/tacknife/combatknife/fluff/katarina(src)
		new /obj/item/clothing/under/rank/internalaffairs/fluff/joan(src)

//drakefrostpaw:Drake Frostpaw
/obj/item/storage/box/fluff/drake
	name = "United Federation Uniform Kit"
	desc = "A box containing all the parts of a United Federation Uniform"
	has_items = list(
		/obj/item/clothing/under/rank/internalaffairs/fluff/joan,
		/obj/item/clothing/suit/storage/fluff/modernfedcoat/modernfedsec,
		/obj/item/clothing/head/caphat/formal/fedcover/fedcoversec,
		/obj/item/clothing/gloves/white,
		)

// Draycu: Schae Yonra
/obj/item/storage/box/fluff/yonra
	name = "Yonra's Starting Kit"
	desc = "A small box containing Yonra's personal effects"
	has_items = list(
		/obj/item/melee/fluff/holochain/mass,
		/obj/item/implanter/reagent_generator/yonra,
		/obj/item/clothing/accessory/medal/silver/unity)

//Razerwing:Archer Maximus
/obj/item/storage/box/fluff/archermaximus
	desc = "Personal Effects"
	has_items = list()

//ivymoomoo:Ivy Baladeva
/obj/item/storage/backpack/messenger/sec/fluff/ivymoomoo
	name = "Ivy's Courier"
	desc = "A bag resembling something used by college students. Contains items for ''MooMoo''."

	New()
		..()
		new /obj/item/clothing/head/beretg(src)
		new /obj/item/fluff/id_kit_ivy(src)
		new /obj/item/storage/fancy/cigarettes/dromedaryco(src)
		new /obj/item/storage/box/matches(src)
		new /obj/item/reagent_containers/food/snacks/sliceable/plaincake(src)

//Xsdew:Penelope Allen
/obj/item/storage/box/fluff/penelope
	name = "Penelope's capsule"
	desc = "A little capsule where a designer's swimsuit is stored."
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "capsule"
	storage_slots = 1
	foldable = null
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/clothing/under/swimsuit/)
	has_items = list(/obj/item/clothing/under/swimsuit/fluff/penelope)

// Aerowing:Sebastian Aji
/obj/item/storage/box/fluff/sebastian_aji
	name = "Sebastian's Lumoco Arms P3 Box"
	has_items = list(
		/obj/item/gun/ballistic/pistol,
		/obj/item/ammo_magazine/m9mm/compact/flash,
		/obj/item/ammo_magazine/m9mm/compact/flash,
		/obj/item/clothing/accessory/permit/gun/fluff/sebastian_aji)

/*
/obj/item/storage/box/fluff/briana_moore
	name = "Briana's Derringer Box"
	has_items = list(
		/obj/item/gun/ballistic/derringer/fluff/briana,
		/obj/item/clothing/accessory/permit/gun/fluff/briana_moore)
*/

/*
//SilencedMP5A5:Serdykov Antoz
/obj/item/storage/box/fluff/serdykov_antoz
	name = "Serdy's Weapon Box"
	has_items = list(
		/obj/item/clothing/accessory/permit/gun/fluff/silencedmp5a5,
		/obj/item/gun/ballistic/colt/fluff/serdy)
*/

//BeyondMyLife: Ne'tra Ky'ram //Made a box because they have so many items that it'd spam the debug log.
/obj/item/storage/box/fluff/kilano
	name = "Ne'tra Ky'ram's Kit"
	desc = "A kit containing Ne'tra Ky'ram's clothing."
	has_items = list(
		/obj/item/clothing/suit/storage/hooded/wintercoat/kilanocoat,
		/obj/item/clothing/under/fluff/kilanosuit,
		/obj/item/storage/backpack/messenger/sec/fluff/kilano,
		/obj/item/storage/belt/security/fluff/kilano,
		/obj/item/clothing/gloves/fluff/kilano/netra,
		/obj/item/clothing/shoes/boots/fluff/kilano,
		/obj/item/clothing/accessory/storage/black_vest/fluff/kilano
		)

// JackNoir413: Mor Xaina
/obj/item/storage/box/fluff/morxaina
	name = "Fashionable clothes set"
	desc = "Set of custom-made, expensive attire elements."
	has_items = list(
		/obj/item/clothing/shoes/fluff/morthighs,
		/obj/item/clothing/gloves/fluff/morsleeves,
		/obj/item/clothing/under/fluff/morunder)

// Mewchild: Phi Vietsi
/obj/item/storage/box/fluff/vietsi
	name = "Phi's Personal Items"
	has_items = list(
		/obj/item/clothing/accessory/medal/bronze_heart,
		/obj/item/clothing/gloves/ring/seal/signet/fluff/vietsi)
END OF CITADEL CHANGES */
/*
Swimsuits, for general use, to avoid arriving to work with your swimsuit.
*/
/obj/item/storage/box/fluff/swimsuit
	name = "Black Swimsuit capsule"
	desc = "A little capsule where a swimsuit is usually stored."
	storage_slots = 1
	icon = 'icons/vore/custom_items_vr.dmi'
	icon_state = "capsule"
	foldable = null
	w_class = ITEMSIZE_SMALL
	max_w_class = ITEMSIZE_NORMAL
	can_hold = list(/obj/item/clothing/under/swimsuit/)
	has_items = list(/obj/item/clothing/under/swimsuit/black)

/obj/item/storage/box/fluff/swimsuit/blue
	name = "Blue Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/blue)

/obj/item/storage/box/fluff/swimsuit/purple
	name = "Purple Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/purple)

/obj/item/storage/box/fluff/swimsuit/green
	name = "Green Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/green)

/obj/item/storage/box/fluff/swimsuit/red
	name = "Red Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/red)

/obj/item/storage/box/fluff/swimsuit/white
	name = "White Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/white)

/obj/item/storage/box/fluff/swimsuit/blue
	name = "Striped Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/striped)

/obj/item/storage/box/fluff/swimsuit/earth
	name = "Earthen Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/earth)

/obj/item/storage/box/fluff/swimsuit/engineering
	name = "Engineering Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/fluff/engineering)

/obj/item/storage/box/fluff/swimsuit/science
	name = "Science Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/fluff/science)

/obj/item/storage/box/fluff/swimsuit/security
	name = "Security Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/fluff/security)

/obj/item/storage/box/fluff/swimsuit/medical
	name = "Medical Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/fluff/medical)

/obj/item/storage/box/fluff/swimsuit/cowbikini
	name = "Cow Bikini capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/stripper/cowbikini)

/obj/item/storage/box/fluff/swimsuit/captain
	name = "Sexy Captain capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/stripper/captain)

/obj/item/storage/box/fluff/swimsuit/highclass
	name = "High Class Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/highclass)

/obj/item/storage/box/fluff/swimsuit/latex
	name = "Latex Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/latex)

/obj/item/storage/box/fluff/swimsuit/risque
	name = "Risque Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/risque)

/obj/item/storage/box/fluff/swimsuit/streamlined
	name = "Streamlined Swimsuit capsule"
	has_items = list(/obj/item/clothing/under/swimsuit/streamlined)

//Monkey boxes for the new primals we have
/obj/item/storage/box/monkeycubes/sobakacubes
	name = "sobaka cube box"
	desc = "Drymate brand sobaka cubes. Just add water!"

/obj/item/storage/box/monkeycubes/sobakacubes/PopulateContents()
	. = ..()
	for(var/i = 1 to 4)
		new /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/sobakacube(src)

/obj/item/storage/box/monkeycubes/sarucubes
	name = "saru cube box"
	desc = "Drymate brand saru cubes. Just add water!"

/obj/item/storage/box/monkeycubes/sarucubes/PopulateContents()
	. = ..()
	for(var/i = 1 to 4)
		new /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/sarucube(src)

/obj/item/storage/box/monkeycubes/sparracubes
	name = "sparra cube box"
	desc = "Drymate brand sparra cubes. Just add water!"

/obj/item/storage/box/monkeycubes/sparracubes/PopulateContents()
	. = ..()
	for(var/i = 1 to 4)
		new /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/sparracube(src)

/obj/item/storage/box/monkeycubes/wolpincubes
	name = "wolpin cube box"
	desc = "Drymate brand wolpin cubes. Just add water!"

/obj/item/storage/box/monkeycubes/wolpincubes/PopulateContents()
	. = ..()
	for(var/i = 1 to 4)
		new /obj/item/reagent_containers/food/snacks/monkeycube/wrapped/wolpincube(src)
