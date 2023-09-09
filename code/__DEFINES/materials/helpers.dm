//* This file is explicitly licensed under the MIT license. *//
//* Copyright (c) 2023 Citadel Station developers.          *//

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
