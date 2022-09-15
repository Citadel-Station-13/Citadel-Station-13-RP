///Compile all the overlays for an atom from the cache lists
// |= on overlays is not actually guaranteed to not add same appearances but we're optimistically using it anyway.
#define COMPILE_OVERLAYS(A)\
	do {\
		var/list/ad = A.add_overlays;\
		var/list/rm = A.remove_overlays;\
		if(LAZYLEN(rm)){\
			A.overlays -= rm;\
			rm.Cut();\
		}\
		if(LAZYLEN(ad)){\
			A.overlays |= ad;\
			ad.Cut();\
		}\
		for(var/I in A.alternate_appearances){\
			var/datum/atom_hud/alternate_appearance/AA = A.alternate_appearances[I];\
			if(AA.transfer_overlays){\
				AA.copy_overlays(A, TRUE);\
			}\
		}\
		A.flags &= ~OVERLAY_QUEUED;\
	} while (FALSE)
