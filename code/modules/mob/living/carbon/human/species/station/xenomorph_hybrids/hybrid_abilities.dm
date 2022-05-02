/mob/living/carbon/human/proc/active_heal()
	set name = "Focused Healing"
	set desc = "You focus on regenerating your wounds."
	set category = "Abilities"

	src.healing = !src.healing
	if(healing)
		to_chat(src, SPAN_NOTICEALIEN("You begin to heal faster."))
	else
		to_chat(src, SPAN_NOTICEALIEN("You stop healing faster."))

/mob/living/carbon/human/proc/hybrid_plant()
	set name = "Plant Weed (10)"
	set desc = "Plants some alien weeds"
	set category = "Abilities"

	if(check_alien_ability(10,1,O_RESIN))
		visible_message(SPAN_ALERTALIEN("[src] has planted some alien weeds!"))
		var/obj/O = new /obj/effect/alien/weeds/hybrid(loc)
		if(O)
			O.color = "#422649"
	return
