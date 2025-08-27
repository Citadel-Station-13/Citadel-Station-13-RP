/client/var/inquisitive_ghost = 1
/mob/observer/dead/verb/toggle_inquisition() // warning: unexpected inquisition
	set name = "Toggle Inquisitiveness"
	set desc = "Sets whether your ghost examines everything on click by default"
	set category = "Ghost"
	if(!client) return
	client.inquisitive_ghost = !client.inquisitive_ghost
	if(client.inquisitive_ghost)
		to_chat(src, "<span class='notice'>You will now examine everything you click on.</span>")
	else
		to_chat(src, "<span class='notice'>You will no longer examine things you click on.</span>")

// Oh by the way this didn't work with old click code which is why clicking shit didn't spam you
/atom/proc/attack_ghost(mob/observer/dead/user)
	SHOULD_CALL_PARENT(TRUE)
	SEND_SIGNAL(src, COMSIG_ATOM_ATTACK_GHOST, user)
	// TODO: main ai interact bay code fucking disgusts me wtf
	if(IsAdminGhost(user))		// admin AI interact
		AdminAIInteract(user)
		return
	if(user.client && user.client.inquisitive_ghost)
		user.examinate(src)

// defaults to just attack_ai
/atom/proc/AdminAIInteract(mob/user)
	return attack_ai(user)
