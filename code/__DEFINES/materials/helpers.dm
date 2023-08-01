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

#define MATERIAL_TRAIT_INVOCATION(A, CHECK, INVOKE, ARGS...) \
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

#warn impl - this doesn't call on_add and on_remove...

/// ensure this is called once and only once when a material is added to an atom
/// alternatively, don't call this at all if you don't want to register traits.
/// this define should null-check, as null is a valid material.
#define MATERIAL_REGISTER(MAT, ATOM, PRIMARY) \
	if(!isnull(MAT?.material_traits)) { \
		for(var/datum/material_trait/__trait as anything in MAT.material_traits) { \
			if(islist(ATOM.material_traits)) { \
				var/__old = ATOM.material_traits[__trait]; \
				ATOM.material_traits[__trait] = __trait.on_add(ATOM, __old, MAT.material_traits[__trait]); \
				ATOM.material_trait_flags |= __trait.material_trait_flags; \
			} \
			else if(isnull(ATOM.material_traits)) { \
				ATOM.material_traits = __trait; \
				ATOM.material_traits_data = __trait.on_add(ATOM, null, MAT.material_traits[__trait]); \
				ATOM.material_trait_flags = __trait.material_trait_flags; \
			} \
			else { \
				var/datum/material_trait/__other = ATOM.material_traits; \
				var/__old = ATOM.material_traits_data; \
				if(__other == __trait) { \
					ATOM.material_traits_data = __trait.on_add(ATOM, __old, MAT.material_traits[__trait]); \
				} \
				else { \
					ATOM.material_traits = list(__other = __old, __trait = __trait.on_add(ATOM, __old, MAT.material_traits[__trait])); \
					ATOM.material_traits_data = null; \
					ATOM.material_trait_flags = __other.material_trait_flags | __trait.material_trait_flags; \
				} \
			} \
		} \
	}

/// ensure this is called once and only once when a material is deleted from an atom
/// this is only to be used if the material was registered. if it was never registered, DO NOT call this.
/// this define should null-check, as null is a valid material.
#define MATERIAL_UNREGISTER(MAT, ATOM, PRIMARY) \
	if(!isnull(MAT?.material_traits)) { \
		for(var/datum/material_trait/__trait as anything in MAT.material_traits) { \
			if(islist(ATOM.material_traits)) { \
				var/__old_data = ATOM.material_traits[__trait]; \
				var/__new_data = __trait.on_remove(ATOM, __old_data, MAT.material_traits[__trait]); \
				if(isnull(__new_data)) { \
					ATOM.material_traits -= __trait; \
					if(length(ATOM.material_traits) == 1){ \
						var/datum/material_trait/__other = ATOM.material_traits[1]; \
						ATOM.material_traits_data = ATOM.material_traits[__other]; \
						ATOM.material_traits = __other; \
						ATOM.material_trait_flags = __other.material_trait_flags; \
					} \
					else { \
						ATOM.material_trait_flags = NONE; \
						for(var/datum/material_trait/__other as anything in ATOM.material_traits){ \
							ATOM.material_trait_flags |= __other.material_trait_flags; \
						} \
					} \
				} \
				else { \
					ATOM.material_traits[__trait] = __new_data; \
				} \
			} \
			else { \
				ASSERT(ATOM.material_traits == __trait); \
				var/__new_data = __trait.on_remove(ATOM, ATOM.material_traits_data, MAT.material_traits[__trait]); \
				if(isnull(__new_data)){ \
					ATOM.material_traits = null; \
					ATOM.material_traits_data = null; \
					ATOM.material_trait_flags = NONE; \
				} \
				else { \
					ATOM.material_traits_data = __new_data; \
				} \
			} \
		} \
	}
