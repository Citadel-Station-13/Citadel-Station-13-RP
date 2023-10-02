/obj/item/card/emag_broken
	desc = "It's a card with a magnetic strip attached to some circuitry. It looks too busted to be used for anything but salvage."
	name = "broken cryptographic sequencer"
	icon_state = "emag-spent"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)

/obj/item/card/emag
	desc = "It's a card with a magnetic strip attached to some circuitry."
	name = "cryptographic sequencer"
	icon_state = "emag"
	item_state = "card-id"
	origin_tech = list(TECH_MAGNET = 2, TECH_ILLEGAL = 2)
	var/uses = 10

/obj/item/card/emag/resolve_attackby(atom/W, mob/user, params, attack_modifier = 1)
	var/used_uses = W.emag_act(uses, user, src)
	if(used_uses < 0)
		return ..(W, user)

	uses -= used_uses
	W.add_fingerprint(user)
	//V Because some things (read lift doors) don't get emagged
	if(used_uses)
		log_and_message_admins("emagged \an [W].")
	else
		log_and_message_admins("attempted to emag \an [W].")
	log_and_message_admins("emagged \an [W].")

	if(uses<1)
		to_chat(user, "<span class='warning'>\The [src] fizzles and sparks - it seems it's been used once too often, and is now spent.</span>")
		var/obj/item/card/emag_broken/junk = new(user.loc)
		junk.add_fingerprint(user)
		qdel(src)

	return 1

/obj/item/card/emag/attackby(obj/item/O as obj, mob/user as mob)
	if(istype(O, /obj/item/stack/telecrystal))
		var/obj/item/stack/telecrystal/T = O
		if(T.amount < 1)
			to_chat(usr, "<span class='notice'>You are not adding enough telecrystals to fuel \the [src].</span>")
			return
		uses += T.amount/2 //Gives 5 uses per 10 TC
		uses = CEILING(uses, 1) //Ensures no decimal uses nonsense, rounds up to be nice
		to_chat(usr, "<span class='notice'>You add \the [O] to \the [src]. Increasing the uses of \the [src] to [uses].</span>")
		qdel(O)

// todo: emag_act
// todo: emag_disrupt
// oh if only we had right click
