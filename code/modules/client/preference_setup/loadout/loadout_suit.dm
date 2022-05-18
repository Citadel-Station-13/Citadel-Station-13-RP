// Suit slot
/datum/gear/suit
	display_name = "Apron - Blue"
	path = /obj/item/clothing/suit/storage/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"

/datum/gear/suit/apron_white
	display_name = "Apron - Colorable"
	path = /obj/item/clothing/suit/storage/apron/white

/datum/gear/suit/apron_white/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/greatcoat
	display_name = "Greatcoat"
	path = /obj/item/clothing/suit/greatcoat

/datum/gear/suit/leather_coat
	display_name = "Leather Coat"
	path = /obj/item/clothing/suit/leathercoat

/datum/gear/suit/puffer_coat
	display_name = "Puffer Coat"
	path = /obj/item/clothing/suit/jacket/puffer

/datum/gear/suit/puffer_vest
	display_name = "Puffer Vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/gear/suit/bomber
	display_name = "Bomber Jacket"
	path = /obj/item/clothing/suit/storage/toggle/bomber

/datum/gear/suit/bomber_alt
	display_name = "Bomber Jacket Alt"
	path = /obj/item/clothing/suit/storage/bomber/alt

/datum/gear/suit/storage/gothcoat
	display_name = "Gothic Coat"
	path = /obj/item/clothing/suit/storage/gothcoat

/datum/gear/suit/leather_jacket
	display_name = "Leather Jacket - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather_jacket_sleeveless
	display_name = "Leather Vest - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless

/datum/gear/suit/leather_jacket_alt
	display_name = "Leather Jacket Alt - Black"
	path = /obj/item/clothing/suit/storage/leather_jacket_alt

/datum/gear/suit/leather_jacket_nt
	display_name = "Leather Jacket - Corporate - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen

/datum/gear/suit/leather_jacket_nt/sleeveless
	display_name = "Leather Vest - Corporate - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless

/datum/gear/suit/brown_jacket
	display_name = "Leather Jacket - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket

/datum/gear/suit/brown_jacket_sleeveless
	display_name = "Leather Vest - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless

/datum/gear/suit/brown_jacket_nt
	display_name = "Leather Jacket - Corporate - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen

/datum/gear/suit/brown_jacket_nt/sleeveless
	display_name = "Leather Vest - Corporate, Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless

/datum/gear/suit/mil
	display_name = "Military Jacket - Selection"
	path = /obj/item/clothing/suit/storage/miljacket

/datum/gear/suit/mil/New()
	..()
	var/list/mil_jackets = list()
	for(var/military_style in typesof(/obj/item/clothing/suit/storage/miljacket))
		var/obj/item/clothing/suit/storage/miljacket/miljacket = military_style
		mil_jackets[initial(miljacket.name)] = miljacket
	gear_tweaks += new/datum/gear_tweak/path(sortTim(mil_jackets, /proc/cmp_text_asc))

/datum/gear/suit/greyjacket
	display_name = "Jacket - Grey"
	path = /obj/item/clothing/suit/storage/greyjacket

/datum/gear/suit/brown_trenchcoat
	display_name = "Trenchcoat - Brown"
	path = /obj/item/clothing/suit/storage/trench

/datum/gear/suit/grey_trenchcoat
	display_name = "Trenchcoat - Grey"
	path = /obj/item/clothing/suit/storage/trench/grey

datum/gear/suit/duster
	display_name = "Cowboy Duster"
	path = /obj/item/clothing/suit/storage/duster

/datum/gear/suit/duster/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/hazard_vest
	display_name = "Hazard Vest - Selection"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard_vest/New()
	..()
	var/list/hazards = list()
	for(var/hazard_style in typesof(/obj/item/clothing/suit/storage/hazardvest))
		var/obj/item/clothing/suit/storage/hazardvest/hazardvest = hazard_style
		hazards[initial(hazardvest.name)] = hazardvest
	gear_tweaks += new/datum/gear_tweak/path(sortTim(hazards, /proc/cmp_text_asc))

/datum/gear/suit/hoodie
	display_name = "Hoodie - Selection"
	path = /obj/item/clothing/suit/storage/toggle/hoodie

/datum/gear/suit/hoodie/New()
	..()
	var/list/hoodies = list()
	for(var/hoodie_style in typesof(/obj/item/clothing/suit/storage/toggle/hoodie))
		var/obj/item/clothing/suit/storage/toggle/hoodie/hoodie = hoodie_style
		hoodies[initial(hoodie.name)] = hoodie
	gear_tweaks += new/datum/gear_tweak/path(sortTim(hoodies, /proc/cmp_text_asc))

/datum/gear/suit/labcoat
	display_name = "Labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat/blue
	display_name = "Labcoat - Blue"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue

/datum/gear/suit/labcoat/blue_edge
	display_name = "Labcoat - Blue-Edged"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue_edge

/datum/gear/suit/labcoat/green
	display_name = "Labcoat - Green"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/green

/datum/gear/suit/labcoat/orange
	display_name = "Labcoat - Orange"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/orange

/datum/gear/suit/labcoat/purple
	display_name = "Labcoat - Purple"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/purple

/datum/gear/suit/labcoat/pink
	display_name = "Labcoat - Pink"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/pink

/datum/gear/suit/labcoat/red
	display_name = "Labcoat - Red"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/red

/datum/gear/suit/labcoat/yellow
	display_name = "Labcoat - Yellow"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/yellow

/datum/gear/suit/overalls
	display_name = "Overalls"
	path = /obj/item/clothing/suit/storage/apron/overalls

/datum/gear/suit/poncho
	display_name = "Poncho Selection"
	path = /obj/item/clothing/accessory/poncho

/datum/gear/suit/poncho/New()
	..()
	var/list/ponchos = list()
	for(var/poncho_style in (typesof(/obj/item/clothing/accessory/poncho) - typesof(/obj/item/clothing/accessory/poncho/roles)))
		var/obj/item/clothing/accessory/poncho/poncho = poncho_style
		ponchos[initial(poncho.name)] = poncho
	gear_tweaks += new/datum/gear_tweak/path(sortTim(ponchos, /proc/cmp_text_asc))

// A colorable cloak
/datum/gear/suit/roles/poncho/cloak
	display_name = "Cloak - Glowing Light"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/glowing

/datum/gear/suit/roles/poncho/cloak/dark
	display_name = "Cloak - Glowing Dark"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/glowingdark

/datum/gear/suit/roles/poncho/cloak/colorable/
	display_name = "Cloak - Colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom

/datum/gear/suit/roles/poncho/cloak/colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/black_lawyer_jacket
	display_name = "Suit Jacket - Black"
	path = /obj/item/clothing/suit/storage/toggle/internalaffairs

/datum/gear/suit/blue_lawyer_jacket
	display_name = "Suit Jacket - Blue"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket

/datum/gear/suit/purple_lawyer_jacket
	display_name = "Suit Jacket - Purple"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/purpjacket

/datum/gear/suit/suspenders
	display_name = "Suspenders"
	path = /obj/item/clothing/suit/suspenders

/datum/gear/suit/wintercoat
	display_name = "Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/gear/suit/wintercoat
	display_name = "Winter Coat - Assistant Formal"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/aformal

/datum/gear/suit/wintercoat/brass
	display_name = "Winter Coat - Brassy"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/ratvar/fake

/datum/gear/suit/wintercoat/runed
	display_name = "Winter Coat - Runed"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/narsie/fake

/datum/gear/suit/wintercoat/olive
	display_name = "Winter Coat - Olive Green"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/olive

/datum/gear/suit/techrobes
	display_name = "Techpriest"
	path = /obj/item/clothing/suit/storage/hooded/techpriest

/datum/gear/suit/varsity
	display_name = "Varsity Jacket - Selection"
	path = /obj/item/clothing/suit/varsity

/datum/gear/suit/varsity/New()
	..()
	var/list/varsities = list()
	for(var/varsity_style in typesof(/obj/item/clothing/suit/varsity))
		var/obj/item/clothing/suit/varsity/varsity = varsity_style
		varsities[initial(varsity.name)] = varsity
	gear_tweaks += new/datum/gear_tweak/path(sortTim(varsities, /proc/cmp_text_asc))

/datum/gear/suit/track
	display_name = "Track Jacket - Selection"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/gear/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	gear_tweaks += new/datum/gear_tweak/path(sortTim(tracks, /proc/cmp_text_asc))

/datum/gear/suit/flannel
	display_name = "Flannel - Grey"
	path = /obj/item/clothing/suit/storage/flannel

/datum/gear/suit/flannel/red
	display_name = "Flannel - Red"
	path = /obj/item/clothing/suit/storage/flannel/red

/datum/gear/suit/flannel/aqua
	display_name = "Flannel - Aqua"
	path = /obj/item/clothing/suit/storage/flannel/aqua

/datum/gear/suit/flannel/brown
	display_name = "Flannel - Brown"
	path = /obj/item/clothing/suit/storage/flannel/brown

/datum/gear/suit/denim_jacket
	display_name = "Denim Jacket"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket

/datum/gear/suit/denim_jacket/corporate
	display_name = "Denim Jacket - Corporate"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen

/datum/gear/suit/denim_vest
	display_name = "Denim Vest"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless

/datum/gear/suit/denim_vest/corporate
	display_name = "Denim Vest - Corporate"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless

/datum/gear/suit/miscellaneous/kimono
	display_name = "Kimono"
	path = /obj/item/clothing/suit/kimono

/datum/gear/suit/miscellaneous/kimono/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/miscellaneous/peacoat
	display_name = "Peacoat"
	path = /obj/item/clothing/suit/storage/toggle/peacoat

/datum/gear/suit/miscellaneous/peacoat/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/miscellaneous/kamishimo
	display_name = "Kamishimo"
	path = /obj/item/clothing/suit/kamishimo

/datum/gear/suit/snowsuit
	display_name = "Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit

/datum/gear/suit/miscellaneous/cardigan
	display_name = "Cardigan (Colorable)"
	path = /obj/item/clothing/suit/storage/toggle/cardigan

/datum/gear/suit/miscellaneous/cardigan/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/storage/dutchcoat
	display_name = "Western Coat"
	path = /obj/item/clothing/suit/storage/dutchcoat

/datum/gear/suit/storage/tailcoat
	display_name = "Tailcoat"
	path = /obj/item/clothing/suit/storage/tailcoat

/datum/gear/suit/storage/redladvic
	display_name = "Red Victorian Coat"
	path = /obj/item/clothing/suit/storage/redladiesvictoriancoat

/datum/gear/suit/storage/ladvic
	display_name = "Ladies Victorian Coat"
	path = /obj/item/clothing/suit/storage/ladiesvictoriancoat

/datum/gear/suit/slimleather
	display_name = "Slim Leather Jacket"
	path = /obj/item/clothing/suit/storage/toggle/slimleather

/datum/gear/suit/ronincoat
	display_name = "Ronin Coat"
	path = /obj/item/clothing/suit/storage/hooded/ronincoat

/datum/gear/suit/labcoat_colorable
	display_name = "Labcoat - Colorable"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat_colorable/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/suit/jacket_modular
	display_name = "Jacket - Modular"
	path = /obj/item/clothing/suit/storage/fluff/jacket

/datum/gear/suit/jacket_modular/New()
	..()
	var/list/the_jackets = list()
	for(var/the_jacket in typesof(/obj/item/clothing/suit/storage/fluff/jacket))
		var/obj/item/clothing/suit/jacket_type = the_jacket
		the_jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(the_jackets, /proc/cmp_text_asc))

/datum/gear/suit/gntop
	display_name = "GN Crop Jacket"
	path = /obj/item/clothing/suit/storage/fluff/gntop

/datum/gear/suit/bomber_pilot
	display_name = "Bomber Jacket - Pilot"
	path = /obj/item/clothing/suit/storage/toggle/bomber/pilot

/datum/gear/suit/highwayman_jacket
	display_name = "Black Jacket w/ Fur Lining"
	path = /obj/item/clothing/suit/highwayman_jacket

/datum/gear/suit/utility_coat
	display_name = "Utility Coat"
	path = /obj/item/clothing/suit/storage/utility_coat
