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

#warn AAAAAAAAAAAAAAA + lazy tick support

/// We are ticking materials.
#define IS_TICKING_MATERIALS(A) (A.atom_flags & ATOM_MATERIALS_TICKING)
#define START_TICKING_MATERIALS(A) SSmaterials.add_ticked_object(src)
#define STOP_TICKING_MATERIALS(A) SSmaterials.remove_ticked_object(src)
