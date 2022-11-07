//Pushable but not pullable objects.

/obj/structure/girder/puzzle
	name = "perfectly smooth glass pillar"
	desc = "A pillar made of a strange glass tough looking glass. You can't seem to pull it no matter how hard you try, though perhaps you could push?"
	icon_state = "puzzle-glass"
	explosion_resistance = 100
	anchored = 0
	max_health = 9999999
	health = 9999999

	pull_resist = MOVE_RESIST_ABSOLUTE

/obj/structure/girder/puzzle/update_icon()
	if(anchored)
		icon_state = initial(icon_state)
	else
		icon_state = initial(icon_state)


/obj/structure/girder/puzzle/Initialize(mapload, materialtype, rmaterialtype, girder_material)
	return ..(mapload, "dungeonium")

/obj/structure/girder/attackby(obj/item/W as obj, mob/user as mob)
	if(W.is_wrench() && state == 0)
		to_chat(user, "<span class='notice'>You find no bolts to dissamble the pillar...</span>")
		return

	else if(istype(W, /obj/item/pickaxe/plasmacutter))
		to_chat(user, "<span class='notice'>No matter how much you heat it the pillar doesn't seem any weaker...</span>")
		return

	else if(istype(W, /obj/item/pickaxe/diamonddrill))
		to_chat(user, "<span class='notice'>Your drill grinds uselessly against the pillar...</span>")
		return

	else if(W.is_screwdriver())
		to_chat(user, "<span class='notice'>You find no screws to unscrew on the pillar...</span>")
		return

	else if(W.is_crowbar())
		to_chat(user, "<span class='notice'>The pillar doesn't budge when you attempt to dislodge it...</span>")
		return

	else if(istype(W, /obj/item/stack/material))
		to_chat(user, "<span class='notice'>Why would you want to reinforce a pillar?</span>")
		return

	else
		return ..()

/obj/structure/girder/puzzle/block
	name = "perfectly smooth metal block"
	desc = "A sturdy metal pillar that is smooth all around. You can't seem to get a grip on it."
	icon_state = "puzzle-block"
	opacity = 1

