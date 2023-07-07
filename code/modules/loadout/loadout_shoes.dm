// Shoelocker
/datum/loadout_entry/shoes
	name = "Sandals"
	path = /obj/item/clothing/shoes/sandal
	slot = SLOT_ID_SHOES
	sort_category = LOADOUT_CATEGORY_SHOES

/datum/loadout_entry/shoes/jackboots
	name = "Jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots

/datum/loadout_entry/shoes/kneeboots
	name = "Jackboots - Knee-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/knee

/datum/loadout_entry/shoes/thighboots
	name = "Jackboots - Thigh-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/thigh

/datum/loadout_entry/shoes/toeless
	name = "Toe-Less Jackboots"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless

/datum/loadout_entry/shoes/toelessknee
	name = "Toe-Less Jackboots - Knee-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless/knee

/datum/loadout_entry/shoes/toelessthigh
	name = "Toe-Less Jackboots - Thigh-Length"
	path = /obj/item/clothing/shoes/boots/jackboots/toeless/thigh

/datum/loadout_entry/shoes/workboots
	name = "Workboots"
	path = /obj/item/clothing/shoes/boots/workboots

/datum/loadout_entry/shoes/workboots/toeless
	name = "Toe-Less Workboots"
	path = /obj/item/clothing/shoes/boots/workboots/toeless

/datum/loadout_entry/shoes/black
	name = "Shoes - Black"
	path = /obj/item/clothing/shoes/black

/datum/loadout_entry/shoes/blue
	name = "Shoes - Blue"
	path = /obj/item/clothing/shoes/blue

/datum/loadout_entry/shoes/brown
	name = "Shoes - Brown"
	path = /obj/item/clothing/shoes/brown

/datum/loadout_entry/shoes/lacey
	name = "Shoes, Oxford Selection"
	path = /obj/item/clothing/shoes/laceup

/datum/loadout_entry/shoes/lacey/New()
	..()
	var/list/laces = list()
	for(var/lace in typesof(/obj/item/clothing/shoes/laceup))
		var/obj/item/clothing/shoes/laceup/lace_type = lace
		laces[initial(lace_type.name)] = lace_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(laces, /proc/cmp_text_asc))

/datum/loadout_entry/shoes/green
	name = "Shoes - Green"
	path = /obj/item/clothing/shoes/green

/datum/loadout_entry/shoes/orange
	name = "Shoes - Orange"
	path = /obj/item/clothing/shoes/orange

/datum/loadout_entry/shoes/purple
	name = "Shoes - Purple"
	path = /obj/item/clothing/shoes/purple

/datum/loadout_entry/shoes/rainbow
	name = "Shoes - Rainbow"
	path = /obj/item/clothing/shoes/rainbow

/datum/loadout_entry/shoes/red
	name = "Shoes - Red"
	path = /obj/item/clothing/shoes/red

/datum/loadout_entry/shoes/white
	name = "Shoes - White"
	path = /obj/item/clothing/shoes/white

/datum/loadout_entry/shoes/yellow
	name = "Shoes - Yellow"
	path = /obj/item/clothing/shoes/yellow

/datum/loadout_entry/shoes/hitops/
	name = "High-Tops - Selection"
	path = /obj/item/clothing/shoes/hitops/

/datum/loadout_entry/shoes/hitops/New()
	..()
	var/list/hitops = list()
	for(var/hitop in typesof(/obj/item/clothing/shoes/hitops))
		var/obj/item/clothing/shoes/hitops/hitop_type = hitop
		hitops[initial(hitop_type.name)] = hitop_type
	tweaks += new/datum/loadout_tweak/path(tim_sort(hitops, /proc/cmp_text_asc))

/datum/loadout_entry/shoes/flipflops
	name = "Flip Flops"
	path = /obj/item/clothing/shoes/flipflop

/datum/loadout_entry/shoes/flipflops/New()
	..()
	tweaks += gear_tweak_free_color_choice

/datum/loadout_entry/shoes/athletic
	name = "Athletic Shoes"
	path = /obj/item/clothing/shoes/athletic

/datum/loadout_entry/shoes/athletic/New()
	..()
	tweaks += gear_tweak_free_color_choice

/datum/loadout_entry/shoes/skater
	name = "Skater Shoes"
	path = /obj/item/clothing/shoes/skater

/datum/loadout_entry/shoes/skater/New()
	..()
	tweaks += gear_tweak_free_color_choice

/datum/loadout_entry/shoes/flats
	name = "Flats"
	path = /obj/item/clothing/shoes/flats/white/color

/datum/loadout_entry/shoes/flats/New()
	..()
	tweaks += gear_tweak_free_color_choice

/datum/loadout_entry/shoes/cowboy
	name = "Cowboy Boots"
	path = /obj/item/clothing/shoes/boots/cowboy

/datum/loadout_entry/shoes/cowboy/classic
	name = "Cowboy Boots - Classic"
	path = /obj/item/clothing/shoes/boots/cowboy/classic

/datum/loadout_entry/shoes/cowboy/snakeskin
	name = "Cowboy Boots - Snakeskin"
	path = /obj/item/clothing/shoes/boots/cowboy/snakeskin

/datum/loadout_entry/shoes/jungle
	name = "Jungle Boots"
	path = /obj/item/clothing/shoes/boots/jungle
	cost = 2

/datum/loadout_entry/shoes/duty
	name = "Duty Boots"
	path = 	/obj/item/clothing/shoes/boots/duty
	cost = 2

/datum/loadout_entry/shoes/dress
	name = "Shoes - Dress"
	path = 	/obj/item/clothing/shoes/dress

/datum/loadout_entry/shoes/dress/white
	name = "Shoes - Dress - White"
	path = 	/obj/item/clothing/shoes/dress/white

/datum/loadout_entry/shoes/heels
	name = "High Heels"
	path = /obj/item/clothing/shoes/heels

/datum/loadout_entry/shoes/heels/New()
	..()
	tweaks += gear_tweak_free_color_choice

/datum/loadout_entry/shoes/slippers
	name = "Bunny Slippers"
	path = /obj/item/clothing/shoes/slippers

/datum/loadout_entry/shoes/boots/winter
	name = "Winter Boots"
	path = /obj/item/clothing/shoes/boots/winter

/datum/loadout_entry/shoes/circuitry
	name = "Boots - Circuitry"
	path = /obj/item/clothing/shoes/circuitry

/datum/loadout_entry/shoes/cowboy/black
	name = "Cowboy Boots - Black"
	path = /obj/item/clothing/shoes/cowboyboots/black

/datum/loadout_entry/shoes/black/cuffs
	name = "Legwraps - Black"
	path = /obj/item/clothing/shoes/black/cuffs

/datum/loadout_entry/shoes/black/cuffs/blue
	name = "Legwraps - Blue"
	path = /obj/item/clothing/shoes/black/cuffs/blue

/datum/loadout_entry/shoes/black/cuffs/red
	name = "Legwraps - Red"
	path = /obj/item/clothing/shoes/black/cuffs/red

/datum/loadout_entry/shoes/siren
	name = "Boots - Siren"
	path = /obj/item/clothing/shoes/boots/fluff/siren

/datum/loadout_entry/shoes/footwraps
	name = "Cloth Footwraps (Colorable)"
	path = /obj/item/clothing/shoes/footwraps

/datum/loadout_entry/shoes/footwraps/New()
	..()
	tweaks += gear_tweak_free_color_choice

/datum/loadout_entry/shoes/laconic
	name = "Laconic Field Boots"
	path = /obj/item/clothing/shoes/boots/laconic

/datum/loadout_entry/shoes/bountyskin
	name = "Bounty Hunters Heels"
	path = /obj/item/clothing/shoes/bountyskin

/datum/loadout_entry/shoes/antediluvian
	name = "Antediluvian Legwraps"
	path = /obj/item/clothing/shoes/antediluvian

/datum/loadout_entry/shoes/antediluvian
	name = "Antediluvian Heels"
	path = /obj/item/clothing/shoes/antediluvian/heels

/datum/loadout_entry/shoes/halfmoon
	name = "Half Moon boots"
	path = /obj/item/clothing/shoes/boots/half_moon

/datum/loadout_entry/shoes/utilitarian
	name = "Utilitarian Shoes"
	path = /obj/item/clothing/shoes/utilitarian

/datum/loadout_entry/shoes/duty_alt
	name = "Duty Boots (Alternate)"
	path = /obj/item/clothing/shoes/boots/duty/alt
	cost = 2

/datum/loadout_entry/shoes/duty_alt/knee
	name = "Duty Boots (Alternate), Knee-High"
	path = /obj/item/clothing/shoes/boots/duty/alt/knee

/datum/loadout_entry/shoes/duty_alt/heel
	name = "Duty Boots (Alternate), Heels"
	path = /obj/item/clothing/shoes/boots/duty/alt/heel

/datum/loadout_entry/shoes/ballet
	name = "Antheia Pointe Shoes"
	path = /obj/item/clothing/shoes/ballet

/datum/loadout_entry/shoes/ballet/New()
	..()
	tweaks += gear_tweak_free_color_choice
