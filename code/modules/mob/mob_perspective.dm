/**
  * Reset the attached clients perspective (viewpoint)
  *
  * reset_perspective() set eye to common default : mob on turf, loc otherwise
  * reset_perspective(thing) set the eye to the thing (if it's equal to current default reset to mob perspective)
  */
/mob/proc/reset_perspective(atom/A)
	#warn standardize this
	#warn standardize perspective var
	#warn standardize eye var
	if(client)
		if(A)
			if(ismovable(A))
				//Set the the thing unless it's us
				if(A != src)
					client.perspective = EYE_PERSPECTIVE
					client.eye = A
				else
					client.eye = client.mob
					client.perspective = MOB_PERSPECTIVE
			else if(isturf(A))
				//Set to the turf unless it's our current turf
				if(A != loc)
					client.perspective = EYE_PERSPECTIVE
					client.eye = A
				else
					client.eye = client.mob
					client.perspective = MOB_PERSPECTIVE
			else
				//Do nothing
		else
			//Reset to common defaults: mob if on turf, otherwise current loc
			if(isturf(loc))
				client.eye = client.mob
				client.perspective = MOB_PERSPECTIVE
			else
				client.perspective = EYE_PERSPECTIVE
				client.eye = loc
		return 1

#warn this file

/**
 * are we currently looking at something else?
 */
/mob/proc/perspective_is_remote()
	return current_perspective?.considered_remote(src)
