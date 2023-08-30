//? /mob/var/mobility_flags
/// any flag
#define CHECK_MOBILITY(target, flags) (target.mobility_flags & flags)
/// all flags
#define CHECK_ALL_MOBILITY(target, flags) CHECK_MULTIPLE_BITFIELDS(target.mobility_flags, flags)

#define MOBILITY_CAN_MOVE       (1<<0) //! Can move.
#define MOBILITY_CAN_STAND      (1<<1) //! Can, and is, standing up.
#define MOBILITY_CAN_PICKUP     (1<<2) //! Can pickup items.
#define MOBILITY_CAN_USE        (1<<3) //! Can use items and interact with world objects like opening closets/etc.
#define MOBILITY_CAN_UI         (1<<4) //! Can use interfaces like consoles.
#define MOBILITY_CAN_STORAGE    (1<<5) //! Can use storage item.
#define MOBILITY_CAN_PULL       (1<<6) //! Can pull things.
#define MOBILITY_CAN_HOLD       (1<<7) //! Can hold non-nodropped items voluntarily.
#define MOBILITY_CAN_RESIST     (1<<8) //! Can resist out of buckling, grabs, cuffs, etc, in the usual order (buckle --> cuffs --> grab)

#define MOBILITY_IS_STANDING    (1<<22) //! READ-ONLY - Set by set_resting() if we're upright as opposed to on the ground for any reason. Used for checks.
#define MOBILITY_IS_CONSCIOUS   (1<<23) //! READ-ONLY - Set by update_stat() if we're conscious by any means. Used for checks.

#define MOBILITY_FLAGS_REAL (MOBILITY_CAN_MOVE | MOBILITY_CAN_STAND | MOBILITY_CAN_PICKUP | MOBILITY_CAN_USE | MOBILITY_CAN_UI | MOBILITY_CAN_STORAGE | MOBILITY_CAN_PULL | MOBILITY_CAN_HOLD | MOBILITY_CAN_RESIST)
#define MOBILITY_FLAGS_VIRTUAL (MOBILITY_IS_CONSCIOUS | MOBILITY_IS_STANDING)
#define MOBILITY_FLAGS_DEFAULT MOBILITY_FLAGS_REAL | MOBILITY_FLAGS_VIRTUAL
#define MOBILITY_FLAGS_ANY_INTERACTION (MOBILITY_CAN_USE | MOBILITY_CAN_PICKUP | MOBILITY_CAN_UI | MOBILITY_CAN_STORAGE)
#define MOBILITY_FLAGS_ANY_MOVEMENT (MOBILITY_CAN_MOVE)

DEFINE_SHARED_BITFIELD(mobility_flags, list(
	"mobility_flags",
	"mobility_flags_blocked",
	"mobility_flags_forced",
	"mobility_check_flags",
), list(
	"MOVE" = MOBILITY_CAN_MOVE,
	"STAND" = MOBILITY_CAN_STAND,
	"PICKUP" = MOBILITY_CAN_PICKUP,
	"USE" = MOBILITY_CAN_USE,
	"UI" = MOBILITY_CAN_UI,
	"STORAGE" = MOBILITY_CAN_STORAGE,
	"PULL" = MOBILITY_CAN_PULL,
	"HOLD" = MOBILITY_CAN_HOLD,
	"RESIST" = MOBILITY_CAN_RESIST,
	"IS_STANDING" = MOBILITY_IS_STANDING,
	"IS_CONSCIOUS" = MOBILITY_IS_CONSCIOUS,
))

//? Helpers

#define IS_STANDING(M) CHECK_MOBILITY(M, MOBILITY_IS_STANDING)
#define IS_PRONE(M) (!IS_STANDING(M))
