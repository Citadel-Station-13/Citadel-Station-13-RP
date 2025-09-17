/atom/movable/overlay
	atom_flags = ATOM_ABSTRACT
	vis_flags = VIS_INHERIT_ID
	anchored = TRUE
	// todo: nuke this shit from orbit, this is awful.
	var/atom/master = null

/atom/movable/overlay/attackby(obj/item/I, mob/user, list/params, clickchain_flags, damage_multiplier)
	return master.attackby(arglist(args))

/atom/movable/overlay/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	return master.attack_hand(arglist(args))
