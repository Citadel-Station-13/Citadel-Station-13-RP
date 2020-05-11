/obj/machinery/transhuman/resleever/MouseDrop_T(var/mob/target, var/mob/user) //Allows borgs to put people into resleeving without external assistance
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !ishuman(target))
		return
	put_mob(target)