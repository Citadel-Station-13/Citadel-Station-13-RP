// Shoelocker
/datum/gear/shoes
	name = "Sandals"
	path = /obj/item/clothing/shoes/sandal
	slot = SLOT_ID_SHOES
	sort_category = "Shoes and Footwear"

/datum/gear/shoes/jackboots
	name = "Jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots

/datum/gear/shoes/kneeboots
	name = "Jackboots - Knee-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/knee

/datum/gear/shoes/thighboots
	name = "Jackboots - Thigh-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/thigh

/datum/gear/shoes/toeless
	name = "Toe-Less Jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless

/datum/gear/shoes/toelessknee
	name = "Toe-Less Jackboots - Knee-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless/knee

/datum/gear/shoes/toelessthigh
	name = "Toe-Less Jackboots - Thigh-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless/thigh

/datum/gear/shoes/workboots
	name = "Workboots"
	path = /obj/item/clothing/shoes/boots/workboots

/datum/gear/shoes/workboots/toeless
	name = "Toe-Less Workboots"
	path = /obj/item/clothing/shoes/boots/workboots/toeless

/datum/gear/shoes/black
	name = "Shoes - Black"
	path = /obj/item/clothing/shoes/black

/datum/gear/shoes/blue
	name = "Shoes - Blue"
	path = /obj/item/clothing/shoes/blue

/datum/gear/shoes/brown
	name = "Shoes - Brown"
	path = /obj/item/clothing/shoes/brown

/datum/gear/shoes/lacey
	name = "Shoes, Oxford Selection"
	path = /obj/item/clothing/shoes/laceup

/datum/gear/shoes/lacey/New()
	..()
	var/list/laces = list()
	for(var/lace in typesof(/obj/item/clothing/shoes/laceup))
		var/obj/item/clothing/shoes/laceup/lace_type = lace
		laces[initial(lace_type.name)] = lace_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(laces, /proc/cmp_text_asc))

/datum/gear/shoes/green
	name = "Shoes - Green"
	path = /obj/item/clothing/shoes/green

/datum/gear/shoes/orange
	name = "Shoes - Orange"
	path = /obj/item/clothing/shoes/orange

/datum/gear/shoes/purple
	name = "Shoes - Purple"
	path = /obj/item/clothing/shoes/purple

/datum/gear/shoes/rainbow
	name = "Shoes - Rainbow"
	path = /obj/item/clothing/shoes/rainbow

/datum/gear/shoes/red
	name = "Shoes - Red"
	path = /obj/item/clothing/shoes/red

/datum/gear/shoes/white
	name = "Shoes - White"
	path = /obj/item/clothing/shoes/white

/datum/gear/shoes/yellow
	name = "Shoes - Yellow"
	path = /obj/item/clothing/shoes/yellow

/datum/gear/shoes/hitops/
	name = "High-Tops - Selection"
	path = /obj/item/clothing/shoes/hitops/

/datum/gear/shoes/hitops/New()
	..()
	var/list/hitops = list()
	for(var/hitop in typesof(/obj/item/clothing/shoes/hitops))
		var/obj/item/clothing/shoes/hitops/hitop_type = hitop
		hitops[initial(hitop_type.name)] = hitop_type
	gear_tweaks += new/datum/gear_tweak/path(tim_sort(hitops, /proc/cmp_text_asc))

/datum/gear/shoes/flipflops
	name = "Flip Flops"
	path = /obj/item/clothing/shoes/flipflop

/datum/gear/shoes/flipflops/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/athletic
	name = "Athletic Shoes"
	path = /obj/item/clothing/shoes/athletic

/datum/gear/shoes/athletic/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/skater
	name = "Skater Shoes"
	path = /obj/item/clothing/shoes/skater

/datum/gear/shoes/skater/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/flats
	name = "Flats"
	path = /obj/item/clothing/shoes/flats/white/color

/datum/gear/shoes/flats/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/cowboy
	name = "Cowboy Boots"
	path = /obj/item/clothing/shoes/boots/cowboy

/datum/gear/shoes/cowboy/classic
	name = "Cowboy Boots - Classic"
	path = /obj/item/clothing/shoes/boots/cowboy/classic

/datum/gear/shoes/cowboy/snakeskin
	name = "Cowboy Boots - Snakeskin"
	path = /obj/item/clothing/shoes/boots/cowboy/snakeskin

/datum/gear/shoes/jungle
	name = "Jungle Boots"
	path = /obj/item/clothing/shoes/boots/jungle
	cost = 2

/datum/gear/shoes/duty
	name = "Duty Boots"
	path = 	/obj/item/clothing/shoes/boots/duty
	cost = 2

/datum/gear/shoes/dress
	name = "Shoes - Dress"
	path = 	/obj/item/clothing/shoes/dress

/datum/gear/shoes/dress/white
	name = "Shoes - Dress - White"
	path = 	/obj/item/clothing/shoes/dress/white

/datum/gear/shoes/heels
	name = "High Heels"
	path = /obj/item/clothing/shoes/heels

/datum/gear/shoes/heels/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/slippers
	name = "Bunny Slippers"
	path = /obj/item/clothing/shoes/slippers

/datum/gear/shoes/boots/winter
	name = "Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter

/datum/gear/shoes/circuitry
	name = "Boots - Circuitry"
	path = /obj/item/clothing/shoes/circuitry

/datum/gear/shoes/cowboy/black
	name = "Cowboy Boots - Black"
	path = /obj/item/clothing/shoes/cowboyboots/black

/datum/gear/shoes/black/cuffs
	name = "Legwraps - Black"
	path = /obj/item/clothing/shoes/black/cuffs

/datum/gear/shoes/black/cuffs/blue
	name = "Legwraps - Blue"
	path = /obj/item/clothing/shoes/black/cuffs/blue

/datum/gear/shoes/black/cuffs/red
	name = "Legwraps - Red"
	path = /obj/item/clothing/shoes/black/cuffs/red

/datum/gear/shoes/siren
	name = "Boots - Siren"
	path = /obj/item/clothing/shoes/boots/fluff/siren

/datum/gear/shoes/footwraps
	name = "Cloth Footwraps (Colorable)"
	path = /obj/item/clothing/shoes/footwraps

/datum/gear/shoes/footwraps/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/shoes/laconic
	name = "Laconic Field Boots"
	path = /obj/item/clothing/shoes/boots/laconic

/datum/gear/shoes/bountyskin
	name = "Bounty Hunter's Heels"
	path = /obj/item/clothing/shoes/bountyskin

/datum/gear/shoes/antediluvian
	name = "Antediluvian Legwraps"
	path = /obj/item/clothing/shoes/antediluvian

/datum/gear/shoes/halfmoon
	name = "Half Moon boots"
	path = /obj/item/clothing/shoes/boots/half_moon

/datum/gear/shoes/utilitarian
	name = "Utilitarian Shoes"
	path = /obj/item/clothing/shoes/utilitarian

/datum/gear/shoes/duty_alt
	name = "Duty Boots (Alternate)"
	path = /obj/item/clothing/shoes/boots/duty/alt
	cost = 2

/datum/gear/shoes/duty_alt/knee
	name = "Duty Boots (Alternate), Knee-High"
	path = /obj/item/clothing/shoes/boots/duty/alt/knee

/datum/gear/shoes/duty_alt/heel
	name = "Duty Boots (Alternate), Heels"
	path = /obj/item/clothing/shoes/boots/duty/alt/heel
