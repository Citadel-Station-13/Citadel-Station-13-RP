/**
 * Client Stat()
 *
 * We only run this if the statpanel is on BYOND mode right now.
 */
/client/Stat()
	if(!tgui_stat?.byond_stat_active)
		return
	..()	// hit mob.Stat()
	if(!statpanel("Turf"))
		return
	if(!tgui_stat.byond_stat_turf)
		stat("No turf listed ; Alt click on an adjacent turf to view contents.")
		return
	stat(tgui_stat.byond_stat_turf.name, tgui_stat.byond_stat_turf)
	for(var/atom/movable/AM as anything in tgui_stat.byond_stat_turf)
		if(!AM.mouse_opacity)
			continue
		if(AM.invisibility > using_perspective.see_invisible)
			continue
		stat(null, AM)
