//* /datum/component/rig_piece rig_piece_flags

#define RIG_PIECE_APPLY_ARMOR (1<<0)
#define RIG_PIECE_APPLY_ENVIRONMENTALS (1<<1)

//* /datum/component/rig_piece sealed

#define RIG_PIECE_UNSEALED (1<<0)
#define RIG_PIECE_SEALING (1<<1)
#define RIG_PIECE_UNSEALING (1<<2)
#define RIG_PIECE_SEALED (1<<3)

#define RIG_PIECE_IS_CYCLING (RIG_PIECE_SEALING | RIG_PIECE_UNSEALING)
