/// from base of /atom/proc/inducer_scan: (obj/item/inducer/I, list/things_to_induce, inducer_flags)
#define COMSIG_ATOM_INDUCER_SCAN			"inducer_check"
	/// completely block inducer action, no feedback
	#define COMPONENT_BLOCK_INDUCER			(1<<0)
	/// say something is interfering
	#define COMPONENT_INTERFERE_INDUCER		(1<<1)
	/// say we're full
	#define COMPONENT_FULL_INDUCER			(1<<2)

/// from base of /datum/proc/inducer_act: (obj/item/inducer/I, amount, inducer_flags)
#define COMSIG_DATUM_INDUCER_ACT				"inducer_act"
