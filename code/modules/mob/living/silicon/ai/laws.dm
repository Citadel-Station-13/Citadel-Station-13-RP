/mob/living/silicon/ai/proc/show_laws_verb()
	set category = "AI Commands"
	set name = "Show Laws"
	src.show_laws()

/mob/living/silicon/ai/show_laws(everyone = FALSE)
	var/who

	if (everyone)
		who = world
	else
		who = src
		to_chat(who, SPAN_BOLD("Obey these laws:"))

	src.laws_sanity_check()
	src.laws.show_laws(who)

/mob/living/silicon/ai/add_ion_law(law)
	..()
	for(var/mob/living/silicon/robot/R in GLOB.mob_list)
		if(R.lawupdate && (R.connected_ai == src))
			R.show_laws()

/mob/living/silicon/ai/proc/ai_checklaws()
	set category = "AI Commands"
	set name = "State Laws"
	subsystem_law_manager()

/mob/proc/showLaws(mob/living/silicon/S)
	return

/mob/observer/dead/showLaws(mob/living/silicon/S)
	if(antagHUD || is_admin(src))
		S.laws.show_laws(src)
