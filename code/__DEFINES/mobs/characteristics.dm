//! General

//? skillcheck types used for specializations and skill checks


//! Skills

//? skill levels.
//? These must be SEQUENTIAL FROM 1 TO X.
#define CHARACTER_SKILL_UNTRAINED 1
#define CHARACTER_SKILL_BASIC 2
#define CHARACTER_SKILL_NOVICE 3
#define CHARACTER_SKILL_TRAINED 4
#define CHARACTER_SKILL_EXPERIENCED 5
#define CHARACTER_SKILL_PROFESSIONAL 6

#define CHARACTER_SKILL_ENUM_MIN 1
#define CHARACTER_SKILL_ENUM_MAX 6

//! Stats

//? stat datatypes
/// a number
#define CHARACTER_STAT_NUMERIC "num"
/// text data
#define CHARACTER_STAT_STRING "str"
/// boolean
#define CHARACTER_STAT_BOOL "bool"
/// a datum of some kind - NOT RECOMMENDED
#define CHARACTER_STAT_DATUM "datum"
/// unknown
#define CHARACTER_STAT_UNKNOWN "unkw"

//! Talents

//! Specializations
