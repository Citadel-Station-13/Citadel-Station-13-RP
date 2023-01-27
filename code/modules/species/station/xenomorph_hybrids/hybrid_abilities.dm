/mob/living/carbon/human/proc/hybrid_plant()
	set name = "Plant Weed (10)"
	set desc = "Plants some alien weeds"
	set category = "Abilities"

	if(check_alien_ability(10,1,O_RESIN))
		visible_message(SPAN_GREEN("<B>[src] has planted some alien weeds!</B>"))
		var/obj/O = new /obj/effect/alien/weeds/hybrid(loc)
		if(O)
			O.color = "#422649"
	return
