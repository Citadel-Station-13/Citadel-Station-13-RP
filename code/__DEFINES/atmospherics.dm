//ATMOS
//stuff you should probably leave well alone!
#define R_IDEAL_GAS_EQUATION	8.31	//kPa*L/(K*mol)
#define ONE_ATMOSPHERE			101.325	//kPa
#define IDEAL_GAS_ENTROPY_CONSTANT 1164    // (mol^3 * s^3) / (kg^3 * L).
#define TCMB					2.7		// -270.3degC
#define TCRYO					225		// -48.15degC
#define T0C						273.15	// 0degC
#define T20C					293.15	// 20degC
#define TN60C 					213.15	// -60 degrees celcius

#define MOLES_CELLSTANDARD		(ONE_ATMOSPHERE*CELL_VOLUME/(T20C*R_IDEAL_GAS_EQUATION))	//moles in a 2.5 m^3 cell at 101.325 Pa and 20 degC
#define M_CELL_WITH_RATIO		(MOLES_CELLSTANDARD * 0.005) //compared against for superconductivity
#define O2STANDARD				0.21	//percentage of oxygen in a normal mixture of air
#define N2STANDARD				0.79	//same but for nitrogen
#define MOLES_O2STANDARD		(MOLES_CELLSTANDARD * O2STANDARD)	// O2 standard value (21%)
#define MOLES_N2STANDARD		(MOLES_CELLSTANDARD * N2STANDARD)	// N2 standard value (79%)
#define CELL_VOLUME				2500	//liters in a cell
#define BREATH_VOLUME			0.5		//liters in a normal breath
#define BREATH_PERCENTAGE		(BREATH_VOLUME / CELL_VOLUME) // Amount of air needed before pass out/suffocation commences.
#define BREATH_MOLES        	(ONE_ATMOSPHERE * BREATH_VOLUME / (T20C * R_IDEAL_GAS_EQUATION)) // Amount of air to take a from a tile 

//EXCITED GROUPS
#define MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND		0.05 //ZAS specific!
//#define EXCITED_GROUP_BREAKDOWN_CYCLES				4		//number of FULL air controller ticks before an excited group breaks down (averages gas contents across turfs)
//#define EXCITED_GROUP_DISMANTLE_CYCLES				16		//number of FULL air controller ticks before an excited group dismantles and removes its turfs from active
//#define MINIMUM_AIR_RATIO_TO_SUSPEND				0.1		//Ratio of air that must move to/from a tile to reset group processing
//#define MINIMUM_AIR_RATIO_TO_MOVE					0.001	//Minimum ratio of air that must move to/from a tile
#define MINIMUM_AIR_TO_SUSPEND						(MOLES_CELLSTANDARD * MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND)	//(MINIMUM_AIR_RATIO_TO_SUSPEND) Minimum amount of air that has to move before a group processing can be suspended
#define MINIMUM_MOLES_DELTA_TO_MOVE					(MOLES_CELLSTANDARD * MINIMUM_TEMPERATURE_RATIO_TO_SUSPEND) //(MINIMUM_AIR_RATIO_TO_MOVE) Either this must be active
#define MINIMUM_TEMPERATURE_TO_MOVE					(T20C+100)			//or this (or both, obviously)
#define MINIMUM_TEMPERATURE_DELTA_TO_SUSPEND		4		//Minimum temperature difference before group processing is suspended
#define MINIMUM_TEMPERATURE_DELTA_TO_CONSIDER		0.5		//Minimum temperature difference before the gas temperatures are just set to be equal
#define MINIMUM_TEMPERATURE_FOR_SUPERCONDUCTION		(T20C+10)
#define MINIMUM_TEMPERATURE_START_SUPERCONDUCTION	(T20C+200)

//HEAT TRANSFER COEFFICIENTS
//Must be between 0 and 1. Values closer to 1 equalize temperature faster
//Should not exceed 0.4 else strange heat flow occur
#define WALL_HEAT_TRANSFER_COEFFICIENT		0.0
#define OPEN_HEAT_TRANSFER_COEFFICIENT		0.4
#define WINDOW_HEAT_TRANSFER_COEFFICIENT	0.1 // A hack for now.
#define FLOOR_HEAT_TRANSFER_COEFFICIENT		OPEN_HEAT_TRANSFER_COEFFICIENT //i'm assuming that this means an open turf
#define DOOR_HEAT_TRANSFER_COEFFICIENT		0.0
#define SPACE_HEAT_TRANSFER_COEFFICIENT		0.2 // A hack to partly simulate radiative heat.

//FIRE
// Phoron fire properties.
#define PHORON_MINIMUM_BURN_TEMPERATURE    (T0C + 126) //400 K - autoignite temperature in tanks and canisters - enclosed environments I guess
#define PHORON_FLASHPOINT                  (T0C + 246) //519 K - autoignite temperature in air if that ever gets implemented.

#define CARBON_LIFEFORM_FIRE_RESISTANCE (T0C + 200)
#define CARBON_LIFEFORM_FIRE_DAMAGE     4

//These control the mole ratio of oxidizer and fuel used in the combustion reaction
#define FIRE_REACTION_OXIDIZER_AMOUNT	3 //should be greater than the fuel amount if fires are going to spread much
#define FIRE_REACTION_FUEL_AMOUNT		2

//These control the speed at which fire burns
#define FIRE_GAS_BURNRATE_MULT			1
#define FIRE_LIQUID_BURNRATE_MULT		0.225

//If the fire is burning slower than this rate then the reaction is going too slow to be self sustaining and the fire burns itself out.
//This ensures that fires don't grind to a near-halt while still remaining active forever.
#define FIRE_GAS_MIN_BURNRATE			0.01
#define FIRE_LIQUD_MIN_BURNRATE			0.0025

//How many moles of fuel are contained within one solid/liquid fuel volume unit
#define LIQUIDFUEL_AMOUNT_TO_MOL		0.45  //mol/volume unit

// XGM gas flags.
#define XGM_GAS_FUEL        (1<<0)
#define XGM_GAS_OXIDIZER    (1<<1)
#define XGM_GAS_CONTAMINANT (1<<2)
#define XGM_GAS_FUSION_FUEL (1<<3)

//GASES
#define MIN_TOXIC_GAS_DAMAGE				1
#define MAX_TOXIC_GAS_DAMAGE				10
//#define MOLES_GAS_VISIBLE					0.25	//Moles in a standard cell after which gases are visible
//#define FACTOR_GAS_VISIBLE_MAX				20 //moles_visible * FACTOR_GAS_VISIBLE_MAX = Moles after which gas is at maximum visibility
//#define MOLES_GAS_VISIBLE_STEP				0.25 //Mole step for alpha updates. This means alpha can update at 0.25, 0.5, 0.75 and so on
#define MOLES_PHORON_VISIBLE				0.7 // Moles in a standard cell after which phoron is visible.

// Pressure limits.
#define PRESSURE_DAMAGE_COEFFICIENT	4 // The amount of pressure damage someone takes is equal to (pressure / HAZARD_HIGH_PRESSURE)*PRESSURE_DAMAGE_COEFFICIENT, with the maximum of MAX_PRESSURE_DAMAGE.
#define MAX_HIGH_PRESSURE_DAMAGE	4 // This used to be 20... I got this much random rage for some stupid decision by polymorph?! Polymorph now lies in a pool of blood with a katana jammed in his spleen. ~Errorage --PS: The katana did less than 20 damage to him :(
#define LOW_PRESSURE_DAMAGE			2 // The amount of damage someone takes when in a low pressure area. (The pressure threshold is so low that it doesn't make sense to do any calculations, so it just applies this flat value).

//PIPES
//Atmos pipe limits
#define NORMPIPERATE             30   // Pipe-insulation rate divisor.
#define HEATPIPERATE             8    // Heat-exchange pipe insulation.
#define FLOWFRAC                 0.99 // Fraction of gas transfered per process.

//TANKS
#define TANK_LEAK_PRESSURE     (30.*ONE_ATMOSPHERE) // Tank starts leaking.
#define TANK_RUPTURE_PRESSURE  (40.*ONE_ATMOSPHERE) // Tank spills all contents into atmosphere.
#define TANK_FRAGMENT_PRESSURE (50.*ONE_ATMOSPHERE) // Boom 3x3 base explosion.
#define TANK_FRAGMENT_SCALE    (10.*ONE_ATMOSPHERE) // +1 for each SCALE kPa above threshold. Was 2 atm.

//CANATMOSPASS
#define ATMOS_PASS_YES 1
#define ATMOS_PASS_NO 0
//#define ATMOS_PASS_PROC -1 //ask CanAtmosPass()
#define ATMOS_PASS_DENSITY -1 //-2 //just check density

// \/ linzas numbers
// #define CANATMOSPASS(A, O) ( A.CanAtmosPass == ATMOS_PASS_PROC ? A.CanAtmosPass(O) : ( A.CanAtmosPass == ATMOS_PASS_DENSITY ? !A.density : A.CanAtmosPass ) )
// #define CANVERTICALATMOSPASS(A, O) ( A.CanAtmosPassVertical == ATMOS_PASS_PROC ? A.CanAtmosPass(O, TRUE) : ( A.CanAtmosPassVertical == ATMOS_PASS_DENSITY ? !A.density : A.CanAtmosPassVertical ) )

//MULTIPIPES
//IF YOU EVER CHANGE THESE CHANGE SPRITES TO MATCH. not implemented!!
// We are based on the three named layers of supply, regular, and scrubber.
#define PIPING_LAYER_SUPPLY		1
#define PIPING_LAYER_REGULAR	2
#define PIPING_LAYER_SCRUBBER	3
#define PIPING_LAYER_FUEL		4
#define PIPING_LAYER_AUX		5
#define PIPING_LAYER_DEFAULT	PIPING_LAYER_REGULAR

// We offset the layer values of the different pipe types to ensure they look nice
#define PIPES_SCRUBBER_LAYER	(PIPES_LAYER - 0.05)
#define PIPES_AUX_LAYER			(PIPES_LAYER - 0.04)
#define PIPES_FUEL_LAYER		(PIPES_LAYER - 0.03)
#define PIPES_SUPPLY_LAYER		(PIPES_LAYER - 0.01)
#define PIPES_HE_LAYER			(PIPES_LAYER + 0.01)

#define PIPING_ALL_LAYER				(1<<0)	//intended to connect with all layers, check for all instead of just one.
#define PIPING_ONE_PER_TURF				(1<<1) 	//can only be built if nothing else with this flag is on the tile already.
#define PIPING_DEFAULT_LAYER_ONLY		(1<<2)	//can only exist at PIPING_LAYER_DEFAULT
#define PIPING_CARDINAL_AUTONORMALIZE	(1<<3)	//north/south east/west doesn't matter, auto normalize on build.

//Construction Orientation Types - Each of these categories has a different selection of how pipes can rotate and flip. Used for RPD.
#define PIPE_STRAIGHT			0 //2 directions: N/S, E/W
#define PIPE_BENDABLE			1 //6 directions: N/S, E/W, N/E, N/W, S/E, S/W
#define PIPE_TRINARY			2 //4 directions: N/E/S, E/S/W, S/W/N, W/N/E
#define PIPE_TRIN_M				3 //8 directions: N->S+E, S->N+E, N->S+W, S->N+W, E->W+S, W->E+S, E->W+N, W->E+N
#define PIPE_DIRECTIONAL		4 //4 directions: N, S, E, W
#define PIPE_ONEDIR				5 //1 direction: N/S/E/W
#define PIPE_UNARY_FLIPPABLE	6 //8 directions: N, S, E, W, N-flipped, S-flipped, E-flipped, W-flipped
#define PIPE_TRIN_T				7 //8 directions: N->S+E, S->N+E, N->S+W, S->N+W, E->W+S, W->E+S, E->W+N, W->E+N

// Pipe connectivity bitflags
#define CONNECT_TYPE_REGULAR	(1<<0) //Center of tile, 'normal'
#define CONNECT_TYPE_SUPPLY		(1<<1) //Atmos air supply pipes
#define CONNECT_TYPE_SCRUBBER	(1<<2) //Atmos air scrubber pipes
#define CONNECT_TYPE_HE			(1<<3) //Heat exchanger pipes
#define CONNECT_TYPE_FUEL		(1<<4) //Fuel pipes for overmap ships
#define CONNECT_TYPE_AUX		(1<<5) //Aux pipes for 'other' things (airlocks, etc)

//HELPERS
// Macro for easy use of boilerplate code for searching for a valid node connection.
#define STANDARD_ATMOS_CHOOSE_NODE(node_num, direction) \
	for(var/obj/machinery/atmospherics/target in get_step(src, direction)) { \
		if(can_be_node(target, node_num)) { \
			node##node_num = target; \
			break; \
		} \
	}

#define QUANTIZE(variable)		(round(variable,0.0000001))/*I feel the need to document what happens here. Basically this is used to catch most rounding errors, however it's previous value made it so that
															once gases got hot enough, most procedures wouldnt occur due to the fact that the mole counts would get rounded away. Thus, we lowered it a few orders of magnititude */
// delete this
#define	PIPE_COLOR_GREY		"#ffffff"	//yes white is grey
#define	PIPE_COLOR_RED		"#ff0000"
#define	PIPE_COLOR_BLUE		"#0000ff"
#define	PIPE_COLOR_CYAN		"#00ffff"
#define	PIPE_COLOR_GREEN	"#00ff00"
#define	PIPE_COLOR_YELLOW	"#ffcc00"
#define	PIPE_COLOR_BLACK	"#444444"
#define	PIPE_COLOR_PURPLE	"#5c1ec0"
//use this nerd
GLOBAL_LIST_INIT(pipe_paint_colors, list(
		"amethyst" = rgb(130,43,255), //supplymain
		"blue" = rgb(0,0,255),
		"brown" = rgb(178,100,56),
		"cyan" = rgb(0,255,249),
		"dark" = rgb(69,69,69),
		"green" = rgb(30,255,0),
		"grey" = rgb(255,255,255),
		"orange" = rgb(255,129,25),
		"purple" = rgb(128,0,182),
		"red" = rgb(255,0,0),
		"violet" = rgb(64,0,128),
		"yellow" = rgb(255,198,0)
))

//ZAS SPECIFIC
#define HUMAN_NEEDED_OXYGEN (MOLES_CELLSTANDARD * BREATH_PERCENTAGE * 0.16)
#define HUMAN_HEAT_CAPACITY 280000 //J/K For 80kg person

#define MOLES_O2ATMOS (MOLES_O2STANDARD * 50)
#define MOLES_N2ATMOS (MOLES_N2STANDARD * 50)

// Defines how much of certain gas do the Atmospherics tanks start with. Values are in kpa per tile (assuming 20C)
#define ATMOSTANK_NITROGEN      90000 // A lot of N2 is needed to produce air mix, that's why we keep 90MPa of it
#define ATMOSTANK_OXYGEN        40000 // O2 is also important for airmix, but not as much as N2 as it's only 21% of it.
#define ATMOSTANK_CO2           25000 // CO2 and PH are not critically important for station, only for toxins and alternative coolants, no need to store a lot of those.
#define ATMOSTANK_PHORON        25000
#define ATMOSTANK_NITROUSOXIDE  10000 // N2O doesn't have a real useful use, i guess it's on station just to allow refilling of sec's riot control canisters?.

//Flags for zone sleeping
#define ZONE_ACTIVE   1
#define ZONE_SLEEPING 0