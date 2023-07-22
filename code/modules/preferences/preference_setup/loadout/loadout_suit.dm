// Suit slot
/datum/gear/suit
	name = "Apron - Blue"
	path = /obj/item/clothing/suit/storage/apron
	slot = SLOT_ID_SUIT
	sort_category = LOADOUT_CATEGORY_SUITS

/datum/gear/suit/apron_white
	name = "Apron - Colorable"
	path = /obj/item/clothing/suit/storage/apron/white

/datum/gear/suit/apron_white/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/greatcoat
	name = "Greatcoat"
	path = /obj/item/clothing/suit/greatcoat

/datum/gear/suit/leather_coat
	name = "Leather Coat"
	path = /obj/item/clothing/suit/leathercoat

/datum/gear/suit/overcoat
	name = "Leather Overcoat"
	path = /obj/item/clothing/suit/overcoat

/datum/gear/suit/puffer_coat
	name = "Puffer Coat"
	path = /obj/item/clothing/suit/jacket/puffer

/datum/gear/suit/puffer_vest
	name = "Puffer Vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/gear/suit/bomber
	name = "Bomber Jacket"
	path = /obj/item/clothing/suit/storage/toggle/bomber

/datum/gear/suit/bomber_alt
	name = "Bomber Jacket Alt"
	path = /obj/item/clothing/suit/storage/bomber/alt

/datum/gear/suit/storage/gothcoat
	name = "Gothic Coat"
	path = /obj/item/clothing/suit/storage/gothcoat

/datum/gear/suit/leather_jacket
	name = "Leather Jacket - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather_jacket_sleeveless
	name = "Leather Vest - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless

/datum/gear/suit/leather_jacket_alt
	name = "Leather Jacket Alt - Black"
	path = /obj/item/clothing/suit/storage/leather_jacket_alt

/datum/gear/suit/leather_jacket_nt
	name = "Leather Jacket - Corporate - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen

/datum/gear/suit/leather_jacket_nt/sleeveless
	name = "Leather Vest - Corporate - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless

/datum/gear/suit/brown_jacket
	name = "Leather Jacket - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket

/datum/gear/suit/brown_jacket_sleeveless
	name = "Leather Vest - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless

/datum/gear/suit/brown_jacket_nt
	name = "Leather Jacket - Corporate - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen

/datum/gear/suit/brown_jacket_nt/sleeveless
	name = "Leather Vest - Corporate, Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless

/datum/gear/suit/mil
	name = "Military Jacket - Selection"
	path = /obj/item/clothing/suit/storage/miljacket

/datum/gear/suit/mil/New()
	..()
	var/list/mil_jackets = list()
	for(var/military_style in typesof(/obj/item/clothing/suit/storage/miljacket))
		var/obj/item/clothing/suit/storage/miljacket/miljacket = military_style
		mil_jackets[initial(miljacket.name)] = miljacket
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(mil_jackets, /proc/cmp_text_asc))

/datum/gear/suit/greyjacket
	name = "Jacket - Grey"
	path = /obj/item/clothing/suit/storage/greyjacket

/datum/gear/suit/brown_trenchcoat
	name = "Trenchcoat - Brown"
	path = /obj/item/clothing/suit/storage/trench

/datum/gear/suit/grey_trenchcoat
	name = "Trenchcoat - Grey"
	path = /obj/item/clothing/suit/storage/trench/grey

/datum/gear/suit/duster
	name = "Cowboy Duster"
	path = /obj/item/clothing/suit/storage/duster

/datum/gear/suit/duster/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/hazard_vest
	name = "Hazard Vest - Selection"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard_vest/New()
	..()
	var/list/hazards = list()
	for(var/hazard_style in typesof(/obj/item/clothing/suit/storage/hazardvest))
		var/obj/item/clothing/suit/storage/hazardvest/hazardvest = hazard_style
		hazards[initial(hazardvest.name)] = hazardvest
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(hazards, /proc/cmp_text_asc))

/datum/gear/suit/hoodie
	name = "Hoodie - Selection"
	path = /obj/item/clothing/suit/storage/toggle/hoodie

/datum/gear/suit/hoodie/New()
	..()
	var/list/hoodies = list()
	for(var/hoodie_style in typesof(/obj/item/clothing/suit/storage/toggle/hoodie))
		var/obj/item/clothing/suit/storage/toggle/hoodie/hoodie = hoodie_style
		hoodies[initial(hoodie.name)] = hoodie
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(hoodies, /proc/cmp_text_asc))

/datum/gear/suit/labcoat
	name = "Labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat/green
	name = "Labcoat - Green"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/green

/datum/gear/suit/overalls
	name = "Overalls"
	path = /obj/item/clothing/suit/storage/apron/overalls

/datum/gear/suit/poncho
	name = "Poncho Selection"
	path = /obj/item/clothing/accessory/poncho

/datum/gear/suit/poncho/New()
	..()
	var/list/ponchos = list()
	for(var/poncho_style in (typesof(/obj/item/clothing/accessory/poncho) - typesof(/obj/item/clothing/accessory/poncho/roles)))
		var/obj/item/clothing/accessory/poncho/poncho = poncho_style
		ponchos[initial(poncho.name)] = poncho
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(ponchos, /proc/cmp_text_asc))

/datum/gear/suit/dust_cloak_selection
	name = "Dust cloak Selection"
	path = /obj/item/clothing/accessory/poncho/dust_cloak

/datum/gear/suit/dust_cloak_selection/New()
	..()
	var/list/dustcloak_selection = list()
	for(var/dustcloak in typesof(/obj/item/clothing/accessory/poncho/dust_cloak))
		var/obj/item/clothing/accessory/poncho/dustcloak_type = dustcloak
		dustcloak_selection[initial(dustcloak_type.name)] = dustcloak_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(dustcloak_selection, /proc/cmp_text_asc))

/datum/gear/suit/cyberpunk_coat_selection
	name = "Cyberpunk Coat Selection"
	path = /obj/item/clothing/suit/storage/cyberpunk

/datum/gear/suit/cyberpunk_coat_selection/New()
	..()
	var/list/cybercoat_selection = list()
	for(var/cybercoat in typesof(/obj/item/clothing/suit/storage/cyberpunk))
		var/obj/item/clothing/accessory/poncho/cybercoat_type = cybercoat
		cybercoat_selection[initial(cybercoat_type.name)] = cybercoat_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(cybercoat_selection, /proc/cmp_text_asc))


// A colorable cloak
/datum/gear/suit/roles/poncho/cloak
	name = "Cloak - Glowing Light"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/glowing

/datum/gear/suit/roles/poncho/cloak/dark
	name = "Cloak - Glowing Dark"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/glowingdark

/datum/gear/suit/roles/poncho/cloak/colorable/
	name = "Cloak - Colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom

/datum/gear/suit/roles/poncho/cloak/colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/halfcloak
	name = "Rough Half Cloak (Tan)"
	path = /obj/item/clothing/accessory/poncho/rough_cloak/tan
/datum/gear/suit/halfcloaktorn
	name = "Rough Torn Half Cloak (Tan)"
	path = /obj/item/clothing/accessory/poncho/rough_cloak_torn/tan
/datum/gear/suit/halfcloak/colorable
	name = "Rough Half Cloak (Colorable)"
	path = /obj/item/clothing/accessory/poncho/rough_cloak

/datum/gear/suit/halfcloak/colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice
/datum/gear/suit/halfcloak/colorable/torn
	name = "Rough Torn Half Cloak (Colorable)"
	path = /obj/item/clothing/accessory/poncho/rough_cloak_torn

/datum/gear/suit/black_lawyer_jacket
	name = "Suit Jacket - Black"
	path = /obj/item/clothing/suit/storage/toggle/internalaffairs

/datum/gear/suit/blue_lawyer_jacket
	name = "Suit Jacket - Blue"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket

/datum/gear/suit/purple_lawyer_jacket
	name = "Suit Jacket - Purple"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/purpjacket

/datum/gear/suit/suspenders
	name = "Suspenders"
	path = /obj/item/clothing/suit/suspenders

/datum/gear/suit/wintercoat
	name = "Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/gear/suit/wintercoat
	name = "Winter Coat - Assistant Formal"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/aformal

/datum/gear/suit/wintercoat/brass
	name = "Winter Coat - Brassy"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/ratvar/fake

/datum/gear/suit/wintercoat/runed
	name = "Winter Coat - Runed"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/narsie/fake

/datum/gear/suit/wintercoat/olive
	name = "Winter Coat - Olive Green"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/olive

/datum/gear/suit/techrobes
	name = "Techpriest"
	path = /obj/item/clothing/suit/storage/hooded/techpriest

/datum/gear/suit/varsity
	name = "Varsity Jacket - Selection"
	path = /obj/item/clothing/suit/varsity

/datum/gear/suit/varsity/New()
	..()
	var/list/varsities = list()
	for(var/varsity_style in typesof(/obj/item/clothing/suit/varsity))
		var/obj/item/clothing/suit/varsity/varsity = varsity_style
		varsities[initial(varsity.name)] = varsity
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(varsities, /proc/cmp_text_asc))

/datum/gear/suit/varsity_worn
	name = "Varsity Jacket - Worn"
	path = /obj/item/clothing/suit/storage/toggle/varsity/worn

/datum/gear/suit/track
	name = "Track Jacket - Selection"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/gear/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(tracks, /proc/cmp_text_asc))

/datum/gear/suit/flannel
	name = "Flannel - Grey"
	path = /obj/item/clothing/suit/storage/flannel

/datum/gear/suit/flannel/red
	name = "Flannel - Red"
	path = /obj/item/clothing/suit/storage/flannel/red

/datum/gear/suit/flannel/aqua
	name = "Flannel - Aqua"
	path = /obj/item/clothing/suit/storage/flannel/aqua

/datum/gear/suit/flannel/brown
	name = "Flannel - Brown"
	path = /obj/item/clothing/suit/storage/flannel/brown

/datum/gear/suit/denim_jacket
	name = "Denim Jacket"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket

/datum/gear/suit/denim_jacket/corporate
	name = "Denim Jacket - Corporate"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen

/datum/gear/suit/denim_vest
	name = "Denim Vest"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless

/datum/gear/suit/denim_vest/corporate
	name = "Denim Vest - Corporate"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless

/datum/gear/suit/miscellaneous/kimono
	name = "Kimono"
	path = /obj/item/clothing/suit/kimono

/datum/gear/suit/miscellaneous/kimono/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/miscellaneous/peacoat
	name = "Peacoat"
	path = /obj/item/clothing/suit/storage/toggle/peacoat

/datum/gear/suit/miscellaneous/peacoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/miscellaneous/kamishimo
	name = "Kamishimo"
	path = /obj/item/clothing/suit/kamishimo

/datum/gear/suit/snowsuit
	name = "Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit

/datum/gear/suit/miscellaneous/cardigan
	name = "Cardigan (Colorable)"
	path = /obj/item/clothing/suit/storage/toggle/cardigan

/datum/gear/suit/miscellaneous/cardigan/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/storage/dutchcoat
	name = "Western Coat"
	path = /obj/item/clothing/suit/storage/dutchcoat

/datum/gear/suit/storage/tailcoat
	name = "Tailcoat"
	path = /obj/item/clothing/suit/storage/tailcoat

/datum/gear/suit/storage/redladvic
	name = "Red Victorian Coat"
	path = /obj/item/clothing/suit/storage/redladiesvictoriancoat

/datum/gear/suit/storage/ladvic
	name = "Ladies Victorian Coat"
	path = /obj/item/clothing/suit/storage/ladiesvictoriancoat

/datum/gear/suit/slimleather
	name = "Slim Leather Jacket"
	path = /obj/item/clothing/suit/storage/toggle/slimleather

/datum/gear/suit/ronincoat
	name = "Ronin Coat"
	path = /obj/item/clothing/suit/storage/toggle/heated/ronincoat

/datum/gear/suit/runnerjacket
	name = "Runner Jacket"
	path = /obj/item/clothing/suit/storage/toggle/heated

/datum/gear/suit/halfpintjacket
	name = "Half-Pint Jacket"
	path = /obj/item/clothing/suit/storage/toggle/heated/half_pint

/datum/gear/suit/halfmoon
	name = "Half Moon Jacket"
	path = /obj/item/clothing/suit/storage/runner/half_moon

/datum/gear/suit/labcoat_colorable
	name = "Labcoat - Colorable"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/jacket_modular
	name = "Jacket - Modular"
	path = /obj/item/clothing/suit/storage/fluff/jacket

/datum/gear/suit/jacket_modular/New()
	..()
	var/list/the_jackets = list()
	for(var/the_jacket in typesof(/obj/item/clothing/suit/storage/fluff/jacket))
		var/obj/item/clothing/suit/jacket_type = the_jacket
		the_jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(the_jackets, /proc/cmp_text_asc))

/datum/gear/suit/gntop
	name = "GN Crop Jacket"
	path = /obj/item/clothing/suit/storage/fluff/gntop

/datum/gear/suit/bomber_pilot
	name = "Bomber Jacket - Pilot"
	path = /obj/item/clothing/suit/storage/toggle/bomber/pilot

/datum/gear/suit/highwayman_jacket
	name = "Black Jacket w/ Fur Lining"
	path = /obj/item/clothing/suit/highwayman_jacket

/datum/gear/suit/samurai
	name = "Replica Karuta-Gane (Colorable)"
	path = /obj/item/clothing/suit/samurai_replica

/datum/gear/suit/samurai/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/laconic
	name = "Laconic Field Coat"
	path = /obj/item/clothing/suit/laconic

/datum/gear/suit/blue_navy_coat
	name = "Navy Blue Coat"
	path = /obj/item/clothing/suit/storage/toggle/navy_coat_blue

/datum/gear/suit/brown_navy_coat
	name = "Navy Brown Coat"
	path = /obj/item/clothing/suit/storage/toggle/navy_coat_brown

/datum/gear/suit/green_navy_coat
	name = "Navy Green Coat"
	path = /obj/item/clothing/suit/storage/toggle/navy_coat_green

/datum/gear/suit/jacket_stripe
	name = "Striped Jacket"
	path = /obj/item/clothing/suit/storage/stripe_jacket

/datum/gear/suit/jacket_darkfur
	name = "Vexatious Coat w/ Dark Fur Lining"
	path = /obj/item/clothing/suit/darkfur

/datum/gear/suit/vainglorious
	name = "Vainglorious Hoodie"
	path = /obj/item/clothing/suit/storage/hooded/vainglorious

/datum/gear/suit/raincoat
	name = "Raincoat"
	path = /obj/item/clothing/suit/storage/hooded/raincoat

/datum/gear/suit/pullover
	name = "Pullover Hoodie - Selection"
	path = /obj/item/clothing/suit/storage/pullover

/datum/gear/suit/pullover/New()
	..()
	var/list/pullovers = list()
	for(var/pullover_style in typesof(/obj/item/clothing/suit/storage/pullover))
		var/obj/item/clothing/suit/storage/pullover/pullover = pullover_style
		pullovers[initial(pullover.name)] = pullover
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(pullovers, /proc/cmp_text_asc))

/datum/gear/suit/antediluvian
	name = "Antediluvian Cloak"
	path = /obj/item/clothing/accessory/poncho/antediluvian

/datum/gear/suit/rainponcho
	name = "Plastic Raincoat"
	path = /obj/item/clothing/suit/storage/hooded/rainponcho

/datum/gear/suit/mekkyaku
	name = "Mekkyaku Hoodie"
	path = /obj/item/clothing/suit/storage/mekkyaku

/datum/gear/suit/utility_fur_coat
	name = "Utility Fur Coat"
	path = /obj/item/clothing/suit/storage/utility_fur_coat

/datum/gear/suit/hobo
	name = "Ragged Coat"
	path = /obj/item/clothing/suit/storage/hobo

/datum/gear/suit/kamina
	name = "Spiral Hero Cloak"
	path = /obj/item/clothing/suit/storage/kamina

/datum/gear/suit/nerdshirt
	name = "Nerdy Shirt"
	path = /obj/item/clothing/suit/nerdshirt

/datum/gear/suit/brownfancycoat
	name = "Brown Fancy Coat"
	path = /obj/item/clothing/suit/storage/toggle/brown_fancycoat

/datum/gear/suit/motojacket
	name = "Motorcycle Jacket"
	path = /obj/item/clothing/suit/storage/toggle/moto_jacket

/datum/gear/suit/furcoat
	name = "Furcoat"
	path = /obj/item/clothing/suit/storage/furcoat

/datum/gear/suit/noble_coat
	name = "Colorful Noble Coat"
	path = /obj/item/clothing/suit/storage/noble_coat

/datum/gear/suit/mercy_hoodie
	name = "Mercy Robe"
	path = /obj/item/clothing/suit/storage/hooded/mercy

/datum/gear/suit/cyberpunk
	name = "Cyber Coat"
	path = /obj/item/clothing/suit/storage/cyberpunk

/datum/gear/suit/cyberpunk_long
	name = "Cyber Coat Long"
	path = /obj/item/clothing/suit/storage/cyberpunk/long

/datum/gear/suit/bladerunner
	name = "Gun Walker Coat"
	path = /obj/item/clothing/suit/storage/bladerunner

/datum/gear/suit/overcoat_fancy
	name = "Fancy Overcoat Brown"
	path = /obj/item/clothing/suit/storage/overcoat_fancy

/datum/gear/suit/drive
	name = "Relatable Jacket"
	path = /obj/item/clothing/suit/storage/drive

/datum/gear/suit/boxer
	name = "Boxer Jacket"
	path = /obj/item/clothing/suit/storage/drive/boxer

/datum/gear/suit/tunnelsnake
	name = "Maintenance Python Jacket"
	path = /obj/item/clothing/suit/storage/tunnelsnake

/datum/gear/suit/triadkiller
	name = "Oriental Coat"
	path = /obj/item/clothing/suit/storage/triadkiller

/datum/gear/suit/furbomberfancy
	name = "Fancy Fur Bomber Jacket"
	path = /obj/item/clothing/suit/storage/toggle/fur_bomber

/datum/gear/suit/bomj
	name = "Bomj Coat"
	path = /obj/item/clothing/suit/storage/bomj

/datum/gear/suit/violetjacket
	name = "Violet Jacket"
	path = /obj/item/clothing/suit/storage/violet

/datum/gear/suit/jamrock
	name = "Jamrock Blazer"
	path = /obj/item/clothing/suit/storage/jamrock

/datum/gear/suit/khakijacket
	name = "Khaki Jacket"
	path = /obj/item/clothing/suit/storage/khaki

/datum/gear/suit/punkvest
	name = "Punk Vest"
	path = /obj/item/clothing/suit/storage/punkvest

/datum/gear/suit/onestar
	name = "One Star Coat"
	path = /obj/item/clothing/suit/storage/onestar

/datum/gear/suit/overcoatdark
	name = "Great Dark Overcoat"
	path = /obj/item/clothing/suit/storage/vest/formal/dark

/datum/gear/suit/overcoatdark/caped
	name = "Great Dark Overcoat Caped"
	path = /obj/item/clothing/suit/storage/vest/formal/dark/caped

/datum/gear/suit/overcoatbleached
	name = "Great Bleached Overcoat Caped"
	path = /obj/item/clothing/suit/storage/vest/formal/bleached

/datum/gear/suit/cropped_hoodie
	name = "Cropped Hoodie"
	path = /obj/item/clothing/suit/cropped_hoodie

/datum/gear/suit/cropped_hoodie/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/cropped_hoodie/croppier
	name = "Cropped Hoodie (high crop)"
	path = /obj/item/clothing/suit/cropped_hoodie/croppier

/datum/gear/suit/cropped_hoodie/veryhighcrop
	name = "Cropped Hoodie (very high crop)"
	path = /obj/item/clothing/suit/cropped_hoodie/croppierer

/datum/gear/suit/cropped_hoodie/croppiest
	name = "Cropped Hoodie (supercrop)"
	path = /obj/item/clothing/suit/cropped_hoodie/croppiest

/datum/gear/suit/leather_cropped
	name = "Cropped Leather Jacket"
	path = /obj/item/clothing/suit/storage/leather_cropped

/datum/gear/suit/leather_supercropped
	name = "Supercropped Leather Jacket"
	path = /obj/item/clothing/suit/storage/leather_supercropped

//Tajaran wears

//Cloak no hoods

/datum/gear/suit/tajarancloak
	name = "Adhomian basic cloak selection"
	description = "A selection of tajaran native cloaks."
	path = /obj/item/clothing/accessory/tponcho/tajarancloak

/datum/gear/suit/tajarancloak/New()
	..()
	var/list/tajarancloaks = list()
	for(var/tajarancloak in (typesof(/obj/item/clothing/accessory/tponcho/tajarancloak)))
		var/obj/item/clothing/accessory/tponcho/tajarancloak/tajarancloak_type = tajarancloak
		tajarancloaks[initial(tajarancloak_type.name)] = tajarancloak_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(tajarancloaks, /proc/cmp_text_asc))

/datum/gear/suit/tajarancloakhood
	name = "Adhomian hooded cloak selection"
	description = "A selection of tajaran native cloaks. These ones have hoods"
	path = /obj/item/clothing/suit/storage/hooded/tajaran/cloak

/datum/gear/suit/tajarancloakhood/New()
	..()
	var/list/tajarancloakhoods = list()
	for(var/tajarancloakhood in (typesof(/obj/item/clothing/suit/storage/hooded/tajaran/cloak)))
		var/obj/item/clothing/suit/storage/hooded/tajaran/cloak/tajarancloakhood_type = tajarancloakhood
		tajarancloakhoods[initial(tajarancloakhood_type.name)] = tajarancloakhood_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(tajarancloakhoods, /proc/cmp_text_asc))

/datum/gear/suit/tajara_coat
	name = "Adhomian coat selection"
	description = "A selection of tajaran native coats."
	path = /obj/item/clothing/suit/storage/toggle/tajaran/coat

/datum/gear/suit/tajara_coat/New()
	..()
	var/list/tajara_coats = list()
	for(var/tajara_coat in (typesof(/obj/item/clothing/suit/storage/toggle/tajaran/coat)))
		var/obj/item/clothing/suit/storage/toggle/tajaran/coat/tajara_coat_type = tajara_coat
		tajara_coats[initial(tajara_coat_type.name)] = tajara_coat_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(tajara_coats, /proc/cmp_text_asc))

/datum/gear/suit/tajara_coat_alt //No toggle
	name = "Adhomian coat alt selection"
	description = "A alternative selection of tajaran native coats."
	path = /obj/item/clothing/suit/storage/tajaran/coat

/datum/gear/suit/tajara_coat_alt/New()
	..()
	var/list/tajara_coat_alts = list()
	for(var/tajara_coat_alt in (typesof(/obj/item/clothing/suit/storage/tajaran/coat)))
		var/obj/item/clothing/suit/storage/tajaran/coat/tajara_coat_alt_type = tajara_coat_alt
		tajara_coat_alts[initial(tajara_coat_alt_type.name)] = tajara_coat_alt_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(tajara_coat_alts, /proc/cmp_text_asc))

/datum/gear/suit/tajara_jacket
	name = "Adhomian jacket selection"
	description = "A selection of tajaran native jackets."
	path = /obj/item/clothing/suit/storage/tajaran/jacket

/datum/gear/suit/tajara_jacket/New()
	..()
	var/list/tajara_jackets = list()
	for(var/tajara_jacket in (typesof(/obj/item/clothing/suit/storage/tajaran/jacket)))
		var/obj/item/clothing/suit/storage/tajaran/jacket/tajara_jacket_type = tajara_jacket
		tajara_jackets[initial(tajara_jacket_type.name)] = tajara_jacket_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(tajara_jackets, /proc/cmp_text_asc))
