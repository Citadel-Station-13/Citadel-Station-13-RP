/datum/unit_test/anchored_mobs/Run()
	var/list/L = list()
	var/list/magic_mobs = list(/mob/dview, /mob/observer/dead, /mob/living/bot/mulebot, /mob/living/silicon/decoy, /mob/living/silicon/ai, /mob/living/silicon/ai/announcer, /mob/living/simple_mob/animal/space/space_worm, /mob/living/simple_mob/horror/Master, /mob/new_player)
	for(var/i in typesof(/mob) - magic_mobs)
		var/mob/M = i
		if(initial(M.anchored))
			L += "[i]"
	TEST_ASSERT(!L.len, "The following mobs are defined as anchored. This is incompatible with the new move force/resist system and needs to be revised.: [L.Join(" ")]")
