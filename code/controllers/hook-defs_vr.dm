//The base hooks themselves

//New() hooks
/hook/client_new

/hook/mob_new

/hook/living_new

// Hook for when a mob de-spawns!
/hook/despawn

//
//Hook helpers to expand hooks to others
//
/hook/mob_new/proc/chain_hooks(mob/M)
	var/result = 1
	if(isliving(M))
		if(!hook_vr("living_new",args))
			result = 0

	//Return 1 to superhook
	return result
