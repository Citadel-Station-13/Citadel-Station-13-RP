//Revive from revival stasis
/mob/proc/changeling_revive()
	set category = "Changeling"
	set name = "Revive"
	set desc = "We are ready to revive ourselves on command."

	var/datum/changeling/changeling = changeling_power(0,0,100,DEAD)
	if(!changeling)
		return 0

	if(changeling.max_geneticpoints < 0) //Absorbed by another ling
		to_chat(src, "<span class='danger'>You have no genomes, not even your own, and cannot revive.</span>")
		return 0

	if(src.stat == DEAD)
		dead_mob_list -= src
		living_mob_list += src

	revive(TRUE, TRUE)

	to_chat(C, "<span class='notice'>We have regenerated.</span>")
	C.update_mobility()
	C.mind.changeling.purchased_powers -= C
	feedback_add_details("changeling_powers","CR")
	C.set_stat(CONSCIOUS)
	C.forbid_seeing_deadchat = FALSE
	C.timeofdeath = null
	remove_verb(src, /mob/proc/changeling_revive)
	// re-add our changeling powers
	C.make_changeling()



	return 1
