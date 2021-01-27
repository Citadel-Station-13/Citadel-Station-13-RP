// Shoelocker
/datum/gear/shoes
	display_name = "Sandals"
	path = /obj/item/clothing/shoes/sandal
	slot = slot_shoes
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/jackboots
	display_name = "Jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots

/datum/gear/shoes/kneeboots
	display_name = "Jackboots - Knee-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/knee

/datum/gear/shoes/thighboots
	display_name = "Jackboots - Thigh-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/thigh

/datum/gear/shoes/toeless
	display_name = "Toe-Less Jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless

/datum/gear/shoes/toelessknee
	display_name = "Toe-Less Jackboots - Knee-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless/knee

/datum/gear/shoes/toelessthigh
	display_name = "Toe-Less Jackboots - Thigh-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless/thigh

/datum/gear/shoes/workboots
	display_name = "Workboots"
	path = /obj/item/clothing/shoes/boots/workboots

/datum/gear/shoes/workboots/toeless
	display_name = "Toe-Less Workboots"
	path = /obj/item/clothing/shoes/boots/workboots/toeless

/datum/gear/shoes/black
	display_name = "Shoes - Black"
	path = /obj/item/clothing/shoes/black

/datum/gear/shoes/blue
	display_name = "Shoes - Blue"
	path = /obj/item/clothing/shoes/blue

/datum/gear/shoes/brown
	display_name = "Shoes - Brown"
	path = /obj/item/clothing/shoes/brown

/datum/gear/shoes/lacey
	display_name = "Shoes, Oxford Selection"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/lacey/New()
	..()
	var/list/laces = list()
	for(var/lace in typesof(/obj/item/clothing/shoes/laceup))
		var/obj/item/clothing/shoes/laceup/lace_type = lace
		laces[initial(lace_type.name)] = lace_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(laces, /proc/cmp_text_asc))

/datum/gear/shoes/green
	display_name = "Shoes - Green"
	path = /obj/item/clothing/shoes/green

/datum/gear/shoes/orange
	display_name = "Shoes - Orange"
	path = /obj/item/clothing/shoes/orange

/datum/gear/shoes/purple
	display_name = "Shoes - Purple"
	path = /obj/item/clothing/shoes/purple

/datum/gear/shoes/rainbow
	display_name = "Shoes - Rainbow"
	path = /obj/item/clothing/shoes/rainbow

/datum/gear/shoes/red
	display_name = "Shoes - Red"
	path = /obj/item/clothing/shoes/red

/datum/gear/shoes/white
	display_name = "Shoes - White"
	path = /obj/item/clothing/shoes/white

/datum/gear/shoes/yellow
	display_name = "Shoes - Yellow"
	path = /obj/item/clothing/shoes/yellow

/datum/gear/shoes/hitops/
	display_name = "High-Tops - Selection"
	path = /obj/item/clothing/shoes/hitops/

/datum/gear/shoes/hitops/New()
	..()
	var/list/hitops = list()
	for(var/hitop in typesof(/obj/item/clothing/shoes/hitops))
		var/obj/item/clothing/shoes/hitops/hitop_type = hitop
		hitops[initial(hitop_type.name)] = hitop_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(hitops, /proc/cmp_text_asc))

/datum/gear/shoes/flipflops
	display_name = "Flip Flops"
	path = /obj/item/clothing/shoes/flipflop

/datum/gear/shoes/flipflops/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/athletic
	display_name = "Athletic Shoes"
	path = /obj/item/clothing/shoes/athletic

/datum/gear/shoes/athletic/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/skater
	display_name = "Skater Shoes"
	path = /obj/item/clothing/shoes/skater

/datum/gear/shoes/skater/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/flats
	display_name = "Flats"
	path = /obj/item/clothing/shoes/flats/white/color

/datum/gear/shoes/flats/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/cowboy
	display_name = "Cowboy Boots"
	path = /obj/item/clothing/shoes/boots/cowboy

/datum/gear/shoes/cowboy/classic
	display_name = "Cowboy Boots - Classic"
	path = /obj/item/clothing/shoes/boots/cowboy/classic

/datum/gear/shoes/cowboy/snakeskin
	display_name = "Cowboy Boots - Snakeskin"
	path = /obj/item/clothing/shoes/boots/cowboy/snakeskin

/datum/gear/shoes/jungle
	display_name = "Jungle Boots"
	path = /obj/item/clothing/shoes/boots/jungle
	cost = 2

/datum/gear/shoes/duty
	display_name = "Duty Boots"
	path = 	/obj/item/clothing/shoes/boots/duty
	cost = 2

/datum/gear/shoes/dress
	display_name = "Shoes - Dress"
	path = 	/obj/item/clothing/shoes/dress

/datum/gear/shoes/dress/white
	display_name = "Shoes - Dress - White"
	path = 	/obj/item/clothing/shoes/dress/white

/datum/gear/shoes/heels
	display_name = "High Heels"
	path = /obj/item/clothing/shoes/heels

/datum/gear/shoes/heels/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/slippers
	display_name = "Bunny Slippers"
	path = /obj/item/clothing/shoes/slippers

/datum/gear/shoes/boots/winter
	display_name = "Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter

/datum/gear/shoes/boots/winter/security
	display_name = "Security - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/security
	allowed_roles = list("Security Officer", "Head of Security", "Warden", "Detective")

/datum/gear/shoes/boots/winter/science
	display_name = "Science - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist")

/datum/gear/shoes/boots/winter/command
	display_name = "Facility Director - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/command
	allowed_roles = list("Facility Director")

/datum/gear/shoes/boots/winter/engineering
	display_name = "Engineering - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/engineering
	allowed_roles = list("Chief Engineer","Atmospheric Technician", "Station Engineer")

/datum/gear/shoes/boots/winter/atmos
	display_name = "Atmospherics Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/atmos
	allowed_roles = list("Chief Engineer", "Atmospheric Technician")

/datum/gear/shoes/boots/winter/medical
	display_name = "Medical - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Field Medic","Paramedic","Geneticist", "Psychiatrist")

/datum/gear/shoes/boots/winter/mining
	display_name = "Mining Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/mining
	allowed_roles = list("Shaft Miner")

/datum/gear/shoes/boots/winter/supply
	display_name = "Supply - Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/supply
	allowed_roles = list("Quartermaster","Cargo Technician")

/datum/gear/shoes/boots/winter/hydro
	display_name = "Hydroponics Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter/hydro
	allowed_roles = list("Botanist", "Xenobiologist")

/datum/gear/shoes/circuitry
	display_name = "Boots - Circuitry"
	path = /obj/item/clothing/shoes/circuitry

/datum/gear/shoes/cowboy/black
	display_name = "Cowboy Boots - Black"
	path = /obj/item/clothing/shoes/cowboyboots/black

/datum/gear/shoes/boots/winter/science
	allowed_roles = list("Research Director","Scientist", "Roboticist", "Xenobiologist", "Explorer", "Pathfinder")

/datum/gear/shoes/boots/winter/medical
	allowed_roles = list("Medical Doctor","Chief Medical Officer","Chemist","Paramedic","Geneticist", "Psychiatrist", "Field Medic")

/datum/gear/shoes/black/cuffs
	display_name = "Legwraps - Black"
	path = /obj/item/clothing/shoes/black/cuffs

/datum/gear/shoes/black/cuffs/blue
	display_name = "Legwraps - Blue"
	path = /obj/item/clothing/shoes/black/cuffs/blue

/datum/gear/shoes/black/cuffs/red
	display_name = "Legwraps - Red"
	path = /obj/item/clothing/shoes/black/cuffs/red

/datum/gear/shoes/siren
	display_name = "Boots - Siren"
	path = /obj/item/clothing/shoes/boots/fluff/siren

/datum/gear/shoes/galoshes/black
	display_name = "Galoshes - Black"
	path = /obj/item/clothing/shoes/galoshes/citadel/black
	allowed_roles = list("Janitor")

/datum/gear/shoes/galoshes/starcon
	display_name = "Galoshes - Dark-Purple"
	path = /obj/item/clothing/shoes/galoshes/citadel/starcon
	allowed_roles = list("Janitor")
	cost = 2
