// Suit slot
/datum/loadout_entry/suit
	name = "Apron - Blue"
	path = /obj/item/clothing/suit/storage/apron
	slot = SLOT_ID_SUIT
	category = LOADOUT_CATEGORY_SUITS

/datum/loadout_entry/suit/apron_white
	name = "Apron - Colorable"
	path = /obj/item/clothing/suit/storage/apron/white

/datum/loadout_entry/suit/greatcoat
	name = "Greatcoat"
	path = /obj/item/clothing/suit/greatcoat

/datum/loadout_entry/suit/leather_coat
	name = "Leather Coat"
	path = /obj/item/clothing/suit/leathercoat

/datum/loadout_entry/suit/overcoat
	name = "Leather Overcoat"
	path = /obj/item/clothing/suit/overcoat

/datum/loadout_entry/suit/puffer_coat
	name = "Puffer Coat"
	path = /obj/item/clothing/suit/jacket/puffer

/datum/loadout_entry/suit/puffer_vest
	name = "Puffer Vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/loadout_entry/suit/bomber
	name = "Bomber Jacket"
	path = /obj/item/clothing/suit/storage/toggle/bomber

/datum/loadout_entry/suit/bomber_alt
	name = "Bomber Jacket Alt"
	path = /obj/item/clothing/suit/storage/bomber/alt

/datum/loadout_entry/suit/storage/gothcoat
	name = "Gothic Coat"
	path = /obj/item/clothing/suit/storage/gothcoat

/datum/loadout_entry/suit/leather_jacket
	name = "Leather Jacket - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/loadout_entry/suit/leather_jacket_sleeveless
	name = "Leather Vest - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless

/datum/loadout_entry/suit/leather_jacket_alt
	name = "Leather Jacket Alt - Black"
	path = /obj/item/clothing/suit/storage/leather_jacket_alt

/datum/loadout_entry/suit/leather_jacket_nt
	name = "Leather Jacket - Corporate - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen

/datum/loadout_entry/suit/leather_jacket_nt/sleeveless
	name = "Leather Vest - Corporate - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless

/datum/loadout_entry/suit/brown_jacket
	name = "Leather Jacket - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket

/datum/loadout_entry/suit/brown_jacket_sleeveless
	name = "Leather Vest - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless

/datum/loadout_entry/suit/brown_jacket_nt
	name = "Leather Jacket - Corporate - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen

/datum/loadout_entry/suit/brown_jacket_nt/sleeveless
	name = "Leather Vest - Corporate, Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless

/datum/loadout_entry/suit/mil
	name = "Military Jacket - Selection"
	path = /obj/item/clothing/suit/storage/miljacket

/datum/loadout_entry/suit/mil/New()
	..()
	var/list/mil_jackets = list()
	for(var/military_style in typesof(/obj/item/clothing/suit/storage/miljacket))
		var/obj/item/clothing/suit/storage/miljacket/miljacket = military_style
		mil_jackets[initial(miljacket.name)] = miljacket
	tweaks += new/datum/loadout_tweak/path(tim_sort(mil_jackets, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/greyjacket
	name = "Jacket - Grey"
	path = /obj/item/clothing/suit/storage/greyjacket

/datum/loadout_entry/suit/brown_trenchcoat
	name = "Trenchcoat - Brown"
	path = /obj/item/clothing/suit/storage/trench

/datum/loadout_entry/suit/grey_trenchcoat
	name = "Trenchcoat - Grey"
	path = /obj/item/clothing/suit/storage/trench/grey

/datum/loadout_entry/suit/duster
	name = "Cowboy Duster"
	path = /obj/item/clothing/suit/storage/duster

/datum/loadout_entry/suit/hazard_vest
	name = "Hazard Vest - Selection"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/loadout_entry/suit/hazard_vest/New()
	..()
	var/list/hazards = list()
	for(var/hazard_style in typesof(/obj/item/clothing/suit/storage/hazardvest))
		var/obj/item/clothing/suit/storage/hazardvest/hazardvest = hazard_style
		hazards[initial(hazardvest.name)] = hazardvest
	tweaks += new/datum/loadout_tweak/path(tim_sort(hazards, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/hoodie
	name = "Hoodie - Selection"
	path = /obj/item/clothing/suit/storage/toggle/hoodie

/datum/loadout_entry/suit/hoodie/New()
	..()
	var/list/hoodies = list()
	for(var/hoodie_style in typesof(/obj/item/clothing/suit/storage/toggle/hoodie))
		var/obj/item/clothing/suit/storage/toggle/hoodie/hoodie = hoodie_style
		hoodies[initial(hoodie.name)] = hoodie
	tweaks += new/datum/loadout_tweak/path(tim_sort(hoodies, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/labcoat
	name = "Labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/loadout_entry/suit/labcoat/green
	name = "Labcoat - Green"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/green

/datum/loadout_entry/suit/overalls
	name = "Overalls"
	path = /obj/item/clothing/suit/storage/apron/overalls

/datum/loadout_entry/suit/poncho
	name = "Poncho Selection"
	path = /obj/item/clothing/accessory/poncho

/datum/loadout_entry/suit/poncho/New()
	..()
	var/list/ponchos = list()
	for(var/poncho_style in (typesof(/obj/item/clothing/accessory/poncho) - typesof(/obj/item/clothing/accessory/poncho/roles)))
		var/obj/item/clothing/accessory/poncho/poncho = poncho_style
		ponchos[initial(poncho.name)] = poncho
	tweaks += new/datum/loadout_tweak/path(tim_sort(ponchos, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/dust_cloak_selection
	name = "Dust cloak Selection"
	path = /obj/item/clothing/accessory/poncho/dust_cloak

/datum/loadout_entry/suit/dust_cloak_selection/New()
	..()
	var/list/dustcloak_selection = list()
	for(var/dustcloak in typesof(/obj/item/clothing/accessory/poncho/dust_cloak))
		var/obj/item/clothing/accessory/poncho/dustcloak_type = dustcloak
		dustcloak_selection[initial(dustcloak_type.name)] = dustcloak_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(dustcloak_selection, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/cyberpunk_coat_selection
	name = "Cyberpunk Coat Selection"
	path = /obj/item/clothing/suit/storage/cyberpunk

/datum/loadout_entry/suit/cyberpunk_coat_selection/New()
	..()
	var/list/cybercoat_selection = list()
	for(var/cybercoat in typesof(/obj/item/clothing/suit/storage/cyberpunk))
		var/obj/item/clothing/accessory/poncho/cybercoat_type = cybercoat
		cybercoat_selection[initial(cybercoat_type.name)] = cybercoat_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(cybercoat_selection, GLOBAL_PROC_REF(text_asc)))


// A colorable cloak
/datum/loadout_entry/suit/roles/poncho/cloak
	name = "Cloak - Glowing Light"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/glowing

/datum/loadout_entry/suit/roles/poncho/cloak/dark
	name = "Cloak - Glowing Dark"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/glowingdark

/datum/loadout_entry/suit/roles/poncho/cloak/colorable/
	name = "Cloak - Colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom

/datum/loadout_entry/suit/halfcloak
	name = "Rough Half Cloak (Tan)"
	path = /obj/item/clothing/accessory/poncho/rough_cloak/tan
/datum/loadout_entry/suit/halfcloaktorn
	name = "Rough Torn Half Cloak (Tan)"
	path = /obj/item/clothing/accessory/poncho/rough_cloak_torn/tan
/datum/loadout_entry/suit/halfcloak/colorable
	name = "Rough Half Cloak (Colorable)"
	path = /obj/item/clothing/accessory/poncho/rough_cloak
/datum/loadout_entry/suit/halfcloak/colorable/torn
	name = "Rough Torn Half Cloak (Colorable)"
	path = /obj/item/clothing/accessory/poncho/rough_cloak_torn

/datum/loadout_entry/suit/black_lawyer_jacket
	name = "Suit Jacket - Black"
	path = /obj/item/clothing/suit/storage/toggle/internalaffairs

/datum/loadout_entry/suit/blue_lawyer_jacket
	name = "Suit Jacket - Blue"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket

/datum/loadout_entry/suit/purple_lawyer_jacket
	name = "Suit Jacket - Purple"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/purpjacket

/datum/loadout_entry/suit/suspenders
	name = "Suspenders"
	path = /obj/item/clothing/suit/suspenders

/datum/loadout_entry/suit/wintercoat
	name = "Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/loadout_entry/suit/wintercoat
	name = "Winter Coat - Assistant Formal"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/aformal

/datum/loadout_entry/suit/wintercoat/brass
	name = "Winter Coat - Brassy"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/ratvar/fake

/datum/loadout_entry/suit/wintercoat/runed
	name = "Winter Coat - Runed"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/narsie/fake

/datum/loadout_entry/suit/wintercoat/olive
	name = "Winter Coat - Olive Green"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/olive

/datum/loadout_entry/suit/techrobes
	name = "Techpriest"
	path = /obj/item/clothing/suit/storage/hooded/techpriest

/datum/loadout_entry/suit/varsity
	name = "Varsity Jacket - Selection"
	path = /obj/item/clothing/suit/varsity

/datum/loadout_entry/suit/varsity/New()
	..()
	var/list/varsities = list()
	for(var/varsity_style in typesof(/obj/item/clothing/suit/varsity))
		var/obj/item/clothing/suit/varsity/varsity = varsity_style
		varsities[initial(varsity.name)] = varsity
	tweaks += new/datum/loadout_tweak/path(tim_sort(varsities, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/varsity_worn
	name = "Varsity Jacket - Worn"
	path = /obj/item/clothing/suit/storage/toggle/varsity/worn

/datum/loadout_entry/suit/track
	name = "Track Jacket - Selection"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/loadout_entry/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	tweaks += new/datum/loadout_tweak/path(tim_sort(tracks, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/flannel
	name = "Flannel - Grey"
	path = /obj/item/clothing/suit/storage/flannel

/datum/loadout_entry/suit/flannel/red
	name = "Flannel - Red"
	path = /obj/item/clothing/suit/storage/flannel/red

/datum/loadout_entry/suit/flannel/aqua
	name = "Flannel - Aqua"
	path = /obj/item/clothing/suit/storage/flannel/aqua

/datum/loadout_entry/suit/flannel/brown
	name = "Flannel - Brown"
	path = /obj/item/clothing/suit/storage/flannel/brown

/datum/loadout_entry/suit/denim_jacket
	name = "Denim Jacket"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket

/datum/loadout_entry/suit/denim_jacket/corporate
	name = "Denim Jacket - Corporate"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen

/datum/loadout_entry/suit/denim_vest
	name = "Denim Vest"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless

/datum/loadout_entry/suit/denim_vest/corporate
	name = "Denim Vest - Corporate"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless

/datum/loadout_entry/suit/miscellaneous/kimono
	name = "Kimono"
	path = /obj/item/clothing/suit/kimono

/datum/loadout_entry/suit/miscellaneous/peacoat
	name = "Peacoat"
	path = /obj/item/clothing/suit/storage/toggle/peacoat

/datum/loadout_entry/suit/miscellaneous/kamishimo
	name = "Kamishimo"
	path = /obj/item/clothing/suit/kamishimo

/datum/loadout_entry/suit/snowsuit
	name = "Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit

/datum/loadout_entry/suit/miscellaneous/cardigan
	name = "Cardigan (Colorable)"
	path = /obj/item/clothing/suit/storage/toggle/cardigan

/datum/loadout_entry/suit/storage/dutchcoat
	name = "Western Coat"
	path = /obj/item/clothing/suit/storage/dutchcoat

/datum/loadout_entry/suit/storage/tailcoat
	name = "Tailcoat"
	path = /obj/item/clothing/suit/storage/tailcoat

/datum/loadout_entry/suit/storage/redladvic
	name = "Red Victorian Coat"
	path = /obj/item/clothing/suit/storage/redladiesvictoriancoat

/datum/loadout_entry/suit/storage/ladvic
	name = "Ladies Victorian Coat"
	path = /obj/item/clothing/suit/storage/ladiesvictoriancoat

/datum/loadout_entry/suit/slimleather
	name = "Slim Leather Jacket"
	path = /obj/item/clothing/suit/storage/toggle/slimleather

/datum/loadout_entry/suit/ronincoat
	name = "Ronin Coat"
	path = /obj/item/clothing/suit/storage/toggle/heated/ronincoat

/datum/loadout_entry/suit/runnerjacket
	name = "Runner Jacket"
	path = /obj/item/clothing/suit/storage/toggle/heated

/datum/loadout_entry/suit/halfpintjacket
	name = "Half-Pint Jacket"
	path = /obj/item/clothing/suit/storage/toggle/heated/half_pint

/datum/loadout_entry/suit/halfmoon
	name = "Half Moon Jacket"
	path = /obj/item/clothing/suit/storage/runner/half_moon

/datum/loadout_entry/suit/labcoat_colorable
	name = "Labcoat - Colorable"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/loadout_entry/suit/jacket_modular
	name = "Jacket - Modular"
	path = /obj/item/clothing/suit/storage/fluff/jacket

/datum/loadout_entry/suit/jacket_modular/New()
	..()
	var/list/the_jackets = list()
	for(var/the_jacket in typesof(/obj/item/clothing/suit/storage/fluff/jacket))
		var/obj/item/clothing/suit/jacket_type = the_jacket
		the_jackets[initial(jacket_type.name)] = jacket_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(the_jackets, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/gntop
	name = "GN Crop Jacket"
	path = /obj/item/clothing/suit/storage/fluff/gntop

/datum/loadout_entry/suit/bomber_pilot
	name = "Bomber Jacket - Pilot"
	path = /obj/item/clothing/suit/storage/toggle/bomber/pilot

/datum/loadout_entry/suit/highwayman_jacket
	name = "Black Jacket w/ Fur Lining"
	path = /obj/item/clothing/suit/highwayman_jacket

/datum/loadout_entry/suit/samurai
	name = "Replica Karuta-Gane (Colorable)"
	path = /obj/item/clothing/suit/samurai_replica

/datum/loadout_entry/suit/laconic
	name = "Laconic Field Coat"
	path = /obj/item/clothing/suit/laconic

/datum/loadout_entry/suit/blue_navy_coat
	name = "Navy Blue Coat"
	path = /obj/item/clothing/suit/storage/toggle/navy_coat_blue

/datum/loadout_entry/suit/brown_navy_coat
	name = "Navy Brown Coat"
	path = /obj/item/clothing/suit/storage/toggle/navy_coat_brown

/datum/loadout_entry/suit/green_navy_coat
	name = "Navy Green Coat"
	path = /obj/item/clothing/suit/storage/toggle/navy_coat_green

/datum/loadout_entry/suit/jacket_stripe
	name = "Striped Jacket"
	path = /obj/item/clothing/suit/storage/stripe_jacket

/datum/loadout_entry/suit/jacket_darkfur
	name = "Vexatious Coat w/ Dark Fur Lining"
	path = /obj/item/clothing/suit/darkfur

/datum/loadout_entry/suit/vainglorious
	name = "Vainglorious Hoodie"
	path = /obj/item/clothing/suit/storage/hooded/vainglorious

/datum/loadout_entry/suit/raincoat
	name = "Raincoat"
	path = /obj/item/clothing/suit/storage/hooded/raincoat

/datum/loadout_entry/suit/pullover
	name = "Pullover Hoodie - Selection"
	path = /obj/item/clothing/suit/storage/pullover

/datum/loadout_entry/suit/pullover/New()
	..()
	var/list/pullovers = list()
	for(var/pullover_style in typesof(/obj/item/clothing/suit/storage/pullover))
		var/obj/item/clothing/suit/storage/pullover/pullover = pullover_style
		pullovers[initial(pullover.name)] = pullover
	tweaks += new/datum/loadout_tweak/path(tim_sort(pullovers, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/antediluvian
	name = "Antediluvian Cloak"
	path = /obj/item/clothing/accessory/poncho/antediluvian

/datum/loadout_entry/suit/rainponcho
	name = "Plastic Raincoat"
	path = /obj/item/clothing/suit/storage/hooded/rainponcho

/datum/loadout_entry/suit/mekkyaku
	name = "Mekkyaku Hoodie"
	path = /obj/item/clothing/suit/storage/mekkyaku

/datum/loadout_entry/suit/utility_fur_coat
	name = "Utility Fur Coat"
	path = /obj/item/clothing/suit/storage/utility_fur_coat

/datum/loadout_entry/suit/hobo
	name = "Ragged Coat"
	path = /obj/item/clothing/suit/storage/hobo

/datum/loadout_entry/suit/kamina
	name = "Spiral Hero Cloak"
	path = /obj/item/clothing/suit/storage/kamina

/datum/loadout_entry/suit/nerdshirt
	name = "Nerdy Shirt"
	path = /obj/item/clothing/suit/nerdshirt

/datum/loadout_entry/suit/brownfancycoat
	name = "Brown Fancy Coat"
	path = /obj/item/clothing/suit/storage/toggle/brown_fancycoat

/datum/loadout_entry/suit/motojacket
	name = "Motorcycle Jacket"
	path = /obj/item/clothing/suit/storage/toggle/moto_jacket

/datum/loadout_entry/suit/furcoat
	name = "Furcoat"
	path = /obj/item/clothing/suit/storage/furcoat

/datum/loadout_entry/suit/noble_coat
	name = "Colorful Noble Coat"
	path = /obj/item/clothing/suit/storage/noble_coat

/datum/loadout_entry/suit/mercy_hoodie
	name = "Mercy Robe"
	path = /obj/item/clothing/suit/storage/hooded/mercy

/datum/loadout_entry/suit/cyberpunk
	name = "Cyber Coat"
	path = /obj/item/clothing/suit/storage/cyberpunk

/datum/loadout_entry/suit/cyberpunk_long
	name = "Cyber Coat Long"
	path = /obj/item/clothing/suit/storage/cyberpunk/long

/datum/loadout_entry/suit/bladerunner
	name = "Gun Walker Coat"
	path = /obj/item/clothing/suit/storage/bladerunner

/datum/loadout_entry/suit/overcoat_fancy
	name = "Fancy Overcoat Brown"
	path = /obj/item/clothing/suit/storage/overcoat_fancy

/datum/loadout_entry/suit/drive
	name = "Relatable Jacket"
	path = /obj/item/clothing/suit/storage/drive

/datum/loadout_entry/suit/boxer
	name = "Boxer Jacket"
	path = /obj/item/clothing/suit/storage/drive/boxer

/datum/loadout_entry/suit/tunnelsnake
	name = "Maintenance Python Jacket"
	path = /obj/item/clothing/suit/storage/tunnelsnake

/datum/loadout_entry/suit/triadkiller
	name = "Oriental Coat"
	path = /obj/item/clothing/suit/storage/triadkiller

/datum/loadout_entry/suit/furbomberfancy
	name = "Fancy Fur Bomber Jacket"
	path = /obj/item/clothing/suit/storage/toggle/fur_bomber

/datum/loadout_entry/suit/bomj
	name = "Bomj Coat"
	path = /obj/item/clothing/suit/storage/bomj

/datum/loadout_entry/suit/violetjacket
	name = "Violet Jacket"
	path = /obj/item/clothing/suit/storage/violet

/datum/loadout_entry/suit/jamrock
	name = "Jamrock Blazer"
	path = /obj/item/clothing/suit/storage/jamrock

/datum/loadout_entry/suit/khakijacket
	name = "Khaki Jacket"
	path = /obj/item/clothing/suit/storage/khaki

/datum/loadout_entry/suit/punkvest
	name = "Punk Vest"
	path = /obj/item/clothing/suit/storage/punkvest

/datum/loadout_entry/suit/onestar
	name = "One Star Coat"
	path = /obj/item/clothing/suit/storage/onestar

/datum/loadout_entry/suit/overcoatdark
	name = "Great Dark Overcoat"
	path = /obj/item/clothing/suit/storage/vest/formal/dark

/datum/loadout_entry/suit/overcoatdark/caped
	name = "Great Dark Overcoat Caped"
	path = /obj/item/clothing/suit/storage/vest/formal/dark/caped

/datum/loadout_entry/suit/overcoatbleached
	name = "Great Bleached Overcoat Caped"
	path = /obj/item/clothing/suit/storage/vest/formal/bleached

/datum/loadout_entry/suit/cropped_hoodie
	name = "Cropped Hoodie"
	path = /obj/item/clothing/suit/cropped_hoodie

/datum/loadout_entry/suit/cropped_hoodie/croppier
	name = "Cropped Hoodie (high crop)"
	path = /obj/item/clothing/suit/cropped_hoodie/croppier

/datum/loadout_entry/suit/cropped_hoodie/veryhighcrop
	name = "Cropped Hoodie (very high crop)"
	path = /obj/item/clothing/suit/cropped_hoodie/croppierer

/datum/loadout_entry/suit/cropped_hoodie/croppiest
	name = "Cropped Hoodie (supercrop)"
	path = /obj/item/clothing/suit/cropped_hoodie/croppiest

/datum/loadout_entry/suit/leather_cropped
	name = "Cropped Leather Jacket"
	path = /obj/item/clothing/suit/storage/leather_cropped

/datum/loadout_entry/suit/leather_supercropped
	name = "Supercropped Leather Jacket"
	path = /obj/item/clothing/suit/storage/leather_supercropped

//Tajaran wears

//Cloak no hoods

/datum/loadout_entry/suit/tajarancloak
	name = "Adhomian basic cloak selection"
	description = "A selection of tajaran native cloaks."
	path = /obj/item/clothing/accessory/tponcho/tajarancloak

/datum/loadout_entry/suit/tajarancloak/New()
	..()
	var/list/tajarancloaks = list()
	for(var/tajarancloak in (typesof(/obj/item/clothing/accessory/tponcho/tajarancloak)))
		var/obj/item/clothing/accessory/tponcho/tajarancloak/tajarancloak_type = tajarancloak
		tajarancloaks[initial(tajarancloak_type.name)] = tajarancloak_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(tajarancloaks, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/tajarancloakhood
	name = "Adhomian hooded cloak selection"
	description = "A selection of tajaran native cloaks. These ones have hoods"
	path = /obj/item/clothing/suit/storage/hooded/tajaran/cloak

/datum/loadout_entry/suit/tajarancloakhood/New()
	..()
	var/list/tajarancloakhoods = list()
	for(var/tajarancloakhood in (typesof(/obj/item/clothing/suit/storage/hooded/tajaran/cloak)))
		var/obj/item/clothing/suit/storage/hooded/tajaran/cloak/tajarancloakhood_type = tajarancloakhood
		tajarancloakhoods[initial(tajarancloakhood_type.name)] = tajarancloakhood_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(tajarancloakhoods, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/tajara_coat
	name = "Adhomian coat selection"
	description = "A selection of tajaran native coats."
	path = /obj/item/clothing/suit/storage/toggle/tajaran/coat

/datum/loadout_entry/suit/tajara_coat/New()
	..()
	var/list/tajara_coats = list()
	for(var/tajara_coat in (typesof(/obj/item/clothing/suit/storage/toggle/tajaran/coat)))
		var/obj/item/clothing/suit/storage/toggle/tajaran/coat/tajara_coat_type = tajara_coat
		tajara_coats[initial(tajara_coat_type.name)] = tajara_coat_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(tajara_coats, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/tajara_coat_alt //No toggle
	name = "Adhomian coat alt selection"
	description = "A alternative selection of tajaran native coats."
	path = /obj/item/clothing/suit/storage/tajaran/coat

/datum/loadout_entry/suit/tajara_coat_alt/New()
	..()
	var/list/tajara_coat_alts = list()
	for(var/tajara_coat_alt in (typesof(/obj/item/clothing/suit/storage/tajaran/coat)))
		var/obj/item/clothing/suit/storage/tajaran/coat/tajara_coat_alt_type = tajara_coat_alt
		tajara_coat_alts[initial(tajara_coat_alt_type.name)] = tajara_coat_alt_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(tajara_coat_alts, GLOBAL_PROC_REF(text_asc)))

/datum/loadout_entry/suit/tajara_jacket
	name = "Adhomian jacket selection"
	description = "A selection of tajaran native jackets."
	path = /obj/item/clothing/suit/storage/tajaran/jacket

/datum/loadout_entry/suit/tajara_jacket/New()
	..()
	var/list/tajara_jackets = list()
	for(var/tajara_jacket in (typesof(/obj/item/clothing/suit/storage/tajaran/jacket)))
		var/obj/item/clothing/suit/storage/tajaran/jacket/tajara_jacket_type = tajara_jacket
		tajara_jackets[initial(tajara_jacket_type.name)] = tajara_jacket_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(tajara_jackets, GLOBAL_PROC_REF(text_asc)))
