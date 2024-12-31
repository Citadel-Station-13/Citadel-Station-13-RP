/datum/species/holosphere/handle_death(var/mob/living/carbon/human/H, gibbed)
	var/deathmsg = "<span class='userdanger'>Systems critically damaged. Emitters temporarily offline.</span>"
	to_chat(H, deathmsg)
	try_transform(force = TRUE)
	holosphere_shell.afflict_stun(hologram_death_duration)
	sleep(hologram_death_duration)
	if(holosphere_shell.stat != DEAD)
		// temp fix because i hate the revive proc and it hates me
		try_untransform(force = TRUE)
		H.revive(force = TRUE, full_heal = TRUE)
		try_transform(force = TRUE)
		// temp fix end
		// H.revive(force = TRUE, full_heal = TRUE)
		var/regenmsg = "<span class='userdanger'>Emitters have returned online. Systems functional.</span>"
		to_chat(holosphere_shell, regenmsg)
