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
