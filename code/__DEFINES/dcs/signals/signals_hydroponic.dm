/**
 *! ## Hydroponics Signals. Format:
 * * When the signal is called: (signal arguments)
 * * All signals send the source datum of the signal as the first argument
 */

//! Plants / Plant Traits Signals
/// Called when a plant with slippery skin is slipped on (mob/victim)
////#define COMSIG_PLANT_ON_SLIP "plant_on_slip"
/// Called when a plant with liquid contents is squashed on (atom/target)
////#define COMSIG_PLANT_ON_SQUASH "plant_on_squash"
/// Called when a plant backfires via the backfire element (mob/victim)
////#define COMSIG_PLANT_ON_BACKFIRE "plant_on_backfire"
/// Called when a seed grows in a tray (obj/machinery/hydroponics)
////#define COMSIG_SEED_ON_GROW "plant_on_grow"
/// Called when a seed is planted in a tray (obj/machinery/hydroponics)
////#define COMSIG_SEED_ON_PLANTED "plant_on_plant"

//! Hydro Tray Signals
/// From base of /obj/machinery/hydroponics/set_seed() : (obj/item/new_seed)
////#define COMSIG_HYDROTRAY_SET_SEED "hydrotray_set_seed"
/// From base of /obj/machinery/hydroponics/set_self_sustaining() : (new_value)
////#define COMSIG_HYDROTRAY_SET_SELFSUSTAINING "hydrotray_set_selfsustaining"
/// From base of /obj/machinery/hydroponics/set_weedlevel() : (new_value)
////#define COMSIG_HYDROTRAY_SET_WEEDLEVEL "hydrotray_set_weedlevel"
/// From base of /obj/machinery/hydroponics/set_pestlevel() : (new_value)
////#define COMSIG_HYDROTRAY_SET_PESTLEVEL "hydrotray_set_pestlevel"
/// From base of /obj/machinery/hydroponics/set_waterlevel() : (new_value)
////#define COMSIG_HYDROTRAY_SET_WATERLEVEL "hydrotray_set_waterlevel"
/// From base of /obj/machinery/hydroponics/set_plant_health() : (new_value)
////#define COMSIG_HYDROTRAY_SET_PLANT_HEALTH "hydrotray_set_plant_health"
/// From base of /obj/machinery/hydroponics/set_toxic() : (new_value)
////#define COMSIG_HYDROTRAY_SET_TOXIC "hydrotray_set_toxic"
/// From base of /obj/machinery/hydroponics/set_plant_status() : (new_value)
////#define COMSIG_HYDROTRAY_SET_PLANT_STATUS "hydrotray_set_plant_status"
/// From base of /obj/machinery/hydroponics/update_tray() : (mob/user, product_count)
////#define COMSIG_HYDROTRAY_ON_HARVEST "hydrotray_on_harvest"
/// From base of /obj/machinery/hydroponics/plantdies()
////#define COMSIG_HYDROTRAY_PLANT_DEATH "hydrotray_plant_death"
