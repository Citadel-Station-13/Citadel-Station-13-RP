//* Movement, including getters / setters *//

/// flying
/// use add/remove_atom_flying() to modify
#define TRAIT_MOVABLE_FLYING "atom_flying"
DATUM_TRAIT(/atom, TRAIT_MOVABLE_FLYING)
/// phsaing
/// use add/remove_atom_phasing() to modify
#define TRAIT_MOVABLE_PHASING "atom_phasing"
DATUM_TRAIT(/atom, TRAIT_MOVABLE_PHASING)
/// floating
/// use add/remove_atom_floating() to modify
#define TRAIT_MOVABLE_FLOATING "atom_floating"
DATUM_TRAIT(/atom, TRAIT_MOVABLE_FLOATING)

/atom/movable/proc/add_atom_flying(source)
	ADD_TRAIT(src, TRAIT_MOVABLE_FLYING, source)
	update_movement_type()

/atom/movable/proc/add_atom_phasing(source)
	ADD_TRAIT(src, TRAIT_MOVABLE_PHASING, source)
	update_movement_type()

/atom/movable/proc/add_atom_floating(source)
	ADD_TRAIT(src, TRAIT_MOVABLE_FLOATING, source)
	update_movement_type()

/atom/movable/proc/remove_atom_flying(source)
	REMOVE_TRAIT(src, TRAIT_MOVABLE_FLYING, source)
	update_movement_type()

/atom/movable/proc/remove_atom_phasing(source)
	REMOVE_TRAIT(src, TRAIT_MOVABLE_PHASING, source)
	update_movement_type()

/atom/movable/proc/remove_atom_floating(source)
	REMOVE_TRAIT(src, TRAIT_MOVABLE_FLOATING, source)
	update_movement_type()

//* Misc *//

/// Freeflight levels should not obliterate this
/// * Technically used for overmaps, but feel free to check for this generally.
#define TRAIT_MOVABLE_FREEFLIGHT_PERMEANCE "freeflight_permeance"
DATUM_TRAIT(/atom/movable, TRAIT_MOVABLE_FREEFLIGHT_PERMEANCE)

/atom/movable/proc/add_movable_freeflight_permeance(source)
	ADD_TRAIT(src, TRAIT_MOVABLE_FREEFLIGHT_PERMEANCE, source)
	movable_flags |= MOVABLE_NO_LOST_IN_SPACE

/atom/movable/proc/remove_movable_freeflight_permeance(source)
	REMOVE_TRAIT(src, TRAIT_MOVABLE_FREEFLIGHT_PERMEANCE, source)
	if(!HAS_TRAIT(src, TRAIT_MOVABLE_FREEFLIGHT_PERMEANCE))
		movable_flags &= ~MOVABLE_NO_LOST_IN_SPACE

/// Freeflight levels should not obliterate this, but recursively
/// * This propagates the trait up recursively to the top-level movable with
///   components. This is usually what you want if you want to set-and-forget.
/// * That said, if your thing will never be contained in another atom, do not use this,
///   as this has a cost to it.
#define TRAIT_MOVABLE_RECURSIVE_FREEFLIGHT_PERMEANCE "recursive_freeflight_permeance"

/atom/movable/proc/add_movable_recursive_freeflight_permeance(source)
	ADD_TRAIT(src, TRAIT_MOVABLE_RECURSIVE_FREEFLIGHT_PERMEANCE, source)
	LoadComponent(/datum/component/recursive_freeflight_permeance)

/atom/movable/proc/remove_movable_recursive_freeflight_permeance(source)
	REMOVE_TRAIT(src, TRAIT_MOVABLE_RECURSIVE_FREEFLIGHT_PERMEANCE, source)
	if(!HAS_TRAIT(src, TRAIT_MOVABLE_RECURSIVE_FREEFLIGHT_PERMEANCE))
		DelComponent(/datum/component/recursive_freeflight_permeance)
