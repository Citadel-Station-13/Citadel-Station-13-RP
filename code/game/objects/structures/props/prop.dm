//The base 'prop' for PoIs or other large junk.

/obj/structure/prop
	name = "something"
	desc = "My description is broken, bug a developer."
	icon = 'icons/obj/structures.dmi'
	icon_state = "safe"
	density = TRUE
	anchored = TRUE
	var/interaction_message = null

/obj/structure/prop/attack_hand(mob/living/user) // Used to tell the player that this isn't useful for anything.
	if(!istype(user))
		return FALSE
	if(!interaction_message)
		return ..()
	else
		to_chat(user, interaction_message)

/obj/structure/prop/halfstair
	name = "Stair"
	desc = "Steps."
	icon = 'icons/props/halfstairs.dmi'
	density = FALSE
	anchored = TRUE

/obj/structure/prop/ambulance
	name = "Ambulance"
	desc = "A long abandoned ambulance, out of fuel and missing the keys... Perhaps you can find something in the back?"
	icon = 'icons/props/ambulance.dmi'
	icon_state = "ambulance"
	density = TRUE
	anchored = TRUE

/obj/structure/prop/brokencomputer
	name = "Unknown console"
	desc = "The computers screen appears to be frozen."
	icon = 'icons/props/computer.dmi'
	icon_state = "bluescreen"
	density = TRUE
	anchored = TRUE

/obj/structure/prop/brokendrncntrl
	name = "Door control console"
	desc = "The console appears to be stuck in a loop, attempting over and over again to open a nearby door."
	icon = 'icons/props/computer.dmi'
	icon_state = "doorcntrl"
	density = TRUE
	anchored = TRUE

/obj/structure/prop/brokendrncntrl
	name = "damaged deployable barrier"
	desc = "Looks like it has seen better days."
	icon = 'icons/props/security.dmi'
	icon_state = "Damaged SecBarrier"
	density = TRUE
	anchored = TRUE