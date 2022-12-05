#define MATERIAL_UNMELTABLE (1<<0)
#define MATERIAL_BRITTLE    (1<<1)
#define MATERIAL_PADDING    (1<<2)

DEFINE_BITFIELD(LEGACY_material_flags, list(
	BITFIELD(MATERIAL_UNMELTABLE),
	BITFIELD(MATERIAL_BRITTLE),
	BITFIELD(MATERIAL_PADDING),
))

#define MATERIAL_EFFECTS           (1<<0) // Whether a material's mechanical effects should apply to the atom. This is necessary for other flags to work.
#define MATERIAL_COLOR             (1<<1) // Applies the material color to the atom's color.
#define MATERIAL_ADD_PREFIX        (1<<2) // Whether a prefix describing the material should be added to the name.
#define MATERIAL_AFFECT_STATISTICS (1<<3) // Whether a material should affect the stats of the atom.

DEFINE_BITFIELD(material_flags, list(
	BITFIELD(MATERIAL_EFFECTS),
	BITFIELD(MATERIAL_COLOR),
	BITFIELD(MATERIAL_ADD_PREFIX),
	BITFIELD(MATERIAL_AFFECT_STATISTICS),
))


//! Material init_flags
#define MATERIAL_INIT_MAPLOAD (1<<0) // Used to make a material initialize at roundstart.
#define MATERIAL_INIT_BESPOKE (1<<1) // Used to make a material type able to be instantiated on demand after roundstart.

DEFINE_BITFIELD(material_init_flags, list(
	BITFIELD(MATERIAL_INIT_MAPLOAD),
	BITFIELD(MATERIAL_INIT_BESPOKE),
))
