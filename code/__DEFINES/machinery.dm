var/global/defer_powernet_rebuild = 0 // True if net rebuild will be called manually after an event.


//! Doors!
#define DOOR_CRUSH_DAMAGE 20
/// How many minutes that a person can be AFK before not being allowed to be an alien.
#define ALIEN_SELECT_AFK_BUFFER 1
// Constants for machine's use_power
/// No continuous power use
#define USE_POWER_OFF    0
/// Machine is using power at its idle power level
#define USE_POWER_IDLE   1
/// Machine is using power at its active power level
#define USE_POWER_ACTIVE 2

//! Bitflags for a machine's preferences on when it should start processing. For use with machinery's `processing_flags` var.
/// Indicates the machine will automatically start processing right after it's `Initialize()` is ran.
#define START_PROCESSING_ON_INIT (1<<0)
/// Machines with this flag will not start processing when it's spawned. Use this if you want to manually control when a machine starts processing.
#define START_PROCESSING_MANUALLY (1<<1)

//! Channel numbers for power.
/// Passed as an argument this means "use whatever current channel is"
#define CURRENT_CHANNEL -1
#define EQUIP   1
#define LIGHT   2
#define ENVIRON 3
/// For total power used only.
#define TOTAL   4

//! Bitflags for machine stat variable.
#define BROKEN	 0x1
#define NOPOWER	 0x2
/// TBD.
#define POWEROFF 0x4
/// Under maintenance.
#define MAINT	 0x8
/// Temporary broken by EMP pulse.
#define EMPED	 0x10

//! Remote control states
#define RCON_NO		1
#define RCON_AUTO	2
#define RCON_YES	3

//! Used by firelocks
#define FIREDOOR_OPEN 1
#define FIREDOOR_CLOSED 2

#define AI_CAMERA_LUMINOSITY 6

//! Camera networks
#define NETWORK_CRESCENT "Spaceport"
// #define NETWORK_CAFE_DOCK "Cafe Dock"
#define NETWORK_CARGO "Cargo"
#define NETWORK_CIRCUITS "Circuits"
#define NETWORK_CIVILIAN "Civilian"
// #define NETWORK_CIVILIAN_EAST "Civilian East"
// #define NETWORK_CIVILIAN_WEST "Civilian West"
#define NETWORK_COMMAND "Command"
#define NETWORK_ENGINE "Engine"
#define NETWORK_ENGINEERING "Engineering"
#define NETWORK_ENGINEERING_OUTPOST "Engineering Outpost"
#define NETWORK_ERT "ZeEmergencyResponseTeam"
#define NETWORK_DEFAULT "Station"
#define NETWORK_MEDICAL "Medical"
#define NETWORK_MERCENARY "MercurialNet"
#define NETWORK_MINE "Mining Outpost"
#define NETWORK_NORTHERN_STAR "Northern Star"
#define NETWORK_RESEARCH "Research"
#define NETWORK_RESEARCH_OUTPOST "Research Outpost"
#define NETWORK_ROBOTS "Robots"
#define NETWORK_PRISON "Prison"
#define NETWORK_SECURITY "Security"
#define NETWORK_INTERROGATION "Interrogation"
#define NETWORK_TELECOM "Tcomms"
#define NETWORK_THUNDER "Entertainment"
#define NETWORK_COMMUNICATORS "Communicators"
#define NETWORK_ALARM_ATMOS "Atmosphere Alarms"
#define NETWORK_ALARM_POWER "Power Alarms"
#define NETWORK_ALARM_FIRE "Fire Alarms"
#define NETWORK_TCOMMS "Telecommunications"
#define NETWORK_OUTSIDE "Outside"
#define NETWORK_EXPLORATION "Exploration"
#define NETWORK_XENOBIO "Xenobiology"

//! Off Station Camera Networks
//TODO: Remove. Though we can keep these for now.
#define NETWORK_TALON_HELMETS "TalonHelmets"
#define NETWORK_TALON_SHIP "TalonShip"
#define NETWORK_TRADE_STATION "Beruang Trade Station"

//! Station Specific Camera Networks
#define NETWORK_TRIUMPH "Triumph"
#define NETWORK_TETHER "Tether"
#define NETWORK_LYTHIOS "Rift"

// Those networks can only be accessed by pre-existing terminals. AIs and new terminals can't use them.
var/list/restricted_camera_networks = list(NETWORK_ERT,NETWORK_MERCENARY,"Secret", NETWORK_COMMUNICATORS)

///Is this ever used? I don't think it is.
#define TRANSMISSION_WIRE		0
///Radio transmissions (like airlock controller to pump)
#define TRANSMISSION_RADIO		1
///Like headsets
#define TRANSMISSION_SUBSPACE	2
///Point-to-point links
#define TRANSMISSION_BLUESPACE	3
///Normal subspace signals
#define SIGNAL_NORMAL	0
///Normal inter-machinery(?) signals
#define SIGNAL_SIMPLE	1
///Untrackable signals
#define SIGNAL_FAKE		2
///Unlogged signals
#define SIGNAL_TEST		4
///Normal data
#define DATA_NORMAL		0
///Intercoms only
#define DATA_INTERCOM	1
///Intercoms and SBRs
#define DATA_LOCAL		2
///Antag interception
#define DATA_ANTAG		3
///Not from a real mob
#define DATA_FAKE		4
//singularity defines
#define STAGE_ONE 	1
#define STAGE_TWO 	3
#define STAGE_THREE	5
#define STAGE_FOUR	7
#define STAGE_FIVE	9
#define STAGE_SUPER	11

/**
 *! Atmospherics Machinery.
 */
/// L/s. This can be used to balance how fast a room is siphoned. Anything higher than CELL_VOLUME has no effect.
#define MAX_SIPHON_FLOWRATE   2500
/// L/s. Max flow rate when scrubbing from a turf.
#define MAX_SCRUBBER_FLOWRATE 200
// These balance how easy or hard it is to create huge pressure gradients with pumps and filters.
// Lower values means it takes longer to create large pressures differences.
// Has no effect on pumping gasses from high pressure to low, only from low to high.
#define ATMOS_PUMP_EFFICIENCY   2.5
#define ATMOS_FILTER_EFFICIENCY 2.5

// Will not bother pumping or filtering if the gas source as fewer than this amount of moles, to help with performance.
#define MINIMUM_MOLES_TO_PUMP		0.01
#define MINIMUM_MOLES_TO_FILTER		0.01
// fire sparking
#define MINIMUM_MOLES_TO_SPARK		0.015

// The flow rate/effectiveness of various atmos devices is limited by their internal volume,
// so for many atmos devices these will control maximum flow rates in L/s.
/// Liters.
#define ATMOS_DEFAULT_VOLUME_PUMP   200
/// L.
#define ATMOS_DEFAULT_VOLUME_FILTER 200
/// L.
#define ATMOS_DEFAULT_VOLUME_MIXER  200
/// L.
#define ATMOS_DEFAULT_VOLUME_PIPE   70
// These are used by supermatter and supermatter monitor program, mostly for UI updating purposes. Higher should always be worse!
/// Unknown status, shouldn't happen but just in case.
#define SUPERMATTER_ERROR -1
/// No or minimal energy
#define SUPERMATTER_INACTIVE 0
/// Normal operation
#define SUPERMATTER_NORMAL 1
/// Ambient temp > 80% of CRITICAL_TEMPERATURE
#define SUPERMATTER_NOTIFY 2
/// Ambient temp > CRITICAL_TEMPERATURE OR integrity damaged
#define SUPERMATTER_WARNING 3
/// Integrity < 50%
#define SUPERMATTER_DANGER 4
/// Integrity < 25%
#define SUPERMATTER_EMERGENCY 5
/// Pretty obvious.
#define SUPERMATTER_DELAMINATING 6
//wIP - PORT ALL OF THESE TO SUBSYSTEMS AND GET RID OF THE WHOLE LIST PROCESS THING
// Fancy-pants START/STOP_PROCESSING() macros that lets us custom define what the list is.
#define START_PROCESSING_IN_LIST(DATUM, LIST) \
if (!(DATUM.datum_flags & DF_ISPROCESSING)) {\
	LIST += DATUM;\
	DATUM.datum_flags |= DF_ISPROCESSING\
}

#define STOP_PROCESSING_IN_LIST(DATUM, LIST) LIST.Remove(DATUM);DATUM.datum_flags &= ~DF_ISPROCESSING

// Note - I would prefer these be defined machines.dm, but some are used prior in file order. ~Leshana
#define START_MACHINE_PROCESSING(Datum) START_PROCESSING_IN_LIST(Datum, global.processing_machines)
#define STOP_MACHINE_PROCESSING(Datum) STOP_PROCESSING_IN_LIST(Datum, global.processing_machines)

#define START_PROCESSING_PIPENET(Datum) START_PROCESSING_IN_LIST(Datum, global.pipe_networks)
#define STOP_PROCESSING_PIPENET(Datum) STOP_PROCESSING_IN_LIST(Datum, global.pipe_networks)

#define START_PROCESSING_POWERNET(Datum) START_PROCESSING_IN_LIST(Datum, global.powernets)
#define STOP_PROCESSING_POWERNET(Datum) STOP_PROCESSING_IN_LIST(Datum, global.powernets)

#define START_PROCESSING_POWER_OBJECT(Datum) START_PROCESSING_IN_LIST(Datum, global.processing_power_items)
#define STOP_PROCESSING_POWER_OBJECT(Datum) STOP_PROCESSING_IN_LIST(Datum, global.processing_power_items)

// Computer login types
#define LOGIN_TYPE_NORMAL 1
#define LOGIN_TYPE_AI 2
#define LOGIN_TYPE_ROBOT 3

//orion game states
#define ORION_STATUS_START 0
#define ORION_STATUS_INSTRUCTIONS 1
#define ORION_STATUS_NORMAL 2
#define ORION_STATUS_GAMEOVER 3
#define ORION_STATUS_MARKET 4

//orion delays (how many turns an action costs)
#define ORION_SHORT_DELAY 2
#define ORION_LONG_DELAY 6

//starting orion crew count
#define ORION_STARTING_CREW_COUNT 4

//orion food to fuel / fuel to food conversion rate
#define ORION_TRADE_RATE 5

//and whether you want fuel or food
#define ORION_I_WANT_FUEL 1
#define ORION_I_WANT_FOOD 2

//orion price of buying pioneer
#define ORION_BUY_CREW_PRICE 10

//...and selling one (its less because having less pioneers is actually not that bad)
#define ORION_SELL_CREW_PRICE 7

//defining the magic numbers sent by tgui
#define ORION_BUY_ENGINE_PARTS 1
#define ORION_BUY_ELECTRONICS 2
#define ORION_BUY_HULL_PARTS 3

//orion gaming record (basically how worried it is that you're a deranged gunk gamer)
//game gives up on trying to help you
#define ORION_GAMER_GIVE_UP -2
//game spawns a pamphlet, post report
#define ORION_GAMER_PAMPHLET -1
//game begins to have a chance to warn sec and med
#define ORION_GAMER_REPORT_THRESHOLD 2
