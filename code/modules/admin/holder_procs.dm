/datum/admins/proc/auto_aghost_follow(atom/target)
	if(!check_rights(R_EVENT|R_MOD|R_ADMIN|R_SERVER|R_EVENT))
		return
	var/client/C = usr.client
	if(!isobserver(usr))
		C.admin_ghost()
	var/mob/observer/dead/G = C.mob
	G.ManualFollow(target)

/datum/admins/proc/teleport_movable_atom(atom/movable/AM, atom/targetloc)
	var/message = "[owner == usr? "[key_name_admin(usr)]" : "[key_name_admin(usr)] (usr) [key_name_admin(owner)] owner"] teleported [AM]([REF(AM)]) to [targetloc]([ADMIN_COORDJMP(targetloc)])."
	log_admin(message)
	message_admins(message)
	AM.forceMove(targetloc)
