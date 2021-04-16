
/obj/item/deck/unus
	name = "deck of unus cards"
	desc = "Because the crew needed another game to get violently angry about."
	icon_state = "deck_unus"

/obj/item/deck/unus/Initialize(mapload)
	. = ..()

	var/datum/playingcard/P
	for(var/suit in list("red", "yellow", "blue", "green"))

		for(var/i = 0, i < 2, i++)
			for(var/number in list("draw two", "skip", "reverse"))
				P = new()
				P.name = "[suit] [number]"
				P.card_icon = "unus_[suit]_action"
				P.back_icon = "card_back_unus"
				cards += P
		for(var/i = 0, i < 2, i++)
			for(var/number in list("one", "two", "three", "four", "five", "six", "seven", "eight", "nine"))
				P = new()
				P.name = "[suit] [number]"
				P.card_icon = "unus_[suit]_number"
				P.back_icon = "card_back_unus"
				cards += P
		for(var/number in list("zero"))
			P = new()
			P.name = "[suit] [number]"
			P.card_icon = "unus_[suit]_number"
			P.back_icon = "card_back_unus"
			cards += P
	for(var/suit in list("wild"))
		for(var/number in list("wild card", "wild draw four"))
			P = new()
			P.name = "[number]"
			P.card_icon = "unus_wild"
			P.back_icon = "card_back_unus"
			cards += P
	
	

/obj/item/deck/unus/shuffle()
	var/mob/living/user = usr
	if (cooldown < world.time - 10)
		var/list/newcards = list()
		while(cards.len)
			var/datum/playingcard/P = pick(cards)
			newcards += P
			cards -= P
		cards = newcards
		playsound(user, 'sound/items/cardshuffle.ogg', 50, 1)
		user.visible_message("\The [user] shuffles [src].")
		cooldown = world.time
	else
		return
