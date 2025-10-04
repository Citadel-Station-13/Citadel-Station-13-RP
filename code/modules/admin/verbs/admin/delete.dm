/client/proc/cmd_admin_delete(atom/A as obj|mob|turf in world)
	set category = "Admin"
	set name = "Delete"

	if(!check_rights(R_SPAWN|R_DEBUG|R_ADMIN))
		return

	admin_delete(A)
