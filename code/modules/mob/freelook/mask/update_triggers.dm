//UPDATE TRIGGERS, when the chunk (and the surrounding chunks) should update.

#define CULT_UPDATE_BUFFER 30

/mob/living/var/updating_cult_vision = 0

/mob/living/Move()
	var/oldLoc = src.loc
	. = ..()
	if(.)
		if(GLOB.cultnet.provides_vision(src))
			if(!updating_cult_vision)
				updating_cult_vision = 1
				addtimer(CALLBACK(src, .proc/__update_cultnet_vision, oldLoc), CULT_UPDATE_BUFFER)

/mob/living/proc/__update_cultnet_vision(oldLoc)
	updating_cult_vision = FALSE
	if(oldLoc == loc)
		return
	GLOB.cultnet.updateVisibility(oldLoc, FALSE)
	GLOB.cultnet.updateVisibility(loc, FALSE)

#undef CULT_UPDATE_BUFFER

/mob/living/Initialize(mapload)
	. = ..()
	GLOB.cultnet.updateVisibility(src, 0)

/mob/living/Destroy()
	GLOB.cultnet.updateVisibility(src, 0)
	return ..()

/mob/living/rejuvenate()
	var/was_dead = stat == DEAD
	..()
	if(was_dead && stat != DEAD)
		// Arise!
		GLOB.cultnet.updateVisibility(src, 0)

/mob/living/death(gibbed, deathmessage="seizes up and falls limp...")
	if(..(gibbed, deathmessage))
		// If true, the mob went from living to dead (assuming everyone has been overriding as they should...)
		GLOB.cultnet.updateVisibility(src)

/datum/antagonist/add_antagonist(var/datum/mind/player)
	. = ..()
	if(src == cult)
		GLOB.cultnet.updateVisibility(player.current, 0)

/datum/antagonist/remove_antagonist(var/datum/mind/player, var/show_message, var/implanted)
	..()
	if(src == cult)
		GLOB.cultnet.updateVisibility(player.current, 0)
