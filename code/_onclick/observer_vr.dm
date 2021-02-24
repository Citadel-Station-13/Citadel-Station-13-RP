/obj/item/paicard/attack_ghost(mob/observer/dead/user)
	if(pai != null) //Have a person in them already?
		user.examinate(src)
		return
	INVOKE_ASYNC(src, .proc/ghost_takeover, user)

/obj/item/paicard/proc/ghost_takeover(mob/observer/dead/user)
	var/choice = input(user, "You sure you want to inhabit this PAI?") in list("Yes", "No")
	var/pai_name = input(user, "Choose your character's name", "Character Name") as text
	var/actual_pai_name = sanitize_name(pai_name)
	var/pai_key
	// Have a person in them already? This also stops the (ghost) from spamming it 52 times before
	// spawning in, as the input()s block the call chain.
	if(pai != null)
		return
	if (isnull(pai_name))
		return
	if(choice == "Yes")
		pai_key = user.key
	else
		return
	var/turf/location = get_turf(src)
	var/obj/item/paicard/card = new(location)
	var/mob/living/silicon/pai/pai = new(card)
	qdel(src)
	pai.key = pai_key
	card.setPersonality(pai)
	pai.SetName(actual_pai_name)
