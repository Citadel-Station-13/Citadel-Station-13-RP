/**
 *! ## /datum/species Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

/// From datum/species/on_species_gain(): (datum/species/new_species, datum/species/old_species)
////#define COMSIG_SPECIES_GAIN "species_gain"
/// From datum/species/on_species_loss(): (datum/species/lost_species)
////#define COMSIG_SPECIES_LOSS "species_loss"
