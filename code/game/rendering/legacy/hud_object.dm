// TODO: reconcile this with screen/actor_hud type?
/atom/movable/screen/hud

/atom/movable/screen/hud/Initialize(mapload, datum/hud/master)
	. = ..()
	hud_legacy = master
	sync_to_hud()

/atom/movable/screen/hud/proc/sync_to_hud()
	if(!hud_legacy)
		return
	icon = hud_legacy.ui_style
	color = hud_legacy.ui_color
	alpha = hud_legacy.ui_alpha

/atom/movable/screen/hud/Click(location, control, params)
	// TODO: add signals to the click abstraction procs on this.
	var/signal_returns = SEND_SIGNAL(src, COMSIG_ATOM_CLICK, usr, location, control, params)
	if(signal_returns & RAISE_ATOM_CLICK_DROP)
		return
	clicked(usr)

/atom/movable/screen/hud/shift_clicked_on(mob/user, location, control, list/params)
	return shift_clicked(usr)

/atom/movable/screen/hud/alt_clicked_on(mob/user, location, control, list/params)
	return alt_clicked(usr)

/atom/movable/screen/hud/ctrl_clicked_on(mob/user, location, control, list/params)
	return ctrl_clicked(usr)

//! Abstracts interface actions to these 4. Middle mouse/Double click not included purposefully for they are awful.

/atom/movable/screen/hud/proc/clicked(mob/user)

/atom/movable/screen/hud/proc/ctrl_clicked(mob/user)

/atom/movable/screen/hud/proc/shift_clicked(mob/user)

/atom/movable/screen/hud/proc/alt_clicked(mob/uesr)
