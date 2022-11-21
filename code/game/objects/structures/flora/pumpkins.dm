/*************
 *! Pumpkins *
 *************/

//Pumpkins
/obj/structure/flora/pumpkin
	name = "pumpkin"
	icon = 'icons/obj/flora/pumpkins.dmi'
	desc = "A healthy, fat pumpkin. It looks as if it was freshly plucked from its vines and shows no signs of decay."
	icon_state = "decor-pumpkin"

/obj/landmark/carved_pumpkin_spawn
	name = "jack o'lantern spawn"
	icon = 'icons/obj/flora/pumpkins.dmi'
	icon_state = "spawner-jackolantern"

/obj/landmark/carved_pumpkin_spawn/New()
	var/new_pumpkin = pick(
		prob(70);/obj/structure/flora/pumpkin,
		prob(60);/obj/structure/flora/pumpkin/carved,
		prob(30);/obj/structure/flora/pumpkin/carved/scream,
		prob(30);/obj/structure/flora/pumpkin/carved/girly,
		prob(10);/obj/structure/flora/pumpkin/carved/owo,
	)
	new new_pumpkin(src.loc)
	..()

/obj/structure/flora/pumpkin/carved
	name = "jack o'lantern"
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has develishly evil-looking eyes and a grinning mouth more than big enough for a very small person to hide in."
	icon_state = "decor-jackolantern"

/obj/structure/flora/pumpkin/carved/scream
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has rounded eyes looking in completely opposite directions and a wide mouth, forever frozen in a silent scream. It looks ridiculous, actually."
	icon_state = "decor-jackolantern-scream"

/obj/structure/flora/pumpkin/carved/girly
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has neatly rounded eyes topped with what appear to be cartoony eyelashes, completed with what seems to have been the carver's attempt at friendly, toothy smile. The mouth is easily the scariest part of its face."
	icon_state = "decor-jackolantern-girly"

/obj/structure/flora/pumpkin/carved/owo
	desc = "A fat, freshly picked pumpkin. This one has a face carved into it! This one has large, round eyes and a squiggly, cat-like smiling mouth. Its pleasantly surprised expression seems to suggest that the pumpkin has noticed something about you."
	icon_state = "decor-jackolantern-owo"

/// Halloween Gift Spawner
/obj/structure/flora/pumpkin/pumpkin_patch
	name = "pumpkin patch"
	desc = "A big pile of pumpkins, guarded by a spooky scarecrow!"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pumpkinpatch"

/obj/structure/flora/pumpkin/pumpkin_patch/presents
	desc = "A big pile of pumpkins, guarded by a spooky scarecrow! It has presents!"
	var/gift_type = /obj/item/b_gift
	var/list/ckeys_that_took = list()

/obj/structure/flora/pumpkin/pumpkin_patch/presents/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!user.ckey)
		return

	if(ckeys_that_took[user.ckey])
		to_chat(user, SPAN_WARNING( "There are no pumpkins that look familiar to you."))
		return
	to_chat(user, SPAN_NOTICE("After a bit of searching, you locate a pumpkin with your face carved into it!"))
	ckeys_that_took[user.ckey] = TRUE
	var/obj/item/G = new gift_type(src)
	user.put_in_hands(G)
