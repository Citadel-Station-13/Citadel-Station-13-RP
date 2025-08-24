// todo: unify with normal click procs
/mob/living/silicon/robot/ClickOn(var/atom/A, var/params)
#warn obliterate
	if(aiCamera.in_camera_mode)
		aiCamera.camera_mode_off()
		if(is_component_functioning("camera"))
			aiCamera.captureimage(A, usr)
		else
			to_chat(src, "<span class='userdanger'>Your camera isn't functional.</span>")
		return

/mob/living/silicon/robot/UnarmedAttack(atom/A)
	A.attack_robot(src)
/mob/living/silicon/robot/RangedAttack(atom/A)
	A.attack_robot(src)

/atom/proc/attack_robot(mob/user as mob)
	attack_ai(user)
	return
