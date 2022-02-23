/datum/holiday/xmas
	name = CHRISTMAS
	desc = "Christmas is a very old holiday that originated in Earth, Sol.  It was a \
					religious holiday for the Christian religion, which would later form Unitarianism.  Nowdays, the holiday is celebrated \
					generally by giving gifts, symbolic decoration, and reuniting with one's family.  It also features a mythical fat \
					red human, known as Santa, who broke into people's homes to loot cookies and milk."
	begin_day = 1
	begin_month = DECEMBER
	end_day = 2
	end_month = JANUARY
	loadout_spam = TRUE
	// drone_hat = /obj/item/clothing/head/santa

// /datum/holiday/xmas/greet()
// 	return "Have a merry Christmas!"

// /datum/holiday/xmas/celebrate()
// 	SSticker.OnRoundstart(CALLBACK(src, .proc/roundstart_celebrate))

// /datum/holiday/xmas/proc/roundstart_celebrate()
// 	for(var/obj/machinery/computer/security/telescreen/entertainment/Monitor in GLOB.machines)
// 		Monitor.icon_state_on = "entertainment_xmas"

// 	for(var/mob/living/simple_animal/pet/dog/corgi/Ian/Ian in GLOB.mob_living_list)
// 		Ian.place_on_head(new /obj/item/clothing/head/helmet/space/santahat(Ian))
