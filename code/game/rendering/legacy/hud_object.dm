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
	SEND_SIGNAL(src, COMSIG_CLICK, location, control, params)
	clicked(usr)

/atom/movable/screen/hud/ShiftClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_SHIFT, user)
	shift_clicked(usr)

/atom/movable/screen/hud/AltClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_ALT, user)
	alt_clicked(usr)

/atom/movable/screen/hud/CtrlClick(mob/user)
	SEND_SIGNAL(src, COMSIG_CLICK_CTRL, user)
	ctrl_clicked(usr)

//! Abstracts interface actions to these 4. Middle mouse/Double click not included purposefully for they are awful.

/atom/movable/screen/hud/proc/clicked(mob/user)

/atom/movable/screen/hud/proc/ctrl_clicked(mob/user)

/atom/movable/screen/hud/proc/shift_clicked(mob/user)

/atom/movable/screen/hud/proc/alt_clicked(mob/uesr)
