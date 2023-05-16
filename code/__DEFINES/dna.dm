// Bitflags for mutations.
#define STRUCDNASIZE 27
#define   UNIDNASIZE 13

//! Generic mutations:
#define MUTATION_TELEKINESIS     1
#define MUTATION_COLD_RESIST     2
#define MUTATION_XRAY            3
#define MUTATION_HULK            4
#define MUTATION_CLUMSY          5
#define MUTATION_FAT             6
#define MUTATION_HUSK            7
#define MUTATION_NOCLONE         8
#define MUTATION_LASER           9 // Harm intent - click anywhere to shoot lasers from eyes.
#define MUTATION_HEAL           10 // Healing people with hands.
#define MUTATION_SKELETON       11
#define MUTATION_PLANT          12

//! Other Mutations:
#define MUTATION_NOBREATH      100 // No need to breathe.
#define MUTATION_REMOTE_VIEW   101 // Remote viewing.
#define MUTATION_REGENERATE    102 // Health regeneration.
#define MUTATION_INCREASE_RUN  103 // No slowdown.
#define MUTATION_REMOTE_TALK   104 // Remote talking.
#define MUTATION_MORPH         105 // Hanging appearance.
#define MUTATION_BLEND         106 // Nothing. (seriously nothing)
#define MUTATION_HALLUCINATION 107 // Hallucinations.
#define MUTATION_NOPRINTS      108 // No fingerprints.
#define MUTATION_NOSHOCK       109 // Insulated hands.
#define MUTATION_DWARFISM      110 // Table climbing.

//! Disabilities
#define DISABILITY_NEARSIGHTED (1<<0)
#define DISABILITY_EPILEPSY    (1<<1)
#define DISABILITY_COUGHING    (1<<2)
#define DISABILITY_TOURETTES   (1<<3)
#define DISABILITY_NERVOUS     (1<<4)

//! sdisabilities
#define SDISABILITY_NERVOUS (1<<0)
#define SDISABILITY_MUTE    (1<<1)
#define SDISABILITY_DEAF    (1<<2)

// The way blocks are handled badly needs a rewrite, this is horrible.
// Too much of a project to handle at the moment, TODO for later.
var/DNABLOCK_BLIND    = 0
var/DNABLOCK_DEAF     = 0
var/DNABLOCK_HULK     = 0
var/DNABLOCK_TELE     = 0
var/DNABLOCK_FIRE     = 0
var/DNABLOCK_XRAY     = 0
var/DNABLOCK_CLUMSY   = 0
var/DNABLOCK_FAKE     = 0
var/DNABLOCK_COUGH    = 0
var/DNABLOCK_GLASSES  = 0
var/DNABLOCK_EPILEPSY = 0
var/DNABLOCK_TWITCH   = 0
var/DNABLOCK_NERVOUS  = 0
var/DNABLOCK_MONKEY   = STRUCDNASIZE

var/DNABLOCK_HEADACHE      = 0
var/DNABLOCK_NOBREATH      = 0
var/DNABLOCK_REMOTEVIEW    = 0
var/DNABLOCK_REGENERATE    = 0
var/DNABLOCK_INCREASERUN   = 0
var/DNABLOCK_REMOTETALK    = 0
var/DNABLOCK_MORPH         = 0
var/DNABLOCK_BLEND         = 0
var/DNABLOCK_HALLUCINATION = 0
var/DNABLOCK_NOPRINTS      = 0
var/DNABLOCK_NOSHOCK       = 0
var/DNABLOCK_DWARFISM      = 0
