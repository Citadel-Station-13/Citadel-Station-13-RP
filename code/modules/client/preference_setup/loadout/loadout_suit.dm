// Suit slot
/datum/gear/suit
	display_name = "Civilian Apron - Blue"
	path = /obj/item/clothing/suit/storage/apron
	slot = slot_wear_suit
	sort_category = "Suits and Overwear"
	cost = 2

/datum/gear/suit/apron_white
	display_name = "Civilian Apron - Colorable"
	path = /obj/item/clothing/suit/storage/apron/white

/datum/gear/suit/apron_white/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/greatcoat
	display_name = "Civilian Greatcoat"
	path = /obj/item/clothing/suit/greatcoat

/datum/gear/suit/leather_coat
	display_name = "Civilian Leather Coat"
	path = /obj/item/clothing/suit/leathercoat

/datum/gear/suit/puffer_coat
	display_name = "Civilian Puffer Coat"
	path = /obj/item/clothing/suit/jacket/puffer

/datum/gear/suit/puffer_vest
	display_name = "Civilian Puffer Vest"
	path = /obj/item/clothing/suit/jacket/puffer/vest

/datum/gear/suit/bomber
	display_name = "Civilian Bomber Jacket"
	path = /obj/item/clothing/suit/storage/toggle/bomber

/datum/gear/suit/bomber_alt
	display_name = "Civilian Bomber Jacket Alt"
	path = /obj/item/clothing/suit/storage/bomber/alt

/datum/gear/suit/leather_jacket
	display_name = "Civilian Leather Jacket - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket

/datum/gear/suit/leather_jacket_sleeveless
	display_name = "Civilian Leather Vest - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/sleeveless

/datum/gear/suit/leather_jacket_alt
	display_name = "Civilian Leather Jacket Alt - Black"
	path = /obj/item/clothing/suit/storage/leather_jacket_alt

/datum/gear/suit/leather_jacket_nt
	display_name = "Civilian Leather Jacket - Corporate - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen

/datum/gear/suit/leather_jacket_nt/sleeveless
	display_name = "Civilian Leather Vest - Corporate - Black"
	path = /obj/item/clothing/suit/storage/toggle/leather_jacket/nanotrasen/sleeveless

/datum/gear/suit/brown_jacket
	display_name = "Civilian Leather Jacket - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket

/datum/gear/suit/brown_jacket_sleeveless
	display_name = "Civilian Leather Vest - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/sleeveless

/datum/gear/suit/brown_jacket_nt
	display_name = "Civilian Leather Jacket - Corporate - Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen

/datum/gear/suit/brown_jacket_nt/sleeveless
	display_name = "Civilian Leather Vest - Corporate, Brown"
	path = /obj/item/clothing/suit/storage/toggle/brown_jacket/nanotrasen/sleeveless

/datum/gear/suit/mil
	display_name = "Civilian Military Jacket - Selection"
	path = /obj/item/clothing/suit/storage/miljacket

/datum/gear/suit/mil/New()
	..()
	var/list/mil_jackets = list()
	for(var/military_style in typesof(/obj/item/clothing/suit/storage/miljacket))
		var/obj/item/clothing/suit/storage/miljacket/miljacket = military_style
		mil_jackets[initial(miljacket.name)] = miljacket
	gear_tweaks += new/datum/gear_tweak/path(sortTim(mil_jackets, /proc/cmp_text_asc))

/datum/gear/suit/greyjacket
	display_name = "Civilian Jacket - Grey"
	path = /obj/item/clothing/suit/storage/greyjacket

/datum/gear/suit/brown_trenchcoat
	display_name = "Civilian Trenchcoat - Brown"
	path = /obj/item/clothing/suit/storage/trench

/datum/gear/suit/grey_trenchcoat
	display_name = "Civilian Trenchcoat - Grey"
	path = /obj/item/clothing/suit/storage/trench/grey

datum/gear/suit/duster
	display_name = "Civilian Cowboy Duster"
	path = /obj/item/clothing/suit/storage/duster

/datum/gear/suit/duster/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/hazard_vest
	display_name = "Civilian Hazard Vest - Selection"
	path = /obj/item/clothing/suit/storage/hazardvest

/datum/gear/suit/hazard_vest/New()
	..()
	var/list/hazards = list()
	for(var/hazard_style in typesof(/obj/item/clothing/suit/storage/hazardvest))
		var/obj/item/clothing/suit/storage/hazardvest/hazardvest = hazard_style
		hazards[initial(hazardvest.name)] = hazardvest
	gear_tweaks += new/datum/gear_tweak/path(sortTim(hazards, /proc/cmp_text_asc))

/datum/gear/suit/hoodie
	display_name = "Civilian Hoodie - Selection"
	path = /obj/item/clothing/suit/storage/toggle/hoodie

/datum/gear/suit/hoodie/New()
	..()
	var/list/hoodies = list()
	for(var/hoodie_style in typesof(/obj/item/clothing/suit/storage/toggle/hoodie))
		var/obj/item/clothing/suit/storage/toggle/hoodie/hoodie = hoodie_style
		hoodies[initial(hoodie.name)] = hoodie
	gear_tweaks += new/datum/gear_tweak/path(sortTim(hoodies, /proc/cmp_text_asc))

/datum/gear/suit/labcoat
	display_name = "Civilian Labcoat"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat/blue
	display_name = "Civilian Labcoat - Blue"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue

/datum/gear/suit/labcoat/blue_edge
	display_name = "Civilian Labcoat - Blue-Edged"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/blue_edge

/datum/gear/suit/labcoat/green
	display_name = "Civilian Labcoat - Green"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/green

/datum/gear/suit/labcoat/orange
	display_name = "Civilian Labcoat - Orange"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/orange

/datum/gear/suit/labcoat/purple
	display_name = "Civilian Labcoat - Purple"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/purple

/datum/gear/suit/labcoat/pink
	display_name = "Civilian Labcoat - Pink"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/pink

/datum/gear/suit/labcoat/red
	display_name = "Civilian Labcoat - Red"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/red

/datum/gear/suit/labcoat/yellow
	display_name = "Civilian Labcoat - Yellow"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/yellow

/datum/gear/suit/labcoat/emt
	display_name = "Medical Labcoat - EMT"
	path = /obj/item/clothing/suit/storage/toggle/labcoat/emt
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/suit/roles/surgical_apron
	display_name = "Medical Surgical Apron"
	path = /obj/item/clothing/suit/surgicalapron
	allowed_roles = list("Medical Doctor","Chief Medical Officer")

/datum/gear/suit/overalls
	display_name = "Civilian Overalls"
	path = /obj/item/clothing/suit/storage/apron/overalls
	cost = 1

/datum/gear/suit/poncho
	display_name = "Civilian Poncho Selection"
	path = /obj/item/clothing/accessory/poncho
	cost = 1

/datum/gear/suit/poncho/New()
	..()
	var/list/ponchos = list()
	for(var/poncho_style in (typesof(/obj/item/clothing/accessory/poncho) - typesof(/obj/item/clothing/accessory/poncho/roles)))
		var/obj/item/clothing/accessory/poncho/poncho = poncho_style
		ponchos[initial(poncho.name)] = poncho
	gear_tweaks += new/datum/gear_tweak/path(sortTim(ponchos, /proc/cmp_text_asc))

/datum/gear/suit/roles/poncho/security
	display_name = "Security Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/security

/datum/gear/suit/roles/poncho/medical
	display_name = "Medical Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/medical

/datum/gear/suit/roles/poncho/engineering
	display_name = "Engineering Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/engineering

/datum/gear/suit/roles/poncho/science
	display_name = "Science Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/science

/datum/gear/suit/roles/poncho/cargo
	display_name = "Cargo Poncho"
	path = /obj/item/clothing/accessory/poncho/roles/cargo

/datum/gear/suit/roles/poncho/cloak/hos
	display_name = "Head of Secuirty - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hos
	allowed_roles = list("Head of Security")

/datum/gear/suit/roles/poncho/cloak/cmo
	display_name = "Chief Medical Officer - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cmo
	allowed_roles = list("Chief Medical Officer")

/datum/gear/suit/roles/poncho/cloak/ce
	display_name = "Chief Engineer - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/ce
	allowed_roles = list("Chief Engineer")

/datum/gear/suit/roles/poncho/cloak/rd
	display_name = "Research Director - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/rd
	allowed_roles = list("Research Director")

/datum/gear/suit/roles/poncho/cloak/qm
	display_name = "Quartermaster - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/qm
	allowed_roles = list("Quartermaster")

/datum/gear/suit/roles/poncho/cloak/captain
	display_name = "Facility Director - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/captain
	allowed_roles = list("Facility Director")

/datum/gear/suit/roles/poncho/cloak/hop
	display_name = "Head of Personnel - Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/hop
	allowed_roles = list("Head of Personnel")

/datum/gear/suit/roles/poncho/cloak/cargo
	display_name = "Cargo Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/cargo

/datum/gear/suit/roles/poncho/cloak/mining
	display_name = "Mining Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/mining

/datum/gear/suit/roles/poncho/cloak/security
	display_name = "Security Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/security

/datum/gear/suit/roles/poncho/cloak/service
	display_name = "Service Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/service

/datum/gear/suit/roles/poncho/cloak/engineer
	display_name = "Engineering Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/engineer

/datum/gear/suit/roles/poncho/cloak/atmos
	display_name = "Atmospherics Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/atmos

/datum/gear/suit/roles/poncho/cloak/research
	display_name = "Science Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/research

/datum/gear/suit/roles/poncho/cloak/medical
	display_name = "Medical Cloak"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/medical

// A colorable cloak
/datum/gear/suit/roles/poncho/cloak/custom
	display_name = "Civilian Cloak - Colorable"
	path = /obj/item/clothing/accessory/poncho/roles/cloak/custom

/datum/gear/suit/roles/poncho/cloak/custom/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/unathi_robe
	display_name = "Civilian Roughspun Robe"
	path = /obj/item/clothing/suit/unathi/robe
	cost = 1

/datum/gear/suit/black_lawyer_jacket
	display_name = "Civilian Suit Jacket - Black"
	path = /obj/item/clothing/suit/storage/toggle/internalaffairs

/datum/gear/suit/blue_lawyer_jacket
	display_name = "Civilian Suit Jacket - Blue"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/bluejacket

/datum/gear/suit/purple_lawyer_jacket
	display_name = "Civilian Suit Jacket - Purple"
	path = /obj/item/clothing/suit/storage/toggle/lawyer/purpjacket

/datum/gear/suit/suspenders
	display_name = "Civilian Suspenders"
	path = /obj/item/clothing/suit/suspenders

/datum/gear/suit/forensics
	display_name = "Detective Forensics Long - Red"
	path = /obj/item/clothing/suit/storage/forensics/red/long
	allowed_roles = list("Detective")

/datum/gear/suit/forensics/blue
	display_name = "Detective Forensics Long - Blue"
	path = /obj/item/clothing/suit/storage/forensics/blue/long
	allowed_roles = list("Detective")

/datum/gear/suit/forensics/blue/short
	display_name = "Detective Forensics - Blue"
	path = /obj/item/clothing/suit/storage/forensics/blue
	allowed_roles = list("Detective")

/datum/gear/suit/forensics/red/short
	display_name = "Detective Forensics - Red"
	path = /obj/item/clothing/suit/storage/forensics/red
	allowed_roles = list("Detective")

/datum/gear/suit/wintercoat
	display_name = "Civilian Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat

/datum/gear/suit/wintercoat/captain
	display_name = "Facility Director - Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/captain
	allowed_roles = list("Facility Director")

/datum/gear/suit/wintercoat/security
	display_name = "Security Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

/datum/gear/suit/wintercoat/medical
	display_name = "Medical Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Field Medic","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/suit/wintercoat/science
	display_name = "Science Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/suit/wintercoat/engineering
	display_name = "Engineering Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Station Engineer")

/datum/gear/suit/wintercoat/atmos
	display_name = "Atmospherics Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/engineering/atmos
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/suit/wintercoat/hydro
	display_name = "Hydroponics Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/hydro
	allowed_roles = list("Botanist", "Xenobiologist")

/datum/gear/suit/wintercoat/cargo
	display_name = "Cargo Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/cargo
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/suit/wintercoat/miner
	display_name = "Mining Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/miner
	allowed_roles = list("Shaft Miner")

/datum/gear/suit/techrobes
	display_name = "Civilian Techpriest"
	path = /obj/item/clothing/suit/storage/hooded/techpriest

/datum/gear/suit/varsity
	display_name = "Civilian Varsity Jacket - Selection"
	path = /obj/item/clothing/suit/varsity

/datum/gear/suit/varsity/New()
	..()
	var/list/varsities = list()
	for(var/varsity_style in typesof(/obj/item/clothing/suit/varsity))
		var/obj/item/clothing/suit/varsity/varsity = varsity_style
		varsities[initial(varsity.name)] = varsity
	gear_tweaks += new/datum/gear_tweak/path(sortTim(varsities, /proc/cmp_text_asc))

/datum/gear/suit/track
	display_name = "Civilian Track Jacket - Selection"
	path = /obj/item/clothing/suit/storage/toggle/track

/datum/gear/suit/track/New()
	..()
	var/list/tracks = list()
	for(var/track_style in typesof(/obj/item/clothing/suit/storage/toggle/track))
		var/obj/item/clothing/suit/storage/toggle/track/track = track_style
		tracks[initial(track.name)] = track
	gear_tweaks += new/datum/gear_tweak/path(sortTim(tracks, /proc/cmp_text_asc))

/datum/gear/suit/flannel
	display_name = "Civilian Flannel - Grey"
	path = /obj/item/clothing/suit/storage/flannel

/datum/gear/suit/flannel/red
	display_name = "Civilian Flannel - Red"
	path = /obj/item/clothing/suit/storage/flannel/red

/datum/gear/suit/flannel/aqua
	display_name = "Civilian Flannel - Aqua"
	path = /obj/item/clothing/suit/storage/flannel/aqua

/datum/gear/suit/flannel/brown
	display_name = "Civilian Flannel - Brown"
	path = /obj/item/clothing/suit/storage/flannel/brown

/datum/gear/suit/denim_jacket
	display_name = "Civilian Denim Jacket"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket

/datum/gear/suit/denim_jacket/corporate
	display_name = "Denim Jacket - Corporate"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen

/datum/gear/suit/denim_vest
	display_name = "Civilian Denim Vest"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/sleeveless

/datum/gear/suit/denim_vest/corporate
	display_name = "Civilian Denim Vest - Corporate"
	path = /obj/item/clothing/suit/storage/toggle/denim_jacket/nanotrasen/sleeveless

/datum/gear/suit/miscellaneous/kimono
	display_name = "Civilian Kimono"
	path = /obj/item/clothing/suit/kimono

/datum/gear/suit/miscellaneous/kimono/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/miscellaneous/sec_dep_jacket
	display_name = "Security Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/sec_dep_jacket

/datum/gear/suit/miscellaneous/engi_dep_jacket
	display_name = "Engineering Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/engi_dep_jacket

/datum/gear/suit/miscellaneous/supply_dep_jacket
	display_name = "Cargo Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/supply_dep_jacket

/datum/gear/suit/miscellaneous/sci_dep_jacket
	display_name = "Science Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/sci_dep_jacket

/datum/gear/suit/miscellaneous/med_dep_jacket
	display_name = "Medical Department Jacket"
	path = /obj/item/clothing/suit/storage/toggle/med_dep_jacket

/datum/gear/suit/miscellaneous/peacoat
	display_name = "Civilian Peacoat"
	path = /obj/item/clothing/suit/storage/toggle/peacoat

/datum/gear/suit/miscellaneous/peacoat/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/miscellaneous/kamishimo
	display_name = "Civilian Kamishimo"
	path = /obj/item/clothing/suit/kamishimo

/datum/gear/suit/snowsuit
	display_name = "Civilian Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit

/datum/gear/suit/snowsuit/command
	display_name = "Command Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/command
	allowed_roles = list("Facility Director","Research Director","Head of Personnel","Head of Security","Chief Engineer","Command Secretary")

/datum/gear/suit/snowsuit/security
	display_name = "Security Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

/datum/gear/suit/snowsuit/medical
	display_name = "Medical Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/suit/snowsuit/science
	display_name = "Science Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/suit/snowsuit/engineering
	display_name = "Engineering Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Station Engineer")

/datum/gear/suit/snowsuit/cargo
	display_name = "Cargo Snowsuit"
	path = /obj/item/clothing/suit/storage/snowsuit/cargo
	allowed_roles = list("Quartermaster","Shaft Miner","Cargo Technician","Head of Personnel")

/datum/gear/suit/miscellaneous/cardigan
	display_name = "Civilian Cardigan"
	path = /obj/item/clothing/suit/storage/toggle/cardigan

/datum/gear/suit/miscellaneous/cardigan/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

datum/gear/suit/miscellaneous/storage/lawyer/bridgeofficer
	display_name = "Command Dress Jacket"
	path = /obj/item/clothing/suit/storage/bridgeofficer
	allowed_roles = list("Facility Director","Research Director","Head of Personnel","Head of Security","Chief Engineer","Command Secretary")

datum/gear/suit/labcoat/paramedicjacketsol
	display_name = "Medical Paramedic Jacket"
	path = /obj/item/clothing/suit/toggle/paramed
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

datum/gear/suit/labcoat/param
	display_name = "Medical EMT Vest"
	path = /obj/item/clothing/suit/toggle/labcoat/paramedic
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/suit/wintercoat/paramed
	display_name = "Medical Winter Coat, Paramedic"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/para
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Search and Rescue","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/suit/wintercoat/bar
	display_name = "Bartender  Winter Coat"
	path = /obj/item/clothing/suit/storage/hooded/wintercoat/bar
	allowed_roles = list("Bartender")

/datum/gear/suit/storage/dutchcoat
	display_name = "Civilian Western Coat"
	path = /obj/item/clothing/suit/storage/dutchcoat

/datum/gear/suit/storage/tailcoat
	display_name = "Civilian Tailcoat"
	path = /obj/item/clothing/suit/storage/tailcoat

datum/gear/suit/miscellaneous/storage/lawyer/bridgeofficerparade
	display_name = "Command Parade Jacket"
	path = /obj/item/clothing/suit/storage/ecdress_ofcr
	allowed_roles = list("Facility Director","Research Director","Head of Personnel","Head of Security","Chief Engineer","Command Secretary")

/datum/gear/suit/storage/redladvic
	display_name = "Civilian Red Victorian Coat"
	path = /obj/item/clothing/suit/storage/redladiesvictoriancoat

/datum/gear/suit/storage/ladvic
	display_name = "Civilian Ladies Victorian Coat"
	path = /obj/item/clothing/suit/storage/ladiesvictoriancoat

/datum/gear/suit/slimleather
	display_name = "Civilian Slim Leather Jacket"
	path = /obj/item/clothing/suit/storage/toggle/slimleather

/datum/gear/suit/ronincoat
	display_name = "Civilian Ronin Coat"
	path = /obj/item/clothing/suit/storage/hooded/ronincoat

/datum/gear/suit/wintercoat/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/suit/wintercoat/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist", "Explorer", "Pathfinder")

/datum/gear/suit/snowsuit/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/suit/snowsuit/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist", "Explorer", "Pathfinder")

/datum/gear/suit/labcoat_colorable
	display_name = "Civilian Labcoat - Colorable"
	path = /obj/item/clothing/suit/storage/toggle/labcoat

/datum/gear/suit/labcoat_colorable/New()
	..()
	gear_tweaks = list(gear_tweak_free_color_choice)

/datum/gear/suit/jacket_modular
	display_name = "Civilian Jacket - Modular"
	path = /obj/item/clothing/suit/storage/fluff/jacket

/datum/gear/suit/jacket_modular/New()
	..()
	var/list/the_jackets = list()
	for(var/the_jacket in typesof(/obj/item/clothing/suit/storage/fluff/jacket))
		var/obj/item/clothing/suit/jacket_type = the_jacket
		the_jackets[initial(jacket_type.name)] = jacket_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(the_jackets, /proc/cmp_text_asc))

/datum/gear/suit/gntop
	display_name = "Civilian GN Crop Jacket"
	path = /obj/item/clothing/suit/storage/fluff/gntop

/datum/gear/suit/bomber_pilot
	display_name = "Civilian Bomber Jacket - Pilot"
	path = /obj/item/clothing/suit/storage/toggle/bomber/pilot



/datum/gear/suit/operations_coat
	display_name = "Command Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat/command
	allowed_roles = list("Facility Director","Research Director","Head of Personnel","Head of Security","Chief Engineer","Command Secretary")

/datum/gear/suit/operations_coat/security
	display_name = "Security Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat
	allowed_roles = list("Head of Security", "Warden", "Detective", "Security Officer")

/datum/gear/suit/operations_coat/medsci
	display_name = "MedSci Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat/medsci
	allowed_roles = list("Chief Medical Officer","Medical Doctor","Chemist","Paramedic","Geneticist","Research Director","Scientist", "Roboticist", "Xenobiologist","Pathfinder","Explorer","Field Medic")

/datum/gear/suit/operations_coat/engineering
	display_name = "Engineering Operations Jacket"
	path = /obj/item/clothing/suit/storage/toggle/operations_coat/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician","Station Engineer")

