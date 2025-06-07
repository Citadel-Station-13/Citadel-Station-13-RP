//* /atom 'atom_flags' variable *//

/// The atom is initialized
#define ATOM_INITIALIZED    (1<<0)
/// Item has priority to check when entering or leaving.
#define ATOM_BORDER         (1<<1)
/// get_hearers_in_view() returns us, meaning we intercept usually for-players messages. Mobs, mechas, etc should all have this!
#define ATOM_HEAR           (1<<2)
/// Atom queued to SSoverlay for compile_overlays
#define ATOM_OVERLAY_QUEUED (1<<3)
/// Atom is absolute-abstract - should not be interactable or movable in any way shape or form
/// This is for stuff like lighting.
#define ATOM_ABSTRACT       (1<<4)
/// Atom is not considered a game world object.
/// This means semantic "wipe game world state" things like turf.empty(), saving, loading, etc, should ignore it,
/// but the atom is not abstract.
#define ATOM_NONWORLD       (1<<5)
/// uses integrity, and is broken
#define ATOM_BROKEN			(1<<6)
/// Used for items if they don't want to get a blood overlay.
#define NOBLOODY            (1<<7) // TODO: item flag
/// Reagents don't react inside this container.
#define NOREACT             (1<<8) // TODO: reagent holder flag
/// Doesn't Conduct electricity. (metal etc.)
#define NOCONDUCT           (1<<9) // TODO: item flag
/// Is an open container for chemistry purposes.
#define OPENCONTAINER       (1<<10) // TODO: reagent holder flags
/// Does not get contaminated by phoron.
#define PHORONGUARD         (1<<11) // TODO: item flag
/// Does not leave user's fingerprints/fibers when used on things?
#define NOPRINT             (1<<12) // TODO: item flag

/// We are ticking in materials
#define ATOM_MATERIALS_TICKING		(1<<22)
/// Use initial icon/icon state for HTML renders in things like VV
#define ATOM_HTML_INITIAL_ICON		(1<<23)

DEFINE_BITFIELD(atom_flags, list(
	BITFIELD(ATOM_INITIALIZED),
	BITFIELD(ATOM_BORDER),
	BITFIELD(ATOM_HEAR),
	BITFIELD(ATOM_OVERLAY_QUEUED),
	BITFIELD(ATOM_ABSTRACT),
	BITFIELD(ATOM_NONWORLD),
	BITFIELD(ATOM_BROKEN),
	BITFIELD(NOBLOODY),
	BITFIELD(NOREACT),
	BITFIELD(NOCONDUCT),
	BITFIELD(OPENCONTAINER),
	BITFIELD(PHORONGUARD),
	BITFIELD(NOPRINT),
	BITFIELD(ATOM_MATERIALS_TICKING),
	BITFIELD(ATOM_HTML_INITIAL_ICON),
))

//? /atom/movable/var/movable_flags
/// Throwing does not scale damage at all regardless of force.
#define MOVABLE_NO_THROW_SPEED_SCALING  (1<<0)
/// Throwing should ignore move force scaling entirely.
#define MOVABLE_NO_THROW_DAMAGE_SCALING (1<<1)
/// Do not spin when thrown.
#define MOVABLE_NO_THROW_SPIN           (1<<2)
/// We are currently about to be yanked by a Moved(), Entered(), or Exited() triggering a Move()
///
/// * used so things like projectile hitscans know to yield
#define MOVABLE_IN_MOVED_YANK		(1<<3)

DEFINE_BITFIELD(movable_flags, list(
	BITFIELD(MOVABLE_NO_THROW_SPEED_SCALING),
	BITFIELD(MOVABLE_NO_THROW_DAMAGE_SCALING),
	BITFIELD(MOVABLE_NO_THROW_SPIN),
	BITFIELD(MOVABLE_IN_MOVED_YANK),
))

// Flags for pass_flags. - Used in /atom/movable/var/pass_flags, and /atom/var/pass_flags_self
#define ATOM_PASS_TABLE				(1<<0)
#define ATOM_PASS_GLASS				(1<<1)
#define ATOM_PASS_GRILLE			(1<<2)
#define ATOM_PASS_BLOB				(1<<3)
#define ATOM_PASS_MOB				(1<<4)
/// let thrown objects pass; only makes sense on pass_flags_self
#define ATOM_PASS_THROWN			(1<<5)
/// Let clicks pass through even if dense
#define ATOM_PASS_CLICK				(1<<6)
/// let overhand thrown objects pass, unless it's directly targeting us
#define ATOM_PASS_OVERHEAD_THROW	(1<<7)
/// let buckled mobs pass always
#define ATOM_PASS_BUCKLED			(1<<8)
/// "please don't interact with us"
/// todo: is this the same as PHASING movement?
#define ATOM_PASS_INCORPOREAL		(1<<9)

/// all actual pass flags / maximum pass
#define ATOM_PASS_FLAGS_ALL (ATOM_PASS_TABLE | ATOM_PASS_GLASS | ATOM_PASS_GRILLE | \
 ATOM_PASS_BLOB | ATOM_PASS_MOB | ATOM_PASS_THROWN | ATOM_PASS_CLICK | \
 ATOM_PASS_OVERHEAD_THROW | ATOM_PASS_BUCKLED | ATOM_PASS_INCORPOREAL)
/// used for beams
#define ATOM_PASS_FLAGS_BEAM (ATOM_PASS_TABLE | ATOM_PASS_GLASS | ATOM_PASS_GRILLE)

DEFINE_BITFIELD(pass_flags, list(
	BITFIELD(ATOM_PASS_TABLE),
	BITFIELD(ATOM_PASS_GLASS),
	BITFIELD(ATOM_PASS_GRILLE),
	BITFIELD(ATOM_PASS_BLOB),
	BITFIELD(ATOM_PASS_MOB),
	BITFIELD(ATOM_PASS_THROWN),
	BITFIELD(ATOM_PASS_CLICK),
	BITFIELD(ATOM_PASS_OVERHEAD_THROW),
	BITFIELD(ATOM_PASS_BUCKLED),
	BITFIELD(ATOM_PASS_INCORPOREAL),
))

DEFINE_BITFIELD(pass_flags_self, list(
	BITFIELD(ATOM_PASS_TABLE),
	BITFIELD(ATOM_PASS_GLASS),
	BITFIELD(ATOM_PASS_GRILLE),
	BITFIELD(ATOM_PASS_BLOB),
	BITFIELD(ATOM_PASS_MOB),
	BITFIELD(ATOM_PASS_THROWN),
	BITFIELD(ATOM_PASS_CLICK),
	BITFIELD(ATOM_PASS_OVERHEAD_THROW),
	BITFIELD(ATOM_PASS_BUCKLED),
	BITFIELD(ATOM_PASS_INCORPOREAL),
))

//? /atom/movable movement_type - only one primary type should be on the atom at a time, but these are flags for quick checks.
/// Can not be stopped from moving from Cross(), CanPass(), or Uncross() failing. Still bumps everything it passes through, though.
#define MOVEMENT_UNSTOPPABLE  (1<<0)
/// Ground movement.
#define MOVEMENT_GROUND       (1<<1)
/// Flying movement.
#define MOVEMENT_FLYING       (1<<2)
/// Phasing movement (phazons, shadekins, etc).
#define MOVEMENT_PHASING      (1<<3)
/// Floating movement like no gravity etc etc.
#define MOVEMENT_FLOATING     (1<<4)

/// main modes of movement
#define MOVEMENT_TYPES (MOVEMENT_GROUND | MOVEMENT_PHASING | MOVEMENT_FLOATING | MOVEMENT_FLYING)

DEFINE_BITFIELD(movement_type, list(
	BITFIELD(MOVEMENT_UNSTOPPABLE),
	BITFIELD(MOVEMENT_GROUND),
	BITFIELD(MOVEMENT_FLYING),
	BITFIELD(MOVEMENT_PHASING),
	BITFIELD(MOVEMENT_FLOATING),
))

//? /atom integrity_flags
/// cannot be broken, period
#define INTEGRITY_INDESTRUCTIBLE (1<<0)
/// completely immune to fire, can't even light
#define INTEGRITY_FIREPROOF (1<<1)
/// completely immune to acid, can't even have it stick
#define INTEGRITY_ACIDPROOF (1<<2)
/// completely immune to lava
#define INTEGRITY_LAVAPROOF (1<<3)
/// don't delete on atom_destruction()
/// be very careful with this flag, as atom_destruction()
/// will keep being called every time it gets damaged while 0 integrity!
#define INTEGRITY_NO_DECONSTRUCT (1<<4)
/// flammable by dynamic atom fire
/// this is opt in as a flag so people have to think about it before throwing it onto things.
/// <--- clueless comment author
#define INTEGRITY_FLAMMABLE (1<<5)

DEFINE_BITFIELD(integrity_flags, list(
	BITFIELD(INTEGRITY_INDESTRUCTIBLE),
	BITFIELD(INTEGRITY_FIREPROOF),
	BITFIELD(INTEGRITY_ACIDPROOF),
	BITFIELD(INTEGRITY_LAVAPROOF),
	BITFIELD(INTEGRITY_NO_DECONSTRUCT),
	BITFIELD(INTEGRITY_FLAMMABLE),
))

//? /atom/movable buckle_flags
/// Requires restrained() (usually handcuffs) to work.
#define BUCKLING_REQUIRES_RESTRAINTS          (1<<0)
/// Buckling doesn't allow you to pull the person to try to move the object (assuming the object otherwise can be pulled). This does NOT stop them from pulling the buckled object!
#define BUCKLING_PREVENTS_PULLING             (1<<1)
/// Automatically pass projectiles hitting us up.
#define BUCKLING_PASS_PROJECTILES_UPWARDS     (1<<2) // todo: implement
/// Do not allow players to do drag/drop buckling.
#define BUCKLING_NO_DEFAULT_BUCKLE            (1<<3)
/// Do not allow players to perform default click interaction unbuckling.
#define BUCKLING_NO_DEFAULT_UNBUCKLE          (1<<4)
/// Do not allow players to resist out of buckling by default.
#define BUCKLING_NO_DEFAULT_RESIST            (1<<5)
/// Don't let us buckle people to ourselves.
#define BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF (1<<6)
/// Lets the user avoid step checks.
#define BUCKLING_GROUND_HOIST                 (1<<7)
/// projects our depth to the buckled object. you usually don't want this.
#define BUCKLING_PROJECTS_DEPTH               (1<<8)

DEFINE_BITFIELD(buckle_flags, list(
	BITFIELD(BUCKLING_REQUIRES_RESTRAINTS),
	BITFIELD(BUCKLING_PREVENTS_PULLING),
	BITFIELD(BUCKLING_PASS_PROJECTILES_UPWARDS),
	BITFIELD(BUCKLING_NO_DEFAULT_BUCKLE),
	BITFIELD(BUCKLING_NO_DEFAULT_UNBUCKLE),
	BITFIELD(BUCKLING_NO_DEFAULT_RESIST),
	BITFIELD(BUCKLING_NO_USER_BUCKLE_OTHER_TO_SELF),
	BITFIELD(BUCKLING_GROUND_HOIST),
	BITFIELD(BUCKLING_PROJECTS_DEPTH),
))
