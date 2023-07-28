//* material checks

/// Checks if a material needs processing
#define MATERIAL_NEEDS_PROCESSING(mat) (mat?.material_trait_flags & MATERIAL_TRAIT_TICKING)
/// Checks if a material needs examine hooks
#define MATERIAL_NEEDS_EXAMINE(mat) (mat?.material_trait_flags & MATERIAL_TRAIT_EXAMINE)

//* object checks

/// We are ticking materials.
#define IS_TICKING_MATERIALS(A) (A.atom_flags & ATOM_MATERIAL_TICKING)
#define START_TICKING_MATERIALS(A) SSmaterials.add_ticked_object(src)
#define STOP_TICKING_MATERIALS(A) SSmaterials.remove_ticked_object(src)
