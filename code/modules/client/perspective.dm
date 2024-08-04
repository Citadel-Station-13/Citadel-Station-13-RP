/**
 * switch perspective - null will cause us to shunt our eye to nullspace!
 */
/client/proc/set_perspective(datum/perspective/P)
	if(using_perspective)
		using_perspective.remove_client(src, TRUE)
		if(using_perspective)
			stack_trace("using perspective didn't clear")
			using_perspective = null
	if(!P)
		eye = null
		lazy_eye = 0
		perspective = EYE_PERSPECTIVE
		return
	P.add_client(src)
	if(using_perspective != P)
		stack_trace("using perspective didn't set")

/**
 * reset perspective to default - usually to our mob's
 */
/client/proc/reset_perspective()
	set_perspective(mob.get_perspective())
