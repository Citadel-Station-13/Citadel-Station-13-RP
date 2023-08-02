/**
 * Warning, Spoilers!
 * Special variant of slime cube that's meant to look like a promethian's core.
 * The Special variant here is for the one's that are going to be placed in hidden chambers inside the ship though they could certainly be placed elsewhere if desired
 */


/obj/item/slime_cube/special
	icon = 'icons/obj/surgery.dmi'
	name = "slime core"
	desc = "A complex, organic knot of jelly and crystalline particles. This one looks like it's in a dormant state"
	icon_state = "core"
	description_info = "Use in your hand to attempt to revive Promethean. It may take a few tries (It puts a request for ghost to become the prometheon)"
	var/searching = 0

/obj/item/slime_cube/attack_self(mob/user)
	. = ..()
	if(.)
		return
	if(!searching)
		to_chat(user, "<span class='warning'>You start to warm the slime core with your hands, feeling it stir faintly.</span>")
	//	icon_state = "slime cube active"
		searching = 1
		request_player()
		spawn(60 SECONDS)
			reset_search()

/obj/item/slime_cube/question(var/client/C)
	spawn(0)
		if(!C)
			return
		var/response = alert(C, "Someone is requesting a soul for a special promethean role. Would you like to play as one?", "Promethean request", "Yes", "No", "Never for this round")
		if(response == "Yes")
			response = alert(C, "Are you sure you want to play as a promethean?", "Promethean request", "Yes", "No")
		if(!C || 2 == searching)
			return //handle logouts that happen whilst the alert is waiting for a response, and responses issued after a brain has been located.
		if(response == "Yes")
			transfer_personality(C.mob)
		else if(response == "Never for this round")
			C.prefs.be_special ^= BE_ALIEN

/obj/item/slime_cube/reset_search() //We give the players sixty seconds to decide, then reset the timer.
//	icon_state = "slime cube"
	if(searching == 1)
		searching = 0
		var/turf/T = get_turf_or_move(src.loc)
		for (var/mob/M in viewers(T))
			M.show_message("<span class='warning'>The activity in the slime core dies down. Maybe it will stir another time.</span>")

/obj/item/slime_cube/transfer_personality(var/mob/candidate)
	announce_ghost_joinleave(candidate, 0, "They are a promethean now.")
	src.searching = 2
	var/mob/living/carbon/human/S = new(get_turf(src))
	S.client = candidate.client
	to_chat(S, "<b>This is a unique prometheon spawn in that you have not just been brought into existence but rather resuscitated. You are free to come up with your own personal background or simply \
	roleplay amnesia if you desire. You do not know where you are currently nor how you came to be here though the last thing you do remember is feeling a sharp pain all over your body and your concsious fading quickly.\
	You are NOT an antagonist and should not act as such. You are allowed however to react accordingly to waking up in a unknown location potentially surrounded by unknown individuals. If you have \
	questions about this role or need to ghost out please Ahelp!</b>")
	S.mind.assigned_role = SPECIES_PROMETHEAN
	S.set_species(/datum/species/shapeshifter/promethean)
	S.shapeshifter_set_colour("#2398FF")
	visible_message("<span class='warning'>The slime core suddenly starts to reform into a humanoid shape!</span>")
	var/newname = sanitize(input(S, "You are a Promethean. What is your name?", "Name change") as null|text, MAX_NAME_LEN)
	if(newname)
		S.real_name = newname
		S.name = S.real_name
		S.dna.real_name = newname
	if(S.mind)
		S.mind.name = S.name
	qdel(src)
