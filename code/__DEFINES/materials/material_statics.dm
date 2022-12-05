/// Amount table damage is multiplied by if it is made of a brittle material (e.g. glass)
#define TABLE_BRITTLE_MATERIAL_MULTIPLIER 4

//! Arbitrary hardness thresholds.
#define MAT_VALUE_SOFT              10
#define MAT_VALUE_FLEXIBLE          20
#define MAT_VALUE_RIGID             40
#define MAT_VALUE_HARD              60
#define MAT_VALUE_VERY_HARD         80

//! Arbitrary reflectiveness thresholds.
#define MAT_VALUE_DULL       10
#define MAT_VALUE_MATTE      20
#define MAT_VALUE_SHINY      40
#define MAT_VALUE_VERY_SHINY 60
#define MAT_VALUE_MIRRORED   80

//! Arbitrary weight thresholds.
#define MAT_VALUE_EXTREMELY_LIGHT 10 // Fabric tier
#define MAT_VALUE_VERY_LIGHT      30 // Glass tier
#define MAT_VALUE_LIGHT           40 // Titanium tier
#define MAT_VALUE_NORMAL          50 // Steel tier
#define MAT_VALUE_HEAVY           70 // Silver tier
#define MAT_VALUE_VERY_HEAVY      80 // Uranium tier
