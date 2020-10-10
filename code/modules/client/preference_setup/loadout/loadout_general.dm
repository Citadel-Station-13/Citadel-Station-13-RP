/datum/gear/cane
	display_name = "Cane"
	path = /obj/item/cane

/datum/gear/cane/white
	display_name = "Cane - White"
	path = /obj/item/cane/whitecane

/datum/gear/cane/whitecollapsible
	display_name = "Cane - White telescopic"
	path = /obj/item/cane/whitecane/collapsible

/datum/gear/cane/crutch
	display_name = "Crutch"
	path = /obj/item/cane/crutch

/datum/gear/dice
	display_name = "Dice Pack"
	path = /obj/item/storage/pill_bottle/dice

/datum/gear/dice/nerd
	display_name = "Dice Pack - Gaming"
	path = /obj/item/storage/pill_bottle/dice_nerd

/datum/gear/dice/cup
	display_name = "Dice Cup and Dice"
	path = /obj/item/storage/dicecup/loaded

/datum/gear/cards
	display_name = "Deck of Cards"
	path = /obj/item/deck/cards

/datum/gear/tarot
	display_name = "Deck of Tarot Cards"
	path = /obj/item/deck/tarot

/datum/gear/holder
	display_name = "Card Holder"
	path = /obj/item/deck/holder

/datum/gear/cardemon_pack
	display_name = "Cardemon Booster Pack"
	path = /obj/item/pack/cardemon

/datum/gear/spaceball_pack
	display_name = "Spaceball Booster Pack"
	path = /obj/item/pack/spaceball

/datum/gear/plushie
	display_name = "Plushie Selection"
	path = /obj/item/toy/plushie/

/datum/gear/plushie/New()
	..()
	var/list/plushies = list()
	for(var/plushie in subtypesof(/obj/item/toy/plushie/) - /obj/item/toy/plushie/therapy)
		var/obj/item/toy/plushie/plushie_type = plushie
		plushies[initial(plushie_type.name)] = plushie_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(plushies, /proc/cmp_text_asc))

/datum/gear/flask
	display_name = "Flask"
	path = /obj/item/reagent_containers/food/drinks/flask/barflask

/datum/gear/flask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_ethanol_reagents())

/datum/gear/vacflask
	display_name = "Flask - Vacuum"
	path = /obj/item/reagent_containers/food/drinks/flask/vacuumflask

/datum/gear/vacflask/New()
	..()
	gear_tweaks += new/datum/gear_tweak/reagents(lunchables_drink_reagents())

/datum/gear/lunchbox
	display_name = "Lunchbox"
	description = "A little lunchbox."
	cost = 2
	path = /obj/item/storage/toolbox/lunchbox

/datum/gear/lunchbox/New()
	..()
	var/list/lunchboxes = list()
	for(var/lunchbox_type in typesof(/obj/item/storage/toolbox/lunchbox))
		var/obj/item/storage/toolbox/lunchbox/lunchbox = lunchbox_type
		if(!initial(lunchbox.filled))
			lunchboxes[initial(lunchbox.name)] = lunchbox_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(lunchboxes, /proc/cmp_text_asc))
	gear_tweaks += new/datum/gear_tweak/contents(lunchables_lunches(), lunchables_snacks(), lunchables_drinks())

/datum/gear/towel
	display_name = "Towel"
	path = /obj/item/towel

/datum/gear/towel/New()
	..()
	gear_tweaks += gear_tweak_free_color_choice

/datum/gear/cahwhite
	display_name = "Cards Against The Galaxy - White Deck"
	path = /obj/item/deck/cah
	description = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the white deck."

/datum/gear/cahblack
	display_name = "Cards Against The Galaxy - Black Deck"
	path = /obj/item/deck/cah/black
	description = "The ever-popular Cards Against The Galaxy word game. Warning: may include traces of broken fourth wall. This is the black deck."

/datum/gear/tennis_ball
	display_name = "Tennis Ball Selection"
	path = /obj/item/toy/tennis

/datum/gear/tennis_ball/New()
	..()
	var/list/tennis_balls = list()
	for(var/tball in typesof(/obj/item/toy/tennis) - typesof(/obj/item/toy/tennis/rainbow))
		var/obj/item/toy/tennis/ball_type = tball
		tennis_balls[initial(ball_type.name)] = ball_type
	gear_tweaks += new/datum/gear_tweak/path(sortTim(tennis_balls, /proc/cmp_text_asc))
