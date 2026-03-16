//* Pipe Layers *//

// We are based on the three named layers of supply, regular, and scrubber.
#define PIPING_LAYER_FUEL		1
#define PIPING_LAYER_SUPPLY		2
#define PIPING_LAYER_REGULAR	3
#define PIPING_LAYER_SCRUBBER	4
#define PIPING_LAYER_AUX		5

#define PIPING_LAYER_MIN 1
#define PIPING_LAYER_MAX 5
#define PIPING_LAYER_DEFAULT PIPING_LAYER_REGULAR

/// Do not change these unles you also change sprites of everything to match this.
#define PIPING_LAYER_P_X 5
/// Do not change these unles you also change sprites of everything to match this.
#define PIPING_LAYER_P_Y 5
#define PIPING_LAYER_LCHANGE 0.05

#define PIPES_FUEL_LAYER		(PIPE_LAYER - PIPING_LAYER_LCHANGE * 2)
#define PIPES_SUPPLY_LAYER		(PIPE_LAYER - PIPING_LAYER_LCHANGE * 1)
#define PIPES_SCRUBBER_LAYER	(PIPE_LAYER + PIPING_LAYER_LCHANGE * 1)
#define PIPES_AUX_LAYER			(PIPE_LAYER + PIPING_LAYER_LCHANGE * 2)
#define PIPES_HE_LAYER			(EXPOSED_PIPE_LAYER + PIPING_LAYER_LCHANGE)

GLOBAL_REAL_LIST(piping_layer_names) = list(
	"Fuel",
	"Supply",
	"Regular",
	"Scrubber",
	"Aux",
)

/proc/piping_layer_to_name(layer)
	return global.piping_layer_names[layer]

/proc/piping_layer_to_numbered_name(layer)
	return "[global.piping_layer_names[layer]] ([layer])"

//* Pipe Flags *//

/// intended to connect with all layers, check for all instead of just one.
#define PIPE_FLAG_ALL_LAYER (1<<0)
/// can only be built if nothing else with this flag is on the tile already.
#define PIPE_FLAG_ONE_PER_TURF (1<<1)
/// can only exist at PIPING_LAYER_DEFAULT
#define PIPE_FLAG_DEFAULT_LAYER_ONLY (1<<2)
/// north/south east/west doesn't matter, auto normalize on build.
#define PIPE_FLAG_CARDINAL_AUTONORMALIZE (1<<3)
/// intended to connect with everything, both layers and colors
//#define PIPING_ALL_COLORS (1<<4)
/// can bridge over pipenets
//#define PIPING_BRIDGE (1<<5)

// TODO: define bitfield the above

// ----- legacy below ------

//PIPES
//Defines for pipe bitmasking
///also just NORTH
#define NORTH_FULLPIPE (1<<0)
///also just SOUTH
#define SOUTH_FULLPIPE (1<<1)
///also just EAST
#define EAST_FULLPIPE (1<<2)
///also just WEST
#define WEST_FULLPIPE (1<<3)
#define NORTH_SHORTPIPE (1<<4)
#define SOUTH_SHORTPIPE (1<<5)
#define EAST_SHORTPIPE (1<<6)
#define WEST_SHORTPIPE (1<<7)
// Helpers to convert cardinals to and from pipe bitfields
// Assumes X_FULLPIPE = X, X_SHORTPIPE >> 4 = X as above
#define FULLPIPE_TO_CARDINALS(bitfield) ((bitfield) & ALL_CARDINALS)
#define SHORTPIPE_TO_CARDINALS(bitfield) (((bitfield) >> 4) & ALL_CARDINALS)
#define CARDINAL_TO_FULLPIPES(cardinals) (cardinals)
#define CARDINAL_TO_SHORTPIPES(cardinals) ((cardinals) << 4)
// A pipe is a stub if it only has zero or one permitted direction. For a regular pipe this is nonsensical, and there are no pipe sprites for this, so it is not allowed.
#define ISSTUB(bits) !((bits) & (bits - 1))
#define ISNOTSTUB(bits) ((bits) & (bits - 1))
//Atmos pipe limits
/// (kPa) What pressure pumps and powered equipment max out at.
#define MAX_OUTPUT_PRESSURE 4500
/// (L/s) Maximum speed powered equipment can work at.
#define MAX_TRANSFER_RATE 200
/// How many percent of the contents that an overclocked volume pumps leak into the air
#define VOLUME_PUMP_LEAK_AMOUNT 0.1
//used for device_type vars
#define UNARY 1
#define BINARY 2
#define TRINARY 3
#define QUATERNARY 4

//TANKS
/// The volume of the standard handheld gas tanks on the station.
#define TANK_STANDARD_VOLUME 70
/// The minimum pressure an gas tanks release valve can be set to.
#define TANK_MIN_RELEASE_PRESSURE 0
/// The maximum pressure an gas tanks release valve can be set to.
#define TANK_MAX_RELEASE_PRESSURE (ONE_ATMOSPHERE*3)
/// The default initial value gas tanks release valves are set to. (At least the ones containing pure plasma/oxygen.)
#define TANK_DEFAULT_RELEASE_PRESSURE ONE_ATMOSPHERE
/// The default initial value gas plasmamen tanks releases valves are set to.
#define TANK_PLASMAMAN_RELEASE_PRESSURE 4
/// The internal temperature in kelvins at which a handheld gas tank begins to take damage.
#define TANK_MELT_TEMPERATURE 1000000
/// The internal pressure in kPa at which a handheld gas tank begins to take damage.
#define TANK_LEAK_PRESSURE (30.*ONE_ATMOSPHERE)
/// The internal pressure in kPa at which a handheld gas tank almost immediately ruptures and leaks.
#define TANK_RUPTURE_PRESSURE (40.*ONE_ATMOSPHERE)
/// The internal pressure in kPa at which an gas tank that breaks will cause an explosion. Will cause a 3x3 explosion.
#define TANK_FRAGMENT_PRESSURE (50.*ONE_ATMOSPHERE)
/// Range scaling constant for tank explosions. Calibrated so +1 for each SCALE kPa above threshold.
#define TANK_FRAGMENT_SCALE (10.*ONE_ATMOSPHERE)
///Arbitrary. I don't even know honestly. -Zan
#define TANK_IDEAL_PRESSURE 1015
/// Denotes that our tank is overpressurized simply from gas merging.
#define TANK_MERGE_OVERPRESSURE "tank_overpressure"
// Indices for the reaction_results returned by explosion_information()
/// Reactions that have happened in the tank.
#define TANK_RESULTS_REACTION 1
/// Additional information of the tank.
#define TANK_RESULTS_MISC 2

// Ventcrawling bitflags, handled in var/vent_movement
///Allows for ventcrawling to occur. All atmospheric machines have this flag on by default. Cryo is the exception
#define VENTCRAWL_ALLOWED	(1<<0)
///Allows mobs to enter or leave from atmospheric machines. On for passive, unary, and scrubber vents.
#define VENTCRAWL_ENTRANCE_ALLOWED (1<<1)
///Used to check if a machinery is visible. Called by update_pipe_vision(). On by default for all except cryo.
#define VENTCRAWL_CAN_SEE	(1<<2)

//
// Pipe Construction
//

//Construction Orientation Types - Each of these categories has a different selection of how pipes can rotate and flip. Used for RPD.
/// 2 directions: N/S, E/W
#define PIPE_STRAIGHT			0
/// 6 directions: N/S, E/W, N/E, N/W, S/E, S/W
#define PIPE_BENDABLE			1
/// 4 directions: N/E/S, E/S/W, S/W/N, W/N/E
#define PIPE_TRINARY			2
/// 8 directions: N->S+E, S->N+E, N->S+W, S->N+W, E->W+S, W->E+S, E->W+N, W->E+N
#define PIPE_TRIN_M				3
/// 4 directions: N, S, E, W
#define PIPE_DIRECTIONAL		4
/// 1 direction: N/S/E/W
#define PIPE_ONEDIR				5
/// 8 directions: N, S, E, W, N-flipped, S-flipped, E-flipped, W-flipped
#define PIPE_UNARY_FLIPPABLE	6
/// 8 directions: N->S+E, S->N+E, N->S+W, S->N+W, E->W+S, W->E+S, E->W+N, W->E+N
#define PIPE_TRIN_T				7
// Pipe connectivity bit flags
/// Center of tile, 'normal'
#define CONNECT_TYPE_REGULAR	1
/// Atmos air supply pipes
#define CONNECT_TYPE_SUPPLY		2
/// Atmos air scrubber pipes
#define CONNECT_TYPE_SCRUBBER	4
/// Heat exchanger pipes
#define CONNECT_TYPE_HE			8
/// Fuel pipes for overmap ships
#define CONNECT_TYPE_FUEL		16
/// Aux pipes for 'other' things (airlocks, etc)
#define CONNECT_TYPE_AUX		32

/// Macro for easy use of boilerplate code for searching for a valid node connection.
#define STANDARD_ATMOS_CHOOSE_NODE(node_num, direction) \
	for(var/obj/machinery/atmospherics/target in get_step(src, direction)) { \
		if(can_be_node(target, node_num)) { \
			node##node_num = target; \
			break; \
		} \
	}
