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
