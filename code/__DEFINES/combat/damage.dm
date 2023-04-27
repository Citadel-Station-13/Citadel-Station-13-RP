//? damage types

// todo: refactor damage types

//? damage_mode bitfield

#define DAMAGE_MODE_SHARP (1<<0)      //! sharp weapons like knives, spears, etc
#define DAMAGE_MODE_EDGE (1<<1)       //! weapons with an edge, like knives, being used as such. without this, sharp = pierce
#define DAMAGE_MODE_ABLATING (1<<2)   //! pulse lasers, etc, basically blows a crater
#define DAMAGE_MODE_PIERCE (1<<3)     //! specifically highly-piercing weapons like bullets, even worse than sharp.
#define DAMAGE_MODE_SHRED (1<<4)      //! messy, shredded wounds instead of a clean cut / pierce. strong.
