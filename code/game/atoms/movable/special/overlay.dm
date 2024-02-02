/atom/movable/overlay
	atom_flags = ATOM_ABSTRACT
	vis_flags = VIS_INHERIT_ID
	anchored = TRUE
	// todo: nuke this shit from orbit, this is awful.
	var/atom/master = null

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
