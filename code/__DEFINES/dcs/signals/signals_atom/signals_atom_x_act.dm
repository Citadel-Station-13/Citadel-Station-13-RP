/**
 *! ## Atom x_act() Procs Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! ## /x_act Signals.
/// From the [EX_ACT] wrapper macro: (severity, target)
////#define COMSIG_ATOM_EX_ACT "atom_ex_act"
/// From base of atom/emp_act(): (severity)
////#define COMSIG_ATOM_EMP_ACT "atom_emp_act"
/// From base of atom/fire_act(): (exposed_temperature, exposed_volume)
////#define COMSIG_ATOM_FIRE_ACT "atom_fire_act"
/// From base of atom/bullet_act(): (/obj/projectile, def_zone)
////#define COMSIG_ATOM_BULLET_ACT "atom_bullet_act"
/// From base of atom/CheckParts(): (list/parts_list, datum/crafting_recipe/R)
////#define COMSIG_ATOM_CHECKPARTS "atom_checkparts"
/// From base of atom/CheckParts(): (atom/movable/new_craft) - The atom has just been used in a crafting recipe and has been moved inside new_craft.
////#define COMSIG_ATOM_USED_IN_CRAFT "atom_used_in_craft"
/// From base of atom/blob_act(): (/obj/structure/blob)
////#define COMSIG_ATOM_BLOB_ACT "atom_blob_act"
	//? If returned, forces nothing to happen when the atom is attacked by a blob
	////#define COMPONENT_CANCEL_BLOB_ACT (1<<0)
/// From base of atom/acid_act(): (acidpwr, acid_volume)
////#define COMSIG_ATOM_ACID_ACT "atom_acid_act"
/// From base of atom/emag_act(): (/mob/user)
////#define COMSIG_ATOM_EMAG_ACT "atom_emag_act"
/// From base of atom/narsie_act(): ()
////#define COMSIG_ATOM_NARSIE_ACT "atom_narsie_act"
/// From base of atom/ratvar_act(): ()
////#define COMSIG_ATOM_RATVAR_ACT "atom_ratvar_act"
/// From base of atom/rcd_act(): (/mob, /obj/item/construction/rcd, passed_mode)
////#define COMSIG_ATOM_RCD_ACT "atom_rcd_act"
/// From base of atom/singularity_pull(): (/datum/component/singularity, current_size)
////#define COMSIG_ATOM_SING_PULL "atom_sing_pull"
/// From obj/machinery/bsa/full/proc/fire(): ()
////#define COMSIG_ATOM_BSA_BEAM "atom_bsa_beam_pass"
	////#define COMSIG_ATOM_BLOCKS_BSA_BEAM (1<<0)

/// Called when teleporting into a protected turf: (channel, turf/origin)
#define COMSIG_ATOM_INTERCEPT_TELEPORT "intercept_teleport"
	#define COMPONENT_BLOCK_TELEPORT (1<<0)
