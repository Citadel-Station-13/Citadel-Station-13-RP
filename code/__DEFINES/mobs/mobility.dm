//! Mob mobility var flags
/// any flag
#define CHECK_MOBILITY(target, flags) (target.mobility_flags & flags)
#define CHECK_ALL_MOBILITY(target, flags) CHECK_MULTIPLE_BITFIELDS(target.mobility_flags, flags)

#define MOBILITY_MOVE    (1<<0) // Can move.
#define MOBILITY_STAND   (1<<1) // Can, and is, standing up.
#define MOBILITY_PICKUP  (1<<2) // Can pickup items.
#define MOBILITY_USE     (1<<3) // Can use items and interact with world objects like opening closets/etc.
#define MOBILITY_UI      (1<<4) // Can use interfaces like consoles.
#define MOBILITY_STORAGE (1<<5) // Can use storage item.
#define MOBILITY_PULL    (1<<6) // Can pull things.
#define MOBILITY_HOLD    (1<<7) // Can hold non-nodropped items voluntarily.
#define MOBILITY_RESIST  (1<<8) // Can resist out of buckling, grabs, cuffs, etc, in the usual order (buckle --> cuffs --> grab)

#define MOBILITY_FLAGS_DEFAULT (MOBILITY_MOVE | MOBILITY_STAND | MOBILITY_PICKUP | MOBILITY_USE | MOBILITY_UI | MOBILITY_STORAGE | MOBILITY_PULL | MOBILITY_RESIST)
#define MOBILITY_FLAGS_ANY_INTERACTION (MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_UI | MOBILITY_STORAGE)

DEFINE_BITFIELD(mobility_flags, list(
	"MOVE" = MOBILITY_MOVE,
	"STAND" = MOBILITY_STAND,
	"PICKUP" = MOBILITY_PICKUP,
	"USE" = MOBILITY_USE,
	"UI" = MOBILITY_UI,
	"STORAGE" = MOBILITY_STORAGE,
	"PULL" = MOBILITY_PULL,
	"HOLD" = MOBILITY_HOLD,
	"RESIST" = MOBILITY_RESIST,
))
