/datum/species/holosphere/handle_death(var/mob/living/carbon/human/H, gibbed)
	var/deathmsg = "<span class='userdanger'>Systems critically damaged. Emitters temporarily offline.</span>"
	to_chat(H, deathmsg)
	transform_component.try_transform(force = TRUE)
	holosphere_shell.afflict_stun(hologram_death_duration)
	sleep(hologram_death_duration)
	if(holosphere_shell.stat != DEAD)
		H.revive(force = TRUE, full_heal = TRUE)
		var/regenmsg = "<span class='userdanger'>Emitters have returned online. Systems functional.</span>"
		to_chat(holosphere_shell, regenmsg)
