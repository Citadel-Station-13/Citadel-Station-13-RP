//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

//* material checks

/// Checks if a material needs processing
#define MATERIAL_NEEDS_PROCESSING(mat) (mat?.material_trait_flags & MATERIAL_TRAIT_TICKING)
/// Checks if a material needs examine hooks
#define MATERIAL_NEEDS_EXAMINE(mat) (mat?.material_trait_flags & MATERIAL_TRAIT_EXAMINE)
/// checks if a material needs registration for setup/teardown
#define MATERIAL_NEEDS_REGISTRATION(mat) (mat?.material_trait_flags & (MATERIAL_TRAIT_REGISTRATION | MATERIAL_TRAIT_TICKING))
/// checks if a material needs attack semantics
#define MATERIAL_NEEDS_ATTACK_SEMANTICS(mat) (mat?.material_trait_flags & MATERIAL_TRAIT_ATTACK)
/// checks if a material needs defense semantics
#define MATERIAL_NEEDS_DEFEND_SEMANTICS(mat) (mat?.material_trait_flags & MATERIAL_TRAIT_DEFEND)

//* object checks

/// We are ticking materials.
#define IS_TICKING_MATERIALS(A) (A.atom_flags & ATOM_MATERIALS_TICKING)
#define START_TICKING_MATERIALS(A) SSmaterials.add_ticked_object(src)
#define STOP_TICKING_MATERIALS(A) SSmaterials.remove_ticked_object(src)

//* /atom level invocation of traits

/// Invocation of material traits
/// A - the atom
/// CHECK - material_trait_flags to check
/// INVOKE - procname on /datum/material_trait to invoke
/// ARGS... - directly appended to the material_trait proc invocation after the params 'host' being A, and 'data' being the data the trait has on A.
#define MATERIAL_INVOKE(A, CHECK, INVOKE, ARGS...) \
	if(A.material_trait_flags & CHECK) { \
		if(islist(A.material_traits)) { \
			for(var/datum/material_trait/__trait as anything in A.material_traits){ \
				if(!(__trait.material_trait_flags & CHECK)) { \
					continue; \
				} \
				__trait.INVOKE(A, A.material_traits[__trait], ##args); \
			} \
		} \
		else { \
			var/datum/material_trait/__trait = A.material_traits; \
			__trait.INVOKE(A, A.material_traits_data, ##args); \
		} \
	}

/// Invocation of material traits with flag return
/// OUT - flag returns from invocations are binary OR'd into this.
/// A - the atom
/// CHECK - material_trait_flags to check
/// INVOKE - procname on /datum/material_trait to invoke
/// ARGS... - directly appended to the material_trait proc invocation after the params 'host' being A, and 'data' being the data the trait has on A.
#define MATERIAL_INVOKE_OUT(OUT, A, CHECK, INVOKE, ARGS...) \
	if(A.material_trait_flags & CHECK) { \
		if(islist(A.material_traits)) { \
			for(var/datum/material_trait/__trait as anything in A.material_traits){ \
				if(!(__trait.material_trait_flags & CHECK)) { \
					continue; \
				} \
				OUT |= __trait.INVOKE(A, A.material_traits[__trait], ##args); \
			} \
		} \
		else { \
			var/datum/material_trait/__trait = A.material_traits; \
			OUT |= __trait.INVOKE(A, A.material_traits_data, ##args); \
		} \
	}
