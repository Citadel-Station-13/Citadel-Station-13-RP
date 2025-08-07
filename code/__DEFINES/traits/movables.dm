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
