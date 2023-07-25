
// Material Defines
#define MAT_BANANIUM		"bananium"
#define MAT_CARBON			"carbon"
#define MAT_CHITIN			"chitin"
#define MAT_COPPER			"copper"
#define MAT_DIAMOND			"diamond"
#define MAT_DURASTEEL		"durasteel"
#define MAT_DURASTEELHULL	"durasteel hull"
#define MAT_GLASS			"glass"
#define MAT_GOLD			"gold"
#define MAT_GRAPHITE		"graphite"
#define MAT_HARDLOG			"hardwood log"
#define MAT_HARDWOOD		"hardwood"
#define MAT_HEMATITE		"hematite"
#define MAT_IRON			"iron"
#define MAT_LEAD			"lead"
#define MAT_LEATHER			"leather"
#define MAT_LOG				"log"
#define MAT_MARBLE			"marble"
#define MAT_METALHYDROGEN	"mhydrogen"
#define MAT_MORPHIUM		"morphium"
#define MAT_MORPHIUMHULL	"morphium hull"
#define MAT_OSMIUM			"osmium"
#define MAT_PHORON			"phoron"
#define MAT_PLASTEEL		"plasteel"
#define MAT_PLASTEELHULL	"plasteel hull"
#define MAT_PLASTIC			"plastic"
#define MAT_PLATINUM		"platinum"
#define MAT_SIFLOG			"alien log"
#define MAT_SIFWOOD			"alien wood"
#define MAT_SILENCIUM		"silencium"
#define MAT_SILVER			"silver"
#define MAT_SNOW			"snow"
#define MAT_STEEL			"steel"
#define MAT_STEELHULL		"steel hull"
#define MAT_SUPERMATTER		"supermatter"
#define MAT_TITANIUM		"titanium"
#define MAT_TITANIUMHULL	"titanium hull"
#define MAT_URANIUM			"uranium"
#define MAT_VALHOLLIDE		"valhollide"
#define MAT_VAUDIUM			"vaudium"
#define MAT_VERDANTIUM		"verdantium"
#define MAT_WOOD			"wood"


#define SHARD_SHARD			"shard"
#define SHARD_SHRAPNEL		"shrapnel"
#define SHARD_STONE_PIECE	"piece"
#define SHARD_SPLINTER		"splinters"
#define SHARD_NONE			""

#define MATERIAL_UNMELTABLE	0x1
#define MATERIAL_BRITTLE	0x2
#define MATERIAL_PADDING	0x4

#define SHEET_MATERIAL_AMOUNT 2000

//* Material - Misc IDs/Keys/Identifiers

/// material part key that a single-material-part object is treated as having
#define MATERIAL_PART_DEFAULT "structure"
/// material_parts value for object does not use material parts system
#define MATERIAL_DEFAULT_DISABLED "DISABLED"
/// material_parts value for object uses hardcoded vars / overrides the abstraction API
#define MATERIAL_DEFAULT_ABSTRACTED "ABSTRACTED"
/// material_parts value for object has a single material but it's absent
#define MATERIAL_DEFAULT_NONE null
/// material ID to pass to Initialize() procs for "erase the default material of this slot"
#define MATERIAL_ID_ERASE "___ERASE___"
