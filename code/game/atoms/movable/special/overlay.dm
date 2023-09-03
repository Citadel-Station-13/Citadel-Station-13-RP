/atom/movable/overlay
	var/atom/master = null
	anchored = TRUE

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
